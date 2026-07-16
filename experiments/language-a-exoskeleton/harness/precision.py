import argparse
import random
from pathlib import Path

from analyze import analyze
from util import PACKET_ROOT, canonical_json_bytes, load_json, sha256_bytes, write_bytes


ARMS = ("NL", "PERSONA", "SCAFFOLD", "LANG-A")
SUBJECTS = ("SYNTHETIC-SUBJECT-1", "SYNTHETIC-SUBJECT-2", "SYNTHETIC-SUBJECT-3")


def clamp(value, low=0.0, high=1.0):
    return max(low, min(high, value))


def binomial(generator, n, probability):
    return sum(generator.random() < probability for _ in range(n))


def simulate_rows(design, scenario, seed):
    generator = random.Random(seed)
    rows = []
    item_number = 0
    for family_index, family in enumerate(design["families"]):
        for _ in range(family["item_count"]):
            item_number += 1
            item_id = f"SIM-{item_number:04d}"
            item_effect = generator.gauss(0, scenario["within_family_sd"])
            family_effect = scenario["family_offsets"][family_index]
            opportunities = generator.choice(scenario["opportunity_distribution"])
            for subject_index, subject in enumerate(SUBJECTS):
                shared = generator.gauss(0, scenario["paired_latent_sd"])
                for arm in ARMS:
                    if generator.random() < scenario["missing_pair_probability"]:
                        continue
                    family_arm_shift = scenario.get("family_arm_shifts", {}).get(arm, [0.0, 0.0, 0.0, 0.0])[family_index]
                    probability = clamp(scenario["baseline_prevalence"] + item_effect + family_effect + family_arm_shift + scenario["subject_offsets"][subject_index] + shared * scenario["paired_correlation"] + scenario["arm_shifts"][arm])
                    defects = binomial(generator, opportunities, probability)
                    refusal = generator.random() < scenario["refusal_probability"]
                    truncation = generator.random() < scenario["truncation_probability"]
                    omission = generator.random() < scenario["omission_probability"]
                    rows.append({
                        "item_id": item_id, "family": family["family_id"], "subject_slot": subject, "arm": arm,
                        "defect_total": defects, "scorable_opportunities": opportunities, "burden": defects / opportunities,
                        "completeness": 0.0 if refusal else (0.5 if omission or truncation else 1.0),
                        "refusal": refusal, "abstention": refusal, "truncation": truncation, "over_bounding": omission,
                        "coupled_defect": refusal or truncation or omission
                    })
    return rows


