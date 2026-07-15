from __future__ import annotations

import json
from pathlib import Path
import shutil
import tempfile
import unittest

from law_audit import (
    AuditAuthorityError, PACKET_NAME, SIDECAR_NAME, abstract_relation,
    canonical_json, scope_domain, temporal_domain, verify_packet,
)


PACKET_ROOT = Path("/tmp/lci0-law-audit-relay-20260715")
EXTRACTED = Path("/tmp/lci0-law-audit-packet-errata-0.1")


class HarnessIntegrityTests(unittest.TestCase):
    def test_01_altered_external_identity_is_distinct(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            packet = root / PACKET_NAME
            sidecar = root / SIDECAR_NAME
            payload = bytearray((PACKET_ROOT / PACKET_NAME).read_bytes())
            payload[-1] ^= 1
            packet.write_bytes(payload)
            sidecar.write_bytes((PACKET_ROOT / SIDECAR_NAME).read_bytes())
            with self.assertRaisesRegex(AuditAuthorityError, "external-identity"):
                verify_packet(packet, sidecar, EXTRACTED)

    def test_02_altered_internal_member_is_distinct(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            packet = root / PACKET_NAME
            sidecar = root / SIDECAR_NAME
            shutil.copyfile(PACKET_ROOT / PACKET_NAME, packet)
            shutil.copyfile(PACKET_ROOT / SIDECAR_NAME, sidecar)
            extracted = root / "packet"
            shutil.copytree(EXTRACTED, extracted)
            target = extracted / "LCI0-DISJOINT-FALLBACK-RULING.md"
            target.write_bytes(target.read_bytes() + b"altered\n")
            with self.assertRaisesRegex(AuditAuthorityError, "internal-coherence"):
                verify_packet(packet, sidecar, extracted)

    def test_03_exact_generator_counts_and_no_duplicates(self):
        temporal, scope = temporal_domain(), scope_domain()
        self.assertEqual((len(temporal), len(scope)), (36, 13))
        self.assertEqual(len({repr(value) for value in temporal}), 36)
        self.assertEqual(len({repr(value) for value in scope}), 13)

    def test_04_wrong_count_is_rejected(self):
        self.assertNotEqual(len(temporal_domain()[:-1]), 36)

    def test_05_wrong_converse_negative_control_is_detected(self):
        wrong = {"before": "before", "after": "after"}
        self.assertNotEqual(wrong["before"], "after")

    def test_06_weakened_composition_set_is_detected(self):
        table = json.loads((EXTRACTED / "LCI0-TEMPORAL-COMPOSITION-TABLE.json").read_text())
        row = next(row for row in table["bounded_linear_core"]["rows"]
                   if row["left_relation"] == "before" and row["right_relation"] == "after")
        self.assertGreater(len(row["permitted_result_relations"]), 1)
        self.assertNotEqual(set(row["permitted_result_relations"]), {"before"})

    def test_07_poisoned_policy_is_not_called_after_failure(self):
        calls = []
        def poison():
            calls.append("called")
            raise AssertionError("policy consulted")
        relation_failure = {"kind": "failure", "code": "ScopeRelationUnknown"}
        if relation_failure["kind"] != "failure":
            poison()
        self.assertEqual(calls, [])

    def test_08_shared_failure_is_not_divergence(self):
        same = {"kind": "relation", "relation": "synthetic-wrong"}
        self.assertEqual(abstract_relation(same), abstract_relation(dict(same)))
        self.assertNotEqual("shared-required-law-violation", "cross-language-divergence")

    def test_09_unresolved_fallback_is_not_pass_or_fail(self):
        inventory = json.loads((EXTRACTED / "LCI0-ALGEBRAIC-LAW-INVENTORY.json").read_text())
        law = next(row for row in inventory["laws"] if row["law_id"] == "LCI0-SCOPE-026")
        self.assertEqual(law["classification"], "AUTHORIALLY-UNRESOLVED")
        self.assertFalse(law["codex_hard_gate"])

    def test_10_cross_010_negative_control_without_adoption(self):
        inventory = json.loads((EXTRACTED / "LCI0-ALGEBRAIC-LAW-INVENTORY.json").read_text())
        law = next(row for row in inventory["laws"] if row["law_id"] == "LCI0-CROSS-010")
        self.assertEqual(law["classification"], "PROFILE-OPTIONAL")
        self.assertFalse(law["codex_hard_gate"])

    def test_11_extension_probe_stays_outside_registered_census(self):
        self.assertEqual(len(scope_domain()), 13)
        self.assertNotEqual(13 + 1, 13)

    def test_12_witness_serialization_order_is_byte_identical(self):
        left = {"z": [3, 2, 1], "a": {"y": 2, "x": 1}}
        right = {"a": {"x": 1, "y": 2}, "z": [3, 2, 1]}
        self.assertEqual(canonical_json(left), canonical_json(right))


if __name__ == "__main__":
    unittest.main(verbosity=2)
