import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "harness"))
from util import canonical_json_bytes, jsonl_bytes, load_jsonl, write_bytes


def generate_synthetic_items():
    schedule = load_jsonl(ROOT / "items/design/schedule.jsonl")
    rows = []
    for row in schedule:
        item_id = row["item_placeholder_id"].replace("PROPOSED", "SYNTH")
        material = f"synthetic-only placeholder {item_id}".encode()
        prompt = f"Synthetic-only task for {item_id}; no real pilot content. Arm={row['arm']}"
        rows.append({
            "item_id": item_id, "item_version": "sha256:" + hashlib.sha256(material).hexdigest(),
            "family": row["family"], "subject_slot": row["subject_slot"], "arm": row["arm"],
            "prompt_artifact_version": "sha256:" + hashlib.sha256(prompt.encode()).hexdigest(),
            "randomization_seed_digest": "sha256:synthetic-dry-run-fixed", "synthetic_prompt": prompt,
            "synthetic_only": True, "permanently_tainted": True
        })
    return rows


def branch_payload(branch):
    family_names = ("bounded-support", "scope-and-version", "conflict-and-residue", "notation-neutral-transfer")
    rows = []
    for family_index, family in enumerate(family_names):
        for item_index in range(6):
            item_id = f"BR-{family_index + 1}-{item_index + 1}"
            for subject_index in range(3):
                subject = f"SYNTHETIC-SUBJECT-{subject_index + 1}"
                if branch == "B-NOTATION":
                    burdens = {"NL": 0.40, "PERSONA": 0.35, "SCAFFOLD": 0.30, "LANG-A": 0.10}
                elif branch == "B-SCAFFOLD":
                    burdens = {"NL": 0.40, "PERSONA": 0.40, "SCAFFOLD": 0.20, "LANG-A": 0.20}
                elif branch == "B-NULL":
                    burdens = {arm: 0.20 for arm in ("NL", "PERSONA", "SCAFFOLD", "LANG-A")}
                elif branch == "B-HARM":
                    burdens = {"NL": 0.20, "PERSONA": 0.20, "SCAFFOLD": 0.20, "LANG-A": 0.40}
                elif branch == "B-INTERACTION":
                    shift = -0.08 if family_index % 2 == 0 else 0.08
                    burdens = {"NL": 0.20, "PERSONA": 0.20, "SCAFFOLD": 0.20, "LANG-A": 0.20 + shift}
                else:
                    burdens = {"NL": 0.20, "PERSONA": 0.20, "SCAFFOLD": 0.20, "LANG-A": 0.13}
                for arm, burden in burdens.items():
                    defects = int(round(burden * 100))
                    rows.append({"item_id": item_id, "family": family, "subject_slot": subject, "arm": arm,
                                 "defect_total": defects, "scorable_opportunities": 100, "burden": defects / 100,
                                 "completeness": 1.0, "refusal": False, "abstention": False, "truncation": False,
                                 "over_bounding": False, "coupled_defect": False})
    gates = {"analysis_admissible": branch != "B-INCONCLUSIVE", "manipulation_checks_pass": True,
             "anti_taxidermy_harm": False, "owner_anti_taxidermy_thresholds_resolved": False}
    return {"rows": rows, "gates": gates, "intended_branch": branch, "synthetic_only": True}


def main():
    write_bytes(ROOT / "controls/synthetic-items.jsonl", jsonl_bytes(generate_synthetic_items()))
    for branch in ("B-NOTATION", "B-SCAFFOLD", "B-NULL", "B-HARM", "B-INTERACTION", "B-INCONCLUSIVE"):
        write_bytes(ROOT / "controls" / f"branch-{branch}.json", canonical_json_bytes(branch_payload(branch)))


if __name__ == "__main__":
    main()
