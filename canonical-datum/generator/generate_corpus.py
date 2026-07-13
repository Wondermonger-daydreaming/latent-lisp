#!/usr/bin/env python3
"""Deterministically generate the Lisp+ Canonical Datum /0 release corpus.

The normative specification is pinned before output is created.  Classified
rows use the shared fixture schema.  Broad mutations that can carry more than
one defect are emitted separately without an expected failure triple; only a
later cross-implementation minimization pass may promote them.

The post-seed Python codec supplies canonical fixture adapters and a consistency
check.  It is deliberately not described or used as a normative oracle.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import hashlib
import json
import math
import os
from pathlib import Path
import platform
import random
import shlex
import subprocess
import sys
from typing import Any, Iterable, Mapping, Sequence


GENERATOR_VERSION = "cd0-corpus-generator/1"
EXPECTED_SPEC_SHA256 = "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc"
DEFAULT_SEED = 0xCD000001
RELEASE_POSITIVE_MINIMUM = 10_000
RELEASE_NEGATIVE_MINIMUM = 20_000
DEFAULT_MUTATION_SAMPLE_COUNT = 128
DEFAULT_TRUNCATION_MAX_DOCUMENT_OCTETS = 16
MAGIC_VERSION = bytes.fromhex("4c50434400")
ASSIGNED_TAGS = (0x00, 0x01, 0x02, 0x10, 0x11, 0x20, 0x21, 0x22, 0x30, 0x31)

OUTPUT_FILENAMES = {
    "positive": "cd0-generated-positive.jsonl",
    "negative": "cd0-generated-negative.jsonl",
    "negative_derivations": "cd0-generated-negative-derivations.jsonl",
    "mutation_candidates": "cd0-mutation-candidates.jsonl",
    "host_scenarios": "cd0-host-property-scenarios.json",
}

REQUIRED_COVERAGE = (
    "assigned-type-tags",
    "reserved-type-tags-and-boundaries",
    "forbidden-type-tags-and-boundaries",
    "uvar-boundaries",
    "zigzag-and-arbitrary-precision",
    "rational-normalization-and-refusal",
    "string-and-bytes-boundaries",
    "utf8-all-sequence-lengths",
    "utf8-nul-maximum-noncharacters",
    "utf8-invalid-overlong-surrogate-truncation",
    "unicode-precomposed-decomposed-confusable",
    "identifier-namespace-distinctions",
    "container-depth-node-count-boundaries",
    "record-permutations-duplicates-prefix-large",
    "all-hand-vector-truncation-points",
    "configured-generated-truncation-points",
    "appended-and-concatenated-documents",
    "overlong-version-integer-rational-count-length-segment",
    "declared-lengths-and-counts-above-budgets",
    "host-cycles-and-improper-lists",
    "host-shared-acyclic-and-mutable-aliases",
    "host-symbols-and-python-bool-int",
    "privileged-host-refusal",
    "privileged-looking-inert-records",
    "mutation-delete-each-octet",
    "mutation-delete-each-suffix",
    "mutation-append-octets",
    "mutation-replace-tags",
    "mutation-overlong-uvar",
    "mutation-change-declared-length-count",
    "mutation-corrupt-utf8",
    "mutation-swap-duplicate-record-fields",
    "mutation-replace-rational-components",
)


class GeneratorError(RuntimeError):
    """A deterministic generator precondition or invariant failed."""


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=True, sort_keys=True, separators=(",", ":"))


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def git_revision(root: Path) -> str:
    completed = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=root,
        check=True,
        capture_output=True,
        text=True,
    )
    return completed.stdout.strip()


def verify_spec(root: Path) -> tuple[Path, str]:
    spec = root / "mneme" / "spec" / "CANONICAL-DATUM-SPEC.md"
    if not spec.is_file():
        raise GeneratorError(f"normative specification not found: {spec}")
    observed = sha256_file(spec)
    if observed != EXPECTED_SPEC_SHA256:
        raise GeneratorError(
            "normative specification digest mismatch: "
            f"expected {EXPECTED_SPEC_SHA256}, observed {observed} at {spec}"
        )
    return spec, observed


def import_codec(root: Path) -> Any:
    source = root / "canonical-datum" / "python"
    sys.path.insert(0, str(source))
    try:
        import cd0  # type: ignore
    finally:
        sys.path.pop(0)
    return cd0


def load_budgets(root: Path, cd0: Any) -> dict[str, Any]:
    path = root / "canonical-datum" / "vectors" / "cd0-budgets.json"
    document = json.loads(path.read_text(encoding="utf-8"))
    result: dict[str, Any] = {}
    for name, source in document["budgets"].items():
        if "base" in source:
            limits = dict(result[source["base"]].limits)
            limits.update({key: value for key, value in source.items() if key != "base"})
        else:
            limits = dict(source)
        result[name] = cd0.ResourceBudget.from_mapping(limits, identifier=name)
    return result


def resolve_budget(value: str | Mapping[str, int], budgets: Mapping[str, Any], cd0: Any, identifier: str) -> Any:
    if isinstance(value, str):
        try:
            return budgets[value]
        except KeyError as exc:
            raise GeneratorError(f"unknown fixture budget {value!r}") from exc
    return cd0.ResourceBudget.from_mapping(value, identifier=identifier)


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line]


def uvar(value: int) -> bytes:
    if value < 0:
        raise GeneratorError("UVAR input is negative")
    result = bytearray()
    while True:
        octet = value & 0x7F
        value >>= 7
        result.append(octet | (0x80 if value else 0))
        if not value:
            return bytes(result)


def overlong_uvar(value: int) -> bytes:
    minimal = bytearray(uvar(value))
    minimal[-1] |= 0x80
    minimal.append(0)
    return bytes(minimal)


def zigzag_inverse(value: int) -> int:
    return value // 2 if value % 2 == 0 else -((value + 1) // 2)


def utf8_hex(text: str) -> str:
    return text.encode("utf-8").hex()


def id_ast(namespace: Sequence[str], path: Sequence[str]) -> dict[str, Any]:
    return {
        "t": "id",
        "namespace_utf8_hex": [utf8_hex(segment) for segment in namespace],
        "path_utf8_hex": [utf8_hex(segment) for segment in path],
    }


def inert_record_ast(shape: str, serial: int) -> dict[str, Any]:
    fields = [
        {"key": id_ast(("cd0",), ("kind",)), "value": {"t": "string", "utf8_hex": utf8_hex(shape)}},
        {"key": id_ast(("cd0",), ("serial",)), "value": {"t": "int", "v": str(serial)}},
        {"key": id_ast(("cd0",), ("payload",)), "value": {"t": "bytes", "hex": serial.to_bytes(4, "big").hex()}},
    ]
    fields.reverse()  # Construction order must not influence canonical field order.
    return {"t": "record", "fields": fields}


def core_positive_asts() -> list[tuple[str, dict[str, Any], list[str]]]:
    values: list[tuple[str, dict[str, Any], list[str]]] = []

    def add(family: str, ast: dict[str, Any], *notes: str) -> None:
        values.append((family, ast, list(notes)))

    add("unit", {"t": "unit"}, "assigned tag 00")
    add("bool-false", {"t": "bool", "v": False}, "assigned tag 01")
    add("bool-true", {"t": "bool", "v": True}, "assigned tag 02")
    for boundary in (0, 1, 2, 126, 127, 128, 129, 16382, 16383, 16384, 16385, 2**127, 2**255 + 1):
        integer = zigzag_inverse(boundary)
        add("integer", {"t": "int", "v": str(integer)}, f"zigzag UVAR boundary {boundary}")
    add("integer", {"t": "int", "v": str(-(2**383) + 1)}, "arbitrary-precision negative boundary")

    for numerator, denominator, note in (
        (1, 2, "positive rational"),
        (-1, 2, "negative rational"),
        (2**127 - 1, 2**127, "large coprime components"),
        (99991, 100003, "large-GCD refusal has a distinct negative companion"),
    ):
        add("rational", {"t": "rat", "p": str(numerator), "q": str(denominator)}, note)

    for text, note in (
        ("", "empty string"),
        ("\x00", "NUL"),
        ("\x7f", "ASCII upper boundary"),
        ("\u0080", "two-octet UTF-8 lower boundary"),
        ("\u07ff", "two-octet UTF-8 upper boundary"),
        ("\u0800", "three-octet UTF-8 lower boundary"),
        ("\uffff", "noncharacter"),
        ("\U00010000", "four-octet UTF-8 lower boundary"),
        ("\U0010ffff", "maximum scalar and noncharacter"),
        ("\u00e9", "precomposed e-acute"),
        ("e\u0301", "decomposed e-acute"),
        ("a", "Latin confusable member"),
        ("\u0430", "Cyrillic confusable member"),
    ):
        add("string", {"t": "string", "utf8_hex": utf8_hex(text)}, note)

    for payload, note in (
        (b"", "empty bytes"),
        (b"\x00", "NUL byte"),
        (b"\x7f", "octet boundary 127"),
        (b"\x80", "octet boundary 128"),
        (bytes(range(16)), "binary sequence"),
        (bytes(range(127)), "length boundary 127"),
        (bytes(range(128)), "length boundary 128"),
    ):
        add("bytes", {"t": "bytes", "hex": payload.hex()}, note)

    add("identifier", id_ast((), ("x",)), "empty namespace")
    add("identifier", id_ast(("n",), ("p",)), "namespace/path distinction")
    add("identifier", id_ast(("\u00e9",), ("e\u0301",)), "Unicode is not normalized")
    add("identifier", id_ast(("ns", "sub"), ("path", "leaf")), "multi-segment identifier")

    add("sequence", {"t": "seq", "items": []}, "empty container")
    add("sequence", {"t": "seq", "items": [{"t": "unit"}]}, "depth and node boundary seed")
    add(
        "sequence",
        {"t": "seq", "items": [{"t": "seq", "items": [{"t": "seq", "items": [{"t": "unit"}]}]}]},
        "nested container",
    )

    prefix_fields = [
        {"key": id_ast((), ("a",)), "value": {"t": "int", "v": "1"}},
        {"key": id_ast((), ("aa",)), "value": {"t": "int", "v": "2"}},
        {"key": id_ast(("a",), ("a",)), "value": {"t": "int", "v": "3"}},
    ]
    prefix_fields.reverse()
    add("record", {"t": "record", "fields": prefix_fields}, "permuted prefix-like record keys")
    large_fields = [
        {"key": id_ast(("large",), (f"k{index:03d}",)), "value": {"t": "int", "v": str(index)}}
        for index in range(32)
    ]
    large_fields.reverse()
    add("record", {"t": "record", "fields": large_fields}, "large key set in reverse source order")

    for serial, shape in enumerate(("capability", "warrant", "claim", "certificate", "receipt"), 1):
        add("privileged-looking-inert-record", inert_record_ast(shape, serial), f"ordinary inert {shape}-shaped record")
    return values


SCALAR_POOL = (
    0x00,
    0x01,
    0x20,
    0x7E,
    0x7F,
    0x80,
    0x7FF,
    0x800,
    0xD7FF,
    0xE000,
    0xFDD0,
    0xFFFE,
    0xFFFF,
    0x10000,
    0x1F600,
    0x10FFFE,
    0x10FFFF,
)


def random_scalar_text(rng: random.Random, serial: int, maximum: int = 12) -> str:
    prefix = f"g{serial:x}:"
    count = rng.randrange(0, maximum + 1)
    suffix = "".join(chr(SCALAR_POOL[rng.randrange(len(SCALAR_POOL))]) for _ in range(count))
    return prefix + suffix


def random_ast(rng: random.Random, serial: int) -> tuple[str, dict[str, Any], list[str]]:
    family = serial % 9
    if family == 0:
        # The named default permits 64 UVAR octets.  Stay well inside that
        # wire-work ceiling while still exercising arbitrary precision.
        bits = 1 + rng.randrange(1, 384)
        value = rng.getrandbits(bits)
        if rng.randrange(2):
            value = -value
        return "integer", {"t": "int", "v": str(value)}, [f"generated integer {bits} bits"]
    if family == 1:
        denominator = rng.randrange(2, 1 << (8 + rng.randrange(0, 48)))
        numerator = rng.randrange(1, denominator * 3)
        if rng.randrange(2):
            numerator = -numerator
        divisor = math.gcd(abs(numerator), denominator)
        numerator //= divisor
        denominator //= divisor
        if denominator == 1:
            denominator = abs(numerator) + 2
            while math.gcd(abs(numerator), denominator) != 1:
                denominator += 1
        return "rational", {"t": "rat", "p": str(numerator), "q": str(denominator)}, ["generated reduced rational"]
    if family == 2:
        text = random_scalar_text(rng, serial)
        return "string", {"t": "string", "utf8_hex": utf8_hex(text)}, ["generated scalar string"]
    if family == 3:
        size = rng.randrange(0, 65)
        payload = serial.to_bytes(8, "big") + bytes(rng.randrange(256) for _ in range(size))
        return "bytes", {"t": "bytes", "hex": payload.hex()}, ["generated byte string"]
    if family == 4:
        namespace = (f"ns{serial:x}", random_scalar_text(rng, serial, 3)) if serial % 2 else ()
        path = (f"p{serial:x}", random_scalar_text(rng, serial + 1, 3))
        return "identifier", id_ast(namespace, path), ["generated explicit namespace/path"]
    if family == 5:
        ast = {
            "t": "seq",
            "items": [
                {"t": "int", "v": str(serial)},
                {"t": "string", "utf8_hex": utf8_hex(random_scalar_text(rng, serial, 4))},
                {"t": "bytes", "hex": serial.to_bytes(8, "big").hex()},
            ],
        }
        return "sequence", ast, ["generated heterogeneous sequence"]
    if family == 6:
        count = 2 + rng.randrange(0, 6)
        fields = [
            {
                "key": id_ast((f"r{serial:x}",), (f"k{index:02d}",)),
                "value": {"t": "int", "v": str(serial * 17 + index)},
            }
            for index in range(count)
        ]
        rng.shuffle(fields)
        return "record", {"t": "record", "fields": fields}, ["generated record permutation"]
    if family == 7:
        ast: dict[str, Any] = {"t": "int", "v": str(serial)}
        depth = 1 + serial % 6
        for _ in range(depth):
            ast = {"t": "seq", "items": [ast]}
        return "nested-sequence", ast, [f"generated depth {depth + 1}"]
    return (
        "mixed-sequence",
        {
            "t": "seq",
            "items": [
                {"t": "bool", "v": bool(serial & 1)},
                id_ast(("generated",), (f"n{serial:x}",)),
                inert_record_ast("receipt", serial),
            ],
        },
        ["generated inert privileged-looking nested record"],
    )


class Coverage:
    def __init__(self) -> None:
        self._ids: dict[str, list[str]] = defaultdict(list)

    def hit(self, name: str, evidence_id: str) -> None:
        if evidence_id not in self._ids[name]:
            self._ids[name].append(evidence_id)

    def manifest(self) -> dict[str, Any]:
        missing = [name for name in REQUIRED_COVERAGE if not self._ids.get(name)]
        if missing:
            raise GeneratorError(f"required Section 28 coverage is empty: {missing}")
        return {
            name: {"count": len(self._ids[name]), "evidence_ids": self._ids[name][:16]}
            for name in REQUIRED_COVERAGE
        }


def build_positives(
    count: int,
    rng: random.Random,
    cd0: Any,
    default_budget: Any,
    coverage: Coverage,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    rows: list[dict[str, Any]] = []
    metadata: list[dict[str, Any]] = []
    seen_documents: set[str] = set()
    candidates = core_positive_asts()
    serial = 0
    while len(rows) < count:
        if candidates:
            family, abstract, notes = candidates.pop(0)
        else:
            family, abstract, notes = random_ast(rng, serial)
            serial += 1
        datum = cd0.from_fixture_ast(abstract, default_budget)
        document = cd0.encode_exact(datum, default_budget)
        decoded = cd0.decode_exact(document, default_budget)
        expected = cd0.to_fixture_ast(decoded)
        if not cd0.equal_datum(datum, decoded):
            raise GeneratorError("post-seed codec round trip disagreed while generating a positive")
        canonical_hex = document.hex()
        if canonical_hex in seen_documents:
            continue
        seen_documents.add(canonical_hex)
        vector_id = f"cd0-pos-generated-{len(rows):08d}"
        row = {
            "id": vector_id,
            "datum_version": 0,
            "abstract": abstract,
            "canonical_hex": canonical_hex,
            "expected_decoded": expected,
            "equality_class": f"generated:{sha256_bytes(document)}",
            "budget": "cd0-conformance-default",
            "notes": [f"generated by {GENERATOR_VERSION}", f"family={family}", *notes],
        }
        rows.append(row)
        metadata.append({"id": vector_id, "family": family, "root_tag": document[5], "octets": len(document)})

        if document[5] in ASSIGNED_TAGS:
            coverage.hit("assigned-type-tags", vector_id)
        if family == "integer":
            coverage.hit("uvar-boundaries", vector_id)
            coverage.hit("zigzag-and-arbitrary-precision", vector_id)
        if family == "rational":
            coverage.hit("rational-normalization-and-refusal", vector_id)
        if family in {"string", "bytes"}:
            coverage.hit("string-and-bytes-boundaries", vector_id)
        if family == "string":
            coverage.hit("utf8-all-sequence-lengths", vector_id)
            coverage.hit("utf8-nul-maximum-noncharacters", vector_id)
            coverage.hit("unicode-precomposed-decomposed-confusable", vector_id)
        if family == "identifier":
            coverage.hit("identifier-namespace-distinctions", vector_id)
            coverage.hit("unicode-precomposed-decomposed-confusable", vector_id)
        if family in {"sequence", "nested-sequence"}:
            coverage.hit("container-depth-node-count-boundaries", vector_id)
        if family == "record":
            coverage.hit("record-permutations-duplicates-prefix-large", vector_id)
        if family == "privileged-looking-inert-record" or "privileged-looking" in " ".join(notes):
            coverage.hit("privileged-looking-inert-records", vector_id)

    observed_tags = {row_meta["root_tag"] for row_meta in metadata}
    missing_tags = set(ASSIGNED_TAGS) - observed_tags
    if missing_tags:
        raise GeneratorError(f"positive corpus omitted assigned tags: {sorted(missing_tags)}")
    return rows, metadata


def failure_row(
    vector_id: str,
    input_hex: str | None,
    budget: str | Mapping[str, int],
    triple: tuple[str, str, str],
    classification: str,
    notes: list[str],
    *,
    host_input: dict[str, Any] | None = None,
    importer: str | None = None,
    status: str | None = None,
    retry_budget: str | Mapping[str, int] | None = None,
) -> dict[str, Any]:
    row: dict[str, Any] = {
        "id": vector_id,
        "input_kind": "host" if host_input is not None else "octets",
        "budget": budget,
        "expected_failure": {"category": triple[0], "code": triple[1], "stage": triple[2]},
        "input_classification": classification,
        "resource_state_unchanged": True,
        "partial_output_forbidden": True,
        "notes": notes,
    }
    if host_input is None:
        if input_hex is None:
            raise GeneratorError("octet negative lacks input")
        row["input_hex"] = input_hex
    else:
        row["host_input"] = host_input
        row["importer"] = importer
    if status is not None:
        row["status"] = status
    if retry_budget is not None:
        row["retry_budget"] = retry_budget
    return row


class NegativeBuilder:
    def __init__(self, cd0: Any, budgets: Mapping[str, Any], coverage: Coverage) -> None:
        self.cd0 = cd0
        self.budgets = budgets
        self.coverage = coverage
        self.rows: list[dict[str, Any]] = []
        self.derivations: list[dict[str, Any]] = []
        self.seen: set[str] = set()

    def add_octets(
        self,
        slug: str,
        source: bytes,
        triple: tuple[str, str, str],
        classification: str,
        operation: str,
        *,
        budget: str | Mapping[str, int] = "cd0-conformance-default",
        retry_budget: str | Mapping[str, int] | None = None,
        source_positive_id: str | None = None,
        status: str | None = None,
        notes: Iterable[str] = (),
        coverage_names: Iterable[str] = (),
    ) -> str | None:
        budget_key = canonical_json(budget)
        uniqueness = f"octets\0{source.hex()}\0{budget_key}"
        if uniqueness in self.seen:
            return None
        self.seen.add(uniqueness)
        vector_id = f"cd0-neg-generated-{len(self.rows):08d}-{slug}"
        row = failure_row(
            vector_id,
            source.hex(),
            budget,
            triple,
            classification,
            [f"generated by {GENERATOR_VERSION}", f"derivation={operation}", *notes],
            status=status,
            retry_budget=retry_budget,
        )
        self._verify(row)
        self.rows.append(row)
        self.derivations.append(
            {
                "id": vector_id,
                "source_positive_id": source_positive_id,
                "operation": operation,
                "edit_minimal": operation in {
                    "append-one-octet",
                    "insert-one-overlong-version-octet",
                    "replace-one-type-tag",
                    "replace-one-magic-octet",
                },
                "primary_defect_basis": "hand-derived grammar template; seed codec used only as consistency check",
            }
        )
        for coverage_name in coverage_names:
            self.coverage.hit(coverage_name, vector_id)
        return vector_id

    def add_host(
        self,
        slug: str,
        host_input: dict[str, Any],
        importer: str,
        triple: tuple[str, str, str],
        classification: str,
        *,
        status: str | None = None,
        notes: Iterable[str] = (),
        coverage_names: Iterable[str] = (),
    ) -> str | None:
        uniqueness = f"host\0{importer}\0{canonical_json(host_input)}"
        if uniqueness in self.seen:
            return None
        self.seen.add(uniqueness)
        vector_id = f"cd0-neg-generated-{len(self.rows):08d}-{slug}"
        row = failure_row(
            vector_id,
            None,
            "cd0-conformance-default",
            triple,
            classification,
            [f"generated by {GENERATOR_VERSION}", *notes],
            host_input=host_input,
            importer=importer,
            status=status,
        )
        self._verify(row)
        self.rows.append(row)
        self.derivations.append(
            {
                "id": vector_id,
                "source_positive_id": None,
                "operation": "host-property-descriptor",
                "edit_minimal": False,
                "primary_defect_basis": "explicit Section 28.2 host scenario",
            }
        )
        for coverage_name in coverage_names:
            self.coverage.hit(coverage_name, vector_id)
        return vector_id

    def _verify(self, row: Mapping[str, Any]) -> None:
        budget = resolve_budget(row["budget"], self.budgets, self.cd0, f"{row['id']}:budget")
        try:
            if row["input_kind"] == "octets":
                self.cd0.decode_exact(bytes.fromhex(row["input_hex"]), budget)
            else:
                self.cd0.import_host_descriptor(row["host_input"], row["importer"], budget)
        except self.cd0.CD0Failure as failure:
            actual = failure.as_dict()
        else:
            raise GeneratorError(f"authored negative unexpectedly succeeded: {row['id']}")
        expected = row["expected_failure"]
        status = row.get("status", "normative")
        if status == "provisional-blocked-stage":
            comparable = (actual["category"], actual["code"]) == (expected["category"], expected["code"])
        elif status == "provisional-blocked-code":
            comparable = (actual["category"], actual["stage"]) == (expected["category"], expected["stage"])
        else:
            comparable = actual == expected
        if not comparable:
            raise GeneratorError(f"seed consistency check disagreed for {row['id']}: expected {expected}, got {actual}")


def identifier_value_bytes(namespace: Sequence[str], path: Sequence[str]) -> bytes:
    result = bytearray((0x22,))
    result.extend(uvar(len(namespace)))
    for segment in namespace:
        payload = segment.encode("utf-8")
        result.extend(uvar(len(payload)))
        result.extend(payload)
    result.extend(uvar(len(path)))
    for segment in path:
        payload = segment.encode("utf-8")
        result.extend(uvar(len(payload)))
        result.extend(payload)
    return bytes(result)


def seed_precise_negatives(builder: NegativeBuilder, positives: Sequence[dict[str, Any]]) -> None:
    invalid = "InvalidCanonicalGrammar"
    noncanonical = "NoncanonicalEncoding"
    unsupported = "UnsupportedFormat"
    resource = "ResourceRefusal"
    privileged = "PrivilegedRestorationAttempt"
    host_unsupported = "UnsupportedHostInput"

    builder.add_octets(
        "magic",
        bytes.fromhex("585043440000"),
        (invalid, "InvalidMagic", "magic"),
        "invalid",
        "replace-one-magic-octet",
        coverage_names=("overlong-version-integer-rational-count-length-segment",),
    )
    builder.add_octets(
        "version-overlong",
        bytes.fromhex("4c504344800000"),
        (noncanonical, "NonminimalVersionEncoding", "version-varint"),
        "noncanonical",
        "insert-one-overlong-version-octet",
        coverage_names=("overlong-version-integer-rational-count-length-segment",),
    )
    builder.add_octets(
        "future-version",
        bytes.fromhex("4c5043440100"),
        (unsupported, "UnsupportedFutureVersion", "version-selection"),
        "unsupported",
        "replace-version-value",
    )

    for tag in range(0x100):
        if tag in ASSIGNED_TAGS:
            continue
        if tag >= 0xF0:
            triple = (privileged, "ForbiddenPrivilegedTag", "type-tag")
            classification = "privileged"
            coverage_name = "forbidden-type-tags-and-boundaries"
        else:
            triple = (invalid, "ReservedTypeTag", "type-tag")
            classification = "invalid"
            coverage_name = "reserved-type-tags-and-boundaries"
        builder.add_octets(
            f"tag-{tag:02x}",
            MAGIC_VERSION + bytes((tag,)),
            triple,
            classification,
            "replace-one-type-tag",
            coverage_names=(coverage_name,),
        )

    for value in (0, 1, 127, 128, 16383, 16384, 2**63, 2**255 + 7):
        builder.add_octets(
            f"integer-overlong-{value.bit_length()}",
            MAGIC_VERSION + b"\x10" + overlong_uvar(value),
            (noncanonical, "NonminimalIntegerEncoding", "integer-payload"),
            "noncanonical",
            "make-integer-uvar-overlong",
            coverage_names=("uvar-boundaries", "overlong-version-integer-rational-count-length-segment"),
        )

    builder.add_octets(
        "rational-numerator-overlong",
        MAGIC_VERSION + b"\x11" + overlong_uvar(1) + uvar(2),
        (noncanonical, "NonminimalRationalComponentEncoding", "rational-payload"),
        "noncanonical",
        "make-rational-component-overlong",
        coverage_names=("rational-normalization-and-refusal", "overlong-version-integer-rational-count-length-segment"),
    )
    builder.add_octets(
        "rational-denominator-overlong",
        MAGIC_VERSION + b"\x11" + uvar(1) + overlong_uvar(2),
        (noncanonical, "NonminimalRationalComponentEncoding", "rational-payload"),
        "noncanonical",
        "make-rational-component-overlong",
        coverage_names=("rational-normalization-and-refusal", "overlong-version-integer-rational-count-length-segment"),
    )
    for slug, numerator, denominator, triple in (
        ("rational-denominator-zero", 1, 0, (invalid, "ZeroDenominator", "rational-payload")),
        ("rational-numerator-zero", 0, 2, (noncanonical, "ZeroRationalEncoding", "rational-payload")),
        ("rational-integral", 1, 1, (noncanonical, "IntegralRationalEncoding", "rational-payload")),
        ("rational-common-factor", 6, 15, (noncanonical, "UnreducedRational", "rational-payload")),
        ("rational-large-gcd", 99991 * 17, 100003 * 17, (noncanonical, "UnreducedRational", "rational-payload")),
    ):
        zigzag = numerator * 2 if numerator >= 0 else -numerator * 2 - 1
        builder.add_octets(
            slug,
            MAGIC_VERSION + b"\x11" + uvar(zigzag) + uvar(denominator),
            triple,
            "invalid" if triple[0] == invalid else "noncanonical",
            "replace-rational-component",
            coverage_names=("rational-normalization-and-refusal",),
        )

    for tag, label, failure_code in ((0x20, "string", "OverlongLengthEncoding"), (0x21, "bytes", "OverlongLengthEncoding")):
        for length in (0, 1, 127, 128):
            payload = bytes((index & 0x7F for index in range(length)))
            builder.add_octets(
                f"{label}-length-{length}-overlong",
                MAGIC_VERSION + bytes((tag,)) + overlong_uvar(length) + payload,
                (noncanonical, failure_code, "length"),
                "noncanonical",
                "make-length-uvar-overlong",
                coverage_names=("string-and-bytes-boundaries", "overlong-version-integer-rational-count-length-segment"),
            )

    builder.add_octets(
        "sequence-count-overlong",
        MAGIC_VERSION + b"\x30" + overlong_uvar(1) + b"\x00",
        (noncanonical, "OverlongCountEncoding", "count"),
        "noncanonical",
        "make-count-uvar-overlong",
        coverage_names=("overlong-version-integer-rational-count-length-segment",),
    )
    builder.add_octets(
        "identifier-path-count-overlong",
        MAGIC_VERSION + b"\x22\x00" + overlong_uvar(1) + b"\x01x",
        (noncanonical, "OverlongCountEncoding", "count"),
        "noncanonical",
        "make-count-uvar-overlong",
        coverage_names=("overlong-version-integer-rational-count-length-segment",),
    )
    builder.add_octets(
        "identifier-segment-length-overlong",
        MAGIC_VERSION + b"\x22\x00\x01" + overlong_uvar(1) + b"x",
        (noncanonical, "OverlongLengthEncoding", "length"),
        "noncanonical",
        "make-segment-length-uvar-overlong",
        coverage_names=("overlong-version-integer-rational-count-length-segment",),
    )

    invalid_utf8 = (
        ("continuation-lead", b"\x80", "InvalidUTF8"),
        ("overlong-nul", b"\xc0\x80", "InvalidUTF8"),
        ("truncated-two", b"\xc2", "InvalidUTF8"),
        ("truncated-three", b"\xe1\x80", "InvalidUTF8"),
        ("truncated-four", b"\xf0\x90\x80", "InvalidUTF8"),
        ("surrogate", b"\xed\xa0\x80", "ForbiddenUnicodeScalar"),
        ("above-maximum", b"\xf4\x90\x80\x80", "InvalidUTF8"),
    )
    for slug, payload, code in invalid_utf8:
        builder.add_octets(
            f"utf8-{slug}",
            MAGIC_VERSION + b"\x20" + uvar(len(payload)) + payload,
            (invalid, code, "utf8"),
            "invalid",
            "replace-string-payload-with-hostile-utf8",
            coverage_names=("utf8-invalid-overlong-surrogate-truncation",),
        )

    key_a = identifier_value_bytes((), ("a",))
    key_b = identifier_value_bytes((), ("b",))
    builder.add_octets(
        "record-order",
        MAGIC_VERSION + b"\x31\x02" + key_b + b"\x00" + key_a + b"\x00",
        (noncanonical, "NoncanonicalFieldOrder", "record-order"),
        "noncanonical",
        "swap-record-fields",
        coverage_names=("record-permutations-duplicates-prefix-large",),
    )
    builder.add_octets(
        "record-duplicate",
        MAGIC_VERSION + b"\x31\x02" + key_a + b"\x00" + key_a + b"\x00",
        (invalid, "DuplicateRecordField", "record-order"),
        "invalid",
        "duplicate-record-field",
        coverage_names=("record-permutations-duplicates-prefix-large",),
    )

    base_document = bytes.fromhex(positives[0]["canonical_hex"])
    builder.add_octets(
        "trailing-byte",
        base_document + b"\x00",
        (invalid, "TrailingBytes", "end-of-input"),
        "invalid",
        "append-one-octet",
        source_positive_id=positives[0]["id"],
        coverage_names=("appended-and-concatenated-documents",),
    )
    builder.add_octets(
        "concatenated",
        base_document + bytes.fromhex(positives[1]["canonical_hex"]),
        (invalid, "TrailingBytes", "end-of-input"),
        "invalid",
        "concatenate-complete-document",
        source_positive_id=positives[0]["id"],
        coverage_names=("appended-and-concatenated-documents",),
    )

    resource_cases = (
        ("input", base_document, "cd0-max-input-5", "ExcessiveInputLength", "input-budget"),
        ("varint", MAGIC_VERSION + b"\x10" + uvar(128), "cd0-max-varint-1", "VarintBudgetExceeded", "integer-payload"),
        ("string-length", MAGIC_VERSION + b"\x20\x02ab", "cd0-max-string-1", "ExcessiveDeclaredLength", "length"),
        ("bytes-length", MAGIC_VERSION + b"\x21\x02ab", "cd0-max-bytes-1", "ExcessiveDeclaredLength", "length"),
        ("sequence-count", MAGIC_VERSION + b"\x30\x02\x00\x00", "cd0-max-sequence-1", "ExcessiveContainerCount", "count"),
        ("record-count", MAGIC_VERSION + b"\x31\x02" + key_a + b"\x00" + key_b + b"\x00", "cd0-max-record-1", "ExcessiveContainerCount", "count"),
        ("identifier-segments", MAGIC_VERSION + identifier_value_bytes(("a", "b"), ("p",)), "cd0-max-id-segments-1", "ExcessiveIdentifierSegments", "count"),
        ("integer-bits", MAGIC_VERSION + b"\x10" + uvar(2 * 65536), "cd0-max-integer-8", "IntegerBudgetExceeded", "integer-payload"),
        ("segment-length", MAGIC_VERSION + identifier_value_bytes((), ("ab",)), "cd0-max-segment-1", "ExcessiveDeclaredLength", "length"),
        ("aggregate", MAGIC_VERSION + b"\x30\x02\x20\x01a\x20\x01b", "cd0-max-aggregate-1", "AggregatePayloadBudgetExceeded", "length"),
    )
    for slug, document, budget, code, stage in resource_cases:
        builder.add_octets(
            f"resource-{slug}",
            document,
            (resource, code, stage),
            "resource",
            "lower-one-resource-budget",
            budget=budget,
            retry_budget="cd0-conformance-default",
            coverage_names=("declared-lengths-and-counts-above-budgets",),
        )

    # These declarations breach their limit before any matching payload is
    # present.  They exercise the required refusal-before-proportional-work
    # precedence rather than ordinary truncation.
    for slug, document, budget, code, stage in (
        ("string-declaration-only", MAGIC_VERSION + b"\x20\x02", "cd0-max-string-1", "ExcessiveDeclaredLength", "length"),
        ("bytes-declaration-only", MAGIC_VERSION + b"\x21\x02", "cd0-max-bytes-1", "ExcessiveDeclaredLength", "length"),
        ("sequence-declaration-only", MAGIC_VERSION + b"\x30\x02", "cd0-max-sequence-1", "ExcessiveContainerCount", "count"),
        ("record-declaration-only", MAGIC_VERSION + b"\x31\x02", "cd0-max-record-1", "ExcessiveContainerCount", "count"),
        ("identifier-declaration-only", MAGIC_VERSION + b"\x22\x02", "cd0-max-id-segments-1", "ExcessiveIdentifierSegments", "count"),
    ):
        builder.add_octets(
            f"resource-{slug}",
            document,
            (resource, code, stage),
            "resource",
            "declared-limit-breach-without-matching-payload",
            budget=budget,
            coverage_names=("declared-lengths-and-counts-above-budgets",),
        )

    nested_unit = MAGIC_VERSION + b"\x30\x01\x00"
    builder.add_octets(
        "resource-depth-boundary",
        nested_unit,
        (resource, "ExcessiveNesting", "container-content"),
        "resource",
        "lower-depth-budget-by-one",
        budget="cd0-max-depth-1",
        retry_budget="cd0-conformance-default",
        status="provisional-blocked-stage",
        notes=("A1 fixes category/code but not this stage",),
        coverage_names=("container-depth-node-count-boundaries",),
    )
    builder.add_octets(
        "resource-node-boundary",
        nested_unit,
        (resource, "NodeBudgetExceeded", "container-content"),
        "resource",
        "lower-node-budget-by-one",
        budget="cd0-max-nodes-1",
        retry_budget="cd0-conformance-default",
        status="provisional-blocked-stage",
        notes=("A1 fixes category/code but not this stage",),
        coverage_names=("container-depth-node-count-boundaries",),
    )

    cycle = {
        "root": {"$ref": "x"},
        "objects": {"x": {"host_type": "sequence", "items": [{"$ref": "x"}]}},
    }
    improper = {
        "root": {"$ref": "x"},
        "objects": {"x": {"host_type": "list", "items": [{"host_type": "integer", "value": "1"}], "tail": {"host_type": "integer", "value": "2"}}},
    }
    builder.add_host(
        "host-cycle",
        cycle,
        "generic-sequence-import/v0",
        (host_unsupported, "CyclicHostInput", "host-import"),
        "host-unsupported",
        coverage_names=("host-cycles-and-improper-lists",),
    )
    builder.add_host(
        "host-improper-list",
        improper,
        "generic-sequence-import/v0",
        (host_unsupported, "ImproperHostList", "host-import"),
        "host-unsupported",
        coverage_names=("host-cycles-and-improper-lists",),
    )
    builder.add_host(
        "host-symbol",
        {"host_type": "common-lisp-symbol", "print_name_utf8_hex": "78", "interned": False, "stable_mapping": None},
        "symbol-to-identifier/v0",
        (host_unsupported, "AmbiguousIdentifier", "host-import"),
        "host-unsupported",
        coverage_names=("host-symbols-and-python-bool-int",),
    )
    builder.add_host(
        "host-python-bool-int",
        {"host_type": "python-bool", "value": True, "requested_cd0_type": "integer"},
        "strict-integer-import/v0",
        (host_unsupported, "UnsupportedHostType", "host-import"),
        "host-unsupported",
        status="provisional-blocked-code",
        notes=("A2 keeps the exact refusal code provisional",),
        coverage_names=("host-symbols-and-python-bool-int",),
    )
    builder.add_host(
        "host-live-capability",
        {"host_type": "live-capability", "fields": {"label": "not a datum"}},
        "core-datum-import/v0",
        (privileged, "PrivilegedHostValue", "host-import"),
        "privileged",
        coverage_names=("privileged-host-refusal",),
    )


def fill_precise_negatives(builder: NegativeBuilder, positives: Sequence[dict[str, Any]], target: int) -> None:
    invalid = "InvalidCanonicalGrammar"
    noncanonical = "NoncanonicalEncoding"
    round_index = 0
    while len(builder.rows) < target:
        for positive in positives:
            document = bytes.fromhex(positive["canonical_hex"])
            if round_index % 2 == 0:
                suffix = bytes(((round_index // 2) & 0xFF,))
                added = builder.add_octets(
                    "trailing-generated",
                    document + suffix,
                    (invalid, "TrailingBytes", "end-of-input"),
                    "invalid",
                    "append-one-octet",
                    source_positive_id=positive["id"],
                    coverage_names=("appended-and-concatenated-documents",),
                )
            else:
                mutated = document[:4] + b"\x80" + document[4:]
                added = builder.add_octets(
                    "version-overlong-generated",
                    mutated,
                    (noncanonical, "NonminimalVersionEncoding", "version-varint"),
                    "noncanonical",
                    "insert-one-overlong-version-octet",
                    source_positive_id=positive["id"],
                    coverage_names=("overlong-version-integer-rational-count-length-segment",),
                )
            if added is not None and len(builder.rows) >= target:
                return
        round_index += 1
        if round_index > 514:
            raise GeneratorError("could not construct enough unique classified negatives")


class MutationBuilder:
    def __init__(self, coverage: Coverage) -> None:
        self.coverage = coverage
        self.rows: list[dict[str, Any]] = []
        self._seen: set[tuple[str, str, str]] = set()

    def add(
        self,
        source_id: str,
        source_scope: str,
        operation: str,
        source_hex: str,
        mutated: bytes,
        coverage_name: str,
        *,
        parameter: Any = None,
    ) -> None:
        key = (source_id, operation, mutated.hex())
        if key in self._seen:
            return
        self._seen.add(key)
        candidate_id = f"cd0-mut-{len(self.rows):09d}"
        self.rows.append(
            {
                "id": candidate_id,
                "source_positive_id": source_id,
                "source_scope": source_scope,
                "operation": operation,
                "parameter": parameter,
                "source_hex": source_hex,
                "input_hex": mutated.hex(),
                "budget": "cd0-conformance-default",
                "classification_status": "unclassified-may-have-multiple-defects",
                "promotion_rule": "minimize and compare both implementations before assigning a permanent primary triple",
            }
        )
        self.coverage.hit(coverage_name, candidate_id)


def value_bytes_from_ast(ast: dict[str, Any], cd0: Any, budget: Any) -> bytes:
    return cd0.encode_exact(cd0.from_fixture_ast(ast, budget), budget)[len(MAGIC_VERSION):]


def add_record_mutations(
    mutations: MutationBuilder,
    positive: Mapping[str, Any],
    cd0: Any,
    budget: Any,
) -> None:
    expected = positive["expected_decoded"]
    if expected.get("t") != "record" or len(expected["fields"]) < 2:
        return
    encoded_fields = [
        value_bytes_from_ast(field["key"], cd0, budget) + value_bytes_from_ast(field["value"], cd0, budget)
        for field in expected["fields"]
    ]
    canonical = bytes.fromhex(positive["canonical_hex"])
    swapped = MAGIC_VERSION + b"\x31" + uvar(len(encoded_fields)) + encoded_fields[1] + encoded_fields[0] + b"".join(encoded_fields[2:])
    mutations.add(
        positive["id"], "generated-sample", "swap-record-fields", canonical.hex(), swapped,
        "mutation-swap-duplicate-record-fields", parameter=[0, 1],
    )
    duplicated = MAGIC_VERSION + b"\x31" + uvar(len(encoded_fields) + 1) + encoded_fields[0] + encoded_fields[0] + b"".join(encoded_fields[1:])
    mutations.add(
        positive["id"], "generated-sample", "duplicate-record-field", canonical.hex(), duplicated,
        "mutation-swap-duplicate-record-fields", parameter=0,
    )


def add_rational_mutations(mutations: MutationBuilder, positive: Mapping[str, Any]) -> None:
    expected = positive["expected_decoded"]
    if expected.get("t") != "rat":
        return
    canonical = bytes.fromhex(positive["canonical_hex"])
    replacements = (
        ("numerator-zero", 0, 2),
        ("denominator-zero", 1, 0),
        ("denominator-one", 1, 1),
        ("common-factor", 6, 10),
    )
    for label, numerator, denominator in replacements:
        zigzag = numerator * 2 if numerator >= 0 else -numerator * 2 - 1
        mutated = MAGIC_VERSION + b"\x11" + uvar(zigzag) + uvar(denominator)
        mutations.add(
            positive["id"], "generated-sample", f"replace-rational-{label}", canonical.hex(), mutated,
            "mutation-replace-rational-components", parameter={"p": numerator, "q": denominator},
        )


def add_declared_size_mutations(mutations: MutationBuilder, positive: Mapping[str, Any]) -> None:
    canonical = bytes.fromhex(positive["canonical_hex"])
    if len(canonical) < 7:
        return
    tag = canonical[5]
    if tag not in {0x20, 0x21, 0x22, 0x30, 0x31}:
        return
    original = canonical[6]
    if original & 0x80:
        return  # Generic UVAR rewriting is intentionally left as an unclassified later extension.
    for delta in (-1, 1):
        changed = max(0, min(127, original + delta))
        mutated = canonical[:6] + bytes((changed,)) + canonical[7:]
        mutations.add(
            positive["id"], "generated-sample", "change-declared-length-or-count", canonical.hex(), mutated,
            "mutation-change-declared-length-count", parameter={"offset": 6, "from": original, "to": changed},
        )


def add_utf8_mutations(mutations: MutationBuilder, positive: Mapping[str, Any]) -> None:
    canonical = bytes.fromhex(positive["canonical_hex"])
    expected = positive["expected_decoded"]
    if expected.get("t") != "string" or len(canonical) < 8:
        return
    payload = bytes.fromhex(expected["utf8_hex"])
    if not payload or canonical[6] & 0x80:
        return
    start = 7
    corruptions = ((0x80, "continuation-as-lead"), (0xC0, "overlong-lead"), (0xF5, "above-maximum-lead"))
    for replacement, label in corruptions:
        mutated = canonical[:start] + bytes((replacement,)) + canonical[start + 1:]
        mutations.add(
            positive["id"], "generated-sample", f"corrupt-utf8-{label}", canonical.hex(), mutated,
            "mutation-corrupt-utf8", parameter={"offset": start, "replacement": replacement},
        )
    for relative, octet in enumerate(payload):
        if 0x80 <= octet <= 0xBF:
            position = start + relative
            mutated = canonical[:position] + b"A" + canonical[position + 1:]
            mutations.add(
                positive["id"], "generated-sample", "corrupt-utf8-continuation-byte", canonical.hex(), mutated,
                "mutation-corrupt-utf8", parameter={"offset": position, "replacement": 0x41},
            )
            break


def select_mutation_samples(positives: Sequence[dict[str, Any]], count: int) -> list[dict[str, Any]]:
    by_tag: dict[int, dict[str, Any]] = {}
    for row in positives:
        tag = bytes.fromhex(row["canonical_hex"])[5]
        current = by_tag.get(tag)
        if current is None:
            by_tag[tag] = row
        elif (
            tag == 0x20
            and not any(
                octet >= 0x80
                for octet in bytes.fromhex(current["expected_decoded"].get("utf8_hex", ""))
            )
            and any(
                octet >= 0x80
                for octet in bytes.fromhex(row["expected_decoded"].get("utf8_hex", ""))
            )
        ):
            # A multi-octet scalar is required to mutate both lead and
            # continuation positions.
            by_tag[tag] = row
    selected: list[dict[str, Any]] = [by_tag[tag] for tag in ASSIGNED_TAGS]
    seen = {row["id"] for row in selected}
    for row in positives:
        if row["id"] not in seen:
            selected.append(row)
            seen.add(row["id"])
        if len(selected) >= count:
            break
    return selected[:count]


def build_mutations(
    root: Path,
    positives: Sequence[dict[str, Any]],
    sample_count: int,
    truncation_max_octets: int,
    cd0: Any,
    budget: Any,
    coverage: Coverage,
) -> tuple[list[dict[str, Any]], dict[str, int]]:
    mutations = MutationBuilder(coverage)
    hand_rows = read_jsonl(root / "canonical-datum" / "vectors" / "cd0-positive.jsonl")
    hand_truncations = 0
    generated_truncations = 0

    for row in hand_rows:
        document = bytes.fromhex(row["canonical_hex"])
        for point in range(len(document)):
            mutations.add(
                row["id"], "hand-positive", "truncate-at", document.hex(), document[:point],
                "all-hand-vector-truncation-points", parameter=point,
            )
            hand_truncations += 1

    for row in positives:
        document = bytes.fromhex(row["canonical_hex"])
        if len(document) <= truncation_max_octets:
            for point in range(len(document)):
                mutations.add(
                    row["id"], "generated-configured-size", "truncate-at", document.hex(), document[:point],
                    "configured-generated-truncation-points", parameter=point,
                )
                generated_truncations += 1

    samples = select_mutation_samples(positives, sample_count)
    for row in samples:
        document = bytes.fromhex(row["canonical_hex"])
        for position in range(len(document)):
            mutations.add(
                row["id"], "generated-sample", "delete-octet", document.hex(), document[:position] + document[position + 1:],
                "mutation-delete-each-octet", parameter=position,
            )
        for point in range(len(document)):
            mutations.add(
                row["id"], "generated-sample", "delete-suffix", document.hex(), document[:point],
                "mutation-delete-each-suffix", parameter=point,
            )
        for suffix in (b"\x00", b"\xff", MAGIC_VERSION + b"\x00"):
            mutations.add(
                row["id"], "generated-sample", "append-octets", document.hex(), document + suffix,
                "mutation-append-octets", parameter=suffix.hex(),
            )
        if len(document) > 5:
            for replacement in (0x03, 0xEF, 0xF0, 0xFF):
                mutations.add(
                    row["id"], "generated-sample", "replace-root-type-tag", document.hex(),
                    document[:5] + bytes((replacement,)) + document[6:],
                    "mutation-replace-tags", parameter=replacement,
                )
        mutations.add(
            row["id"], "generated-sample", "make-version-uvar-overlong", document.hex(),
            document[:4] + b"\x80" + document[4:],
            "mutation-overlong-uvar", parameter={"offset": 4},
        )
        add_declared_size_mutations(mutations, row)
        add_utf8_mutations(mutations, row)
        add_record_mutations(mutations, row, cd0, budget)
        add_rational_mutations(mutations, row)

    return mutations.rows, {
        "hand_positive_documents": len(hand_rows),
        "hand_truncation_candidates": hand_truncations,
        "generated_documents_at_or_below_configured_size": sum(
            1 for row in positives if len(bytes.fromhex(row["canonical_hex"])) <= truncation_max_octets
        ),
        "generated_truncation_candidates": generated_truncations,
        "sampled_positive_documents": len(samples),
    }


def build_host_scenarios(positives: Sequence[dict[str, Any]], coverage: Coverage) -> dict[str, Any]:
    privileged_refs = [
        row["id"]
        for row in positives
        if any("ordinary inert" in note for note in row["notes"])
    ]
    scenarios = [
        {
            "id": "cd0-host-property-cycle",
            "kind": "negative-host-graph",
            "requirement": "active-ancestor cycles refuse without partial datum",
            "descriptor": {"root": {"$ref": "x"}, "objects": {"x": {"host_type": "sequence", "items": [{"$ref": "x"}]}}},
            "expected": {"category": "UnsupportedHostInput", "code": "CyclicHostInput", "stage": "host-import"},
        },
        {
            "id": "cd0-host-property-improper-list",
            "kind": "negative-host-graph",
            "requirement": "an improper host list is not a CD/0 sequence",
            "descriptor": {"root": {"$ref": "x"}, "objects": {"x": {"host_type": "list", "items": [], "tail": {"host_type": "unit"}}}},
            "expected": {"category": "UnsupportedHostInput", "code": "ImproperHostList", "stage": "host-import"},
        },
        {
            "id": "cd0-host-property-shared-acyclic",
            "kind": "positive-host-graph",
            "requirement": "repeated non-active references import by abstract value, not host identity",
            "descriptor": {
                "root": {"$ref": "root"},
                "objects": {
                    "root": {"host_type": "sequence", "items": [{"$ref": "leaf"}, {"$ref": "leaf"}]},
                    "leaf": {"host_type": "sequence", "items": [{"host_type": "integer", "value": "7"}]},
                },
            },
            "expected_ast": {"t": "seq", "items": [{"t": "seq", "items": [{"t": "int", "v": "7"}]}, {"t": "seq", "items": [{"t": "int", "v": "7"}]}]},
        },
        {
            "id": "cd0-host-property-mutable-aliases",
            "kind": "mutation-resistance-property",
            "requirement": "successful datums snapshot mutable aliases",
            "host_sources": ["mutable-string-buffer", "bytearray", "memoryview", "list", "vector", "record-field-list"],
            "probe": "mutate every source after construction/decode; AST and canonical bytes remain unchanged",
        },
        {
            "id": "cd0-host-property-symbols-bool",
            "kind": "disjoint-host-types-property",
            "requirement": "symbols need explicit mapping and Python bool never imports as integer",
            "cases": ["interned-symbol-without-mapping", "uninterned-symbol", "package-renamed-symbol", "python-true-as-integer", "python-false-as-zero"],
            "divergence_boundary": "A2 leaves the bool/importer exact code provisional",
        },
        {
            "id": "cd0-host-property-namespaces",
            "kind": "equality-property",
            "requirement": "identifier namespaces, paths, case, and Unicode scalars remain exact and disjoint",
            "cases": ["empty-vs-nonempty-namespace", "namespace-vs-path", "case-distinction", "precomposed-vs-decomposed", "Latin-vs-Cyrillic-confusable"],
        },
        {
            "id": "cd0-host-property-live-privileged",
            "kind": "negative-host-value",
            "requirement": "live capability/warrant/claim/certificate/receipt values cannot be restored",
            "expected_category": "PrivilegedRestorationAttempt",
        },
        {
            "id": "cd0-host-property-inert-records",
            "kind": "positive-inertness-property",
            "requirement": "shape alone has no privilege; decode performs no dispatch, lookup, I/O, evaluation, or restoration",
            "positive_vector_refs": privileged_refs,
            "shapes": ["capability", "warrant", "claim", "certificate", "receipt"],
        },
        {
            "id": "cd0-host-property-rational-construction",
            "kind": "constructor-normalization-property",
            "requirement": "2/4 constructs the same abstract value as 1/2 while exact bytes for unreduced 2/4 refuse",
            "divergence_boundary": "A7: this is metadata, not an invented fixture AST constructor form",
        },
    ]
    coverage.hit("host-cycles-and-improper-lists", "cd0-host-property-cycle")
    coverage.hit("host-cycles-and-improper-lists", "cd0-host-property-improper-list")
    coverage.hit("host-shared-acyclic-and-mutable-aliases", "cd0-host-property-shared-acyclic")
    coverage.hit("host-shared-acyclic-and-mutable-aliases", "cd0-host-property-mutable-aliases")
    coverage.hit("host-symbols-and-python-bool-int", "cd0-host-property-symbols-bool")
    coverage.hit("identifier-namespace-distinctions", "cd0-host-property-namespaces")
    coverage.hit("privileged-host-refusal", "cd0-host-property-live-privileged")
    coverage.hit("privileged-looking-inert-records", "cd0-host-property-inert-records")
    coverage.hit("rational-normalization-and-refusal", "cd0-host-property-rational-construction")
    return {
        "schema": "cd0-host-property-scenarios/v1",
        "factual_status": "executable scenario metadata; not evidence that a probe ran",
        "scenarios": scenarios,
    }


def write_jsonl(path: Path, rows: Sequence[Mapping[str, Any]]) -> None:
    payload = "".join(canonical_json(row) + "\n" for row in rows)
    path.write_text(payload, encoding="ascii", newline="\n")


def write_json(path: Path, value: Any) -> None:
    path.write_text(json.dumps(value, ensure_ascii=True, sort_keys=True, indent=2) + "\n", encoding="ascii", newline="\n")


def artifact_record(path: Path, row_count: int | None = None) -> dict[str, Any]:
    record: dict[str, Any] = {
        "sha256": sha256_file(path),
        "octets": path.stat().st_size,
    }
    if row_count is not None:
        record["rows"] = row_count
    return record


def corpus_digest(artifacts: Mapping[str, Mapping[str, Any]]) -> str:
    material = b"".join(
        name.encode("utf-8") + b"\0" + artifacts[name]["sha256"].encode("ascii") + b"\n"
        for name in sorted(artifacts)
    )
    return sha256_bytes(material)


def logical_command(args: argparse.Namespace, root: Path) -> list[str]:
    try:
        output = str(args.output_dir.resolve().relative_to(root.resolve()))
    except ValueError:
        output = str(args.output_dir.resolve())
    result = [
        "python3",
        "canonical-datum/generator/generate_corpus.py",
        "--output-dir",
        output,
        "--seed",
        str(args.seed),
        "--positive-count",
        str(args.positive_count),
        "--negative-count",
        str(args.negative_count),
        "--mutation-sample-count",
        str(args.mutation_sample_count),
        "--truncation-max-document-octets",
        str(args.truncation_max_document_octets),
    ]
    if args.allow_small:
        result.append("--allow-small")
    return result


def generate(args: argparse.Namespace) -> Path:
    root = args.repo_root.resolve()
    spec_path, spec_digest = verify_spec(root)
    if not args.allow_small:
        if args.positive_count < RELEASE_POSITIVE_MINIMUM:
            raise GeneratorError(f"release positive count must be at least {RELEASE_POSITIVE_MINIMUM}")
        if args.negative_count < RELEASE_NEGATIVE_MINIMUM:
            raise GeneratorError(f"release negative count must be at least {RELEASE_NEGATIVE_MINIMUM}")
    if args.positive_count < len(core_positive_asts()):
        raise GeneratorError(f"positive count must be at least {len(core_positive_asts())} to cover the core matrix")
    if args.negative_count < 512:
        raise GeneratorError("negative count must be at least 512 to cover all reserved and forbidden tags")
    if args.mutation_sample_count < len(ASSIGNED_TAGS):
        raise GeneratorError(f"mutation sample count must be at least {len(ASSIGNED_TAGS)}")
    if args.mutation_sample_count > args.positive_count:
        raise GeneratorError("mutation sample count exceeds positive count")
    if args.truncation_max_document_octets < 1:
        raise GeneratorError("truncation maximum must be positive")

    output = args.output_dir.resolve()
    if output.exists():
        raise GeneratorError(f"refusing to overwrite existing output directory: {output}")
    output.parent.mkdir(parents=True, exist_ok=True)

    cd0 = import_codec(root)
    budgets = load_budgets(root, cd0)
    default_budget = budgets["cd0-conformance-default"]
    coverage = Coverage()
    rng = random.Random(args.seed)

    positives, positive_metadata = build_positives(args.positive_count, rng, cd0, default_budget, coverage)
    negative_builder = NegativeBuilder(cd0, budgets, coverage)
    seed_precise_negatives(negative_builder, positives)
    fill_precise_negatives(negative_builder, positives, args.negative_count)
    mutations, truncation_summary = build_mutations(
        root,
        positives,
        args.mutation_sample_count,
        args.truncation_max_document_octets,
        cd0,
        default_budget,
        coverage,
    )
    host_scenarios = build_host_scenarios(positives, coverage)

    if len({row["canonical_hex"] for row in positives}) != len(positives):
        raise GeneratorError("positive canonical documents are not unique")
    if len(negative_builder.rows) != args.negative_count:
        raise GeneratorError("classified negative count differs from requested count")
    if len(negative_builder.derivations) != len(negative_builder.rows):
        raise GeneratorError("negative derivation sidecar is incomplete")

    # Assert complete coverage before creating the output directory.  A failed
    # precondition therefore leaves no partial corpus behind.
    coverage_document = coverage.manifest()

    output.mkdir()
    paths = {name: output / filename for name, filename in OUTPUT_FILENAMES.items()}
    write_jsonl(paths["positive"], positives)
    write_jsonl(paths["negative"], negative_builder.rows)
    write_jsonl(paths["negative_derivations"], negative_builder.derivations)
    write_jsonl(paths["mutation_candidates"], mutations)
    write_json(paths["host_scenarios"], host_scenarios)

    artifacts = {
        OUTPUT_FILENAMES["positive"]: artifact_record(paths["positive"], len(positives)),
        OUTPUT_FILENAMES["negative"]: artifact_record(paths["negative"], len(negative_builder.rows)),
        OUTPUT_FILENAMES["negative_derivations"]: artifact_record(paths["negative_derivations"], len(negative_builder.derivations)),
        OUTPUT_FILENAMES["mutation_candidates"]: artifact_record(paths["mutation_candidates"], len(mutations)),
        OUTPUT_FILENAMES["host_scenarios"]: artifact_record(paths["host_scenarios"], len(host_scenarios["scenarios"])),
    }
    command_argv = logical_command(args, root)
    manifest = {
        "schema": "cd0-generated-corpus-manifest/v1",
        "generator_version": GENERATOR_VERSION,
        "deterministic_seed": args.seed,
        "logical_command_argv": command_argv,
        "logical_command": shlex.join(command_argv),
        "invocation_argv": [sys.executable, *sys.argv[1:]],
        "invocation_command": shlex.join([sys.executable, *sys.argv[1:]]),
        "source_revision": git_revision(root),
        "generator_runtime": {
            "implementation": platform.python_implementation(),
            "version": platform.python_version(),
            "random_engine": "random.Random (MT19937) with explicit integer seed",
        },
        "normative_specification": {
            "path": str(spec_path.relative_to(root)),
            "sha256": spec_digest,
        },
        "counts": {
            "positive": len(positives),
            "classified_negative": len(negative_builder.rows),
            "negative_derivations": len(negative_builder.derivations),
            "unclassified_mutation_candidates": len(mutations),
            "host_property_scenarios": len(host_scenarios["scenarios"]),
        },
        "release_thresholds": {
            "positive_minimum": RELEASE_POSITIVE_MINIMUM,
            "classified_negative_minimum": RELEASE_NEGATIVE_MINIMUM,
            "qualifies": len(positives) >= RELEASE_POSITIVE_MINIMUM and len(negative_builder.rows) >= RELEASE_NEGATIVE_MINIMUM,
            "allow_small_test_mode": bool(args.allow_small),
        },
        "truncation_configuration": {
            "maximum_generated_document_octets": args.truncation_max_document_octets,
            **truncation_summary,
        },
        "artifacts": artifacts,
        "corpus_sha256": corpus_digest(artifacts),
        "coverage": coverage_document,
        "representation_and_oracle_boundary": {
            "fixture_ast": "shared Section 27 JSON AST",
            "encoder_classifier": "post-seed Python CD/0 implementation",
            "authority": "consistency aid only; canonical identity and failure triples remain governed by the pinned specification and differential conformance",
            "mutation_candidates": "unclassified; no permanent triple until minimized and compared",
        },
        "divergence_boundary": "A1-A9 remain open; provisional host bool code is marked and mutations carry no inferred normative triple",
        "positive_root_tag_counts": {
            f"{tag:02x}": sum(1 for item in positive_metadata if item["root_tag"] == tag)
            for tag in ASSIGNED_TAGS
        },
        "manifest_self_hash": "excluded to avoid circularity; hash this file in the external artifact ledger",
    }
    write_json(output / "cd0-corpus-manifest.json", manifest)
    return output / "cd0-corpus-manifest.json"


def parse_integer(text: str) -> int:
    try:
        return int(text, 0)
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"invalid integer {text!r}") from exc


def parser() -> argparse.ArgumentParser:
    root = Path(__file__).resolve().parents[2]
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--repo-root", type=Path, default=root, help=argparse.SUPPRESS)
    result.add_argument("--output-dir", type=Path, required=True)
    result.add_argument("--seed", type=parse_integer, default=DEFAULT_SEED)
    result.add_argument("--positive-count", type=int, default=RELEASE_POSITIVE_MINIMUM)
    result.add_argument("--negative-count", type=int, default=RELEASE_NEGATIVE_MINIMUM)
    result.add_argument("--mutation-sample-count", type=int, default=DEFAULT_MUTATION_SAMPLE_COUNT)
    result.add_argument(
        "--truncation-max-document-octets",
        type=int,
        default=DEFAULT_TRUNCATION_MAX_DOCUMENT_OCTETS,
    )
    result.add_argument("--allow-small", action="store_true", help="permit non-release counts for deterministic tests")
    return result


def main(argv: Sequence[str] | None = None) -> int:
    args = parser().parse_args(argv)
    try:
        manifest = generate(args)
    except (GeneratorError, subprocess.CalledProcessError) as exc:
        print(f"cd0 corpus generation refused: {exc}", file=sys.stderr)
        return 2
    print(manifest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
