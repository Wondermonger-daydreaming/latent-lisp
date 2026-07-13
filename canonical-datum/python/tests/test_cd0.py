from __future__ import annotations

import builtins
from concurrent.futures import ThreadPoolExecutor
from dataclasses import FrozenInstanceError, replace
import json
import os
from pathlib import Path
import pickle
import socket
import subprocess
import sys
import textwrap
import unittest
from unittest import mock

import cd0


ROOT = Path(__file__).resolve().parents[3]
VECTOR_DIR = ROOT / "canonical-datum" / "vectors"


def read_jsonl(name: str) -> list[dict]:
    return [
        json.loads(line)
        for line in (VECTOR_DIR / name).read_text(encoding="utf-8").splitlines()
        if line
    ]


def load_budgets() -> dict[str, cd0.ResourceBudget]:
    document = json.loads((VECTOR_DIR / "cd0-budgets.json").read_text(encoding="utf-8"))
    raw = document["budgets"]
    resolved: dict[str, cd0.ResourceBudget] = {}
    for name, value in raw.items():
        if "base" in value:
            limits = dict(resolved[value["base"]].limits)
            limits.update({key: item for key, item in value.items() if key != "base"})
        else:
            limits = dict(value)
        resolved[name] = cd0.ResourceBudget.from_mapping(limits, identifier=name)
    return resolved


POSITIVES = read_jsonl("cd0-positive.jsonl")
NEGATIVES = read_jsonl("cd0-negative.jsonl")
BUDGETS = load_budgets()
DEFAULT = BUDGETS["cd0-conformance-default"]
DISTINCT_PAIRS = json.loads((VECTOR_DIR / "cd0-distinct-pairs.json").read_text(encoding="utf-8"))["pairs"]


def resolve_budget(value, *, identifier: str) -> cd0.ResourceBudget:
    if isinstance(value, str):
        return BUDGETS[value]
    return cd0.ResourceBudget.from_mapping(value, identifier=identifier)


def construct_positive(row: dict, budget: cd0.ResourceBudget) -> cd0.Datum:
    if "construction" in row:
        return cd0.from_fixture_construction(row["construction"], budget)
    return cd0.from_fixture_ast(row["abstract"], budget)


class SharedVectorTests(unittest.TestCase):
    """Methods are installed below so every shared row is one unittest."""


def make_positive_test(row: dict):
    def test(self: SharedVectorTests) -> None:
        budget = resolve_budget(row["budget"], identifier=f"{row['id']}:budget")
        constructed = construct_positive(row, budget)
        self.assertEqual(cd0.to_fixture_ast(constructed), row["expected_decoded"])
        expected_bytes = bytes.fromhex(row["canonical_hex"])
        self.assertEqual(cd0.encode_exact(constructed, budget), expected_bytes)
        decoded = cd0.decode_exact(expected_bytes, budget)
        self.assertEqual(cd0.to_fixture_ast(decoded), row["expected_decoded"])
        self.assertTrue(cd0.equal_datum(constructed, decoded))
        self.assertEqual(cd0.encode_exact(decoded, budget), expected_bytes)
        if "diagnostic" in row:
            self.assertEqual(cd0.diagnostic_render(decoded), row["diagnostic"])

        mutable_source = bytearray(expected_bytes)
        from_mutable = cd0.decode_exact(mutable_source, budget)
        mutable_source[:] = b"\xff" * len(mutable_source)
        self.assertEqual(cd0.encode_exact(from_mutable, budget), expected_bytes)

        mutable_ast = cd0.to_fixture_ast(decoded)
        mutable_ast.clear()
        self.assertEqual(cd0.encode_exact(decoded, budget), expected_bytes)

    return test


def make_negative_test(row: dict):
    def test(self: SharedVectorTests) -> None:
        budget = resolve_budget(row["budget"], identifier=f"{row['id']}:budget")
        with self.assertRaises(cd0.CD0Failure) as raised:
            if row["input_kind"] == "octets":
                cd0.decode_exact(bytes.fromhex(row["input_hex"]), budget)
            else:
                cd0.import_host_descriptor(row["host_input"], row["importer"], budget)

        expected = row["expected_failure"]
        actual = raised.exception.as_dict()
        self.assertEqual(row.get("status", "normative"), "normative")
        self.assertEqual(actual, expected)

        if "retry_budget" in row:
            retry = resolve_budget(row["retry_budget"], identifier=f"{row['id']}:retry")
            decoded = cd0.decode_exact(bytes.fromhex(row["input_hex"]), retry)
            self.assertEqual(cd0.encode_exact(decoded, retry).hex(), row["input_hex"])

    return test


for _index, _row in enumerate(POSITIVES, 1):
    setattr(
        SharedVectorTests,
        f"test_positive_{_index:02d}_{_row['id'].replace('-', '_')}",
        make_positive_test(_row),
    )

for _index, _row in enumerate(NEGATIVES, 1):
    setattr(
        SharedVectorTests,
        f"test_negative_{_index:02d}_{_row['id'].replace('-', '_')}",
        make_negative_test(_row),
    )


