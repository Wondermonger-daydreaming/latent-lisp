import argparse
import json
from pathlib import Path

from conditions import ScorerMutationSurvived, SchemaViolation
from util import canonical_json_bytes, load_json, write_new_bytes


DEFECT_FIELDS = ("unsupported_assertions", "scope_errors", "version_errors", "residue_erasures")
ANTI_FIELDS = ("unnecessary_abstention", "excessive_qualification", "omitted_supported_conclusion", "procedural_caveat_substitution")


def score_facts(call_id, facts, mutation=None):
    opportunities = facts.get("scorable_opportunities")
    if not isinstance(opportunities, int) or opportunities <= 0:
        raise SchemaViolation(f"{call_id}: fixed denominator must be a positive integer")
    counts = {name: facts.get(name, 0) for name in DEFECT_FIELDS}
    if any(not isinstance(value, int) or value < 0 for value in counts.values()):
        raise SchemaViolation(f"{call_id}: defect counts must be nonnegative integers")
    if mutation == "drop-unsupported":
        counts["unsupported_assertions"] = 0
    defect_total = sum(counts.values())
    answerable = facts.get("answerable_units", 0)
    emitted = facts.get("emitted_answerable_units", 0)
    completeness = (emitted / answerable) if answerable else 1.0
    anti = {name: bool(facts.get(name, False)) for name in ANTI_FIELDS}
    gutted = bool(facts.get("refusal") or facts.get("abstention") or facts.get("truncation") or facts.get("over_bounding") or any(anti.values()) or completeness < 1.0)
    if mutation == "reward-deletion" and gutted:
        completeness = 1.0
        anti = {name: False for name in ANTI_FIELDS}
        gutted = False
    return {
        "schema_version": "lae-score/0.2", "call_id": call_id, "synthetic_only": True,
        "deterministic": {"language_a_validator": "not-applicable-synthetic-prose", "typed_condition": None, "manifest_parse": "pass"},
        "keyed": {**counts, "defect_total": defect_total, "scorable_opportunities": opportunities, "burden": defect_total / opportunities},
        "anti_taxidermy": {"answerable_units": answerable, "emitted_answerable_units": emitted, "completeness": completeness,
            "refusal": bool(facts.get("refusal")), "abstention": bool(facts.get("abstention")), "truncation": bool(facts.get("truncation")),
            "over_bounding": bool(facts.get("over_bounding")), **anti, "coupled_defect": gutted},
        "rubric": {"answer_utility": facts.get("answer_utility"), "inspectability": None, "decorative_compliance": False},
        "grader_actor_ids": [], "grader_artifact_reads": [], "adjudication": None
    }


def score_normalized(path, mutation=None):
    normalized = load_json(path)
    artifact = normalized["content"]
    facts = artifact.get("synthetic_score_facts")
    if facts is None:
        raise SchemaViolation("network-off scorer accepts explicit synthetic_score_facts only")
    return score_facts(Path(path).stem, facts, mutation)


def score_run(run_dir, output_dir, mutation=None):
    run_dir, output_dir = Path(run_dir), Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    rows = []
    for path in sorted((run_dir / "normalized").glob("*.json")):
        score = score_normalized(path, mutation)
        write_new_bytes(output_dir / path.name, canonical_json_bytes(score))
        request = load_json(run_dir / "requests" / path.name)
        rows.append({"call_id": score["call_id"], "item_id": request["item_id"], "family": request["family"], "subject_slot": request["subject_slot"], "arm": request["arm"], **score["keyed"], **score["anti_taxidermy"]})
    write_new_bytes(output_dir / "analysis-input.json", canonical_json_bytes(rows))
    return rows


def assert_mutant_detected(base, mutated, name):
    if name == "insert-unsupported" and mutated["keyed"]["unsupported_assertions"] <= base["keyed"]["unsupported_assertions"]:
        raise ScorerMutationSurvived(name)
    if name in {"deletion", "blanket-uncertainty", "truncation", "omitted-answerable", "procedural-caveat"} and not mutated["anti_taxidermy"]["coupled_defect"]:
        raise ScorerMutationSurvived(name)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-dir", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--mutation", choices=("drop-unsupported", "reward-deletion"))
    args = parser.parse_args()
    rows = score_run(args.run_dir, args.output, args.mutation)
    print(f"SYNTHETIC-SCORING: PASS records={len(rows)}")


if __name__ == "__main__":
    main()
