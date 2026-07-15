"""Closed expected-free differential protocol metadata for the Python successor."""

from __future__ import annotations

from typing import Any


PROTOCOL = "lisp-plus-lci0-differential/v1"
FIXTURE_PROFILE_VERSION = "0.1.0"
PYTHON_SEED_COMMIT = "4ec2e519d05aeacd2412cb8aedc5f76bde702571"
PYTHON_SEED_TREE = "9f7915b460f449976a5d7fa856861ad5ce1d36ca"

BUDGET = {
    "cd0_budget_id": "lci0-first-implementation-cd0",
    "lci_budget_fixture_id": "resource-budget.lci-first-implementation.0",
    "lci_budget_canonical_sha256": (
        "b574f188fbc24c99018a8095fb9846511f582136c416b5f4cd685ba67ee16c93"
    ),
}

REQUEST_FIELDS = frozenset(
    {
        "protocol",
        "request_id",
        "operation",
        "fixture_profile_version",
        "input_canonical_hex",
        "budget",
    }
)


class ProtocolError(ValueError):
    """Closed runner-protocol failure; never a normative LCI failure."""

    def __init__(self, code: str, path: tuple[str, ...] = ()) -> None:
        self.code = code
        self.path = path
        super().__init__(code)


def validate_request(value: Any) -> dict[str, Any]:
    if type(value) is not dict or set(value) != REQUEST_FIELDS:
        raise ProtocolError("InvalidDifferentialRequest")
    if value["protocol"] != PROTOCOL:
        raise ProtocolError("UnsupportedDifferentialProtocol", ("protocol",))
    if type(value["request_id"]) is not str or not value["request_id"]:
        raise ProtocolError("InvalidDifferentialRequestId", ("request_id",))
    if type(value["operation"]) is not str or not value["operation"]:
        raise ProtocolError("InvalidDifferentialOperation", ("operation",))
    if value["fixture_profile_version"] != FIXTURE_PROFILE_VERSION:
        raise ProtocolError("UnsupportedFixtureProfile", ("fixture_profile_version",))
    encoded = value["input_canonical_hex"]
    if (
        type(encoded) is not str
        or len(encoded) % 2
        or encoded != encoded.lower()
        or any(character not in "0123456789abcdef" for character in encoded)
    ):
        raise ProtocolError("InvalidCanonicalHex", ("input_canonical_hex",))
    if value["budget"] != BUDGET:
        raise ProtocolError("UnpinnedDifferentialBudget", ("budget",))
    return value


def request(request_id: str, operation: str, input_canonical_hex: str) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request_id,
        "operation": operation,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "input_canonical_hex": input_canonical_hex,
        "budget": dict(BUDGET),
    }