class ConstructorAndEqualityTests(unittest.TestCase):
    def test_all_nine_families_are_explicit_and_disjoint(self) -> None:
        values = (
            cd0.unit(),
            cd0.boolean(False),
            cd0.integer(0),
            cd0.rational(1, 2),
            cd0.string(""),
            cd0.byte_string(b""),
            cd0.identifier((), ("x",)),
            cd0.sequence(()),
            cd0.record(()),
        )
        self.assertEqual(len({type(value) for value in values}), 9)
        for left_index, left in enumerate(values):
            for right_index, right in enumerate(values):
                self.assertEqual(cd0.equal_datum(left, right), left_index == right_index)

    def test_python_bool_never_collapses_into_integer(self) -> None:
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.integer(True)
        self.assertEqual(raised.exception.triple, ("UnsupportedHostInput", "UnsupportedHostType", "host-import"))
        self.assertFalse(cd0.equal_datum(cd0.boolean(True), cd0.integer(1)))
        self.assertNotEqual(cd0.encode_exact(cd0.boolean(True), DEFAULT), cd0.encode_exact(cd0.integer(1), DEFAULT))

    def test_rational_constructor_normalizes(self) -> None:
        self.assertEqual(cd0.rational(2, 4), cd0.Rational(1, 2))
        self.assertEqual(cd0.rational(-2, -4), cd0.Rational(1, 2))
        self.assertEqual(cd0.rational(0, -9), cd0.Integer(0))
        self.assertEqual(cd0.rational(12, 4), cd0.Integer(3))
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.rational(1, 0)
        self.assertEqual(
            raised.exception.triple,
            ("UnsupportedHostInput", "ZeroDenominator", "host-import"),
        )

    def test_record_source_order_is_unobservable(self) -> None:
        key_a = cd0.identifier((), ("a",))
        key_b = cd0.identifier((), ("b",))
        forward = cd0.record(((key_a, cd0.integer(1)), (key_b, cd0.boolean(True))))
        reverse = cd0.record(((key_b, cd0.boolean(True)), (key_a, cd0.integer(1))))
        self.assertTrue(cd0.equal_datum(forward, reverse))
        self.assertEqual(cd0.encode_exact(forward, DEFAULT), cd0.encode_exact(reverse, DEFAULT))
        self.assertEqual(tuple(key.path[0] for key, _ in reverse.items_view), ("a", "b"))

    def test_duplicate_record_constructor_is_refused(self) -> None:
        key = cd0.identifier((), ("a",))
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.record(((key, cd0.unit()), (key, cd0.boolean(True))))
        self.assertEqual(raised.exception.triple, ("UnsupportedHostInput", "DuplicateRecordField", "host-import"))

    def test_unicode_is_scalar_exact_and_not_normalized(self) -> None:
        precomposed = cd0.string("\u00e9")
        decomposed = cd0.string("e\u0301")
        self.assertFalse(cd0.equal_datum(precomposed, decomposed))
        self.assertNotEqual(cd0.encode_exact(precomposed, DEFAULT), cd0.encode_exact(decomposed, DEFAULT))
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.string("\ud800")
        self.assertEqual(raised.exception.code, "InvalidHostUnicode")

    def test_identifier_distinctions(self) -> None:
        values = (
            cd0.identifier((), ("A",)),
            cd0.identifier((), ("a",)),
            cd0.identifier(("n",), ("a",)),
            cd0.identifier((), ("a", "b")),
            cd0.identifier((), ("ab",)),
            cd0.identifier((), ("\u00e9",)),
            cd0.identifier((), ("e\u0301",)),
        )
        encoded = {cd0.encode_exact(value, DEFAULT) for value in values}
        self.assertEqual(len(encoded), len(values))

    def test_equality_encoding_equivalence_for_normalized_constructions(self) -> None:
        normalized = cd0.rational(2, 4)
        direct = cd0.Rational(1, 2)
        self.assertTrue(cd0.equal_datum(normalized, direct))
        self.assertEqual(cd0.encode_exact(normalized, DEFAULT), cd0.encode_exact(direct, DEFAULT))


class ImmutabilityTests(unittest.TestCase):
    def test_mutable_sources_are_snapshotted(self) -> None:
        raw = bytearray(b"abc")
        view = memoryview(raw)
        bytes_value = cd0.byte_string(view)

        sequence_source = [cd0.string("left")]
        sequence_value = cd0.sequence(sequence_source)

        namespace_source = ["ns"]
        path_source = ["name"]
        identifier_value = cd0.identifier(namespace_source, path_source)

        fields_source = [(identifier_value, sequence_value)]
        record_value = cd0.record(fields_source)
        before = cd0.encode_exact(record_value, DEFAULT)

        raw[:] = b"xyz"
        sequence_source[0] = cd0.string("right")
        namespace_source[0] = "changed"
        path_source.append("changed")
        fields_source.clear()

        self.assertEqual(bytes_value.value, b"abc")
        self.assertEqual(sequence_value.items, (cd0.string("left"),))
        self.assertEqual(identifier_value.namespace, ("ns",))
        self.assertEqual(identifier_value.path, ("name",))
        self.assertEqual(cd0.encode_exact(record_value, DEFAULT), before)

    def test_decoded_mutable_buffer_is_snapshotted(self) -> None:
        source = bytearray.fromhex("4c504344002103616263")
        datum = cd0.decode_exact(source, DEFAULT)
        expected = cd0.encode_exact(datum, DEFAULT)
        source[:] = b"\x00" * len(source)
        self.assertEqual(cd0.encode_exact(datum, DEFAULT), expected)
        self.assertEqual(datum.value, b"abc")

    def test_accessors_are_immutable(self) -> None:
        datum = cd0.sequence((cd0.byte_string(bytearray(b"x")),))
        self.assertIsInstance(datum.items, tuple)
        self.assertIsInstance(datum.items[0].value, bytes)
        with self.assertRaises(FrozenInstanceError):
            datum.items = ()  # type: ignore[misc]
        with self.assertRaises(TypeError):
            datum.items[0].value[0] = 0  # type: ignore[index]

    def test_fixture_ast_output_is_a_defensive_copy(self) -> None:
        datum = cd0.sequence((cd0.string("test"),))
        before = cd0.encode_exact(datum, DEFAULT)
        exported = cd0.to_fixture_ast(datum)
        exported["items"][0]["utf8_hex"] = "00"
        self.assertEqual(cd0.encode_exact(datum, DEFAULT), before)

    def test_budget_is_frozen_and_limit_view_is_read_only(self) -> None:
        with self.assertRaises(FrozenInstanceError):
            DEFAULT.max_depth = 1  # type: ignore[misc]
        with self.assertRaises(TypeError):
            DEFAULT.limits["max_depth"] = 1  # type: ignore[index]


