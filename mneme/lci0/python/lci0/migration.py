"""Bounded, non-evaluating v1 fixture parser and inert migration mapping.

This module recognizes only the frozen fixture grammar and tables.  It never
loads legacy code, interns a package symbol, consults a v1 registry, or creates
live authority.
"""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache

import cd0

from .core import (
    FIXTURE,
    FIXTURE_FIELD,
    LCI,
    LCI_RESOURCE_LIMITS,
    MNEME_PROPOSITION_ARGUMENT,
    MNEME_PROPOSITION_FIELD,
    TAG,
    _closed,
    _integer_zero,
    _reject_unknown,
    _require_kind,
    _resource_failure,
    canonical_bytes,
    field_by_path,
    ident,
    operation_resource_guard,
    project_claim_id,
    record_field,
    validate_basis,
    validate_frame,
    validate_represented_loss,
    validate_scope,
    validate_stable_ref,
)
from .model import LCIFailure, scalar
from .package import fixture_datum


LEGACY_GRAMMAR_OBJECT = ("object", "artifact", "legacy-grammar", "v1-fixture", "0")

PACKAGE_SYMBOL_MAP = {
    ("MNEME", "FILE-EXISTS", "proposition-form"): ("proposition-form", "file-exists"),
    ("MNEME", "EQUALS", "proposition-form"): ("proposition-form", "exact-equality"),
    ("MNEME", "CALL-RESULT-EQUALS", "proposition-form"): ("proposition-form", "call-result-equality"),
    ("MNEME", "ALL", "proposition-form"): ("proposition-form", "universal-property-over-scope"),
    ("MNEME", "EXISTS", "proposition-form"): ("proposition-form", "existential-property"),
    ("MNEME", "AVERAGE", "proposition-form"): ("proposition-form", "average-statistical-value"),
    ("MNEME", "BOUNDED-ABSENCE", "proposition-form"): ("proposition-form", "bounded-corpus-absence"),
    ("MNEME", "SAYS", "proposition-form"): ("proposition-form", "artifact-contains-says"),
    ("MNEME", "RETURNED", "proposition-form"): ("proposition-form", "producer-returned-value"),
    ("MNEME", "UNIVERSAL", "scope-form"): ("scope-form", "universal"),
    ("MNEME", "TENANT", "scope-form"): ("scope-form", "tenant"),
    ("MNEME", "SELF-DESCRIBING", "frame-form"): ("frame-variant", "self-describing"),
}

AS_OF_ROLE_MAP = {
    "claim": "subject-time",
    "observation": "observation-time",
    "execution": "execution-time",
    "attestation": "issue-time",
    "completion": "semantic-boundary-log-horizon",
    "standing-query": "query-time",
    "judgment": None,
}


@lru_cache(maxsize=1)
def _registry_package_symbol_map() -> dict[tuple[str, str, str], tuple[str, ...]]:
    rows = fixture_datum("migration.package-symbol-map.0")
    if type(rows) is not cd0.Sequence or len(rows.items) != 12:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    result: dict[tuple[str, str, str], tuple[str, ...]] = {}
    for index, row in enumerate(rows.items):
        fields = _field_map(
            row,
            ("source-package", "source-symbol", "semantic-role", "destination-identifier"),
            "migration-mapping",
            (str(index),),
        )
        source_package = fields["source-package"]
        source_symbol = fields["source-symbol"]
        role = fields["semantic-role"]
        destination = fields["destination-identifier"]
        if (
            type(source_package) is not cd0.String
            or type(source_symbol) is not cd0.String
            or type(role) is not cd0.Identifier
            or role.namespace != FIXTURE
            or role.path[:1] != ("mapping-semantic-role",)
            or len(role.path) != 2
            or type(destination) is not cd0.Identifier
            or destination.namespace != FIXTURE
        ):
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
        _reject_unknown(
            row,
            ("source-package", "source-symbol", "semantic-role", "destination-identifier"),
            stage="migration-mapping",
            prefix=(str(index),),
            namespace=FIXTURE_FIELD,
        )
        key = (source_package.value, source_symbol.value, role.path[1])
        if key in result:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
        result[key] = destination.path
    if result != PACKAGE_SYMBOL_MAP:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    return result


@lru_cache(maxsize=1)
def _registry_as_of_role_map() -> dict[str, str | None]:
    rows = fixture_datum("migration.as-of-role-map.0")
    if type(rows) is not cd0.Sequence or len(rows.items) != 7:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    result: dict[str, str | None] = {}
    for index, row in enumerate(rows.items):
        fields = _field_map(
            row,
            ("source-record", "source-field", "destination-role", "classification"),
            "migration-mapping",
            (str(index),),
        )
        source_record = fields["source-record"]
        source_field = fields["source-field"]
        role = fields["destination-role"]
        classification = fields["classification"]
        if (
            type(source_record) is not cd0.Identifier
            or source_record.namespace != FIXTURE
            or len(source_record.path) != 2
            or source_record.path[0] != "legacy-source-record"
            or type(source_field) is not cd0.String
            or source_field.value != "as-of"
            or type(role) is not cd0.Identifier
            or role.namespace != FIXTURE
            or len(role.path) != 2
            or role.path[0] != "temporal-role"
            or type(classification) is not cd0.Identifier
            or classification.namespace != FIXTURE
            or len(classification.path) != 2
            or classification.path[0] != "temporal-role-class"
        ):
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
        _reject_unknown(
            row,
            ("source-record", "source-field", "destination-role", "classification"),
            stage="migration-mapping",
            prefix=(str(index),),
            namespace=FIXTURE_FIELD,
        )
        exact = classification.path[1] == "exact"
        ambiguous = classification.path[1] == "ambiguous-refuse" and role.path[1] == "unclassified"
        if not exact and not ambiguous:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
        result[source_record.path[1]] = role.path[1] if exact else None
    if result != AS_OF_ROLE_MAP:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    return result


def _ff(name: str) -> str:
    return f"fixture-field:{name}"


def _migration_failure(
    code: str,
    stage: str,
    path: tuple[str, ...],
    *,
    category: str = "migration-refusal",
) -> LCIFailure:
    return LCIFailure(category, code, stage, path)


