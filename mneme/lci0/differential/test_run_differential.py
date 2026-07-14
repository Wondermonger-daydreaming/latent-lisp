from __future__ import annotations

import copy
import unittest

import run_differential as subject


def _blocked_mismatches() -> list[dict[str, str]]:
    return [
        {
            "request_id": request_id,
            "kind": "vector",
            "disposition": "authorial-blocked",
        }
        for request_id in sorted(subject.BLOCKED_VECTOR_REQUESTS)
    ]


def _comparison() -> dict:
    result = {
        "counts": {
            "vector_requests": 215,
            "vector_passed": 211,
            "vector_blocked": 4,
        },
        "mismatches": _blocked_mismatches(),
    }
    return {
        "implementations": {
            "common-lisp": copy.deepcopy(result),
            "python": copy.deepcopy(result),
        },
        "cross_implementation_mismatches": [],
    }


class AuthorialBlockerGateTests(unittest.TestCase):
    def test_accepts_exact_closed_vector_census(self):
        self.assertTrue(subject._only_authorial_blockers(_comparison()))

    def test_rejects_nearby_vector_failure(self):
        value = _comparison()
        value["implementations"]["python"]["mismatches"].append(
            {"request_id": "vector:LCI0-P001", "kind": "vector"}
        )
        self.assertFalse(subject._only_authorial_blockers(value))

    def test_accepts_enumerated_path_only_cross_difference(self):
        value = _comparison()
        request_id = sorted(subject.BLOCKED_RELATION_PATH_REQUESTS)[0]
        value["cross_implementation_mismatches"] = [
            {
                "request_id": request_id,
                "kind": "relation",
                "differences": {
                    "failure": {
                        "common-lisp": {
                            "category": "relation-undetermined",
                            "code": "ScopeIncompatible",
                            "stage": "scope-relation",
                            "path": ["right"],
                        },
                        "python": {
                            "category": "relation-undetermined",
                            "code": "ScopeIncompatible",
                            "stage": "scope-relation",
                            "path": ["right", "calculus"],
                        },
                    }
                },
            }
        ]
        self.assertTrue(subject._only_authorial_blockers(value))

    def test_rejects_non_path_cross_difference(self):
        value = _comparison()
        request_id = sorted(subject.BLOCKED_RELATION_PATH_REQUESTS)[0]
        value["cross_implementation_mismatches"] = [
            {
                "request_id": request_id,
                "kind": "relation",
                "differences": {
                    "failure": {
                        "common-lisp": {
                            "category": "relation-undetermined",
                            "code": "ScopeIncompatible",
                            "stage": "scope-relation",
                            "path": ["right"],
                        },
                        "python": {
                            "category": "relation-undetermined",
                            "code": "ScopeRelationUnknown",
                            "stage": "scope-relation",
                            "path": ["right", "calculus"],
                        },
                    }
                },
            }
        ]
        self.assertFalse(subject._only_authorial_blockers(value))


class HostileConstructionTests(unittest.TestCase):
    def test_named_mutable_aliases_are_exact_fail_closed_witnesses(self):
        cases = {case["name"]: case for case in subject._hostile_cases()}
        expected = {
            "stable-ref-alias-display-model",
            "stable-ref-alias-bare-filename",
            "stable-ref-alias-mutable-url",
            "stable-ref-alias-latest-case-folded",
            "stable-ref-alias-main-case-folded",
            "stable-ref-alias-package-symbol-spelling",
        }
        self.assertTrue(expected <= set(cases))
        for name in expected:
            self.assertEqual(
                cases[name]["expected_failure"],
                {
                    "category": "reference-refusal",
                    "code": "UnresolvedAlias",
                    "stage": "stable-reference",
                    "path": ["material", "object-id"],
                },
            )


if __name__ == "__main__":
    unittest.main()