class ResourceTests(unittest.TestCase):
    def assert_failure(self, callable_, triple: tuple[str, str, str]) -> cd0.CD0Failure:
        with self.assertRaises(cd0.CD0Failure) as raised:
            callable_()
        self.assertEqual(raised.exception.triple, triple)
        return raised.exception

    def test_output_boundary_is_atomic_and_retry_succeeds(self) -> None:
        too_small = replace(DEFAULT, max_output_octets=5, identifier="output-5")
        self.assert_failure(
            lambda: cd0.encode_exact(cd0.unit(), too_small),
            ("ResourceRefusal", "ExcessiveOutputLength", "allocation"),
        )
        self.assertEqual(cd0.encode_exact(cd0.unit(), DEFAULT).hex(), "4c5043440000")

    def test_depth_and_node_boundaries_retry(self) -> None:
        document = bytes.fromhex("4c50434400300100")
        depth_one = replace(DEFAULT, max_depth=1, identifier="depth-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, depth_one),
            ("ResourceRefusal", "ExcessiveNesting", "type-tag"),
        )
        node_one = replace(DEFAULT, max_nodes=1, identifier="nodes-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, node_one),
            ("ResourceRefusal", "NodeBudgetExceeded", "type-tag"),
        )
        self.assertEqual(cd0.to_fixture_ast(cd0.decode_exact(document, DEFAULT))["t"], "seq")

    def test_count_promised_items_use_count_stage_before_first_octet(self) -> None:
        cases = {
            "sequence item": "4c504344003001",
            "record key": "4c504344003101",
            "record value": "4c5043440031012200010161",
            "identifier namespace segment": "4c504344002201",
            "identifier path segment": "4c50434400220001",
        }
        for label, input_hex in cases.items():
            with self.subTest(label=label):
                self.assert_failure(
                    lambda input_hex=input_hex: cd0.decode_exact(bytes.fromhex(input_hex), DEFAULT),
                    ("InvalidCanonicalGrammar", "TruncatedInput", "count"),
                )

    def test_integer_magnitude_boundary_uses_mathematical_absolute_value(self) -> None:
        document = cd0.encode_exact(cd0.integer(-65), DEFAULT)
        seven_bits = replace(DEFAULT, max_integer_bits=7, identifier="integer-7")
        self.assertEqual(cd0.decode_exact(document, seven_bits), cd0.integer(-65))
        six_bits = replace(DEFAULT, max_integer_bits=6, identifier="integer-6")
        self.assert_failure(
            lambda: cd0.decode_exact(document, six_bits),
            ("ResourceRefusal", "IntegerBudgetExceeded", "integer-payload"),
        )

    def test_aggregate_payload_boundary_and_retry(self) -> None:
        document = cd0.encode_exact(cd0.string("ab"), DEFAULT)
        aggregate_one = replace(DEFAULT, max_aggregate_payload_octets=1, identifier="aggregate-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, aggregate_one),
            ("ResourceRefusal", "AggregatePayloadBudgetExceeded", "length"),
        )
        self.assertEqual(cd0.decode_exact(document, DEFAULT), cd0.string("ab"))

    def test_segment_boundary_and_retry(self) -> None:
        document = cd0.encode_exact(cd0.identifier((), ("ab",)), DEFAULT)
        segment_one = replace(DEFAULT, max_segment_octets=1, identifier="segment-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, segment_one),
            ("ResourceRefusal", "ExcessiveDeclaredLength", "length"),
        )
        self.assertEqual(cd0.decode_exact(document, DEFAULT), cd0.identifier((), ("ab",)))

    def test_identifier_segment_limit_is_aggregate(self) -> None:
        document = cd0.encode_exact(cd0.identifier(("n",), ("p",)), DEFAULT)
        one = replace(DEFAULT, max_identifier_segments=1, identifier="segments-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, one),
            ("ResourceRefusal", "ExcessiveIdentifierSegments", "count"),
        )

    def test_record_key_work_budget_for_encoder(self) -> None:
        datum = cd0.record(((cd0.identifier((), ("a",)), cd0.unit()),))
        four = replace(DEFAULT, max_total_record_key_octets=4, identifier="key-work-4")
        self.assert_failure(
            lambda: cd0.encode_exact(datum, four),
            ("ResourceRefusal", "RecordKeyWorkBudgetExceeded", "encode-ordering"),
        )
        self.assertTrue(cd0.encode_exact(datum, DEFAULT))

    def test_integer_varint_boundary_and_retry(self) -> None:
        document = cd0.encode_exact(cd0.integer(64), DEFAULT)
        one_octet = replace(DEFAULT, max_varint_octets=1, identifier="varint-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, one_octet),
            ("ResourceRefusal", "VarintBudgetExceeded", "integer-payload"),
        )
        two_octets = replace(DEFAULT, max_varint_octets=2, identifier="varint-2")
        self.assertEqual(cd0.decode_exact(document, two_octets), cd0.integer(64))

    def test_single_bytes_boundary_and_retry(self) -> None:
        document = cd0.encode_exact(cd0.byte_string(b"ab"), DEFAULT)
        one = replace(DEFAULT, max_single_bytes_octets=1, identifier="bytes-1")
        self.assert_failure(
            lambda: cd0.decode_exact(document, one),
            ("ResourceRefusal", "ExcessiveDeclaredLength", "length"),
        )
        self.assertEqual(cd0.decode_exact(document, DEFAULT), cd0.byte_string(b"ab"))

    def test_runtime_encoder_uses_only_output_and_key_work_limits(self) -> None:
        # Errata 0.1 A9: already-valid runtime data are not re-admitted under
        # decode/import structural limits.
        restrictive = replace(
            DEFAULT,
            max_depth=0,
            max_nodes=0,
            max_sequence_items=0,
            max_integer_bits=0,
            identifier="encoder-A9-choice",
        )
        self.assertEqual(
            cd0.encode_exact(cd0.sequence((cd0.integer(99),)), restrictive),
            cd0.encode_exact(cd0.sequence((cd0.integer(99),)), DEFAULT),
        )


