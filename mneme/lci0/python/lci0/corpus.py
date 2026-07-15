"""Independent exhaustive verification of the frozen LCI/0 CD/0 corpus."""

from __future__ import annotations

from dataclasses import dataclass
import hashlib
from typing import Any, Iterable, Iterator

import cd0

from .adapter import from_package_json, schema_census
from .core import CD0_BUDGET, canonical_bytes, field_by_path
from .package import iter_vectors, registry


MAGIC_HEX = "4c50434400"


class CorpusVerificationFailure(RuntimeError):
    pass


@dataclass(frozen=True, slots=True)
class CorpusReport:
    registry_definitions: int
    vectors: int
    official_documents: int
    relation_table_documents: int
    nested_e1_documents: int
    supplementary_documents: int
    total_documents: int
    schema_shapes: tuple[tuple[str, int], ...]
    magic_registry_values: int
    magic_vector_values: int


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise CorpusVerificationFailure(message)


def _merge_counts(total: dict[str, int], current: dict[str, int]) -> None:
    for name, count in current.items():
        total[name] = total.get(name, 0) + count


def _canonical_row(row: dict[str, Any], label: str, shape_counts: dict[str, int]) -> bytes:
    required = {"abstract_cd0", "canonical_cd0_hex"}
    _require(required <= set(row), f"{label}: missing canonical-document fields")
    encoded_hex = row["canonical_cd0_hex"]
    _require(type(encoded_hex) is str and encoded_hex.startswith(MAGIC_HEX), f"{label}: bad CD/0 magic")
    _require(len(encoded_hex) % 2 == 0 and encoded_hex == encoded_hex.lower(), f"{label}: noncanonical hex surface")
    encoded = bytes.fromhex(encoded_hex)
    if "canonical_octets_byte_count" in row:
        _require(type(row["canonical_octets_byte_count"]) is int, f"{label}: invalid byte count")
        _require(len(encoded) == row["canonical_octets_byte_count"], f"{label}: byte count mismatch")
    if "sha256_checksum_of_canonical_octets" in row:
        digest = row["sha256_checksum_of_canonical_octets"]
        _require(type(digest) is str and hashlib.sha256(encoded).hexdigest() == digest, f"{label}: SHA-256 mismatch")
    _merge_counts(shape_counts, schema_census(row["abstract_cd0"]))
    abstract = from_package_json(row["abstract_cd0"], CD0_BUDGET)
    decoded = cd0.decode_exact(encoded, CD0_BUDGET)
    _require(decoded == abstract, f"{label}: decoded datum differs from abstract datum")
    if "expected_decoded_abstract_value" in row:
        _merge_counts(shape_counts, schema_census(row["expected_decoded_abstract_value"]))
        expected = from_package_json(row["expected_decoded_abstract_value"], CD0_BUDGET)
        _require(decoded == expected, f"{label}: decoded datum differs from expected decoded datum")
    _require(cd0.encode_exact(decoded, CD0_BUDGET) == encoded, f"{label}: re-encoding differs")
    _require(canonical_bytes(abstract) == encoded, f"{label}: abstract encoding differs")
    return encoded


def _walk(value: Any, path: tuple[Any, ...] = ()) -> Iterator[tuple[tuple[Any, ...], Any]]:
    yield path, value
    if type(value) is dict:
        for key, child in value.items():
            yield from _walk(child, path + (key,))
    elif type(value) is list:
        for index, child in enumerate(value):
            yield from _walk(child, path + (index,))


def _magic_locations(value: Any) -> list[tuple[tuple[Any, ...], str]]:
    return [
        (path, child)
        for path, child in _walk(value)
        if type(child) is str and child.startswith(MAGIC_HEX)
    ]