def _field_map(value: cd0.Datum, allowed: tuple[str, ...], stage: str, path: tuple[str, ...]) -> dict[str, cd0.Datum]:
    _closed(value, allowed, stage=stage, prefix=path, namespace=FIXTURE_FIELD, check_unknown=False)
    return {
        key.path[0]: item
        for key, item in value.fields
        if key.namespace == FIXTURE_FIELD and len(key.path) == 1
    }


def _stable_object_id(value: cd0.Datum, domain: str, path: tuple[str, ...]) -> tuple[str, ...]:
    validate_stable_ref(value, path=path)
    domain_value = field_by_path(value, "domain")
    if domain_value.namespace != FIXTURE or domain_value.path != ("domain", domain):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", path)
    object_id = field_by_path(field_by_path(value, "material"), "object-id")
    return object_id.path


@dataclass(frozen=True, slots=True)
class LegacySymbol:
    text: str


@dataclass(frozen=True, slots=True)
class LegacyString:
    text: str


LegacyNode = int | LegacySymbol | LegacyString | list["LegacyNode"]


class _LegacyParser:
    def __init__(self, source: bytes):
        if len(source) > LCI_RESOURCE_LIMITS["migration-input-octets"]:
            _resource_failure("migration-input-octets", "migration", (_ff("source-bytes"),))
        try:
            self.text = source.decode("utf-8", "strict")
        except UnicodeDecodeError as exc:
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),)) from exc
        self.index = 0
        self.nodes = 0

    def _refuse(self) -> None:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))

    def _skip_space(self) -> None:
        while self.index < len(self.text) and self.text[self.index] in " \t\r\n":
            self.index += 1

    def _count(self) -> None:
        self.nodes += 1
        if self.nodes > 4096:
            _resource_failure("node-count", "migration", (_ff("source-bytes"),))

    def parse(self) -> list[LegacyNode]:
        self._skip_space()
        result = self._form(1)
        self._skip_space()
        if self.index != len(self.text) or not isinstance(result, list):
            self._refuse()
        return result

    def _form(self, depth: int) -> LegacyNode:
        if depth > 32 or self.index >= len(self.text):
            self._refuse()
        char = self.text[self.index]
        if char in "#'`,;|":
            self._refuse()
        if char == "(":
            self.index += 1
            self._count()
            result: list[LegacyNode] = []
            while True:
                self._skip_space()
                if self.index >= len(self.text):
                    self._refuse()
                if self.text[self.index] == ")":
                    self.index += 1
                    return result
                if self.text[self.index] == "." and (
                    self.index + 1 == len(self.text)
                    or self.text[self.index + 1] in " \t\r\n)"
                ):
                    self._refuse()
                result.append(self._form(depth + 1))
        if char == ")":
            self._refuse()
        if char == '"':
            return self._string()
        return self._atom()

    def _string(self) -> LegacyString:
        self.index += 1
        result: list[str] = []
        while self.index < len(self.text):
            char = self.text[self.index]
            self.index += 1
            if char == '"':
                text = "".join(result)
                if len(text.encode("utf-8")) > 4096:
                    self._refuse()
                self._count()
                return LegacyString(text)
            if char == "\\":
                if self.index >= len(self.text) or self.text[self.index] not in {'"', "\\"}:
                    self._refuse()
                char = self.text[self.index]
                self.index += 1
            if ord(char) < 0x20 and char not in "\t\r\n":
                self._refuse()
            result.append(char)
        self._refuse()
        raise AssertionError("unreachable")

    def _atom(self) -> int | LegacySymbol:
        start = self.index
        while self.index < len(self.text) and self.text[self.index] not in " \t\r\n()":
            if self.text[self.index] in "#'`,;|\"":
                self._refuse()
            self.index += 1
        token = self.text[start:self.index]
        if not token or len(token.encode("utf-8")) > 128:
            self._refuse()
        self._count()
        negative = token.startswith("-")
        digits = token[1:] if negative else token
        if digits and all("0" <= char <= "9" for char in digits):
            if (len(digits) > 1 and digits.startswith("0")) or token == "-0":
                self._refuse()
            return int(token)
        if token == "." or token.count("::") > 1 or (":" in token and not token.startswith(":") and "::" not in token):
            self._refuse()
        return LegacySymbol(token)


def parse_legacy_bytes(source: bytes) -> list[LegacyNode]:
    """Parse exactly one bounded proper-list fixture form and EOF."""

    return _LegacyParser(source).parse()


def _symbol(value: LegacyNode, expected: str | None = None) -> str:
    if not isinstance(value, LegacySymbol) or (expected is not None and value.text != expected):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    return value.text


def _string(value: LegacyNode) -> str:
    if not isinstance(value, LegacyString):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    return value.text


def _legacy_form_fields(form: list[LegacyNode]) -> tuple[str, dict[str, LegacyNode]]:
    if not form:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    head = _symbol(form[0])
    if head not in {"legacy-claim", "legacy-judgment"} or len(form) % 2 != 1:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    allowed = {
        ":op",
        ":mapping-candidate",
        ":arg",
        ":fingerprint",
        ":as-of",
        ":scope",
        ":corpus",
        ":frame",
        ":warrants",
        ":restore-live",
    }
    result: dict[str, LegacyNode] = {}
    for index in range(1, len(form), 2):
        name = _symbol(form[index])
        if name not in allowed or name in result:
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
        result[name] = form[index + 1]
    required = {":op", ":arg", ":fingerprint", ":as-of", ":scope", ":corpus", ":frame"}
    if not required.issubset(result):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    return head, result


def _package_symbol(value: LegacyNode) -> tuple[str, str]:
    token = _symbol(value)
    pieces = token.split("::")
    if len(pieces) != 2 or not pieces[0] or not pieces[1]:
        raise _migration_failure("AmbiguousIdentifier", "migration-mapping", (_ff("parsed-inert-value"), _ff("proposition"), _ff("operator")))
    return pieces[0], pieces[1]