class HostImportAndInertnessTests(unittest.TestCase):
    def test_fixture_import_detects_active_ancestry_cycle(self) -> None:
        cyclic: dict = {"t": "seq"}
        cyclic["items"] = [cyclic]
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.from_fixture_ast(cyclic, DEFAULT)
        self.assertEqual(raised.exception.triple, ("UnsupportedHostInput", "CyclicHostInput", "host-import"))

    def test_fixture_import_accepts_shared_acyclic_substructure(self) -> None:
        shared = {"t": "string", "utf8_hex": "736861726564"}
        ast = {"t": "seq", "items": [shared, shared]}
        datum = cd0.from_fixture_ast(ast, DEFAULT)
        self.assertEqual(datum.items[0], datum.items[1])
        self.assertEqual(
            cd0.to_fixture_ast(datum),
            {"t": "seq", "items": [dict(shared), dict(shared)]},
        )

    def test_host_descriptor_import_accepts_shared_acyclic_substructure(self) -> None:
        descriptor = {
            "root": {"$ref": "root"},
            "objects": {
                "root": {"host_type": "sequence", "items": [{"$ref": "leaf"}, {"$ref": "leaf"}]},
                "leaf": {"host_type": "integer", "value": "7"},
            },
        }
        datum = cd0.import_host_descriptor(descriptor, "generic-sequence-import/v0", DEFAULT)
        self.assertEqual(datum, cd0.sequence((cd0.integer(7), cd0.integer(7))))

    def test_fixture_import_snapshots_source_lists(self) -> None:
        ast = {"t": "seq", "items": [{"t": "bytes", "hex": "00ff"}]}
        datum = cd0.from_fixture_ast(ast, DEFAULT)
        before = cd0.encode_exact(datum, DEFAULT)
        ast["items"].clear()
        self.assertEqual(cd0.encode_exact(datum, DEFAULT), before)

    def test_privileged_looking_record_decodes_as_inert_record_without_hooks(self) -> None:
        labels = ("capability", "warrant", "claim", "certificate", "receipt", "authority")
        datum = cd0.record(
            tuple((cd0.identifier(("profile",), (label,)), cd0.string("inert")) for label in labels)
        )
        document = cd0.encode_exact(datum, DEFAULT)
        with (
            mock.patch.object(builtins, "eval", side_effect=AssertionError("eval invoked")),
            mock.patch.object(builtins, "open", side_effect=AssertionError("open invoked")),
            mock.patch.object(pickle, "loads", side_effect=AssertionError("pickle invoked")),
            mock.patch.object(socket, "socket", side_effect=AssertionError("network invoked")),
        ):
            decoded = cd0.decode_exact(document, DEFAULT)
        self.assertIs(type(decoded), cd0.Record)
        self.assertEqual(cd0.to_fixture_ast(decoded)["t"], "record")

    def test_arbitrary_python_objects_are_not_implicitly_imported(self) -> None:
        class PrivilegedLooking:
            capability = True

            def __repr__(self) -> str:
                raise AssertionError("repr must not be used")

        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.encode_exact(PrivilegedLooking(), DEFAULT)  # type: ignore[arg-type]
        self.assertEqual(raised.exception.triple, ("UnsupportedHostInput", "UnsupportedHostType", "host-import"))


class AmbientAndProcessTests(unittest.TestCase):
    def test_hash_seed_process_and_source_order_invariance(self) -> None:
        limits_json = json.dumps(dict(DEFAULT.limits), sort_keys=True)
        program = textwrap.dedent(
            f"""
            import json
            import cd0
            budget = cd0.ResourceBudget.from_mapping(json.loads({limits_json!r}), identifier='child')
            source = {{('alpha', 1), ('beta', 2), ('gamma', 3)}}
            fields = [(cd0.identifier(('ambient',), (name,)), cd0.integer(value)) for name, value in source]
            print(cd0.encode_exact(cd0.record(fields), budget).hex())
            """
        )
        outputs = []
        for seed in ("1", "777"):
            environment = dict(os.environ)
            environment["PYTHONHASHSEED"] = seed
            completed = subprocess.run(
                [sys.executable, "-c", program],
                check=True,
                capture_output=True,
                text=True,
                env=environment,
            )
            outputs.append(completed.stdout.strip())
        self.assertEqual(outputs[0], outputs[1])

    def test_fixture_dictionary_insertion_order_is_irrelevant(self) -> None:
        first = {"t": "int", "v": "7"}
        second = {"v": "7", "t": "int"}
        self.assertEqual(
            cd0.encode_exact(cd0.from_fixture_ast(first, DEFAULT), DEFAULT),
            cd0.encode_exact(cd0.from_fixture_ast(second, DEFAULT), DEFAULT),
        )

    def test_concurrent_reads_and_encodes_are_invariant(self) -> None:
        datum = cd0.record(
            (
                (cd0.identifier(("concurrency",), ("payload",)), cd0.sequence((cd0.integer(1), cd0.string("x")))),
            )
        )
        expected = cd0.encode_exact(datum, DEFAULT)
        with ThreadPoolExecutor(max_workers=8) as executor:
            observed = list(executor.map(lambda _: cd0.encode_exact(datum, DEFAULT), range(128)))
        self.assertEqual(observed, [expected] * 128)


class HostStackSafetyTests(unittest.TestCase):
    DEPTH = 1500

    def deep_budget(self) -> cd0.ResourceBudget:
        return replace(
            DEFAULT,
            max_depth=self.DEPTH + 1,
            max_nodes=self.DEPTH + 1,
            identifier="python-host-stack-witness",
        )

    def assert_allocation_refusal(self, callable_) -> None:
        old_limit = sys.getrecursionlimit()
        try:
            sys.setrecursionlimit(300)
            with self.assertRaises(cd0.CD0Failure) as raised:
                callable_()
        finally:
            sys.setrecursionlimit(old_limit)
        self.assertEqual(
            raised.exception.triple,
            ("ResourceRefusal", "AllocationRefused", "allocation"),
        )

    def nested_datum(self, leaf: cd0.Datum | None = None) -> cd0.Datum:
        value = cd0.unit() if leaf is None else leaf
        for _ in range(self.DEPTH):
            value = cd0.sequence((value,))
        return value

    def test_deep_decode_translates_host_stack_exhaustion(self) -> None:
        document = b"LPCD\x00" + b"\x30\x01" * self.DEPTH + b"\x00"
        self.assert_allocation_refusal(lambda: cd0.decode_exact(document, self.deep_budget()))

    def test_deep_encode_translates_host_stack_exhaustion(self) -> None:
        value = self.nested_datum()
        self.assert_allocation_refusal(lambda: cd0.encode_exact(value, self.deep_budget()))

    def test_deep_fixture_import_translates_host_stack_exhaustion(self) -> None:
        ast: dict = {"t": "unit"}
        for _ in range(self.DEPTH):
            ast = {"t": "seq", "items": [ast]}
        self.assert_allocation_refusal(lambda: cd0.from_fixture_ast(ast, self.deep_budget()))

    def test_deep_descriptor_import_translates_host_stack_exhaustion(self) -> None:
        node: dict = {"host_type": "unit"}
        for _ in range(self.DEPTH):
            node = {"host_type": "sequence", "items": [node]}
        descriptor = {"root": node, "objects": {}}
        self.assert_allocation_refusal(
            lambda: cd0.import_host_descriptor(
                descriptor,
                "generic-sequence-import/v0",
                self.deep_budget(),
            )
        )

    def test_iterative_equality_survives_deep_values(self) -> None:
        left = self.nested_datum(cd0.integer(1))
        equal = self.nested_datum(cd0.integer(1))
        distinct = self.nested_datum(cd0.integer(2))
        old_limit = sys.getrecursionlimit()
        try:
            sys.setrecursionlimit(100)
            self.assertTrue(cd0.equal_datum(left, equal))
            self.assertFalse(cd0.equal_datum(left, distinct))
        finally:
            sys.setrecursionlimit(old_limit)

    def test_iterative_fixture_export_survives_deep_values(self) -> None:
        ast = cd0.to_fixture_ast(self.nested_datum())
        for _ in range(self.DEPTH):
            self.assertEqual(ast["t"], "seq")
            ast = ast["items"][0]
        self.assertEqual(ast, {"t": "unit"})

    def test_deep_diagnostic_translates_host_stack_exhaustion(self) -> None:
        value = self.nested_datum()
        self.assert_allocation_refusal(lambda: cd0.diagnostic_render(value))


