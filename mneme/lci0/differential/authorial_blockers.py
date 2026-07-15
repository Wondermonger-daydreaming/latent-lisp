"""Closed authorial-return census — now empty after LCI/0 closure.

The ten authorial closures (LCI0-AC-001 .. LCI0-AC-010), instantiated by
fixture overlay 0.2 (2026-07-14), retired every formerly blocked differential
surface: the four superseded official vectors (N012, E5-COVERAGE-INSUFFICIENT,
P024, P029), the thirty-eight relation-table companion failure paths, and the
eight ruled hostile results.  Both language forges now produce the ruled
results byte-for-byte, so the differential harness converges fully and no
authorial-return observation remains.

These names are retained as *empty* closed sets/dicts so the coordinator, the
post-convergence gate, and their tests keep one shared, diff-able declaration
that the census is closed (not silently forgotten).  The import-time
assertions below fail loudly if any nonempty blocker census reappears.
"""

from __future__ import annotations


BLOCKED_VECTOR_REQUESTS = frozenset()

BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS = frozenset()

# Formerly the smallest witnessed envelope set for hostile inputs whose complete
# result document the frozen 0.1 package did not determine.  Overlay 0.2 rules
# each of them exactly, so the candidate map is empty.
BLOCKED_HOSTILE_FAILURE_CANDIDATES: dict[str, tuple[dict[str, object], ...]] = {}

BLOCKED_HOSTILE_SUCCESS_REQUESTS = frozenset()

BLOCKED_HOSTILE_REQUESTS = frozenset(
    BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS
    | BLOCKED_HOSTILE_FAILURE_CANDIDATES.keys()
    | BLOCKED_HOSTILE_SUCCESS_REQUESTS
)

# Formerly the cross-language fields tolerated to differ while a hostile result
# awaited authorial closure.  Every ruled hostile result is now byte-identical
# across both implementations, so zero cross-difference is tolerated.
BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS: dict[str, frozenset[str]] = {}

# Closed successful-execution census for each successor adapter.  With every
# authorial closure resolved, all vector, relation, and hostile requests now
# pass; the zero-valued *_blocked keys are absent because Counter omits them.
EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS = {
    "document_passed": 1593,
    "document_requests": 1593,
    "hostile_passed": 29,
    "hostile_requests": 29,
    "relation_passed": 458,
    "relation_requests": 458,
    "vector_passed": 215,
    "vector_requests": 215,
}

EXPECTED_SUCCESSOR_REQUEST_COUNTS = {
    "baseline_requests_per_implementation": 2266,
    "hostile_requests_per_implementation": 29,
    "magic_registry_values": 1133,
    "magic_vector_values": 460,
    "official_documents": 1105,
    "relation_semantic_requests": 458,
    "supplementary_documents": 488,
    "supplementary_nested_e1_documents": 30,
    "supplementary_relation_documents": 458,
    "total_documents": 1593,
    "total_requests_per_implementation": 2295,
    "vector_semantic_requests": 215,
}

# Formerly the 24 cross-calculus scope orientations and 14 symbolic-right
# temporal orientations whose companion failure path was underdetermined.  The
# ruled paths (right/calculus and right/expression/form) are now produced and
# oracle-checked, so no relation path remains blocked.
BLOCKED_RELATION_PATH_REQUESTS = frozenset()


if len(BLOCKED_VECTOR_REQUESTS) != 0:  # import-time closed-census assertion
    raise RuntimeError("authorial vector blocker census drift")
if len(BLOCKED_HOSTILE_REQUESTS) != 0:
    raise RuntimeError("authorial hostile blocker census drift")
if set(BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS) != BLOCKED_HOSTILE_REQUESTS:
    raise RuntimeError("authorial hostile cross-field census drift")
if len(BLOCKED_RELATION_PATH_REQUESTS) != 0:
    raise RuntimeError("authorial relation-path blocker census drift")
if sum(EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS.values()) != 4590:
    raise RuntimeError("successor implementation count census drift")