def _validate_wrapper(source: cd0.Datum, *, allow_failed_parse: bool = False) -> tuple[dict[str, cd0.Datum], bytes]:
    common = (
        "kind",
        "schema-version",
        "source-artifact",
        "source-bytes",
        "grammar",
        "parse-expected",
    )
    allowed = common + (("expected-parser-code",) if allow_failed_parse else ("parsed-inert-value",))
    _closed(
        source,
        allowed,
        stage="migration-source",
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    fields = {
        key.path[0]: item
        for key, item in source.fields
        if key.namespace == FIXTURE_FIELD and len(key.path) == 1
    }
    _require_kind(source, "legacy-source-fixture", "UnsupportedLegacyForm", "migration-source", (), namespace=FIXTURE)
    _integer_zero(fields["schema-version"], "UnsupportedLegacyForm", "migration-source", (_ff("schema-version"),))
    _stable_object_id(fields["source-artifact"], "artifact", (_ff("source-artifact"),))
    source_bytes = fields["source-bytes"]
    if type(source_bytes) is not cd0.ByteString:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    grammar_id = _stable_object_id(fields["grammar"], "artifact", (_ff("grammar"),))
    grammar_version = field_by_path(field_by_path(fields["grammar"], "material"), "object-version")
    if grammar_id != LEGACY_GRAMMAR_OBJECT or type(grammar_version) is not cd0.Integer or grammar_version.value != 0:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("grammar"),))
    parse_expected = fields["parse-expected"]
    if type(parse_expected) is not cd0.Boolean or parse_expected.value is allow_failed_parse:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parse-expected"),))
    if allow_failed_parse:
        parser_code = fields["expected-parser-code"]
        if (
            type(parser_code) is not cd0.Identifier
            or parser_code.namespace != ("lisp-plus", "lci", "0", "failure")
            or parser_code.path != ("UnsupportedLegacyForm",)
        ):
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("expected-parser-code"),))
    else:
        _validate_inert(fields["parsed-inert-value"])
    _reject_unknown(
        source,
        allowed,
        stage="migration-source",
        namespace=FIXTURE_FIELD,
    )
    return fields, source_bytes.value


def _validate_inert(inert: cd0.Datum) -> dict[str, cd0.Datum]:
    allowed = (
        "kind",
        "schema-version",
        "fixture-name",
        "source-record-site",
        "proposition",
        "fingerprint",
        "as-of",
        "scope-token",
        "corpus-token",
        "frame-token",
        "predecessor-warrants",
        "attempt-live-restoration",
        "mapping-candidate",
    )
    # Frame is deliberately checked after package/symbol and as-of mapping so
    # N027 retains its exact IdentityBearingLoss classification.
    required = tuple(name for name in allowed if name not in {"frame-token", "mapping-candidate"})
    _closed(
        inert,
        allowed,
        required=required,
        stage="migration-source",
        prefix=(_ff("parsed-inert-value"),),
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    fields = {
        key.path[0]: item
        for key, item in inert.fields
        if key.namespace == FIXTURE_FIELD and len(key.path) == 1
    }
    kind = fields["kind"]
    if type(kind) is not cd0.Identifier or kind.namespace != FIXTURE or kind.path != ("legacy-tag", "v1-claim-record"):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("kind")))
    version = fields["schema-version"]
    if type(version) is not cd0.Integer or version.value != 1:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("schema-version")))
    if type(fields["fixture-name"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("fixture-name")))
    source_site = fields["source-record-site"]
    if (
        type(source_site) is not cd0.Identifier
        or source_site.namespace != FIXTURE
        or len(source_site.path) != 2
        or source_site.path[0] != "legacy-source-record"
    ):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("source-record-site")))
    proposition = fields["proposition"]
    proposition_path = (_ff("parsed-inert-value"), _ff("proposition"))
    proposition_fields = _field_map(
        proposition,
        ("operator", "arguments"),
        "migration-source",
        proposition_path,
    )
    operator = proposition_fields["operator"]
    operator_path = proposition_path + (_ff("operator"),)
    operator_fields = _field_map(
        operator,
        ("kind", "package", "symbol"),
        "migration-source",
        operator_path,
    )
    operator_kind = operator_fields["kind"]
    if type(operator_kind) is not cd0.Identifier or operator_kind.namespace != FIXTURE or operator_kind.path != ("legacy-tag", "package-qualified-symbol"):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", operator_path + (_ff("kind"),))
    if type(operator_fields["package"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", operator_path + (_ff("package"),))
    if type(operator_fields["symbol"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", operator_path + (_ff("symbol"),))
    _reject_unknown(operator, ("kind", "package", "symbol"), stage="migration-source", prefix=operator_path, namespace=FIXTURE_FIELD)
    arguments = proposition_fields["arguments"]
    if type(arguments) is not cd0.Sequence or len(arguments.items) != 1 or type(arguments.items[0]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", proposition_path + (_ff("arguments"),))
    _reject_unknown(proposition, ("operator", "arguments"), stage="migration-source", prefix=proposition_path, namespace=FIXTURE_FIELD)
    if type(fields["fingerprint"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("fingerprint")))
    if type(fields["as-of"]) is not cd0.Integer:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("as-of")))
    scope = fields["scope-token"]
    if (
        type(scope) is not cd0.Identifier
        or scope.namespace != FIXTURE
        or len(scope.path) != 2
        or scope.path[0] != "legacy-scope-token"
    ):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("scope-token")))
    corpus = fields["corpus-token"]
    corpus_path = (_ff("parsed-inert-value"), _ff("corpus-token"))
    corpus_fields = _field_map(
        corpus,
        ("name", "revision"),
        "migration-source",
        corpus_path,
    )
    if type(corpus_fields["name"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", corpus_path + (_ff("name"),))
    if type(corpus_fields["revision"]) is not cd0.Integer or corpus_fields["revision"].value < 0:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", corpus_path + (_ff("revision"),))
    _reject_unknown(corpus, ("name", "revision"), stage="migration-source", prefix=corpus_path, namespace=FIXTURE_FIELD)
    if "frame-token" in fields and type(fields["frame-token"]) is not cd0.String:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("frame-token")))
    predecessors = fields["predecessor-warrants"]
    if type(predecessors) is not cd0.Sequence:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("predecessor-warrants")))
    for index, predecessor in enumerate(predecessors.items):
        predecessor_path = (_ff("parsed-inert-value"), _ff("predecessor-warrants"), str(index))
        object_id = _stable_object_id(predecessor, "artifact", predecessor_path)
        if object_id != ("object", "artifact", "warrant-testimony", "inert-predecessor"):
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", predecessor_path)
    if type(fields["attempt-live-restoration"]) is not cd0.Boolean:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("attempt-live-restoration")))
    if "mapping-candidate" in fields:
        mapping = fields["mapping-candidate"]
        if (
            type(mapping) is not cd0.Identifier
            or mapping.namespace != FIXTURE
            or len(mapping.path) != 2
            or mapping.path[0] != "proposition-form"
        ):
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("mapping-candidate")))
    _reject_unknown(
        inert,
        allowed,
        stage="migration-source",
        prefix=(_ff("parsed-inert-value"),),
        namespace=FIXTURE_FIELD,
    )
    return fields