class DecimalGuardTests(unittest.TestCase):
    @unittest.skipUnless(hasattr(sys, "set_int_max_str_digits"), "Python has no decimal digit guard")
    def test_local_digit_limit_does_not_change_fixture_identity(self) -> None:
        source = "1" + "0" * 999
        old_limit = sys.get_int_max_str_digits()
        try:
            sys.set_int_max_str_digits(640)
            datum = cd0.from_fixture_ast({"t": "int", "v": source}, DEFAULT)
            self.assertEqual(cd0.to_fixture_ast(datum), {"t": "int", "v": source})
            self.assertEqual(cd0.diagnostic_render(datum), source)
            rational = cd0.from_fixture_ast({"t": "rat", "p": "1", "q": source}, DEFAULT)
            self.assertEqual(
                cd0.to_fixture_ast(rational),
                {"t": "rat", "p": "1", "q": source},
            )
            self.assertEqual(cd0.diagnostic_render(rational), f"rat(1,{source})")
            descriptor = {
                "root": {"host_type": "integer", "value": source},
                "objects": {},
            }
            imported = cd0.import_host_descriptor(
                descriptor,
                "generic-sequence-import/v0",
                DEFAULT,
            )
            self.assertTrue(cd0.equal_datum(imported, datum))
        finally:
            sys.set_int_max_str_digits(old_limit)

    @unittest.skipUnless(hasattr(sys, "set_int_max_str_digits"), "Python has no decimal digit guard")
    def test_cross_process_digit_limit_does_not_change_fixture_identity(self) -> None:
        limits_json = json.dumps(dict(DEFAULT.limits), sort_keys=True)
        program = textwrap.dedent(
            f"""
            import json
            import sys
            import cd0
            sys.set_int_max_str_digits(640)
            budget = cd0.ResourceBudget.from_mapping(json.loads({limits_json!r}), identifier='digit-child')
            source = '1' + '0' * 999
            datum = cd0.from_fixture_ast({{'t': 'int', 'v': source}}, budget)
            print(cd0.to_fixture_ast(datum)['v'] == source)
            print(cd0.diagnostic_render(datum) == source)
            """
        )
        completed = subprocess.run(
            [sys.executable, "-c", program],
            check=True,
            capture_output=True,
            text=True,
            env=dict(os.environ),
        )
        self.assertEqual(completed.stdout.splitlines(), ["True", "True"])

    def test_oversized_decimal_refuses_before_unbounded_integer_construction(self) -> None:
        tiny = replace(DEFAULT, max_integer_bits=8, identifier="fixture-integer-8")
        operations = (
            lambda: cd0.from_fixture_ast({"t": "int", "v": "9" * 5000}, tiny),
            lambda: cd0.from_fixture_ast(
                {"t": "rat", "p": "1", "q": "9" * 5000},
                tiny,
            ),
            lambda: cd0.import_host_descriptor(
                {
                    "root": {"host_type": "integer", "value": "9" * 5000},
                    "objects": {},
                },
                "generic-sequence-import/v0",
                tiny,
            ),
        )
        for operation in operations:
            with self.subTest(operation=operation), self.assertRaises(cd0.CD0Failure) as raised:
                operation()
            self.assertEqual(
                raised.exception.triple,
                ("ResourceRefusal", "IntegerBudgetExceeded", "host-import"),
            )

    def test_fixture_decimal_rejects_negative_zero(self) -> None:
        for ast in (
            {"t": "int", "v": "-0"},
            {"t": "rat", "p": "-0", "q": "2"},
            {"t": "rat", "p": "1", "q": "-0"},
        ):
            with self.subTest(ast=ast), self.assertRaises(cd0.CD0Failure) as raised:
                cd0.from_fixture_ast(ast, DEFAULT)
            self.assertEqual(
                raised.exception.triple,
                ("UnsupportedHostInput", "UnsupportedHostType", "host-import"),
            )
        descriptor = {"root": {"host_type": "integer", "value": "-0"}, "objects": {}}
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.import_host_descriptor(descriptor, "generic-sequence-import/v0", DEFAULT)
        self.assertEqual(
            raised.exception.triple,
            ("UnsupportedHostInput", "UnsupportedHostType", "host-import"),
        )