def verify_corpus() -> CorpusReport:
    package_registry = registry()
    definitions = package_registry.get("definitions")
    _require(type(definitions) is list and len(definitions) == 675, "registry definition count mismatch")
    fixture_ids = [row.get("fixture_id") for row in definitions]
    _require(len(fixture_ids) == len(set(fixture_ids)), "duplicate fixture id")
    fixture_id_set = set(fixture_ids)
    shapes: dict[str, int] = {}

    official = 0
    for row in definitions:
        _canonical_row(row, f"definition:{row.get('fixture_id')}", shapes)
        official += 1

    vectors = list(iter_vectors())
    _require(len(vectors) == 215, "vector count mismatch")
    vector_ids = [row.get("vector_id") for row in vectors]
    _require(len(vector_ids) == len(set(vector_ids)), "duplicate vector id")
    required = {*(f"LCI0-P{number:03d}" for number in range(1, 31)), *(f"LCI0-N{number:03d}" for number in range(1, 33))}
    _require(required <= set(vector_ids), "missing required P/N vector")
    for row in vectors:
        vector_id = row.get("vector_id")
        _canonical_row(row["inputs"], f"vector-input:{vector_id}", shapes)
        _canonical_row(row["expected"], f"vector-expected:{vector_id}", shapes)
        official += 2
    _require(official == 1105, "official document count mismatch")

    relation_count = 0
    tables = package_registry.get("relation_and_mapping_tables")
    _require(type(tables) is dict, "relation/mapping table shape mismatch")
    for table_name in ("scope_relation_table_0", "temporal_relation_table_0"):
        table = tables.get(table_name)
        _require(type(table) is dict and type(table.get("entries")) is list, f"{table_name}: bad table shape")
        for index, row in enumerate(table["entries"]):
            _canonical_row(row, f"{table_name}:{index}", shapes)
            _require(row.get("left_fixture") in fixture_id_set, f"{table_name}:{index}: dangling left fixture")
            _require(row.get("right_fixture") in fixture_id_set, f"{table_name}:{index}: dangling right fixture")
            relation_count += 1
    _require(relation_count == 458, "relation-table document count mismatch")

    nested_count = 0
    for row in vectors:
        locations = [
            (path, value)
            for path, value in _magic_locations(row)
            if path and path[-1] == "hex"
        ]
        if str(row.get("vector_id", "")).startswith("LCI0-E1-"):
            _require(len(locations) == 3, f"{row.get('vector_id')}: E1 nested document triple missing")
            nested_values = [bytes.fromhex(value) for _, value in locations]
            _require(len(set(nested_values)) == 1, f"{row.get('vector_id')}: E1 nested triple differs")
            nested = nested_values[0]
            decoded = cd0.decode_exact(nested, CD0_BUDGET)
            _require(cd0.encode_exact(decoded, CD0_BUDGET) == nested, f"{row.get('vector_id')}: nested E1 re-encoding differs")
            input_abstract = from_package_json(row["inputs"]["abstract_cd0"], CD0_BUDGET)
            fixture_value = field_by_path(field_by_path(input_abstract, "payload"), "fixture-value")
            _require(canonical_bytes(fixture_value) == nested, f"{row.get('vector_id')}: nested E1 value differs from package expectation")
            nested_count += 3
        else:
            _require(not locations, f"{row.get('vector_id')}: unclassified nested canonical document")
    _require(nested_count == 30, "nested E1 document count mismatch")

    # A key-name census and a value-prefix census must discover identical sets.
    registry_magic = _magic_locations(package_registry)
    vector_magic = []
    for index, row in enumerate(vectors):
        vector_magic.extend(((index,) + path, value) for path, value in _magic_locations(row))
    registry_named = [item for item in registry_magic if item[0] and item[0][-1] == "canonical_cd0_hex"]
    vector_named = [item for item in vector_magic if item[0] and item[0][-1] in {"canonical_cd0_hex", "hex"}]
    _require(len(registry_magic) == len(registry_named) == 1133, "registry magic-prefix/key-name census divergence")
    _require(len(vector_magic) == len(vector_named) == 460, "vector magic-prefix/key-name census divergence")

    supplementary = relation_count + nested_count
    _require(supplementary == 488 and official + supplementary == 1593, "full corpus count mismatch")
    return CorpusReport(
        registry_definitions=675,
        vectors=215,
        official_documents=official,
        relation_table_documents=relation_count,
        nested_e1_documents=nested_count,
        supplementary_documents=supplementary,
        total_documents=official + supplementary,
        schema_shapes=tuple(sorted(shapes.items())),
        magic_registry_values=len(registry_magic),
        magic_vector_values=len(vector_magic),
    )