def run_study(design, scenarios, master_seed=90210, repetitions=36, bootstrap_iterations=160):
    all_branches = ("B-HARM", "B-INTERACTION", "B-NOTATION", "B-SCAFFOLD", "B-NULL", "B-INCONCLUSIVE")
    reports = []
    master = random.Random(master_seed)
    for scenario in scenarios:
        counts = {branch: 0 for branch in all_branches}
        interval_widths = []
        for _ in range(repetitions):
            rows = simulate_rows(design, scenario, master.randrange(1 << 63))
            receipt = analyze({"rows": rows, "gates": {"analysis_admissible": True, "manipulation_checks_pass": True,
                "anti_taxidermy_harm": False, "owner_anti_taxidermy_thresholds_resolved": False}}, seed=master.randrange(1 << 31), iterations=bootstrap_iterations)
            counts[receipt["banked_branch"]] += 1
            dn = receipt["estimates"]["D_N"]["interval_95"]
            if dn["low"] is not None:
                interval_widths.append(dn["high"] - dn["low"])
        reports.append({"scenario_id": scenario["scenario_id"], "synthetic_truth_label": scenario["truth_label"],
                        "branch_counts": counts, "branch_frequencies": {key: counts[key] / repetitions for key in all_branches},
                        "mean_D_N_interval_width": sum(interval_widths) / len(interval_widths) if interval_widths else None})
    reachable = {branch: any(report["branch_counts"][branch] > 0 for report in reports) for branch in all_branches}
    truth_to_branch = {"notation": "B-NOTATION", "scaffold": "B-SCAFFOLD", "equivalence": "B-NULL", "harm": "B-HARM", "interaction": "B-INTERACTION"}
    structural_checks = []
    for scenario, scenario_report in zip(scenarios, reports):
        if not scenario.get("canonical_favorable"):
            continue
        branch = truth_to_branch[scenario["truth_label"]]
        selected = scenario_report["branch_counts"][branch]
        structural_checks.append({"scenario_id": scenario["scenario_id"], "intended_branch": branch, "selections": selected, "structurally_reachable": selected > 0})
        if selected == 0:
            raise RuntimeError(f"PILOT-AUTHORITY-RETURN — STRUCTURALLY UNREACHABLE BRANCH: {branch}; scenario={scenario['scenario_id']}; smallest-change=requires owner design review under Errata 0.1 section 5.4")
    report = {
        "schema_version": "lae-synthetic-precision/0.2", "synthetic_only": True, "not_efficacy_evidence": True,
        "abstract": "Frozen pilot-scale synthetic design evidence for first-pass emission over the sampled item bank geometry, subject releases, routes, settings, and run window; no inference to hidden reasoning; no inference to enforcement efficacy; no inference to production custody, global independence, or totality.",
        "design_sha256": f"sha256:{sha256_bytes(canonical_json_bytes(design))}", "scenario_sha256": f"sha256:{sha256_bytes(canonical_json_bytes(scenarios))}",
        "master_seed": master_seed, "repetitions_per_scenario": repetitions, "bootstrap_iterations": bootstrap_iterations,
        "fixed_margins": {"delta": 0.1, "epsilon": 0.05, "harm": 0.1, "family_interaction": 0.15},
        "resampling": "items with replacement within family; retain all subject and arm observations; fixed subjects not resampled",
        "scenario_results": reports, "canonical_favorable_branch_checks": structural_checks, "branch_reachable_in_declared_grid": reachable,
        "required_questions": {
            "equivalence_interval_realistically_attainable": reachable["B-NULL"],
            "improvement_margin_estimable_with_useful_frequency": reachable["B-NOTATION"] or reachable["B-SCAFFOLD"],
            "harm_margin_estimable_with_useful_frequency": reachable["B-HARM"],
            "interaction_has_meaningful_operating_power": reachable["B-INTERACTION"],
            "sparse_counts_make_any_branch_structurally_unreachable": [key for key, value in reachable.items() if not value],
            "inconclusive_can_dominate_under_substantive_truth": any(r["branch_frequencies"]["B-INCONCLUSIVE"] >= 0.5 and r["synthetic_truth_label"] != "inconclusive" for r in reports)
        },
        "anti_taxidermy_limit": "Refusal, truncation, omission, and missingness are simulated, but unresolved owner numerical harm gates are not invented; branch frequencies are conditional on burden-based harm only.",
        "permitted_recommendation": "retain-proposed-design-as-feasibility-oriented-pilot",
        "owner_design_disposition": "UNRESOLVED-OWNER-SLOT"
    }
    report["report_sha256"] = sha256_bytes(canonical_json_bytes(report))
    return report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--design", default=str(PACKET_ROOT / "items/design/design.json"))
    parser.add_argument("--scenarios", default=str(PACKET_ROOT / "controls/precision-scenarios.json"))
    parser.add_argument("--output", default=str(PACKET_ROOT / "evidence/analysis/SYNTHETIC-PRECISION-REPORT.json"))
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    report = run_study(load_json(args.design), load_json(args.scenarios))
    data = canonical_json_bytes(report)
    if args.check:
        if Path(args.output).read_bytes() != data:
            raise RuntimeError("SyntheticPrecisionReplayDiverged")
    else:
        write_bytes(args.output, data)
    print(f"SYNTHETIC-PRECISION: PASS report_sha256={report['report_sha256']}")


if __name__ == "__main__":
    main()