def _cohere_parsed(form: list[LegacyNode], fields: dict[str, cd0.Datum]) -> None:
    head, parsed = _legacy_form_fields(form)
    source_site = fields["source-record-site"]
    expected_site = "claim" if head == "legacy-claim" else "judgment"
    if type(source_site) is not cd0.Identifier or source_site.namespace != FIXTURE or source_site.path != ("legacy-source-record", expected_site):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("source-record-site")))
    package_name, symbol_name = _package_symbol(parsed[":op"])
    operator = field_by_path(fields["proposition"], "operator")
    if scalar(field_by_path(operator, "package")) != package_name or scalar(field_by_path(operator, "symbol")) != symbol_name:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("proposition"), _ff("operator")))
    argument = field_by_path(fields["proposition"], "arguments").items[0]
    if argument.value != _string(parsed[":arg"]):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("proposition"), _ff("arguments")))
    # The old fingerprint is inert predecessor metadata, not a reconstructed
    # identity coordinate.  The fixture intentionally supplies collisions and
    # does not require the parsed display fingerprint to equal that metadata.
    _string(parsed[":fingerprint"])
    if type(parsed[":as-of"]) is not int or fields["as-of"].value != parsed[":as-of"]:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("as-of")))
    scope_name = _symbol(parsed[":scope"])
    scope = fields["scope-token"]
    if type(scope) is not cd0.Identifier or scope.namespace != FIXTURE or scope.path != ("legacy-scope-token", scope_name):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("scope-token")))
    corpus_form = parsed[":corpus"]
    corpus = fields["corpus-token"]
    if not isinstance(corpus_form, list) or len(corpus_form) != 2:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    if field_by_path(corpus, "name").value != _symbol(corpus_form[0]) or type(corpus_form[1]) is not int or field_by_path(corpus, "revision").value != corpus_form[1]:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("corpus-token")))
    if "frame-token" not in fields:
        return
    if type(fields["frame-token"]) is not cd0.String or fields["frame-token"].value != _symbol(parsed[":frame"]):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("frame-token")))
    mapping = parsed.get(":mapping-candidate")
    declared_mapping = fields.get("mapping-candidate")
    if (mapping is None) != (declared_mapping is None) or (
        mapping is not None
        and (
            type(declared_mapping) is not cd0.Identifier
            or declared_mapping.namespace != FIXTURE
            or declared_mapping.path != ("proposition-form", _symbol(mapping))
        )
    ):
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("mapping-candidate")))
    warrants = parsed.get(":warrants")
    expected_warrant_count = len(fields["predecessor-warrants"].items)
    if warrants is None:
        actual_warrant_count = 0
    elif isinstance(warrants, list) and all(isinstance(item, LegacySymbol) for item in warrants):
        actual_warrant_count = len(warrants)
        if actual_warrant_count != 1 or _symbol(warrants[0]) != "inert-warrant-1":
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    else:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    if actual_warrant_count != expected_warrant_count:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("predecessor-warrants")))
    restore = parsed.get(":restore-live")
    restore_value = False if restore is None else _symbol(restore) == "t"
    if restore is not None and _symbol(restore) != "t":
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    if fields["attempt-live-restoration"].value != restore_value:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("parsed-inert-value"), _ff("attempt-live-restoration")))


def _stable_ref(domain: str, *object_tail: str, object_version: int = 0) -> cd0.Record:
    material = cd0.record(
        (
            record_field(FIXTURE_FIELD, "kind", ident(FIXTURE, "tag", "fixture-stable-material")),
            record_field(FIXTURE_FIELD, "schema-version", cd0.integer(0)),
            record_field(FIXTURE_FIELD, "object-id", ident(FIXTURE, "object", domain, *object_tail)),
            record_field(FIXTURE_FIELD, "object-version", cd0.integer(object_version)),
        )
    )
    result = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "stable-reference")),
            record_field(LCI, "domain", ident(FIXTURE, "domain", domain)),
            record_field(LCI, "scheme", ident(FIXTURE, "scheme", domain, "structural", "0")),
            record_field(LCI, "material", material),
        )
    )
    validate_stable_ref(result)
    return result


@lru_cache(maxsize=1)
def _scope_reconstruction_map() -> dict[str, cd0.Datum]:
    rows = fixture_datum("migration.scope-map.0")
    if type(rows) is not cd0.Sequence:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    result: dict[str, cd0.Datum] = {}
    for index, row in enumerate(rows.items):
        path = (str(index),)
        values = _field_map(row, ("legacy-form", "scope"), "migration-mapping", path)
        legacy_form, scope = values["legacy-form"], values["scope"]
        if type(legacy_form) is not cd0.String:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping", path)
        validate_scope(scope, path=path + ("scope",))
        _reject_unknown(row, ("legacy-form", "scope"), stage="migration-mapping", prefix=path, namespace=FIXTURE_FIELD)
        if legacy_form.value in result:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping", path)
        result[legacy_form.value] = scope
    if set(result) != {
        "MNEME::UNIVERSAL",
        '(MNEME::TENANT "a")',
        '(MNEME::TENANT "b")',
        '(MNEME::DEPARTMENT "research")',
    }:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    return result


