import argparse
import math
import random
from collections import defaultdict
from pathlib import Path

from util import canonical_json_bytes, load_json, sha256_bytes, write_bytes


CONTRASTS = {"D_N": ("LANG-A", "SCAFFOLD"), "D_S": ("SCAFFOLD", "PERSONA"), "D_P": ("PERSONA", "NL")}
PRECEDENCE = ("B-HARM", "B-INTERACTION", "B-NOTATION", "B-SCAFFOLD", "B-NULL", "B-INCONCLUSIVE")


def percentile(values, probability):
    values = sorted(values)
    if not values:
        return None
    position = (len(values) - 1) * probability
    lower = math.floor(position)
    upper = math.ceil(position)
    if lower == upper:
        return values[lower]
    return values[lower] * (upper - position) + values[upper] * (position - lower)


def paired_cells(rows):
    by_cell = defaultdict(dict)
    for row in rows:
        if row["arm"] in {arm for pair in CONTRASTS.values() for arm in pair}:
            by_cell[(row["item_id"], row["family"], row["subject_slot"])][row["arm"]] = row
    cells = []
    for (item_id, family, subject), arms in sorted(by_cell.items()):
        record = {"item_id": item_id, "family": family, "subject_slot": subject, "contrasts": {}, "arms": arms}
        for name, (left, right) in CONTRASTS.items():
            if left in arms and right in arms:
                record["contrasts"][name] = arms[left]["burden"] - arms[right]["burden"]
        cells.append(record)
    return cells


def mean(values):
    return sum(values) / len(values) if values else None


def bootstrap(cells, seed, iterations):
    by_family_item = defaultdict(lambda: defaultdict(list))
    for cell in cells:
        by_family_item[cell["family"]][cell["item_id"]].append(cell)
    generator = random.Random(seed)
    distributions = {name: [] for name in CONTRASTS}
    family_distributions = {family: {name: [] for name in CONTRASTS} for family in by_family_item}
    for _ in range(iterations):
        retained = []
        retained_by_family = defaultdict(list)
        for family in sorted(by_family_item):
            identities = sorted(by_family_item[family])
            sampled = [generator.choice(identities) for _ in identities]
            for item_id in sampled:
                cluster = by_family_item[family][item_id]
                retained.extend(cluster)
                retained_by_family[family].extend(cluster)
        for name in CONTRASTS:
            values = [cell["contrasts"][name] for cell in retained if name in cell["contrasts"]]
            if values:
                distributions[name].append(mean(values))
            for family, family_cells in retained_by_family.items():
                family_values = [cell["contrasts"][name] for cell in family_cells if name in cell["contrasts"]]
                if family_values:
                    family_distributions[family][name].append(mean(family_values))
    return distributions, family_distributions


def interval(values):
    return {"low": percentile(values, 0.025), "high": percentile(values, 0.975)}


def secondary_opportunity_weighted(cells):
    results = {}
    for name, (left, right) in CONTRASTS.items():
        paired = [cell for cell in cells if name in cell["contrasts"]]
        left_num = sum(cell["arms"][left]["defect_total"] for cell in paired)
        left_den = sum(cell["arms"][left]["scorable_opportunities"] for cell in paired)
        right_num = sum(cell["arms"][right]["defect_total"] for cell in paired)
        right_den = sum(cell["arms"][right]["scorable_opportunities"] for cell in paired)
        results[name] = {"label": "secondary", "difference": (left_num / left_den) - (right_num / right_den),
                         "left_numerator": left_num, "left_denominator": left_den,
                         "right_numerator": right_num, "right_denominator": right_den}
    return results


