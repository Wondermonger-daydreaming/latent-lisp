"""Clean-room Python implementation of Lisp+ Canonical Datum /0.

The public surface deliberately accepts only explicit CD/0 constructors or the
typed shared-fixture AST.  It does not infer datum meaning from arbitrary Python
objects.  Canonical bytes and diagnostic rendering are separate operations.
"""

from __future__ import annotations

from dataclasses import dataclass, fields as dataclass_fields
import math
import re
from types import MappingProxyType
from typing import Any, Iterable, Iterator, Mapping


MAGIC = b"LPCD"
FORMAT_VERSION = 0

INVALID_GRAMMAR = "InvalidCanonicalGrammar"
NONCANONICAL = "NoncanonicalEncoding"
UNSUPPORTED_FORMAT = "UnsupportedFormat"
RESOURCE_REFUSAL = "ResourceRefusal"
UNSUPPORTED_HOST = "UnsupportedHostInput"
PRIVILEGED_ATTEMPT = "PrivilegedRestorationAttempt"
INTERNAL_FAILURE = "InternalInvariantFailure"

_DECIMAL_RE = re.compile(r"^-?(?:0|[1-9][0-9]*)$")
_HEX_RE = re.compile(r"^(?:[0-9a-f]{2})*$")


class CD0Failure(Exception):
    """Typed CD/0 failure with the normative comparison triple."""

    __slots__ = (
        "category",
        "code",
        "stage",
        "offset",
        "path",
        "detail",
        "budget_id",
    )

    def __init__(
        self,
        category: str,
        code: str,
        stage: str,
        *,
        offset: int | None = None,
        path: tuple[Any, ...] = (),
        detail: Any = None,
        budget_id: str | None = None,
    ) -> None:
        self.category = category
        self.code = code
        self.stage = stage
        self.offset = offset
        self.path = tuple(path)
        self.detail = detail
        self.budget_id = budget_id
        super().__init__(f"{category}/{code}/{stage}")

    @property
    def triple(self) -> tuple[str, str, str]:
        return (self.category, self.code, self.stage)

    def as_dict(self) -> dict[str, str]:
        return {"category": self.category, "code": self.code, "stage": self.stage}


@dataclass(frozen=True, slots=True)
class ResourceBudget:
    """Immutable resolved resource budget.

    The identifier is diagnostic metadata; the fourteen limits are the fields
    required by Section 21.2.
    """

    max_input_octets: int
    max_output_octets: int
    max_varint_octets: int
    max_integer_bits: int
    max_depth: int
    max_nodes: int
    max_sequence_items: int
    max_record_fields: int
    max_identifier_segments: int
    max_segment_octets: int
    max_single_string_octets: int
    max_single_bytes_octets: int
    max_aggregate_payload_octets: int
    max_total_record_key_octets: int
    identifier: str = "custom"

    def __post_init__(self) -> None:
        for field in dataclass_fields(self):
            if field.name == "identifier":
                if type(self.identifier) is not str or not self.identifier:
                    raise ValueError("budget identifier must be a nonempty str")
                continue
            value = getattr(self, field.name)
            if type(value) is not int or value < 0:
                raise ValueError(f"{field.name} must be a nonnegative int")

    @classmethod
    def from_mapping(cls, value: Mapping[str, Any], *, identifier: str = "custom") -> "ResourceBudget":
        expected = {field.name for field in dataclass_fields(cls) if field.name != "identifier"}
        supplied = set(value)
        if supplied != expected:
            missing = sorted(expected - supplied)
            extra = sorted(supplied - expected)
            raise ValueError(f"budget fields mismatch: missing={missing}, extra={extra}")
        return cls(**{name: value[name] for name in expected}, identifier=identifier)

    @property
    def limits(self) -> Mapping[str, int]:
        return MappingProxyType(
            {
                field.name: getattr(self, field.name)
                for field in dataclass_fields(self)
                if field.name != "identifier"
            }
        )


class Datum:
    """Marker base class for the fixed inert CD/0 runtime families."""

    __slots__ = ()


def _constructor_failure(code: str, detail: str | None = None) -> CD0Failure:
    # Constructor triples are unresolved by specification divergence A2.  This
    # seed consistently treats them as explicit host-input failures.
    return CD0Failure(UNSUPPORTED_HOST, code, "host-import", detail=detail)


def _require_scalar_string(value: Any, *, nonempty: bool = False) -> str:
    if type(value) is not str:
        raise _constructor_failure("UnsupportedHostType", "expected exact Python str")
    if nonempty and not value:
        raise _constructor_failure("EmptyIdentifierSegment")
    if any(0xD800 <= ord(character) <= 0xDFFF for character in value):
        raise _constructor_failure("InvalidHostUnicode", "surrogate code point")
    return value


@dataclass(frozen=True, slots=True)
class Unit(Datum):
    pass


@dataclass(frozen=True, slots=True)
class Boolean(Datum):
    value: bool

    def __post_init__(self) -> None:
        if type(self.value) is not bool:
            raise _constructor_failure("UnsupportedHostType", "boolean requires exact bool")


@dataclass(frozen=True, slots=True)
class Integer(Datum):
    value: int

    def __post_init__(self) -> None:
        if type(self.value) is not int:
            raise _constructor_failure("UnsupportedHostType", "integer requires exact int; bool is disjoint")


@dataclass(frozen=True, slots=True)
class Rational(Datum):
    numerator: int
    denominator: int

    def __post_init__(self) -> None:
        if type(self.numerator) is not int or type(self.denominator) is not int:
            raise _constructor_failure("UnsupportedHostType", "rational components require exact int")
        if self.denominator == 0:
            raise _constructor_failure("ZeroDenominator")
        if self.denominator < 0:
            raise _constructor_failure("NegativeDenominatorHostRational")
        if self.numerator == 0:
            raise _constructor_failure("ZeroRationalEncoding")
        if self.denominator == 1:
            raise _constructor_failure("IntegralRationalEncoding")
        if math.gcd(abs(self.numerator), self.denominator) != 1:
            raise _constructor_failure("UnreducedRational")


@dataclass(frozen=True, slots=True)
class String(Datum):
    value: str

    def __post_init__(self) -> None:
        object.__setattr__(self, "value", _require_scalar_string(self.value))

    @property
    def scalar_length(self) -> int:
        return len(self.value)


