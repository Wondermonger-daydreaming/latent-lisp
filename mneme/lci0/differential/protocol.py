"""Closed, expected-free protocol shared by the LCI/0 integration adapters.

Expected fixture results deliberately do not appear in this module or in any
adapter request.  The integration coordinator alone owns fixture oracles.
"""

from __future__ import annotations

from typing import Any


PROTOCOL = "lisp-plus-lci0-differential/v1"
FIXTURE_PROFILE_VERSION = "0.1.0"

COMMON_LISP_SEED_COMMIT = "b3d28bc49c3b015096cb04c6ad08c19829f511a9"
COMMON_LISP_SEED_TREE = "d48c39f933cde591f3303fcd3c9f42a0dac1a869"
PYTHON_SEED_COMMIT = "4ec2e519d05aeacd2412cb8aedc5f76bde702571"
PYTHON_SEED_TREE = "9f7915b460f449976a5d7fa856861ad5ce1d36ca"

LCI_BUDGET_ID = "resource-budget.lci-first-implementation.0"
LCI_BUDGET_CANONICAL_SHA256 = (
    "b574f188fbc24c99018a8095fb9846511f582136c416b5f4cd685ba67ee16c93"
)
CD0_BUDGET_ID = "lci0-first-implementation-cd0"

BUDGET = {
    "cd0_budget_id": CD0_BUDGET_ID,
    "lci_budget_fixture_id": LCI_BUDGET_ID,
    "lci_budget_canonical_sha256": LCI_BUDGET_CANONICAL_SHA256,
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

INTEGRATION_OPERATIONS = frozenset(
    {
        "document-roundtrip",
        "scope-relation-table",
        "temporal-relation-table",
        "hostile-validate-stable-ref",
        "hostile-validate-claim-id",
        "hostile-validate-warrant-target",
        "hostile-project-claim-id",
        "hostile-match-target",
        "hostile-claim-ids-equal",
        "hostile-evaluate-policy-c",
    }
)


class ProtocolError(ValueError):
    """A closed-protocol failure, distinct from an LCI semantic failure."""

    def __init__(self, code: str, path: tuple[str, ...] = ()) -> None:
        self.code = code
        self.path = path
        super().__init__(f"{code} at {path!r}")


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


def request(
    request_id: str,
    operation: str,
    input_canonical_hex: str,
) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request_id,
        "operation": operation,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "input_canonical_hex": input_canonical_hex,
        "budget": dict(BUDGET),
    }