@lru_cache(maxsize=1)
def _corpus_frame_reconstruction_maps() -> tuple[dict[tuple[str, int], cd0.Datum], dict[str, cd0.Datum]]:
    rules = fixture_datum("migration.corpus-frame-reconstruction-rules.0")
    allowed = ("kind", "schema-version", "corpus-rules", "frame-rules", "missing-corpus-behavior", "missing-frame-behavior", "mutable-revision-alias-behavior")
    values = _field_map(rules, allowed, "migration-mapping", ())
    _require_kind(rules, "migration-reconstruction-rules", "FixtureRegistryMismatch", "migration-mapping", (), namespace=FIXTURE)
    _integer_zero(values["schema-version"], "FixtureRegistryMismatch", "migration-mapping", ("schema-version",))
    corpus_rows, frame_rows = values["corpus-rules"], values["frame-rules"]
    if type(corpus_rows) is not cd0.Sequence or type(frame_rows) is not cd0.Sequence:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    corpus_map: dict[tuple[str, int], cd0.Datum] = {}
    for index, row in enumerate(corpus_rows.items):
        path = ("corpus-rules", str(index))
        fields = _field_map(row, ("source-corpus", "source-revision", "basis"), "migration-mapping", path)
        source_corpus, source_revision, basis = fields["source-corpus"], fields["source-revision"], fields["basis"]
        if type(source_corpus) is not cd0.String or type(source_revision) is not cd0.Integer:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping", path)
        validate_basis(basis, path=path + ("basis",))
        _reject_unknown(row, ("source-corpus", "source-revision", "basis"), stage="migration-mapping", prefix=path, namespace=FIXTURE_FIELD)
        corpus_map[(source_corpus.value, source_revision.value)] = basis
    frame_map: dict[str, cd0.Datum] = {}
    for index, row in enumerate(frame_rows.items):
        path = ("frame-rules", str(index))
        fields = _field_map(row, ("source-frame", "frame"), "migration-mapping", path)
        source_frame, frame = fields["source-frame"], fields["frame"]
        if type(source_frame) is not cd0.String:
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping", path)
        validate_frame(frame, path + ("frame",))
        _reject_unknown(row, ("source-frame", "frame"), stage="migration-mapping", prefix=path, namespace=FIXTURE_FIELD)
        frame_map[source_frame.value] = frame
    _reject_unknown(rules, allowed, stage="migration-mapping", namespace=FIXTURE_FIELD)
    if set(corpus_map) != {("alpha", 3), ("alpha", 4)} or set(frame_map) != {
        "MNEME::SELF-DESCRIBING",
        "MNEME::ANIMAL-SI-V1",
    }:
        raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "migration-mapping")
    return corpus_map, frame_map


def _locator_argument(name: str, coordinate: str, role: str) -> cd0.Record:
    locator = cd0.record(
        (
            record_field(MNEME_PROPOSITION_FIELD, "kind", ident(FIXTURE, "tag", "locator-slot")),
            record_field(MNEME_PROPOSITION_FIELD, "schema-version", cd0.integer(0)),
            record_field(MNEME_PROPOSITION_FIELD, "coordinate", ident(FIXTURE, "locator-coordinate", coordinate)),
            record_field(MNEME_PROPOSITION_FIELD, "locator-role", ident(FIXTURE, "locator-role", role)),
        )
    )
    return cd0.record(
        (
            record_field(MNEME_PROPOSITION_FIELD, "kind", ident(FIXTURE, "tag", "proposition-argument")),
            record_field(MNEME_PROPOSITION_FIELD, "schema-version", cd0.integer(0)),
            record_field(MNEME_PROPOSITION_FIELD, "placement", ident(FIXTURE, "proposition-placement", "external-claim-location-locator")),
            record_field(MNEME_PROPOSITION_FIELD, "value", locator),
        )
    )


def _reconstruct_file_proposition(argument: str) -> cd0.Record:
    if argument != "alpha.txt":
        raise _migration_failure("UnsupportedLegacyForm", "migration-mapping", (_ff("parsed-inert-value"), _ff("proposition"), _ff("arguments")))
    subject = cd0.record(
        (
            record_field(MNEME_PROPOSITION_FIELD, "kind", ident(FIXTURE, "tag", "proposition-argument")),
            record_field(MNEME_PROPOSITION_FIELD, "schema-version", cd0.integer(0)),
            record_field(MNEME_PROPOSITION_FIELD, "placement", ident(FIXTURE, "proposition-placement", "proposition-subject-content")),
            record_field(MNEME_PROPOSITION_FIELD, "value", _stable_ref("artifact", "file", argument)),
        )
    )
    arguments = cd0.record(
        (
            record_field(MNEME_PROPOSITION_ARGUMENT, "artifact", subject),
            record_field(MNEME_PROPOSITION_ARGUMENT, "scope-locator", _locator_argument("scope-locator", "scope", "claim-scope")),
            record_field(MNEME_PROPOSITION_ARGUMENT, "subject-time-locator", _locator_argument("subject-time-locator", "subject-time", "proposition-subject-time")),
            record_field(MNEME_PROPOSITION_ARGUMENT, "basis-locator", _locator_argument("basis-locator", "basis", "claim-basis")),
            record_field(MNEME_PROPOSITION_ARGUMENT, "frame-locator", _locator_argument("frame-locator", "interpretation-frame", "claim-interpretation-frame")),
        )
    )
    return cd0.record(
        (
            record_field(MNEME_PROPOSITION_FIELD, "kind", ident(FIXTURE, "tag", "mneme-fixture-proposition")),
            record_field(MNEME_PROPOSITION_FIELD, "schema-version", cd0.integer(0)),
            record_field(MNEME_PROPOSITION_FIELD, "form", ident(FIXTURE, "proposition-form", "file-exists")),
            record_field(MNEME_PROPOSITION_FIELD, "arguments", arguments),
        )
    )


def _reconstruct_subject_time(tick: int) -> cd0.Record:
    expression = cd0.record(
        (
            record_field(FIXTURE_FIELD, "kind", ident(FIXTURE, "tag", "temporal-expression")),
            record_field(FIXTURE_FIELD, "schema-version", cd0.integer(0)),
            record_field(FIXTURE_FIELD, "form", ident(FIXTURE, "temporal-form", "instant")),
            record_field(FIXTURE_FIELD, "tick", cd0.integer(tick)),
        )
    )
    return cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "subject-time")),
            record_field(LCI, "schema-version", cd0.integer(0)),
            record_field(LCI, "temporal-model", _stable_ref("temporal-model", "mneme-fixture-time")),
            record_field(LCI, "expression", expression),
        )
    )