@dataclass(frozen=True, slots=True)
class ByteString(Datum):
    value: bytes

    def __post_init__(self) -> None:
        if not isinstance(self.value, (bytes, bytearray, memoryview)):
            raise _constructor_failure("UnsupportedHostType", "byte string requires a bytes-like snapshot")
        try:
            snapshot = bytes(self.value)
        except (TypeError, ValueError) as exc:
            raise _constructor_failure("UnsupportedHostType", str(exc)) from exc
        object.__setattr__(self, "value", snapshot)


def _snapshot_segments(value: Any, label: str) -> tuple[str, ...]:
    if isinstance(value, (str, bytes, bytearray, memoryview)):
        raise _constructor_failure("UnsupportedHostType", f"{label} must be an iterable of segments")
    try:
        result = tuple(value)
    except TypeError as exc:
        raise _constructor_failure("UnsupportedHostType", f"{label} is not iterable") from exc
    return tuple(_require_scalar_string(segment, nonempty=True) for segment in result)


@dataclass(frozen=True, slots=True)
class Identifier(Datum):
    namespace: tuple[str, ...]
    path: tuple[str, ...]

    def __post_init__(self) -> None:
        namespace = _snapshot_segments(self.namespace, "identifier namespace")
        path = _snapshot_segments(self.path, "identifier path")
        if not path:
            raise _constructor_failure("MissingIdentifierPath")
        object.__setattr__(self, "namespace", namespace)
        object.__setattr__(self, "path", path)


@dataclass(frozen=True, slots=True)
class Sequence(Datum):
    items: tuple[Datum, ...]

    def __post_init__(self) -> None:
        if isinstance(self.items, (str, bytes, bytearray, memoryview, Mapping)):
            raise _constructor_failure("UnsupportedHostType", "sequence requires an explicit iterable of datums")
        try:
            snapshot = tuple(self.items)
        except TypeError as exc:
            raise _constructor_failure("UnsupportedHostType", "sequence source is not iterable") from exc
        if any(not _is_datum(item) for item in snapshot):
            raise _constructor_failure("UnsupportedHostType", "sequence element is not a CD/0 datum")
        object.__setattr__(self, "items", snapshot)

    def __iter__(self) -> Iterator[Datum]:
        return iter(self.items)

    def __len__(self) -> int:
        return len(self.items)


@dataclass(frozen=True, slots=True)
class Record(Datum):
    fields: tuple[tuple[Identifier, Datum], ...]

    def __post_init__(self) -> None:
        if isinstance(self.fields, Mapping):
            raise _constructor_failure("UnsupportedHostType", "record requires an explicit field sequence")
        try:
            source = tuple(self.fields)
        except TypeError as exc:
            raise _constructor_failure("UnsupportedHostType", "record field source is not iterable") from exc
        normalized: list[tuple[Identifier, Datum]] = []
        encoded_keys: set[bytes] = set()
        for field in source:
            try:
                key, value = field
            except (TypeError, ValueError) as exc:
                raise _constructor_failure("UnsupportedHostType", "record field must be a key/value pair") from exc
            if type(key) is not Identifier or not _is_datum(value):
                raise _constructor_failure("UnsupportedHostType", "record fields require Identifier keys and datums")
            key_bytes = _identifier_value_bytes(key)
            if key_bytes in encoded_keys:
                raise _constructor_failure("DuplicateRecordField")
            encoded_keys.add(key_bytes)
            normalized.append((key, value))
        normalized.sort(key=lambda pair: _identifier_value_bytes(pair[0]))
        object.__setattr__(self, "fields", tuple(normalized))

    def __iter__(self) -> Iterator[tuple[Identifier, Datum]]:
        return iter(self.fields)

    def __len__(self) -> int:
        return len(self.fields)

    def get(self, key: Identifier, default: Any = None) -> Datum | Any:
        if type(key) is not Identifier:
            raise _constructor_failure("UnsupportedHostType", "record lookup key must be Identifier")
        for existing, value in self.fields:
            if existing == key:
                return value
        return default

    @property
    def items_view(self) -> tuple[tuple[Identifier, Datum], ...]:
        return self.fields


_DATUM_TYPES = (Unit, Boolean, Integer, Rational, String, ByteString, Identifier, Sequence, Record)
_UNIT = Unit()


def _is_datum(value: Any) -> bool:
    return type(value) in _DATUM_TYPES


def unit() -> Unit:
    return _UNIT


def boolean(value: bool) -> Boolean:
    return Boolean(value)


def integer(value: int) -> Integer:
    return Integer(value)


def rational(numerator: int, denominator: int) -> Integer | Rational:
    """Construct and normalize an exact rational as required by Section 8.3."""

    if type(numerator) is not int or type(denominator) is not int:
        raise _constructor_failure("UnsupportedHostType", "rational components require exact int")
    if denominator == 0:
        raise _constructor_failure("ZeroDenominator")
    if denominator < 0:
        numerator = -numerator
        denominator = -denominator
    divisor = math.gcd(abs(numerator), denominator)
    numerator //= divisor
    denominator //= divisor
    if numerator == 0:
        return Integer(0)
    if denominator == 1:
        return Integer(numerator)
    return Rational(numerator, denominator)


def string(value: str) -> String:
    return String(value)


def byte_string(value: bytes | bytearray | memoryview) -> ByteString:
    return ByteString(value)


def identifier(namespace: Iterable[str], path: Iterable[str]) -> Identifier:
    return Identifier(namespace, path)  # type: ignore[arg-type]


def sequence(items: Iterable[Datum]) -> Sequence:
    return Sequence(items)  # type: ignore[arg-type]


def record(fields: Iterable[tuple[Identifier, Datum]]) -> Record:
    return Record(fields)  # type: ignore[arg-type]


def equal_datum(left: Datum, right: Datum) -> bool:
    if not _is_datum(left) or not _is_datum(right):
        raise _constructor_failure("UnsupportedHostType", "equal_datum accepts only runtime datums")
    return type(left) is type(right) and left == right


def _uvar_bytes(value: int) -> bytes:
    if type(value) is not int or value < 0:
        raise ValueError("UVAR requires a nonnegative exact int")
    result = bytearray()
    while True:
        octet = value & 0x7F
        value >>= 7
        if value:
            result.append(octet | 0x80)
        else:
            result.append(octet)
            return bytes(result)


