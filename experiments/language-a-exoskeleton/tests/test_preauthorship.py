import copy
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "harness"))

import preauthorship as pre
from conditions import DraftItemUsedAsFrozen, MutationNotExercised, OwnerDecisionUnresolved


class PreauthorshipRepairTests(unittest.TestCase):
    def test_all_strict_schema_surfaces_exist(self):
        inventory = pre.schema_inventory()
        self.assertEqual(21, len(inventory))
        self.assertEqual(len(inventory), len({row["schema_version"] for row in inventory}))
        required = {
            "item-record", "source-packet-manifest", "source-component", "arm-rendering",
            "ancestry-declaration", "prior-exposure-declaration", "exclusion-taint-record",
            "lexical-collision-receipt", "semantic-overlap-receipt", "catchability-witness",
            "item-freezer-dossier", "freezer-decision-record", "key-author-input-manifest",
            "handoff-public-artifact",
            "owner-decision-record", "lineage-event", "opportunity-record", "keyed-unit-record",
            "future-score-profile-record", "construct-validity-specimen-record",
            "future-branch-receipt-riders",
        }
        self.assertEqual(required, {row["schema"] for row in inventory})

    def test_synthetic_graph_private_boundary_and_future_capacity_validate(self):
        records = pre.synthetic_record_graph()
        pre.validate_record_graph(records, allow_synthetic=True)
        for record in pre.synthetic_private_records() + pre.synthetic_construct_capacity_records():
            pre.validate_record(record)
        frozen = pre.synthetic_record_graph(state="frozen")
        self.assertTrue(pre.validate_key_author_input(pre.synthetic_key_manifest(), frozen))

    def test_successor_lineage_and_owner_predecessors_close(self):
        lineage = pre.load_successor_lineage()
        self.assertTrue(pre.validate_lineage(lineage))
        decisions = pre.validate_owner_records(pre.load_owner_records(), lineage_events=lineage)
        self.assertEqual("unresolved", decisions["ODR-43"]["status"])
        self.assertEqual("unresolved", decisions["ODR-60"]["status"])
        with self.assertRaises(OwnerDecisionUnresolved):
            pre.drafting_gate(list(decisions.values()))

    def test_every_frozen_consumer_uses_state_not_filename_or_boolean(self):
        item = pre.synthetic_record_graph()[-1]
        for consumer in sorted(pre.CONSUMERS_REQUIRING_FROZEN):
            with self.assertRaises(DraftItemUsedAsFrozen):
                pre.validate_consumption(item, consumer)

    def test_construct_specimens_are_identity_only_and_permanently_tainted(self):
        specimens = pre.validate_construct_specimen_registry()
        self.assertEqual({f"TXD-{number:02d}" for number in range(1, 11)}, {row["specimen_id"] for row in specimens})
        self.assertTrue(all(row["identity_only"] and not row["full_behavior_implemented"] for row in specimens))

    def test_authorial_custody_includes_design_note_without_authority_promotion(self):
        custody = pre.verify_authorial_inputs()
        note = next(row for row in custody["records"] if row["original_supplied_filename"] == "ANTI-TAXIDERMY-CONSTRUCT-VALIDITY-NOTE.md")
        self.assertEqual("owner-supplied-reviewed-design-input", note["standing"])
        self.assertEqual(27378, note["byte_length"])

    def test_undeclared_or_unimplemented_mutation_fails_verification(self):
        registry = copy.deepcopy(pre.strict_json_load(pre.MUTATION_REGISTRY_PATH))
        registry["mutations"].append({"mutation_id": "declared-but-not-implemented", "expected_condition": "PilotError"})
        with self.assertRaises(MutationNotExercised):
            pre.execute_mutations(registry)


if __name__ == "__main__":
    unittest.main(verbosity=2)