def _projection_input(proposition: cd0.Datum, location: cd0.Datum) -> cd0.Record:
    policy = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "identity-policy")),
            record_field(LCI, "policy-id", ident(("lisp-plus", "lci"), "located-claim-identity")),
            record_field(LCI, "policy-version", cd0.integer(0)),
        )
    )
    profile = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "claim-profile")),
            record_field(LCI, "profile-id", ident(("lisp-plus", "mneme"), "located-claim")),
            record_field(LCI, "profile-version", cd0.integer(0)),
        )
    )
    return cd0.record(
        (
            record_field(LCI, "identity-policy", policy),
            record_field(LCI, "claim-profile", profile),
            record_field(LCI, "proposition", proposition),
            record_field(LCI, "location", location),
        )
    )


def _inheritance_loss() -> cd0.Record:
    operation = _stable_ref("procedure", "handoff")
    predecessor = _stable_ref("artifact", "occurrence", "predecessor")
    account = cd0.record(
        (
            record_field(FIXTURE_FIELD, "kind", ident(FIXTURE, "tag", "represented-loss-account")),
            record_field(FIXTURE_FIELD, "schema-version", cd0.integer(0)),
            record_field(FIXTURE_FIELD, "account-schema", ident(FIXTURE, "represented-loss-account-schema", "handoff", "0")),
            record_field(FIXTURE_FIELD, "predecessor-occurrence", predecessor),
            record_field(FIXTURE_FIELD, "handoff-receipt", _stable_ref("artifact", "receipt", "handoff", "1")),
            record_field(FIXTURE_FIELD, "live-authority-transferred", cd0.boolean(False)),
            record_field(FIXTURE_FIELD, "custody-continuity-proven", cd0.boolean(False)),
            record_field(FIXTURE_FIELD, "successor-live-warrants", cd0.integer(0)),
            record_field(FIXTURE_FIELD, "handoff-procedure", operation),
        )
    )
    loss = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "represented-loss")),
            record_field(LCI, "schema-version", cd0.integer(0)),
            record_field(LCI, "operation", operation),
            record_field(LCI, "source", predecessor),
            record_field(
                LCI,
                "lost-dimensions",
                cd0.sequence(
                    (
                        ident(FIXTURE, "lost-dimension", "live-authority"),
                        ident(FIXTURE, "lost-dimension", "custody-continuity"),
                    )
                ),
            ),
            record_field(LCI, "consequence", ident(LCI + ("relation",), "authority-or-custody-loss")),
            record_field(LCI, "account", account),
        )
    )
    validate_represented_loss(loss)
    return loss


def validate_migration_result(value: cd0.Datum) -> cd0.Datum:
    allowed = (
        "kind",
        "schema-version",
        "source",
        "adapter",
        "classification",
        "claim",
        "claim-id",
        "lineage",
        "represented-loss",
        "legacy-testimony",
        "live-warrants-created",
    )
    _closed(value, allowed, stage="migration-result", namespace=LCI, check_unknown=False)
    _require_kind(value, "migration-result", "InvalidMigrationResult", "migration-result", ())
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "migration-result", ("schema-version",))
    source = field_by_path(value, "source")
    _stable_object_id(source, "artifact", ("source",))
    adapter = field_by_path(value, "adapter")
    if _stable_object_id(adapter, "procedure", ("adapter",)) != ("object", "procedure", "migrate-v1"):
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("adapter",), category="invalid-input")
    classification = field_by_path(value, "classification")
    if (
        type(classification) is not cd0.Identifier
        or classification.namespace != FIXTURE
        or classification.path not in {
            ("migration-classification", "exact"),
            ("migration-classification", "exact-after-explicit-tagging"),
            ("migration-classification", "new-identity-required"),
            ("migration-classification", "lossy-with-represented-loss"),
            ("migration-classification", "rejected"),
            ("migration-classification", "deferred-to-named-calculus"),
            ("migration-classification", "privileged-runtime-relation-outside-claim-id"),
        }
    ):
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("classification",), category="invalid-input")
    claim = field_by_path(value, "claim")
    claim_fields = _field_map(claim, ("proposition", "location"), "migration-result", ("claim",))
    projected = project_claim_id(_projection_input(claim_fields["proposition"], claim_fields["location"]))
    _reject_unknown(claim, ("proposition", "location"), stage="migration-result", prefix=("claim",), namespace=FIXTURE_FIELD)
    claim_id = field_by_path(value, "claim-id")
    project_claim_id(claim_id)
    lineage = field_by_path(value, "lineage")
    if type(lineage) is not cd0.Sequence:
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("lineage",), category="invalid-input")
    for index, edge in enumerate(lineage.items):
        edge_path = ("lineage", str(index))
        edge_fields = _field_map(edge, ("relation", "source"), "migration-result", edge_path)
        relation = edge_fields["relation"]
        if type(relation) is not cd0.Identifier or relation.namespace != FIXTURE or relation.path != ("lineage-relation", "migration"):
            raise _migration_failure("InvalidMigrationResult", "migration-result", edge_path + ("relation",), category="invalid-input")
        _stable_object_id(edge_fields["source"], "artifact", edge_path + ("source",))
        _reject_unknown(edge, ("relation", "source"), stage="migration-result", prefix=edge_path, namespace=FIXTURE_FIELD)
    losses = field_by_path(value, "represented-loss")
    if type(losses) is not cd0.Sequence:
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("represented-loss",), category="invalid-input")
    for index, loss in enumerate(losses.items):
        validate_represented_loss(loss, ("represented-loss", str(index)))
    if (
        classification.path
        == ("migration-classification", "privileged-runtime-relation-outside-claim-id")
        and not losses.items
    ):
        raise LCIFailure(
            "migration-refusal",
            "RepresentedLossRequired",
            "represented-loss",
            ("represented-loss",),
        )
    testimony = field_by_path(value, "legacy-testimony")
    if type(testimony) is not cd0.Sequence:
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("legacy-testimony",), category="invalid-input")
    for index, item in enumerate(testimony.items):
        item_path = ("legacy-testimony", str(index))
        item_fields = _field_map(item, ("kind", "artifact"), "migration-result", item_path)
        kind = item_fields["kind"]
        if type(kind) is not cd0.Identifier or kind.namespace != FIXTURE or kind.path != ("legacy-testimony", "predecessor-warrant"):
            raise _migration_failure("InvalidMigrationResult", "migration-result", item_path + ("kind",), category="invalid-input")
        _stable_object_id(item_fields["artifact"], "artifact", item_path + ("artifact",))
        _reject_unknown(item, ("kind", "artifact"), stage="migration-result", prefix=item_path, namespace=FIXTURE_FIELD)
    live = field_by_path(value, "live-warrants-created")
    if type(live) is not cd0.Boolean or live.value:
        raise LCIFailure("privilege-refusal", "PrivilegedRestorationAttempt", "privilege-boundary", ("live-warrants-created",))
    _reject_unknown(value, allowed, stage="migration-result", namespace=LCI)
    if canonical_bytes(claim_id) != projected.canonical_bytes:
        raise _migration_failure("ClaimIdCacheMismatch", "claim-id-cache", ("claim-id",), category="projection-refusal")
    if len(lineage.items) != 1 or canonical_bytes(field_by_path(lineage.items[0], "source")) != canonical_bytes(source):
        raise _migration_failure("InvalidMigrationResult", "migration-result", ("lineage",), category="invalid-input")
    return value