class HostImportPreallocationTests(unittest.TestCase):
    def test_fixture_hex_budget_precedes_bytes_conversion(self) -> None:
        tiny = replace(DEFAULT, max_single_bytes_octets=1, identifier="fixture-bytes-1")
        with mock.patch.object(
            cd0,
            "_fixture_hex_to_bytes",
            side_effect=AssertionError("hex conversion reached"),
        ):
            with self.assertRaises(cd0.CD0Failure) as raised:
                cd0.from_fixture_ast({"t": "bytes", "hex": "0001"}, tiny)
        self.assertEqual(
            raised.exception.triple,
            ("ResourceRefusal", "ExcessiveDeclaredLength", "host-import"),
        )

    def test_descriptor_hex_budget_precedes_bytes_conversion(self) -> None:
        tiny = replace(DEFAULT, max_single_bytes_octets=1, identifier="descriptor-bytes-1")
        descriptor = {"root": {"host_type": "bytes", "hex": "0001"}, "objects": {}}
        with mock.patch.object(
            cd0,
            "_fixture_hex_to_bytes",
            side_effect=AssertionError("hex conversion reached"),
        ):
            with self.assertRaises(cd0.CD0Failure) as raised:
                cd0.import_host_descriptor(descriptor, "generic-sequence-import/v0", tiny)
        self.assertEqual(
            raised.exception.triple,
            ("ResourceRefusal", "ExcessiveDeclaredLength", "host-import"),
        )

    def test_fixture_container_limits_precede_runtime_construction(self) -> None:
        cases = (
            (
                {"t": "seq", "items": [{"t": "unit"}]},
                replace(DEFAULT, max_sequence_items=0, identifier="fixture-sequence-0"),
            ),
            (
                {
                    "t": "record",
                    "fields": [
                        {
                            "key": {"t": "id", "namespace_utf8_hex": [], "path_utf8_hex": ["61"]},
                            "value": {"t": "unit"},
                        }
                    ],
                },
                replace(DEFAULT, max_record_fields=0, identifier="fixture-record-0"),
            ),
            (
                {"t": "id", "namespace_utf8_hex": [], "path_utf8_hex": ["61"]},
                replace(DEFAULT, max_identifier_segments=0, identifier="fixture-segments-0"),
            ),
        )
        for ast, budget in cases:
            with self.subTest(tag=ast["t"]), self.assertRaises(cd0.CD0Failure) as raised:
                cd0.from_fixture_ast(ast, budget)
            self.assertEqual(raised.exception.category, "ResourceRefusal")


class GrammarBoundaryTests(unittest.TestCase):
    def test_integer_and_uvar_boundaries_round_trip(self) -> None:
        values = (
            0,
            -1,
            1,
            -64,
            64,
            -8192,
            8192,
            -(1 << 500),
            1 << 500,
        )
        roomy = replace(DEFAULT, max_varint_octets=80, identifier="integer-500-bits")
        for value in values:
            with self.subTest(value=value):
                datum = cd0.integer(value)
                encoded = cd0.encode_exact(datum, roomy)
                self.assertEqual(cd0.decode_exact(encoded, roomy), datum)

    def test_rational_large_exact_round_trip(self) -> None:
        datum = cd0.rational(-((1 << 300) + 1), (1 << 301) + 3)
        self.assertIs(type(datum), cd0.Rational)
        document = cd0.encode_exact(datum, DEFAULT)
        self.assertEqual(cd0.decode_exact(document, DEFAULT), datum)

    def test_valid_utf8_scalar_boundaries_and_noncharacters(self) -> None:
        text = "".join(
            chr(scalar)
            for scalar in (
                0x0000,
                0x007F,
                0x0080,
                0x07FF,
                0x0800,
                0xD7FF,
                0xE000,
                0xFDD0,
                0xFFFF,
                0x10000,
                0x10FFFF,
                0xFEFF,
            )
        )
        datum = cd0.string(text)
        document = cd0.encode_exact(datum, DEFAULT)
        self.assertEqual(cd0.decode_exact(document, DEFAULT), datum)

    def test_additional_invalid_utf8_shapes(self) -> None:
        payloads = (b"\xc1\x80", b"\xc2", b"\xe1\x80", b"\xf1\x80\x80", b"\xf5\x80\x80\x80", b"\xe1A\x80")
        for payload in payloads:
            with self.subTest(payload=payload.hex()):
                document = b"LPCD\x00\x20" + bytes((len(payload),)) + payload
                with self.assertRaises(cd0.CD0Failure) as raised:
                    cd0.decode_exact(document, DEFAULT)
                self.assertEqual(raised.exception.triple, ("InvalidCanonicalGrammar", "InvalidUTF8", "utf8"))

    def test_bom_is_preserved_as_data(self) -> None:
        datum = cd0.string("\ufeffA")
        decoded = cd0.decode_exact(cd0.encode_exact(datum, DEFAULT), DEFAULT)
        self.assertEqual(decoded.value, "\ufeffA")

    def test_record_prefix_like_keys_sort_by_complete_value_bytes(self) -> None:
        keys = (
            cd0.identifier((), ("a", "b")),
            cd0.identifier((), ("ab",)),
            cd0.identifier((), ("a",)),
            cd0.identifier(("a",), ("b",)),
        )
        datum = cd0.record(tuple((key, cd0.unit()) for key in reversed(keys)))
        document = cd0.encode_exact(datum, DEFAULT)
        decoded = cd0.decode_exact(document, DEFAULT)
        self.assertEqual(decoded, datum)
        key_documents = [cd0.encode_exact(key, DEFAULT)[5:] for key, _ in datum.fields]
        self.assertEqual(key_documents, sorted(key_documents))

    def test_A1_truncated_payload_stage(self) -> None:
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.decode_exact(bytes.fromhex("4c504344002002c3"), DEFAULT)
        self.assertEqual(raised.exception.triple, ("InvalidCanonicalGrammar", "TruncatedInput", "length"))

    def test_A5_simultaneous_resource_precedence(self) -> None:
        nested = bytes.fromhex("4c50434400300100")
        depth_and_nodes = replace(DEFAULT, max_depth=1, max_nodes=1, identifier="A5-depth-nodes")
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.decode_exact(nested, depth_and_nodes)
        self.assertEqual(
            raised.exception.triple,
            ("ResourceRefusal", "ExcessiveNesting", "type-tag"),
        )

        text = bytes.fromhex("4c5043440020026162")
        single_and_aggregate = replace(
            DEFAULT,
            max_single_string_octets=1,
            max_aggregate_payload_octets=1,
            identifier="A5-payloads",
        )
        with self.assertRaises(cd0.CD0Failure) as raised:
            cd0.decode_exact(text, single_and_aggregate)
        self.assertEqual(
            raised.exception.triple,
            ("ResourceRefusal", "ExcessiveDeclaredLength", "length"),
        )

    def test_A6_record_key_tag_precedence(self) -> None:
        with self.assertRaises(cd0.CD0Failure) as forbidden:
            cd0.decode_exact(bytes.fromhex("4c504344003101f0"), DEFAULT)
        self.assertEqual(
            forbidden.exception.triple,
            ("PrivilegedRestorationAttempt", "ForbiddenPrivilegedTag", "type-tag"),
        )
        with self.assertRaises(cd0.CD0Failure) as reserved:
            cd0.decode_exact(bytes.fromhex("4c50434400310103"), DEFAULT)
        self.assertEqual(
            reserved.exception.triple,
            ("InvalidCanonicalGrammar", "RecordKeyNotIdentifier", "record-key"),
        )


