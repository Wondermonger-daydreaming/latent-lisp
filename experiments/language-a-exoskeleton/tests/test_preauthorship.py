import copy
import hashlib
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "harness"))

import preauthorship as pre
from conditions import (DraftItemUsedAsFrozen, FreezerDossierReferenceInvalid,
                        MutationNotExercised, ODR43ExposureClassSetInvalid,
                        OwnerDecisionUnresolved, PreauthorshipSchemaViolation)


class PreauthorshipRepairTests(unittest.TestCase):
    def test_all_strict_schema_surfaces_exist(self):
        inventory = pre.schema_inventory()
        self.assertEqual(26, len(inventory))
        self.assertEqual(len(inventory), len({row["schema_version"] for row in inventory}))
        required = {
            "item-record", "source-packet-manifest", "source-component", "arm-rendering",
            "ancestry-declaration", "prior-exposure-declaration", "exclusion-taint-record",
            "lexical-collision-receipt", "semantic-overlap-receipt", "catchability-witness",
            "item-freezer-dossier", "freezer-decision-record", "state-transition-record",
            "frozen-bank-manifest", "key-author-input-manifest",
            "handoff-public-artifact",
            "owner-decision-record", "owner-decision-record-adopted", "odr-60-allocation-candidate", "lineage-event-legacy",
            "lineage-event", "opportunity-record", "keyed-unit-record",
            "future-score-profile-record", "construct-validity-specimen-record",
            "future-branch-receipt-riders",
        }
        self.assertEqual(required, {row["schema"] for row in inventory})

    def test_synthetic_graph_private_boundary_and_future_capacity_validate(self):
        records = pre.synthetic_record_graph()
        pre.validate_record_graph(records, allow_synthetic=True)
        for record in pre.synthetic_private_records() + pre.synthetic_construct_capacity_records():
            pre.validate_record(record)
        for state in ("freezer-accepted", "frozen"):
            graph = pre.synthetic_record_graph(state=state)
            pre.validate_record_graph(graph, allow_synthetic=True)
        frozen = pre.synthetic_frozen_bank_records()
        self.assertTrue(pre.validate_key_author_input(pre.synthetic_key_manifest(frozen), frozen, allow_synthetic=True))

    def test_successor_lineage_and_adopted_owner_heads_close(self):
        lineage = pre.load_successor_lineage()
        self.assertTrue(pre.validate_lineage(lineage))
        records = pre.load_owner_records()
        decisions = pre.validate_owner_records(records, require_adopted=True, lineage_events=lineage)
        self.assertEqual("adopted", decisions["ODR-43"]["status"])
        self.assertEqual("adopted", decisions["ODR-60"]["status"])
        self.assertTrue(pre.drafting_gate(records, lineage))
        self.assertEqual(2, sum(record["status"] == "unresolved" for record in records))

    def test_owner_candidate_is_commission_bound_unresolved_and_derived_only(self):
        candidate = pre.load_odr60_candidate()
        totals = pre.validate_odr60_candidate(candidate)
        self.assertTrue(pre.validate_odr60_ruling_match(candidate["allocation"]))
        self.assertEqual("unresolved-owner-payload", candidate["standing"])
        self.assertEqual(pre.COMMISSION_BASIS_DIGEST, candidate["commission_basis_sha256"])
        self.assertEqual(24, totals["total_item_slots"])
        self.assertFalse(any("total" in key for key in candidate["allocation"]))

    def test_unresolved_owner_predecessor_bytes_are_unchanged(self):
        expected = {
            "ODR-43.json": "9ca88d96f8f159f2cad199e6f85d8e6aaa7bf5a240029210540e4c456157a65f",
            "ODR-60.json": "3963288b92bb8d56f31dae4e7719acf33dfd03df08b921f20c8b65291653f9d3",
        }
        for name, digest in expected.items():
            self.assertEqual(digest, hashlib.sha256((pre.OWNER_RECORD_DIR / name).read_bytes()).hexdigest())

    def test_strict_transmission_and_typed_pending_receipt_both_validate(self):
        lineage = pre.load_successor_lineage()
        self.assertTrue(pre.validate_lineage(lineage))
        strict = [event for event in lineage if event["schema_version"] == "lae-lineage-event/2.0.0" and event["event_type"] == "transmission"]
        self.assertEqual(1, len(strict))
        self.assertTrue(strict[0]["artifact_refs"])
        self.assertTrue(pre.validate_lineage(pre.synthetic_transmission_lineage(pending_receipt=True)))

    def test_commission_golden_vector_and_escaped_fixture_custody(self):
        self.assertEqual(2, len(pre.verify_commission_inputs()))
        self.assertEqual(7, len(pre.validate_escaped_defect_registry()["fixtures"]))
        self.assertEqual(16003, pre.verify_owner_reverification()["byte_length"])
        self.assertEqual(259, pre.validate_canonical_golden_vector()["canonical_byte_length"])

    def test_complete_synthetic_owner_adoption_closes_and_real_successors_are_adopted(self):
        records, lineage = pre.synthetic_owner_adoption_graph()
        self.assertTrue(pre.validate_lineage(lineage))
        selected = pre.validate_owner_records(records, require_adopted=True, lineage_events=lineage)
        self.assertEqual({"ODR-43", "ODR-60"}, set(selected))
        self.assertTrue(pre.drafting_gate(records, lineage))
        self.assertEqual(2, sum(record["status"] == "adopted" for record in pre.load_owner_records()))

    def test_odr43_exposure_classes_are_exact_not_just_three_rows(self):
        records, _ = pre.synthetic_owner_adoption_graph()
        successor = next(
            record for record in records
            if record["decision_id"] == "ODR-43" and record["status"] == "adopted"
        )
        decision = successor["exact_decision"]
        decision["exposure_declarations"] = [copy.deepcopy(decision["exposure_declarations"][0]) for _ in range(3)]
        with self.assertRaises(ODR43ExposureClassSetInvalid):
            pre.validate_odr43_exposure_class_set(decision)
        with self.assertRaises(PreauthorshipSchemaViolation):
            pre.validate_record(pre._reseal(successor), "owner-decision-record", verify_bound_bytes=False)

    def test_missing_freezer_dossier_rejected_before_key_handoff(self):
        records = pre.synthetic_frozen_bank_records()
        key_manifest = pre.synthetic_key_manifest(records)
        without_dossier = [
            record for record in records
            if record["schema_version"] != "lae-item-freezer-dossier/1.0.0"
        ]
        with self.assertRaises(FreezerDossierReferenceInvalid):
            pre.validate_record_graph(without_dossier, allow_synthetic=True)
        self.assertTrue(pre.validate_key_author_input(key_manifest, records, allow_synthetic=True))
        self.assertFalse(any(entry["artifact_kind"] == "item-freezer-dossier" for entry in key_manifest["entries"]))

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