def _construct_migration_result(
    fields: dict[str, cd0.Datum],
    case: str,
    source_artifact: cd0.Datum,
) -> cd0.Datum:
    operator = field_by_path(fields["proposition"], "operator")
    argument = field_by_path(fields["proposition"], "arguments").items[0].value
    proposition = _reconstruct_file_proposition(argument)
    scope_token = fields["scope-token"].path[1]
    scope_key = f'(MNEME::TENANT "{scope_token.removeprefix("tenant-")}")'
    scope = _scope_reconstruction_map()[scope_key]
    corpus_fields = _field_map(fields["corpus-token"], ("name", "revision"), "migration-mapping", ("corpus-token",))
    corpus_key = (corpus_fields["name"].value, corpus_fields["revision"].value)
    corpus_map, frame_map = _corpus_frame_reconstruction_maps()
    basis = corpus_map[corpus_key]
    frame = frame_map[fields["frame-token"].value]
    subject_time = _reconstruct_subject_time(fields["as-of"].value)
    location = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "claim-location")),
            record_field(LCI, "scope", scope),
            record_field(LCI, "subject-time", subject_time),
            record_field(LCI, "basis", basis),
            record_field(LCI, "interpretation-frame", frame),
            record_field(LCI, "profile-location", cd0.record(())),
        )
    )
    claim = cd0.record(
        (
            record_field(FIXTURE_FIELD, "proposition", proposition),
            record_field(FIXTURE_FIELD, "location", location),
        )
    )
    claim_id = project_claim_id(_projection_input(proposition, location)).datum
    # Migration source identity is explicit wrapper evidence.  It is never
    # synthesized from the semantic case, fixture name, or reconstructed corpus.
    _stable_object_id(source_artifact, "artifact", (_ff("source-artifact"),))
    source = source_artifact
    adapter = _stable_ref("procedure", "migrate-v1")
    lineage = cd0.sequence(
        (
            cd0.record(
                (
                    record_field(FIXTURE_FIELD, "relation", ident(FIXTURE, "lineage-relation", "migration")),
                    record_field(FIXTURE_FIELD, "source", source),
                )
            ),
        )
    )
    inert_predecessor = case == "inert-predecessor"
    losses = cd0.sequence((_inheritance_loss(),)) if inert_predecessor else cd0.sequence(())
    testimony = (
        cd0.sequence(
            (
                cd0.record(
                    (
                        record_field(FIXTURE_FIELD, "kind", ident(FIXTURE, "legacy-testimony", "predecessor-warrant")),
                        record_field(FIXTURE_FIELD, "artifact", _stable_ref("artifact", "warrant-testimony", "inert-predecessor")),
                    )
                ),
            )
        )
        if inert_predecessor
        else cd0.sequence(())
    )
    classification = (
        "privileged-runtime-relation-outside-claim-id"
        if inert_predecessor
        else "exact-after-explicit-tagging"
    )
    result = cd0.record(
        (
            record_field(LCI, "kind", ident(TAG, "migration-result")),
            record_field(LCI, "schema-version", cd0.integer(0)),
            record_field(LCI, "source", source),
            record_field(LCI, "adapter", adapter),
            record_field(LCI, "classification", ident(FIXTURE, "migration-classification", classification)),
            record_field(LCI, "claim", claim),
            record_field(LCI, "claim-id", claim_id),
            record_field(LCI, "lineage", lineage),
            record_field(LCI, "represented-loss", losses),
            record_field(LCI, "legacy-testimony", testimony),
            record_field(LCI, "live-warrants-created", cd0.boolean(False)),
        )
    )
    validate_migration_result(result)
    return result