def analyze(payload, seed=1729, iterations=800):
    if isinstance(payload, list):
        rows, gates = payload, {}
    else:
        rows, gates = payload["rows"], payload.get("gates", {})
    cells = paired_cells(rows)
    distributions, family_distributions = bootstrap(cells, seed, iterations)
    estimates = {}
    for name in CONTRASTS:
        values = [cell["contrasts"][name] for cell in cells if name in cell["contrasts"]]
        estimates[name] = {"estimate": mean(values), "paired_cells": len(values), "interval_95": interval(distributions[name]),
                           "sign_counts": {"negative": sum(v < 0 for v in values), "zero": sum(v == 0 for v in values), "positive": sum(v > 0 for v in values)}}
    family = {}
    for family_name in sorted(family_distributions):
        family[family_name] = {}
        family_cells = [cell for cell in cells if cell["family"] == family_name]
        for name in CONTRASTS:
            values = [cell["contrasts"][name] for cell in family_cells if name in cell["contrasts"]]
            family[family_name][name] = {"estimate": mean(values), "interval_95": interval(family_distributions[family_name][name])}
    delta, epsilon, harm, interaction_threshold = 0.10, 0.05, 0.10, 0.15
    valid = gates.get("analysis_admissible", True)
    manipulation = gates.get("manipulation_checks_pass", True)
    anti_harm = gates.get("anti_taxidermy_harm", False)

    def ci(name):
        return estimates[name]["interval_95"]

    harm_by_burden = any(ci(name)["low"] is not None and ci(name)["low"] >= harm for name in CONTRASTS)
    family_harm = any(data[name]["interval_95"]["low"] is not None and data[name]["interval_95"]["low"] >= harm for data in family.values() for name in CONTRASTS)
    harm_predicate = valid and (anti_harm or harm_by_burden or family_harm)
    dn_family = [data["D_N"] for data in family.values()]
    family_estimates = [entry["estimate"] for entry in dn_family if entry["estimate"] is not None]
    opposite = any(a["interval_95"]["high"] < 0 for a in dn_family) and any(a["interval_95"]["low"] > 0 for a in dn_family)
    interaction_predicate = valid and len(family_estimates) >= 2 and max(family_estimates) - min(family_estimates) > interaction_threshold and opposite
    notation_predicate = valid and manipulation and ci("D_N")["high"] is not None and ci("D_N")["high"] <= -delta
    scaffold_predicate = valid and manipulation and ci("D_S")["high"] is not None and ci("D_S")["high"] <= -delta and ci("D_N")["low"] >= -epsilon and ci("D_N")["high"] <= epsilon
    null_predicate = valid and manipulation and all(ci(name)["low"] >= -epsilon and ci(name)["high"] <= epsilon for name in CONTRASTS)
    predicates = {"B-HARM": harm_predicate, "B-INTERACTION": interaction_predicate, "B-NOTATION": notation_predicate,
                  "B-SCAFFOLD": scaffold_predicate, "B-NULL": null_predicate, "B-INCONCLUSIVE": True}
    banked = next(name for name in PRECEDENCE if predicates[name])
    receipt = {
        "schema_version": "lae-analysis/0.2", "pilot_scale_only": True, "synthetic_only": True,
        "primary_estimand": "unweighted mean of paired per-call burden differences across item-by-fixed-subject cells",
        "fixed_denominator": True, "bootstrap_unit": "item clustered within frozen family; all subject and arm observations retained",
        "fixed_subject_strata": True, "bootstrap_seed": seed, "bootstrap_iterations": iterations,
        "margins": {"delta": delta, "epsilon": epsilon, "harm": harm, "family_interaction": interaction_threshold},
        "estimates": estimates, "family_estimates": family, "secondary_opportunity_weighted": secondary_opportunity_weighted(cells),
        "gates": {"analysis_admissible": valid, "manipulation_checks_pass": manipulation, "anti_taxidermy_harm": anti_harm,
                  "owner_anti_taxidermy_thresholds_resolved": gates.get("owner_anti_taxidermy_thresholds_resolved", False)},
        "all_predicates": predicates, "branch_precedence": list(PRECEDENCE), "banked_branch": banked,
        "claim_ceiling": "synthetic branch fixture only; no pilot verdict and no efficacy evidence"
    }
    receipt["receipt_sha256"] = sha256_bytes(canonical_json_bytes(receipt))
    return receipt


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--seed", type=int, default=1729)
    parser.add_argument("--iterations", type=int, default=800)
    args = parser.parse_args()
    receipt = analyze(load_json(args.input), args.seed, args.iterations)
    write_bytes(args.output, canonical_json_bytes(receipt))
    print(f"SYNTHETIC-ANALYSIS: PASS branch={receipt['banked_branch']}")


if __name__ == "__main__":
    main()