def _zigzag(value: int) -> int:
    return 2 * value if value >= 0 else -2 * value - 1


def _unzigzag(value: int) -> int:
    return value // 2 if value % 2 == 0 else -((value + 1) // 2)


def _identifier_value_bytes(value: Identifier) -> bytes:
    result = bytearray((0x22,))
    result.extend(_uvar_bytes(len(value.namespace)))
    for segment in value.namespace:
        payload = segment.encode("utf-8")
        result.extend(_uvar_bytes(len(payload)))
        result.extend(payload)
    result.extend(_uvar_bytes(len(value.path)))
    for segment in value.path:
        payload = segment.encode("utf-8")
        result.extend(_uvar_bytes(len(payload)))
        result.extend(payload)
    return bytes(result)


class _Encoder:
    __slots__ = ("budget", "output", "record_key_octets", "active")

    def __init__(self, budget: ResourceBudget) -> None:
        self.budget = budget
        self.output = bytearray()
        self.record_key_octets = 0
        self.active: set[int] = set()

    def fail(self, category: str, code: str, stage: str, *, detail: Any = None) -> None:
        raise CD0Failure(category, code, stage, detail=detail, budget_id=self.budget.identifier)

    def emit(self, value: bytes | bytearray) -> None:
        if len(self.output) + len(value) > self.budget.max_output_octets:
            # A1 leaves the encoder stage open.  This seed uses allocation.
            self.fail(RESOURCE_REFUSAL, "ExcessiveOutputLength", "allocation")
        self.output.extend(value)

    def emit_uvar(self, value: int) -> None:
        while True:
            octet = value & 0x7F
            value >>= 7
            self.emit(bytes((octet | 0x80 if value else octet,)))
            if not value:
                return

    def encode(self, value: Datum) -> bytes:
        self.emit(MAGIC)
        self.emit_uvar(FORMAT_VERSION)
        self.encode_value(value)
        return bytes(self.output)

    def encode_value(self, value: Datum) -> None:
        if not _is_datum(value):
            self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
        if type(value) is Unit:
            self.emit(b"\x00")
            return
        if type(value) is Boolean:
            if type(value.value) is not bool:
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
            self.emit(b"\x02" if value.value else b"\x01")
            return
        if type(value) is Integer:
            if type(value.value) is not int:
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
            self.emit(b"\x10")
            self.emit_uvar(_zigzag(value.value))
            return
        if type(value) is Rational:
            if (
                type(value.numerator) is not int
                or type(value.denominator) is not int
                or value.numerator == 0
                or value.denominator <= 1
                or math.gcd(abs(value.numerator), value.denominator) != 1
            ):
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
            self.emit(b"\x11")
            self.emit_uvar(_zigzag(value.numerator))
            self.emit_uvar(value.denominator)
            return
        if type(value) is String:
            try:
                payload = value.value.encode("utf-8", errors="strict")
            except (AttributeError, UnicodeEncodeError):
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
            self.emit(b"\x20")
            self.emit_uvar(len(payload))
            self.emit(payload)
            return
        if type(value) is ByteString:
            if type(value.value) is not bytes:
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
            self.emit(b"\x21")
            self.emit_uvar(len(value.value))
            self.emit(value.value)
            return
        if type(value) is Identifier:
            self.emit(_identifier_value_bytes(value))
            return
        if type(value) is Sequence:
            marker = id(value)
            if marker in self.active:
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal", detail="cycle")
            self.active.add(marker)
            try:
                self.emit(b"\x30")
                self.emit_uvar(len(value.items))
                for item in value.items:
                    self.encode_value(item)
            finally:
                self.active.remove(marker)
            return
        if type(value) is Record:
            marker = id(value)
            if marker in self.active:
                self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal", detail="cycle")
            self.active.add(marker)
            try:
                encoded: list[tuple[bytes, Datum]] = []
                seen: set[bytes] = set()
                for key, field_value in value.fields:
                    if type(key) is not Identifier or not _is_datum(field_value):
                        self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")
                    key_bytes = _identifier_value_bytes(key)
                    self.record_key_octets += len(key_bytes)
                    if self.record_key_octets > self.budget.max_total_record_key_octets:
                        self.fail(RESOURCE_REFUSAL, "RecordKeyWorkBudgetExceeded", "encode-ordering")
                    if key_bytes in seen:
                        self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "encode-ordering")
                    seen.add(key_bytes)
                    encoded.append((key_bytes, field_value))
                encoded.sort(key=lambda pair: pair[0])
                self.emit(b"\x31")
                self.emit_uvar(len(encoded))
                for key_bytes, field_value in encoded:
                    self.emit(key_bytes)
                    self.encode_value(field_value)
            finally:
                self.active.remove(marker)
            return
        self.fail(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")


def encode_exact(value: Datum, budget: ResourceBudget) -> bytes:
    """Return one immutable canonical document or raise :class:`CD0Failure`."""

    if type(budget) is not ResourceBudget:
        raise _constructor_failure("UnsupportedHostType", "encode_exact requires ResourceBudget")
    if not _is_datum(value):
        raise _constructor_failure("UnsupportedHostType", "encode_exact accepts only runtime datums")
    try:
        return _Encoder(budget).encode(value)
    except MemoryError as exc:
        raise CD0Failure(
            RESOURCE_REFUSAL,
            "AllocationRefused",
            "allocation",
            budget_id=budget.identifier,
        ) from exc


def _utf8_failure(code: str, offset: int, budget_id: str) -> CD0Failure:
    return CD0Failure(INVALID_GRAMMAR, code, "utf8", offset=offset, budget_id=budget_id)


def _decode_strict_utf8(payload: bytes, base_offset: int, budget_id: str) -> str:
    """Validate exactly the Section 12.2 byte shapes and return a scalar str."""

    index = 0
    size = len(payload)
    while index < size:
        first = payload[index]
        if first <= 0x7F:
            index += 1
            continue

        def continuation(position: int) -> bool:
            return position < size and 0x80 <= payload[position] <= 0xBF

        if 0xC2 <= first <= 0xDF:
            if not continuation(index + 1):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 2
            continue
        if first == 0xE0:
            if not (index + 2 < size and 0xA0 <= payload[index + 1] <= 0xBF and continuation(index + 2)):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 3
            continue
        if 0xE1 <= first <= 0xEC or 0xEE <= first <= 0xEF:
            if not (continuation(index + 1) and continuation(index + 2)):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 3
            continue
        if first == 0xED:
            if index + 2 < size and 0xA0 <= payload[index + 1] <= 0xBF and continuation(index + 2):
                raise _utf8_failure("ForbiddenUnicodeScalar", base_offset + index, budget_id)
            if not (index + 2 < size and 0x80 <= payload[index + 1] <= 0x9F and continuation(index + 2)):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 3
            continue
        if first == 0xF0:
            if not (
                index + 3 < size
                and 0x90 <= payload[index + 1] <= 0xBF
                and continuation(index + 2)
                and continuation(index + 3)
            ):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 4
            continue
        if 0xF1 <= first <= 0xF3:
            if not (continuation(index + 1) and continuation(index + 2) and continuation(index + 3)):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 4
            continue
        if first == 0xF4:
            if not (
                index + 3 < size
                and 0x80 <= payload[index + 1] <= 0x8F
                and continuation(index + 2)
                and continuation(index + 3)
            ):
                raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
            index += 4
            continue
        raise _utf8_failure("InvalidUTF8", base_offset + index, budget_id)
    return payload.decode("utf-8", errors="strict")


class _Decoder:
    __slots__ = ("data", "budget", "position", "nodes", "aggregate_payload")

    def __init__(self, data: bytes, budget: ResourceBudget) -> None:
        self.data = data
        self.budget = budget
        self.position = 0
        self.nodes = 0
        self.aggregate_payload = 0

    def fail(
        self,
        category: str,
        code: str,
        stage: str,
        *,
        offset: int | None = None,
        detail: Any = None,
    ) -> None:
        raise CD0Failure(
            category,
            code,
            stage,
            offset=self.position if offset is None else offset,
            detail=detail,
            budget_id=self.budget.identifier,
        )

    def decode(self) -> Datum:
        if len(self.data) > self.budget.max_input_octets:
            self.fail(RESOURCE_REFUSAL, "ExcessiveInputLength", "input-budget", offset=0)
        for expected in MAGIC:
            if self.position >= len(self.data):
                self.fail(INVALID_GRAMMAR, "TruncatedInput", "magic")
            if self.data[self.position] != expected:
                self.fail(INVALID_GRAMMAR, "InvalidMagic", "magic")
            self.position += 1
        version = self.read_uvar("version-varint", "NonminimalVersionEncoding")
        if version != FORMAT_VERSION:
            self.fail(UNSUPPORTED_FORMAT, "UnsupportedFutureVersion", "version-selection")
        value = self.parse_value(1)
        if self.position != len(self.data):
            self.fail(INVALID_GRAMMAR, "TrailingBytes", "end-of-input")
        return value

    def read_uvar(self, stage: str, nonminimal_code: str) -> int:
        value = 0
        shift = 0
        count = 0
        while True:
            if count >= self.budget.max_varint_octets:
                self.fail(RESOURCE_REFUSAL, "VarintBudgetExceeded", stage)
            if self.position >= len(self.data):
                self.fail(INVALID_GRAMMAR, "TruncatedInput", stage)
            octet = self.data[self.position]
            self.position += 1
            payload = octet & 0x7F
            value |= payload << shift
            count += 1
            if not (octet & 0x80):
                if count > 1 and payload == 0:
                    self.fail(NONCANONICAL, nonminimal_code, stage, offset=self.position - 1)
                return value
            shift += 7

    def before_node(self, depth: int) -> None:
        # A5 implementation-local tie break: depth precedes node count.
        if depth > self.budget.max_depth:
            self.fail(RESOURCE_REFUSAL, "ExcessiveNesting", "type-tag")
        if self.nodes >= self.budget.max_nodes:
            self.fail(RESOURCE_REFUSAL, "NodeBudgetExceeded", "type-tag")
        self.nodes += 1

    def require_payload(self, length: int, stage: str) -> tuple[bytes, int]:
        start = self.position
        end = start + length
        if end > len(self.data):
            self.fail(INVALID_GRAMMAR, "TruncatedInput", stage)
        self.position = end
        return self.data[start:end], start

    def add_payload(self, length: int) -> None:
        if self.aggregate_payload + length > self.budget.max_aggregate_payload_octets:
            self.fail(RESOURCE_REFUSAL, "AggregatePayloadBudgetExceeded", "length")
        self.aggregate_payload += length

    def check_integer_bits(self, value: int, stage: str) -> None:
        # A3 implementation-local choice: mathematical magnitude bit length.
        if abs(value).bit_length() > self.budget.max_integer_bits:
            self.fail(RESOURCE_REFUSAL, "IntegerBudgetExceeded", stage)

    def parse_value(self, depth: int) -> Datum:
        self.before_node(depth)
        if self.position >= len(self.data):
            self.fail(INVALID_GRAMMAR, "TruncatedInput", "type-tag")
        tag = self.data[self.position]
        self.position += 1
        if tag == 0x00:
            return _UNIT
        if tag == 0x01:
            return Boolean(False)
        if tag == 0x02:
            return Boolean(True)
        if tag == 0x10:
            encoded = self.read_uvar("integer-payload", "NonminimalIntegerEncoding")
            value = _unzigzag(encoded)
            self.check_integer_bits(value, "integer-payload")
            return Integer(value)
        if tag == 0x11:
            numerator_encoded = self.read_uvar("rational-payload", "NonminimalRationalComponentEncoding")
            numerator = _unzigzag(numerator_encoded)
            self.check_integer_bits(numerator, "rational-payload")
            denominator = self.read_uvar("rational-payload", "NonminimalRationalComponentEncoding")
            self.check_integer_bits(denominator, "rational-payload")
            if denominator == 0:
                self.fail(INVALID_GRAMMAR, "ZeroDenominator", "rational-payload")
            if numerator == 0:
                self.fail(NONCANONICAL, "ZeroRationalEncoding", "rational-payload")
            if denominator == 1:
                self.fail(NONCANONICAL, "IntegralRationalEncoding", "rational-payload")
            if math.gcd(abs(numerator), denominator) != 1:
                self.fail(NONCANONICAL, "UnreducedRational", "rational-payload")
            return Rational(numerator, denominator)
        if tag == 0x20:
            return self.parse_string()
        if tag == 0x21:
            return self.parse_bytes()
        if tag == 0x22:
            return self.parse_identifier_payload()
        if tag == 0x30:
            count = self.read_uvar("count", "OverlongCountEncoding")
            if count > self.budget.max_sequence_items:
                self.fail(RESOURCE_REFUSAL, "ExcessiveContainerCount", "count")
            return Sequence(tuple(self.parse_value(depth + 1) for _ in range(count)))
        if tag == 0x31:
            return self.parse_record(depth)
        if tag >= 0xF0:
            self.fail(PRIVILEGED_ATTEMPT, "ForbiddenPrivilegedTag", "type-tag", offset=self.position - 1)
        self.fail(INVALID_GRAMMAR, "ReservedTypeTag", "type-tag", offset=self.position - 1)

    def read_length(self, maximum: int) -> int:
        length = self.read_uvar("length", "OverlongLengthEncoding")
        # A5 implementation-local tie break: local length before aggregate.
        if length > maximum:
            self.fail(RESOURCE_REFUSAL, "ExcessiveDeclaredLength", "length")
        self.add_payload(length)
        return length

    def parse_string(self) -> String:
        length = self.read_length(self.budget.max_single_string_octets)
        payload, start = self.require_payload(length, "length")
        text = _decode_strict_utf8(payload, start, self.budget.identifier)
        return String(text)

    def parse_bytes(self) -> ByteString:
        length = self.read_length(self.budget.max_single_bytes_octets)
        payload, _ = self.require_payload(length, "length")
        return ByteString(payload)

    def parse_segment(self) -> str:
        length = self.read_uvar("length", "OverlongLengthEncoding")
        if length == 0:
            self.fail(INVALID_GRAMMAR, "EmptyIdentifierSegment", "identifier")
        if length > self.budget.max_segment_octets:
            self.fail(RESOURCE_REFUSAL, "ExcessiveDeclaredLength", "length")
        self.add_payload(length)
        payload, start = self.require_payload(length, "length")
        return _decode_strict_utf8(payload, start, self.budget.identifier)

    def parse_identifier_payload(self) -> Identifier:
        namespace_count = self.read_uvar("count", "OverlongCountEncoding")
        if namespace_count > self.budget.max_identifier_segments:
            self.fail(RESOURCE_REFUSAL, "ExcessiveIdentifierSegments", "count")
        namespace = tuple(self.parse_segment() for _ in range(namespace_count))
        path_count = self.read_uvar("count", "OverlongCountEncoding")
        if path_count == 0:
            self.fail(INVALID_GRAMMAR, "MissingIdentifierPath", "identifier")
        # A4 implementation-local choice: the segment budget is aggregate.
        if namespace_count + path_count > self.budget.max_identifier_segments:
            self.fail(RESOURCE_REFUSAL, "ExcessiveIdentifierSegments", "count")
        path = tuple(self.parse_segment() for _ in range(path_count))
        return Identifier(namespace, path)

    def parse_record_key(self, depth: int) -> tuple[Identifier, bytes]:
        self.before_node(depth)
        if self.position >= len(self.data):
            self.fail(INVALID_GRAMMAR, "TruncatedInput", "record-key")
        start = self.position
        tag = self.data[self.position]
        self.position += 1
        # A6 implementation-local choice: forbidden tags retain security
        # telemetry; every other non-identifier tag is RecordKeyNotIdentifier.
        if tag >= 0xF0:
            self.fail(PRIVILEGED_ATTEMPT, "ForbiddenPrivilegedTag", "type-tag", offset=start)
        if tag != 0x22:
            self.fail(INVALID_GRAMMAR, "RecordKeyNotIdentifier", "record-key", offset=start)
        key = self.parse_identifier_payload()
        return key, self.data[start:self.position]

    def parse_record(self, depth: int) -> Record:
        count = self.read_uvar("count", "OverlongCountEncoding")
        if count > self.budget.max_record_fields:
            self.fail(RESOURCE_REFUSAL, "ExcessiveContainerCount", "count")
        fields: list[tuple[Identifier, Datum]] = []
        previous: bytes | None = None
        for _ in range(count):
            key, key_bytes = self.parse_record_key(depth + 1)
            if previous is not None:
                if key_bytes == previous:
                    self.fail(INVALID_GRAMMAR, "DuplicateRecordField", "record-order")
                if key_bytes < previous:
                    self.fail(NONCANONICAL, "NoncanonicalFieldOrder", "record-order")
            previous = key_bytes
            fields.append((key, self.parse_value(depth + 1)))
        return Record(tuple(fields))


def decode_exact(source: bytes | bytearray | memoryview, budget: ResourceBudget) -> Datum:
    """Decode one complete canonical document from a caller-independent snapshot."""

    if type(budget) is not ResourceBudget:
        raise _constructor_failure("UnsupportedHostType", "decode_exact requires ResourceBudget")
    if not isinstance(source, (bytes, bytearray, memoryview)):
        raise _constructor_failure("UnsupportedHostType", "decode_exact requires a bytes-like input")
    try:
        source_octets = source.nbytes if isinstance(source, memoryview) else len(source)
    except ValueError as exc:
        raise _constructor_failure("UnsupportedHostType", str(exc)) from exc
    if source_octets > budget.max_input_octets:
        raise CD0Failure(
            RESOURCE_REFUSAL,
            "ExcessiveInputLength",
            "input-budget",
            offset=0,
            budget_id=budget.identifier,
        )
    try:
        snapshot = bytes(source)
    except (TypeError, ValueError) as exc:
        raise _constructor_failure("UnsupportedHostType", str(exc)) from exc
    except MemoryError as exc:
        raise CD0Failure(
            RESOURCE_REFUSAL,
            "AllocationRefused",
            "allocation",
            budget_id=budget.identifier,
        ) from exc
    try:
        return _Decoder(snapshot, budget).decode()
    except MemoryError as exc:
        raise CD0Failure(
            RESOURCE_REFUSAL,
            "AllocationRefused",
            "allocation",
            budget_id=budget.identifier,
        ) from exc


class _FixtureImporter:
    __slots__ = ("budget", "nodes", "aggregate_payload", "record_key_octets", "active")

    def __init__(self, budget: ResourceBudget) -> None:
        self.budget = budget
        self.nodes = 0
        self.aggregate_payload = 0
        self.record_key_octets = 0
        self.active: set[int] = set()

    def fail(self, code: str, *, category: str = UNSUPPORTED_HOST, detail: Any = None) -> None:
        raise CD0Failure(category, code, "host-import", detail=detail, budget_id=self.budget.identifier)

    def node(self, depth: int) -> None:
        if depth > self.budget.max_depth:
            self.fail("ExcessiveNesting", category=RESOURCE_REFUSAL)
        if self.nodes >= self.budget.max_nodes:
            self.fail("NodeBudgetExceeded", category=RESOURCE_REFUSAL)
        self.nodes += 1

    def payload(self, length: int, maximum: int) -> None:
        if length > maximum:
            self.fail("ExcessiveDeclaredLength", category=RESOURCE_REFUSAL)
        if self.aggregate_payload + length > self.budget.max_aggregate_payload_octets:
            self.fail("AggregatePayloadBudgetExceeded", category=RESOURCE_REFUSAL)
        self.aggregate_payload += length

    def enter(self, value: Any) -> int | None:
        if not isinstance(value, (dict, list, tuple)):
            return None
        marker = id(value)
        if marker in self.active:
            self.fail("CyclicHostInput")
        self.active.add(marker)
        return marker

    def leave(self, marker: int | None) -> None:
        if marker is not None:
            self.active.remove(marker)

    def exact_object(self, value: Any, keys: set[str]) -> dict[str, Any]:
        if type(value) is not dict or set(value) != keys:
            self.fail("UnsupportedHostType", detail=f"expected object fields {sorted(keys)}")
        return value

    def decimal(self, value: Any) -> int:
        if type(value) is not str or not _DECIMAL_RE.fullmatch(value):
            self.fail("UnsupportedHostType", detail="invalid fixture decimal")
        return int(value)

    def hex_payload(self, value: Any, *, nonempty: bool = False) -> bytes:
        if type(value) is not str or not _HEX_RE.fullmatch(value):
            self.fail("UnsupportedHostType", detail="invalid lowercase fixture hex")
        payload = bytes.fromhex(value)
        if nonempty and not payload:
            self.fail("EmptyIdentifierSegment")
        return payload

    def text_payload(self, value: Any, *, nonempty: bool = False) -> tuple[str, bytes]:
        payload = self.hex_payload(value, nonempty=nonempty)
        try:
            text = _decode_strict_utf8(payload, 0, self.budget.identifier)
        except CD0Failure as exc:
            self.fail("InvalidHostUnicode", detail=exc.code)
        return text, payload

    def parse_identifier(self, value: Any, depth: int, *, node_already_counted: bool = False) -> Identifier:
        if not node_already_counted:
            self.node(depth)
        marker = self.enter(value)
        try:
            ast = self.exact_object(value, {"t", "namespace_utf8_hex", "path_utf8_hex"})
            if ast["t"] != "id":
                self.fail("UnsupportedHostType")
            namespace_source = ast["namespace_utf8_hex"]
            path_source = ast["path_utf8_hex"]
            if type(namespace_source) not in (list, tuple) or type(path_source) not in (list, tuple):
                self.fail("UnsupportedHostType")
            namespace_items = tuple(namespace_source)
            path_items = tuple(path_source)
            if not path_items:
                self.fail("MissingIdentifierPath")
            if len(namespace_items) + len(path_items) > self.budget.max_identifier_segments:
                self.fail("ExcessiveIdentifierSegments", category=RESOURCE_REFUSAL)
            namespace: list[str] = []
            path: list[str] = []
            for encoded in namespace_items:
                text, payload = self.text_payload(encoded, nonempty=True)
                self.payload(len(payload), self.budget.max_segment_octets)
                namespace.append(text)
            for encoded in path_items:
                text, payload = self.text_payload(encoded, nonempty=True)
                self.payload(len(payload), self.budget.max_segment_octets)
                path.append(text)
            return Identifier(tuple(namespace), tuple(path))
        finally:
            self.leave(marker)

    def parse(self, value: Any, depth: int = 1) -> Datum:
        self.node(depth)
        marker = self.enter(value)
        try:
            if type(value) is not dict or type(value.get("t")) is not str:
                self.fail("UnsupportedHostType", detail="fixture datum must be a tagged object")
            tag = value["t"]
            if tag == "unit":
                self.exact_object(value, {"t"})
                return _UNIT
            if tag == "bool":
                ast = self.exact_object(value, {"t", "v"})
                if type(ast["v"]) is not bool:
                    self.fail("UnsupportedHostType")
                return Boolean(ast["v"])
            if tag == "int":
                ast = self.exact_object(value, {"t", "v"})
                number = self.decimal(ast["v"])
                if abs(number).bit_length() > self.budget.max_integer_bits:
                    self.fail("IntegerBudgetExceeded", category=RESOURCE_REFUSAL)
                return Integer(number)
            if tag == "rat":
                ast = self.exact_object(value, {"t", "p", "q"})
                numerator = self.decimal(ast["p"])
                denominator = self.decimal(ast["q"])
                if max(abs(numerator).bit_length(), abs(denominator).bit_length()) > self.budget.max_integer_bits:
                    self.fail("IntegerBudgetExceeded", category=RESOURCE_REFUSAL)
                if numerator == 0 or denominator <= 1 or math.gcd(abs(numerator), denominator) != 1:
                    self.fail("UnsupportedHostType", detail="fixture rational is not an abstract Rational")
                return Rational(numerator, denominator)
            if tag == "string":
                ast = self.exact_object(value, {"t", "utf8_hex"})
                text, payload = self.text_payload(ast["utf8_hex"])
                self.payload(len(payload), self.budget.max_single_string_octets)
                return String(text)
            if tag == "bytes":
                ast = self.exact_object(value, {"t", "hex"})
                payload = self.hex_payload(ast["hex"])
                self.payload(len(payload), self.budget.max_single_bytes_octets)
                return ByteString(payload)
            if tag == "id":
                # Reuse the current active marker and node accounting.
                self.leave(marker)
                marker = None
                return self.parse_identifier(value, depth, node_already_counted=True)
            if tag == "seq":
                ast = self.exact_object(value, {"t", "items"})
                source = ast["items"]
                if type(source) not in (list, tuple):
                    self.fail("UnsupportedHostType")
                items_marker = self.enter(source)
                try:
                    items = tuple(source)
                    if len(items) > self.budget.max_sequence_items:
                        self.fail("ExcessiveContainerCount", category=RESOURCE_REFUSAL)
                    return Sequence(tuple(self.parse(item, depth + 1) for item in items))
                finally:
                    self.leave(items_marker)
            if tag == "record":
                ast = self.exact_object(value, {"t", "fields"})
                source = ast["fields"]
                if type(source) not in (list, tuple):
                    self.fail("UnsupportedHostType")
                fields_marker = self.enter(source)
                try:
                    source_fields = tuple(source)
                    if len(source_fields) > self.budget.max_record_fields:
                        self.fail("ExcessiveContainerCount", category=RESOURCE_REFUSAL)
                    result: list[tuple[Identifier, Datum]] = []
                    seen: set[bytes] = set()
                    for field in source_fields:
                        field_marker = self.enter(field)
                        try:
                            field_ast = self.exact_object(field, {"key", "value"})
                            key = self.parse_identifier(field_ast["key"], depth + 1)
                            key_bytes = _identifier_value_bytes(key)
                            self.record_key_octets += len(key_bytes)
                            if self.record_key_octets > self.budget.max_total_record_key_octets:
                                self.fail("RecordKeyWorkBudgetExceeded", category=RESOURCE_REFUSAL)
                            if key_bytes in seen:
                                self.fail("DuplicateRecordField")
                            seen.add(key_bytes)
                            field_value = self.parse(field_ast["value"], depth + 1)
                            result.append((key, field_value))
                        finally:
                            self.leave(field_marker)
                    return Record(tuple(result))
                finally:
                    self.leave(fields_marker)
            self.fail("UnsupportedHostType", detail=f"unknown fixture tag {tag!r}")
        finally:
            self.leave(marker)


def from_fixture_ast(value: Any, budget: ResourceBudget) -> Datum:
    """Import the explicit shared fixture AST with cycle and budget checks."""

    if type(budget) is not ResourceBudget:
        raise _constructor_failure("UnsupportedHostType", "from_fixture_ast requires ResourceBudget")
    try:
        return _FixtureImporter(budget).parse(value)
    except MemoryError as exc:
        raise CD0Failure(
            RESOURCE_REFUSAL,
            "AllocationRefused",
            "allocation",
            budget_id=budget.identifier,
        ) from exc


class _HostDescriptorImporter:
    """Interpreter for the shared Section-28.2 hostile-host descriptors.

    This is an explicit conformance adapter, not generic Python serialization.
    It recognizes only the declared importer names and closed descriptor forms.
    """

    __slots__ = ("budget", "objects", "active", "nodes", "aggregate_payload")

    def __init__(self, descriptor: Mapping[str, Any], budget: ResourceBudget) -> None:
        self.budget = budget
        if type(descriptor) is not dict or set(descriptor) != {"root", "objects"}:
            self.fail("UnsupportedHostType", detail="host graph requires root and objects")
        objects = descriptor["objects"]
        if type(objects) is not dict or any(type(label) is not str for label in objects):
            self.fail("UnsupportedHostType", detail="host graph objects must be a string-keyed object")
        self.objects = dict(objects)
        self.active: set[str] = set()
        self.nodes = 0
        self.aggregate_payload = 0

    def fail(self, code: str, *, category: str = UNSUPPORTED_HOST, detail: Any = None) -> None:
        raise CD0Failure(category, code, "host-import", detail=detail, budget_id=self.budget.identifier)

    def before_node(self, depth: int) -> None:
        if depth > self.budget.max_depth:
            self.fail("ExcessiveNesting", category=RESOURCE_REFUSAL)
        if self.nodes >= self.budget.max_nodes:
            self.fail("NodeBudgetExceeded", category=RESOURCE_REFUSAL)
        self.nodes += 1

    def add_payload(self, length: int, maximum: int) -> None:
        if length > maximum:
            self.fail("ExcessiveDeclaredLength", category=RESOURCE_REFUSAL)
        if self.aggregate_payload + length > self.budget.max_aggregate_payload_octets:
            self.fail("AggregatePayloadBudgetExceeded", category=RESOURCE_REFUSAL)
        self.aggregate_payload += length

    def import_root(self, root: Any) -> Datum:
        return self.import_node(root, 1)

    def import_ref(self, label: Any, depth: int) -> Datum:
        if type(label) is not str or label not in self.objects:
            self.fail("UnsupportedHostType", detail="unknown host graph reference")
        if label in self.active:
            self.fail("CyclicHostInput")
        self.active.add(label)
        try:
            return self.import_node(self.objects[label], depth)
        finally:
            self.active.remove(label)

    def import_node(self, node: Any, depth: int) -> Datum:
        if type(node) is not dict:
            self.fail("UnsupportedHostType", detail="host node must be an object")
        if set(node) == {"$ref"}:
            return self.import_ref(node["$ref"], depth)
        host_type = node.get("host_type")
        if type(host_type) is not str:
            self.fail("UnsupportedHostType", detail="host node lacks host_type")
        self.before_node(depth)
        if host_type in {"sequence", "list"}:
            items = node.get("items")
            if type(items) not in (list, tuple):
                self.fail("UnsupportedHostType", detail="host sequence items must be an array")
            snapshot = tuple(items)
            if len(snapshot) > self.budget.max_sequence_items:
                self.fail("ExcessiveContainerCount", category=RESOURCE_REFUSAL)
            if host_type == "list" and node.get("tail") is not None:
                self.fail("ImproperHostList")
            return Sequence(tuple(self.import_node(item, depth + 1) for item in snapshot))
        if host_type == "unit":
            return _UNIT
        if host_type == "boolean":
            value = node.get("value")
            if type(value) is not bool:
                self.fail("UnsupportedHostType")
            return Boolean(value)
        if host_type == "integer":
            source = node.get("value")
            if type(source) is not str or not _DECIMAL_RE.fullmatch(source):
                self.fail("UnsupportedHostType")
            value = int(source)
            if abs(value).bit_length() > self.budget.max_integer_bits:
                self.fail("IntegerBudgetExceeded", category=RESOURCE_REFUSAL)
            return Integer(value)
        if host_type == "string":
            value = node.get("value")
            try:
                result = String(value)
            except CD0Failure as exc:
                if exc.code == "InvalidHostUnicode":
                    self.fail("InvalidHostUnicode")
                raise
            self.add_payload(len(result.value.encode("utf-8")), self.budget.max_single_string_octets)
            return result
        if host_type == "bytes":
            source = node.get("hex")
            if type(source) is not str or not _HEX_RE.fullmatch(source):
                self.fail("UnsupportedHostType")
            payload = bytes.fromhex(source)
            self.add_payload(len(payload), self.budget.max_single_bytes_octets)
            return ByteString(payload)
        self.fail("UnsupportedHostType", detail=f"unsupported host_type {host_type!r}")


def import_host_descriptor(host_input: Any, importer: str, budget: ResourceBudget) -> Datum:
    """Run one explicitly named importer over a shared hostile-host descriptor."""

    if type(budget) is not ResourceBudget or type(importer) is not str or type(host_input) is not dict:
        raise _constructor_failure("UnsupportedHostType", "invalid host descriptor invocation")
    if importer == "generic-sequence-import/v0":
        return _HostDescriptorImporter(host_input, budget).import_root(host_input.get("root"))
    if importer == "strict-integer-import/v0":
        if host_input.get("host_type") == "python-bool" and host_input.get("requested_cd0_type") == "integer":
            # The bool/int refusal is normative; A2 leaves the exact code
            # provisional.  This seed's local constructor code is retained.
            return integer(host_input.get("value"))
        raise _constructor_failure("UnsupportedHostType", "strict integer descriptor not mapped")
    if importer == "symbol-to-identifier/v0":
        if host_input.get("stable_mapping") is None or host_input.get("interned") is False:
            raise CD0Failure(
                UNSUPPORTED_HOST,
                "AmbiguousIdentifier",
                "host-import",
                budget_id=budget.identifier,
            )
        raise _constructor_failure("UnsupportedHostType", "symbol mapping descriptor not supported")
    if importer == "core-datum-import/v0":
        if host_input.get("host_type") in {
            "live-capability",
            "live-warrant",
            "authenticated-claim",
            "active-receipt",
        }:
            raise CD0Failure(
                PRIVILEGED_ATTEMPT,
                "PrivilegedHostValue",
                "host-import",
                budget_id=budget.identifier,
            )
        raise _constructor_failure("UnsupportedHostType", "core host descriptor not mapped")
    raise _constructor_failure("UnsupportedHostType", "unknown importer")


def to_fixture_ast(value: Datum) -> dict[str, Any]:
    """Return a new mutable JSON-compatible AST copy for an immutable datum."""

    if not _is_datum(value):
        raise _constructor_failure("UnsupportedHostType", "to_fixture_ast accepts only runtime datums")
    if type(value) is Unit:
        return {"t": "unit"}
    if type(value) is Boolean:
        return {"t": "bool", "v": value.value}
    if type(value) is Integer:
        return {"t": "int", "v": str(value.value)}
    if type(value) is Rational:
        return {"t": "rat", "p": str(value.numerator), "q": str(value.denominator)}
    if type(value) is String:
        return {"t": "string", "utf8_hex": value.value.encode("utf-8").hex()}
    if type(value) is ByteString:
        return {"t": "bytes", "hex": value.value.hex()}
    if type(value) is Identifier:
        return {
            "t": "id",
            "namespace_utf8_hex": [segment.encode("utf-8").hex() for segment in value.namespace],
            "path_utf8_hex": [segment.encode("utf-8").hex() for segment in value.path],
        }
    if type(value) is Sequence:
        return {"t": "seq", "items": [to_fixture_ast(item) for item in value.items]}
    if type(value) is Record:
        return {
            "t": "record",
            "fields": [
                {"key": to_fixture_ast(key), "value": to_fixture_ast(field_value)}
                for key, field_value in value.fields
            ],
        }
    raise CD0Failure(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")


def _render_string(value: str) -> str:
    result: list[str] = ['"']
    for character in value:
        scalar = ord(character)
        if character == '"':
            result.append('\\"')
        elif character == "\\":
            result.append("\\\\")
        elif character == "\n":
            result.append("\\n")
        elif character == "\r":
            result.append("\\r")
        elif character == "\t":
            result.append("\\t")
        elif 0x20 <= scalar <= 0x7E:
            result.append(character)
        else:
            result.append(f"\\u{{{scalar:x}}}")
    result.append('"')
    return "".join(result)


def diagnostic_render(value: Datum) -> str:
    """Render preferred diagnostic text; it has no identity authority."""

    if not _is_datum(value):
        raise _constructor_failure("UnsupportedHostType", "diagnostic_render accepts only runtime datums")
    if type(value) is Unit:
        return "unit"
    if type(value) is Boolean:
        return "true" if value.value else "false"
    if type(value) is Integer:
        return str(value.value)
    if type(value) is Rational:
        return f"rat({value.numerator},{value.denominator})"
    if type(value) is String:
        return _render_string(value.value)
    if type(value) is ByteString:
        return f'hex"{value.value.hex()}"'
    if type(value) is Identifier:
        namespace = ",".join(_render_string(segment) for segment in value.namespace)
        path = ",".join(_render_string(segment) for segment in value.path)
        return f"id(ns=[{namespace}],path=[{path}])"
    if type(value) is Sequence:
        return "[" + ",".join(diagnostic_render(item) for item in value.items) + "]"
    if type(value) is Record:
        contents = ",".join(
            f"{diagnostic_render(key)}=>{diagnostic_render(field_value)}"
            for key, field_value in value.fields
        )
        return f"record{{{contents}}}"
    raise CD0Failure(INTERNAL_FAILURE, "EncoderInvariantFailure", "internal")


__all__ = [
    "MAGIC",
    "FORMAT_VERSION",
    "CD0Failure",
    "ResourceBudget",
    "Datum",
    "Unit",
    "Boolean",
    "Integer",
    "Rational",
    "String",
    "ByteString",
    "Identifier",
    "Sequence",
    "Record",
    "unit",
    "boolean",
    "integer",
    "rational",
    "string",
    "byte_string",
    "identifier",
    "sequence",
    "record",
    "equal_datum",
    "encode_exact",
    "decode_exact",
    "from_fixture_ast",
    "import_host_descriptor",
    "to_fixture_ast",
    "diagnostic_render",
]
