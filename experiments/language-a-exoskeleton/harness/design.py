import argparse
import hashlib
import random
from pathlib import Path

from conditions import ScheduleReplayDiverged, SchemaViolation
from util import PACKET_ROOT, canonical_json_bytes, jsonl_bytes, load_json, sha256_bytes, write_bytes


FAMILIES = ("bounded-support", "scope-and-version", "conflict-and-residue", "notation-neutral-transfer")
CORE_ARMS = ("NL", "PERSONA", "SCAFFOLD", "LANG-A")


def validate_design(design):
    if design.get("schema_version") != "lae-design/0.2":
        raise SchemaViolation("design schema_version must be lae-design/0.2")
    families = design.get("families", [])
    if [f.get("family_id") for f in families] != list(FAMILIES):
        raise SchemaViolation("the four controlling families must appear in controlling order")
    if any(not isinstance(f.get("item_count"), int) or f["item_count"] < 1 for f in families):
        raise SchemaViolation("every family needs a positive integer item_count")
    if design.get("subject_slots") != ["SYNTHETIC-SUBJECT-1", "SYNTHETIC-SUBJECT-2", "SYNTHETIC-SUBJECT-3"]:
        raise SchemaViolation("construction design must preserve three fixed synthetic subject strata")
    if design.get("core_arms") != list(CORE_ARMS) or design.get("sham_arm") != "SHAM":
        raise SchemaViolation("arm semantics differ from authority")
    if design.get("fixed_margins") != {"delta": 0.1, "epsilon": 0.05, "harm": 0.1, "family_interaction": 0.15}:
        raise SchemaViolation("fixed margins are immutable under Errata 0.1")
    total = sum(f["item_count"] for f in families)
    sham = sum(f.get("sham_item_count", 0) for f in families)
    calls = total * len(CORE_ARMS) * 3 + sham * 3
    if calls > design.get("scheduled_call_ceiling", 312):
        raise SchemaViolation("declarative design exceeds the 312 scheduled-call ceiling")
    if design.get("attempted_call_ceiling") != 344 or design.get("spend_ceiling_usd") != "8.00":
        raise SchemaViolation("controlling call or spend ceiling changed")
    return {"items": total, "sham_items": sham, "scheduled_calls": calls, "subjects": 3}


def generate(design):
    counts = validate_design(design)
    rows = []
    item_number = 0
    for family in design["families"]:
        for family_index in range(1, family["item_count"] + 1):
            item_number += 1
            placeholder = f"PROPOSED-{item_number:04d}"
            for subject in design["subject_slots"]:
                for arm in CORE_ARMS:
                    rows.append({"item_placeholder_id": placeholder, "family": family["family_id"], "family_index": family_index, "subject_slot": subject, "arm": arm, "synthetic_only": True})
                if family_index <= family["sham_item_count"]:
                    rows.append({"item_placeholder_id": placeholder, "family": family["family_id"], "family_index": family_index, "subject_slot": subject, "arm": "SHAM", "synthetic_only": True})
    seed_digest = hashlib.sha256(design["randomization_seed_label"].encode("utf-8")).hexdigest()
    random.Random(int(seed_digest, 16)).shuffle(rows)
    schedule = [{"schedule_index": index, "call_id": f"DESIGN-CALL-{index:06d}", **row} for index, row in enumerate(rows, 1)]
    summary = {
        "schema_version": "lae-generated-counts/0.2",
        "design_version": design["design_version"],
        "design_sha256": f"sha256:{sha256_bytes(canonical_json_bytes(design))}",
        "randomization_seed_digest": f"sha256:{seed_digest}",
        "schedule_sha256": f"sha256:{sha256_bytes(jsonl_bytes(schedule))}",
        **counts,
        "core_cells": counts["items"] * 4 * counts["subjects"],
        "sham_cells": counts["sham_items"] * counts["subjects"],
        "overall_analyzable_floor": int((counts["scheduled_calls"] * 0.9) + 0.999999),
        "stratum_floor_fraction": 0.8,
    }
    return schedule, summary


def write_generated(design_path, schedule_path, counts_path, check=False):
    schedule, counts = generate(load_json(design_path))
    schedule_bytes, counts_bytes = jsonl_bytes(schedule), canonical_json_bytes(counts)
    if check:
        if Path(schedule_path).read_bytes() != schedule_bytes or Path(counts_path).read_bytes() != counts_bytes:
            raise ScheduleReplayDiverged("design-derived schedule or count census differs")
    else:
        write_bytes(schedule_path, schedule_bytes)
        write_bytes(counts_path, counts_bytes)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--design", default=str(PACKET_ROOT / "items/design/design.json"))
    parser.add_argument("--schedule", default=str(PACKET_ROOT / "items/design/schedule.jsonl"))
    parser.add_argument("--counts", default=str(PACKET_ROOT / "items/design/generated-counts.json"))
    args = parser.parse_args()
    write_generated(args.design, args.schedule, args.counts, args.check)
    print("DESIGN-REPRODUCTION: PASS")


if __name__ == "__main__":
    main()