def _select_migration_result(
    fields: dict[str, cd0.Datum],
    source_artifact: cd0.Datum | None,
) -> cd0.Datum:
    operator = field_by_path(fields["proposition"], "operator")
    package_name = scalar(field_by_path(operator, "package"))
    symbol_name = scalar(field_by_path(operator, "symbol"))
    operator_path = (_ff("parsed-inert-value"), _ff("proposition"), _ff("operator"))
    if package_name != "MNEME":
        raise _migration_failure("AmbiguousIdentifier", "migration-mapping", operator_path)
    mapped = _registry_package_symbol_map().get((package_name, symbol_name, "proposition-form"))
    if mapped is None:
        if "mapping-candidate" in fields:
            raise _migration_failure(
                "SemanticIdentifierMappingMismatch",
                "migration-mapping",
                (_ff("parsed-inert-value"), _ff("mapping-candidate")),
            )
        raise _migration_failure("AmbiguousIdentifier", "migration-mapping", operator_path)
    if mapped != ("proposition-form", "file-exists"):
        raise _migration_failure("UnsupportedLegacyForm", "migration-mapping", operator_path)
    site = fields["source-record-site"]
    if type(site) is not cd0.Identifier or site.namespace != FIXTURE or len(site.path) != 2 or site.path[0] != "legacy-source-record":
        raise _migration_failure("UnclassifiedAsOf", "migration-mapping", (_ff("parsed-inert-value"), _ff("as-of")))
    role = _registry_as_of_role_map().get(site.path[1], ...)
    if role is ... or role is None:
        raise _migration_failure("UnclassifiedAsOf", "migration-mapping", (_ff("parsed-inert-value"), _ff("as-of")))
    if role != "subject-time":
        raise _migration_failure("UnsupportedLegacyForm", "migration-mapping", (_ff("parsed-inert-value"), _ff("as-of")))
    if "frame-token" not in fields:
        raise _migration_failure("IdentityBearingLoss", "represented-loss", (_ff("frame-token"),))
    frame = fields["frame-token"]
    if type(frame) is not cd0.String or frame.value != "MNEME::SELF-DESCRIBING":
        raise _migration_failure("IdentityBearingLoss", "represented-loss", (_ff("frame-token"),))
    as_of = fields["as-of"].value
    scope = fields["scope-token"]
    corpus = fields["corpus-token"]
    scope_name = scope.path if type(scope) is cd0.Identifier and scope.namespace == FIXTURE else ()
    corpus_name = scalar(field_by_path(corpus, "name"))
    corpus_revision = scalar(field_by_path(corpus, "revision"))
    if corpus_name != "alpha" or corpus_revision not in {3, 4}:
        raise _migration_failure("IdentityBearingLoss", "represented-loss", (_ff("parsed-inert-value"), _ff("corpus-token")))
    predecessors = len(fields["predecessor-warrants"].items)
    attempted = fields["attempt-live-restoration"].value
    if attempted:
        raise LCIFailure(
            "privilege-refusal",
            "PrivilegedRestorationAttempt",
            "privilege-boundary",
            (_ff("parsed-inert-value"), _ff("attempt-live-restoration")),
        )
    case: str | None = None
    if predecessors == 1 and as_of == 100 and scope_name == ("legacy-scope-token", "tenant-a") and corpus_revision == 3:
        case = "inert-predecessor"
    elif predecessors == 0 and scope_name == ("legacy-scope-token", "tenant-a") and corpus_revision == 3:
        case = {100: "time-100", 124: "time-124"}.get(as_of)
    elif predecessors == 0 and as_of == 100 and scope_name == ("legacy-scope-token", "tenant-b") and corpus_revision == 3:
        case = "scope-tenant-b"
    elif predecessors == 0 and as_of == 100 and scope_name == ("legacy-scope-token", "tenant-a") and corpus_revision == 4:
        case = "corpus-r4"
    if case is None:
        raise _migration_failure("UnsupportedLegacyForm", "migration-mapping", (_ff("parsed-inert-value"),))
    fixture_name = fields["fixture-name"].value
    expected_names = {
        "time-100": {"time-100", "printer-variation"},
        "time-124": {"time-124"},
        "scope-tenant-b": {"scope-tenant-b"},
        "corpus-r4": {"corpus-r4"},
        "inert-predecessor": {"inert-predecessor-warrant"},
    }
    if fixture_name not in expected_names[case]:
        raise _migration_failure("UnsupportedLegacyForm", "migration-mapping", (_ff("parsed-inert-value"), _ff("fixture-name")))
    if source_artifact is None:
        raise _migration_failure(
            "UnsupportedLegacyForm",
            "migration-source",
            (_ff("source-artifact"),),
        )
    return _construct_migration_result(fields, case, source_artifact)


def migrate(source: cd0.Datum) -> cd0.Datum:
    """Validate, parse, cohere, and map one frozen v1 fixture to inert LCI data."""

    if type(source) is not cd0.Record:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", ())
    names = {key.path[0] for key, _ in source.fields if key.namespace == FIXTURE_FIELD and len(key.path) == 1}
    if "parsed-inert-value" in names or "grammar" in names:
        wrapper, source_bytes = _validate_wrapper(source)
        if wrapper["parse-expected"].value is not True or "parsed-inert-value" not in wrapper:
            raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
        form = parse_legacy_bytes(source_bytes)
        inert = wrapper["parsed-inert-value"]
        fields = _validate_inert(inert)
        _cohere_parsed(form, fields)
        source_artifact = wrapper["source-artifact"]
    else:
        fields = _validate_inert(source)
        source_artifact = None
    return _select_migration_result(fields, source_artifact)


def refuse_legacy_source(source: cd0.Datum) -> None:
    """Execute the parse-only hostile fixture and return its normative refusal."""

    wrapper, source_bytes = _validate_wrapper(source, allow_failed_parse=True)
    if wrapper["parse-expected"].value is not False:
        raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))
    try:
        parse_legacy_bytes(source_bytes)
    except LCIFailure as exc:
        if exc.code == "UnsupportedLegacyForm":
            raise
        raise
    raise _migration_failure("UnsupportedLegacyForm", "migration-source", (_ff("source-bytes"),))


def legacy_inert(source: cd0.Datum) -> cd0.Datum:
    fields, _ = _validate_wrapper(source)
    return fields["parsed-inert-value"]


def migration_structural_equal(left: cd0.Datum, right: cd0.Datum) -> bool:
    return canonical_bytes(left) == canonical_bytes(right)


_migrate_semantics = migrate


def migrate(source: cd0.Datum) -> cd0.Datum:
    with operation_resource_guard(source, stage="migration"):
        return _migrate_semantics(source)


_refuse_legacy_source_semantics = refuse_legacy_source


def refuse_legacy_source(source: cd0.Datum) -> None:
    with operation_resource_guard(source, stage="migration"):
        _refuse_legacy_source_semantics(source)


_validate_migration_result_semantics = validate_migration_result


def validate_migration_result(value: cd0.Datum) -> cd0.Datum:
    with operation_resource_guard(value, stage="migration"):
        return _validate_migration_result_semantics(value)