class ErrataClosureTests(unittest.TestCase):
    def assert_failure(self, callable_, triple: tuple[str, str, str]) -> None:
        with self.assertRaises(cd0.CD0Failure) as raised:
            callable_()
        self.assertEqual(raised.exception.triple, triple)

    def test_A2_constructor_invariant_failures_are_host_input(self) -> None:
        key = cd0.identifier((), ("a",))
        cases = (
            (lambda: cd0.rational(1, 0), "ZeroDenominator"),
            (lambda: cd0.identifier((), ()), "MissingIdentifierPath"),
            (lambda: cd0.identifier(("",), ("p",)), "EmptyIdentifierSegment"),
            (
                lambda: cd0.record(((key, cd0.unit()), (key, cd0.boolean(True)))),
                "DuplicateRecordField",
            ),
        )
        for operation, code in cases:
            with self.subTest(code=code):
                self.assert_failure(
                    operation,
                    ("UnsupportedHostInput", code, "host-import"),
                )

    def test_A3_magnitude_bits_are_exact_and_pre_reduction(self) -> None:
        for value in (0, 1, -1, 2, -2, 63, -65, 255, -256):
            with self.subTest(value=value):
                bits = abs(value).bit_length()
                datum = cd0.integer(value)
                document = cd0.encode_exact(datum, DEFAULT)
                exact = replace(DEFAULT, max_integer_bits=bits, identifier=f"A3-{value}-exact")
                self.assertEqual(cd0.decode_exact(document, exact), datum)
                if bits:
                    too_small = replace(
                        DEFAULT,
                        max_integer_bits=bits - 1,
                        identifier=f"A3-{value}-small",
                    )
                    self.assert_failure(
                        lambda document=document, too_small=too_small: cd0.decode_exact(
                            document,
                            too_small,
                        ),
                        ("ResourceRefusal", "IntegerBudgetExceeded", "integer-payload"),
                    )

        pre_reduction = replace(DEFAULT, max_integer_bits=1, identifier="A3-pre-reduction")
        self.assert_failure(
            lambda: cd0.from_fixture_construction(
                {"op": "rational", "p": "1024", "q": "1024"},
                pre_reduction,
            ),
            ("ResourceRefusal", "IntegerBudgetExceeded", "host-import"),
        )

    def test_A4_identifier_segment_budget_is_aggregate(self) -> None:
        datum = cd0.identifier(("n",), ("p",))
        document = cd0.encode_exact(datum, DEFAULT)
        exact = replace(DEFAULT, max_identifier_segments=2, identifier="A4-exact")
        small = replace(DEFAULT, max_identifier_segments=1, identifier="A4-small")
        self.assertEqual(cd0.decode_exact(document, exact), datum)
        self.assert_failure(
            lambda: cd0.decode_exact(document, small),
            ("ResourceRefusal", "ExcessiveIdentifierSegments", "count"),
        )

    def test_A5_resource_precedence_uses_complete_triples(self) -> None:
        nested = bytes.fromhex("4c50434400300100")
        both_structural = replace(DEFAULT, max_depth=1, max_nodes=1, identifier="A5-structural")
        self.assert_failure(
            lambda: cd0.decode_exact(nested, both_structural),
            ("ResourceRefusal", "ExcessiveNesting", "type-tag"),
        )
        text = bytes.fromhex("4c5043440020026162")
        both_payload = replace(
            DEFAULT,
            max_single_string_octets=1,
            max_aggregate_payload_octets=1,
            identifier="A5-payload",
        )
        self.assert_failure(
            lambda: cd0.decode_exact(text, both_payload),
            ("ResourceRefusal", "ExcessiveDeclaredLength", "length"),
        )

    def test_A6_forbidden_record_key_tag_retains_precedence(self) -> None:
        self.assert_failure(
            lambda: cd0.decode_exact(bytes.fromhex("4c504344003101f0"), DEFAULT),
            ("PrivilegedRestorationAttempt", "ForbiddenPrivilegedTag", "type-tag"),
        )
        self.assert_failure(
            lambda: cd0.decode_exact(bytes.fromhex("4c50434400310103"), DEFAULT),
            ("InvalidCanonicalGrammar", "RecordKeyNotIdentifier", "record-key"),
        )

    def test_A7_construction_descriptor_is_not_an_abstract_datum(self) -> None:
        cases = (
            ({"op": "rational", "p": "2", "q": "4"}, cd0.Rational(1, 2)),
            ({"op": "rational", "p": "2", "q": "2"}, cd0.Integer(1)),
            ({"op": "rational", "p": "0", "q": "7"}, cd0.Integer(0)),
        )
        for descriptor, expected in cases:
            with self.subTest(descriptor=descriptor):
                constructed = cd0.from_fixture_construction(descriptor, DEFAULT)
                self.assertEqual(constructed, expected)
                self.assertEqual(
                    cd0.to_fixture_ast(constructed),
                    cd0.to_fixture_ast(expected),
                )
        self.assert_failure(
            lambda: cd0.from_fixture_construction(
                {"op": "rational", "p": "1", "q": "0"},
                DEFAULT,
            ),
            ("UnsupportedHostInput", "ZeroDenominator", "host-import"),
        )

    def test_A7_construction_descriptor_translates_key_validation_allocation(self) -> None:
        descriptor = {"op": "rational", "p": "1", "q": "2"}
        with mock.patch.object(
            builtins,
            "set",
            side_effect=MemoryError("injected descriptor key-set allocation"),
        ):
            self.assert_failure(
                lambda: cd0.from_fixture_construction(descriptor, DEFAULT),
                ("ResourceRefusal", "AllocationRefused", "allocation"),
            )

    def test_A8_record_key_work_counts_each_occurrence_once(self) -> None:
        datum = cd0.record(
            (
                (cd0.identifier((), ("b",)), cd0.unit()),
                (cd0.identifier((), ("a",)), cd0.unit()),
            )
        )
        exact = replace(DEFAULT, max_total_record_key_octets=10, identifier="A8-exact")
        small = replace(DEFAULT, max_total_record_key_octets=9, identifier="A8-small")
        self.assertEqual(cd0.encode_exact(datum, exact), cd0.encode_exact(datum, DEFAULT))
        self.assert_failure(
            lambda: cd0.encode_exact(datum, small),
            ("ResourceRefusal", "RecordKeyWorkBudgetExceeded", "encode-ordering"),
        )

        wide_key = cd0.identifier(("\u00e9",), ("\U0001f600", "a" * 128))
        wide_datum = cd0.record(((wide_key, cd0.unit()),))
        value_octets = len(cd0.encode_exact(wide_key, DEFAULT)) - 5
        wide_exact = replace(
            DEFAULT,
            max_total_record_key_octets=value_octets,
            identifier="A8-wide-exact",
        )
        wide_small = replace(
            DEFAULT,
            max_total_record_key_octets=value_octets - 1,
            identifier="A8-wide-small",
        )
        self.assertEqual(
            cd0.encode_exact(wide_datum, wide_exact),
            cd0.encode_exact(wide_datum, DEFAULT),
        )
        self.assert_failure(
            lambda: cd0.encode_exact(wide_datum, wide_small),
            ("ResourceRefusal", "RecordKeyWorkBudgetExceeded", "encode-ordering"),
        )

    def test_A8_encoder_key_work_precedes_key_materialization(self) -> None:
        datum = cd0.record(((cd0.identifier((), ("a",)), cd0.unit()),))
        zero = replace(DEFAULT, max_total_record_key_octets=0, identifier="A8-encode-zero")
        with mock.patch.object(
            cd0,
            "_identifier_value_bytes",
            side_effect=MemoryError("injected key materialization"),
        ):
            self.assert_failure(
                lambda: cd0.encode_exact(datum, zero),
                ("ResourceRefusal", "RecordKeyWorkBudgetExceeded", "encode-ordering"),
            )

    def test_A8_fixture_key_work_precedes_key_materialization(self) -> None:
        fixture = {
            "t": "record",
            "fields": [
                {
                    "key": {
                        "t": "id",
                        "namespace_utf8_hex": [],
                        "path_utf8_hex": ["61"],
                    },
                    "value": {"t": "unit"},
                }
            ],
        }
        zero = replace(DEFAULT, max_total_record_key_octets=0, identifier="A8-import-zero")
        with mock.patch.object(
            cd0,
            "_identifier_value_bytes",
            side_effect=MemoryError("injected key materialization"),
        ):
            self.assert_failure(
                lambda: cd0.from_fixture_ast(fixture, zero),
                ("ResourceRefusal", "RecordKeyWorkBudgetExceeded", "host-import"),
            )

    def test_A9_runtime_encoding_ignores_structural_admission_budgets(self) -> None:
        datum = cd0.record(
            (
                (
                    cd0.identifier(("n",), ("p",)),
                    cd0.sequence((cd0.integer(99), cd0.string("x"), cd0.byte_string(b"y"))),
                ),
            )
        )
        runtime = replace(
            DEFAULT,
            max_input_octets=0,
            max_varint_octets=0,
            max_integer_bits=0,
            max_depth=0,
            max_nodes=0,
            max_sequence_items=0,
            max_record_fields=0,
            max_identifier_segments=0,
            max_segment_octets=0,
            max_single_string_octets=0,
            max_single_bytes_octets=0,
            max_aggregate_payload_octets=0,
            identifier="A9-runtime",
        )
        self.assertEqual(cd0.encode_exact(datum, runtime), cd0.encode_exact(datum, DEFAULT))

        decode_budget = replace(DEFAULT, max_output_octets=0, identifier="A9-decode")
        self.assertEqual(
            cd0.decode_exact(cd0.encode_exact(cd0.integer(1), DEFAULT), decode_budget),
            cd0.integer(1),
        )
        import_budget = replace(
            DEFAULT,
            max_input_octets=0,
            max_output_octets=0,
            max_varint_octets=0,
            identifier="A9-import",
        )
        self.assertEqual(
            cd0.from_fixture_ast({"t": "int", "v": "1"}, import_budget),
            cd0.integer(1),
        )


class DiagnosticTests(unittest.TestCase):
    def test_diagnostic_rendering_is_ascii_only_and_separate_from_identity(self) -> None:
        datum = cd0.string('"\\\n\r\t\x00\u00e9')
        rendered = cd0.diagnostic_render(datum)
        self.assertEqual(rendered, '"\\"\\\\\\n\\r\\t\\u{0}\\u{e9}"')
        rendered.encode("ascii")
        self.assertNotEqual(rendered.encode("ascii"), cd0.encode_exact(datum, DEFAULT))


class VectorManifestTests(unittest.TestCase):
    def test_fixture_counts_are_exact(self) -> None:
        self.assertEqual(len(POSITIVES), 25)
        self.assertEqual(len(NEGATIVES), 71)

    def test_equality_classes_are_coherent(self) -> None:
        groups: dict[str, list[cd0.Datum]] = {}
        for row in POSITIVES:
            groups.setdefault(row["equality_class"], []).append(
                construct_positive(
                    row,
                    resolve_budget(row["budget"], identifier=f"{row['id']}:equality"),
                )
            )
        for values in groups.values():
            for value in values[1:]:
                self.assertTrue(cd0.equal_datum(values[0], value))
                self.assertEqual(cd0.encode_exact(values[0], DEFAULT), cd0.encode_exact(value, DEFAULT))

    def test_declared_distinct_pairs_are_unequal_and_encode_differently(self) -> None:
        by_id = {
            row["id"]: construct_positive(
                row,
                resolve_budget(row["budget"], identifier=f"{row['id']}:distinct"),
            )
            for row in POSITIVES
        }
        for pair in DISTINCT_PAIRS:
            with self.subTest(left=pair["left"], right=pair["right"]):
                left = by_id[pair["left"]]
                right = by_id[pair["right"]]
                self.assertFalse(cd0.equal_datum(left, right))
                self.assertNotEqual(cd0.encode_exact(left, DEFAULT), cd0.encode_exact(right, DEFAULT))


if __name__ == "__main__":
    unittest.main(verbosity=2)
