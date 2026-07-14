"""Closed census of frozen LCI/0 authorial-return observations.

These identifiers are evidence classifications, not alternate expected
results.  They keep the coordinator and the post-convergence gate from
silently drifting apart while the frozen package awaits authorial closure.
"""

from __future__ import annotations


BLOCKED_VECTOR_REQUESTS = frozenset(
    {
        "vector:LCI0-N012",
        "vector:LCI0-E5-COVERAGE-INSUFFICIENT",
        "vector:LCI0-P024",
        "vector:LCI0-P029",
    }
)

BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS = frozenset(
    {"hostile:policy-c-fail-closed"}
)

# These generated hostile inputs have a pinned binary outcome or a pinned
# subset of their failure tuple, but the frozen package does not determine the
# complete result document.  The candidates below are the smallest witnessed
# envelope set; they are blocker bounds, not alternate normative expectations.
BLOCKED_HOSTILE_FAILURE_CANDIDATES = {
    "hostile:stable-ref-alias-package-symbol-spelling": (
        {
            "category": "reference-refusal",
            "code": "UnresolvedAlias",
            "stage": "stable-reference",
            "path": ["material", "fixture-field:object-id"],
        },
        {
            "category": "reference-refusal",
            "code": "MutableReference",
            "stage": "stable-reference",
            "path": ["material", "fixture-field:object-id"],
        },
    ),
    "hostile:observed-with-executed-target-schema": (
        {
            "category": "invalid-input",
            "code": "TargetSchemaKindMismatch",
            "stage": "target-schema",
            "path": ["target-schema"],
        },
        {
            "category": "invalid-input",
            "code": "TargetSchemaKindMismatch",
            "stage": "target-shape",
            "path": ["target-schema"],
        },
    ),
    "hostile:executed-with-observed-target-schema": (
        {
            "category": "invalid-input",
            "code": "TargetSchemaKindMismatch",
            "stage": "target-schema",
            "path": ["target-schema"],
        },
        {
            "category": "invalid-input",
            "code": "TargetSchemaKindMismatch",
            "stage": "target-shape",
            "path": ["target-schema"],
        },
    ),
    "hostile:target-nested-coverage-future-selector": (
        {
            "category": "invalid-input",
            "code": "UnknownField",
            "stage": "scope",
            "path": [
                "boundaries",
                "fixture-field:coverage-scope",
                "expression",
                "fixture-field:future-selector",
            ],
        },
        {
            "category": "invalid-input",
            "code": "InvalidScope",
            "stage": "scope",
            "path": [
                "boundaries",
                "fixture-field:coverage-scope",
                "expression",
            ],
        },
    ),
    "hostile:resource-stable-ref-material-5000": (
        {
            "category": "resource-refusal",
            "code": "StableReferenceMaterialBudgetExceeded",
            "stage": "validation",
            "path": ["material"],
        },
        {
            "category": "resource-refusal",
            "code": "StableReferenceMaterialBudgetExceeded",
            "stage": "validation",
            "path": [],
        },
    ),
    "hostile:migration-grammar-reference-substitution": (
        {
            "category": "migration-refusal",
            "code": "UnsupportedLegacyForm",
            "stage": "migration-source",
            "path": ["fixture-field:grammar"],
        },
        {
            "category": "reference-refusal",
            "code": "InvalidStableReference",
            "stage": "stable-reference",
            "path": [
                "fixture-field:grammar",
                "material",
                "fixture-field:object-id",
            ],
        },
    ),
}

BLOCKED_HOSTILE_SUCCESS_REQUESTS = frozenset(
    {"hostile:resource-maximum-nesting-at-limit-64"}
)

BLOCKED_HOSTILE_REQUESTS = frozenset(
    BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS
    | BLOCKED_HOSTILE_FAILURE_CANDIDATES.keys()
    | BLOCKED_HOSTILE_SUCCESS_REQUESTS
)

# Cross-language fields that may differ after each complete response has
# independently satisfied the bounded blocker validator.
BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS = {
    "hostile:stable-ref-alias-package-symbol-spelling": frozenset({"failure"}),
    "hostile:observed-with-executed-target-schema": frozenset({"failure"}),
    "hostile:executed-with-observed-target-schema": frozenset({"failure"}),
    "hostile:target-nested-coverage-future-selector": frozenset({"failure"}),
    "hostile:resource-stable-ref-material-5000": frozenset({"failure"}),
    "hostile:resource-maximum-nesting-at-limit-64": frozenset(
        {"actual_canonical_cd0_hex"}
    ),
    "hostile:migration-grammar-reference-substitution": frozenset(
        {"failure", "actual_canonical_cd0_hex"}
    ),
    "hostile:policy-c-fail-closed": frozenset(),
}

# Closed successful-execution census for each successor adapter.  Zero-valued
# failure/protocol keys are deliberately absent because Counter omits them.
EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS = {
    "document_passed": 1593,
    "document_requests": 1593,
    "hostile_blocked": 8,
    "hostile_passed": 21,
    "hostile_requests": 29,
    "relation_blocked": 38,
    "relation_passed": 420,
    "relation_requests": 458,
    "vector_blocked": 4,
    "vector_passed": 211,
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

# Exact enumeration from LCI0-DIV-014: 24 cross-calculus orientations and
# 14 symbolic-right temporal orientations.  Their relation values are pinned
# and equal; only the unpinned companion failure path remains blocked.
BLOCKED_RELATION_PATH_REQUESTS = frozenset(
    {
        "relation:scope_relation_table_0:012:scope.universal:scope.second.alpha",
        "relation:scope_relation_table_0:025:scope.org-acme:scope.second.alpha",
        "relation:scope_relation_table_0:038:scope.dept-research:scope.second.alpha",
        "relation:scope_relation_table_0:051:scope.dept-operations:scope.second.alpha",
        "relation:scope_relation_table_0:064:scope.tenant-a:scope.second.alpha",
        "relation:scope_relation_table_0:077:scope.tenant-b:scope.second.alpha",
        "relation:scope_relation_table_0:090:scope.region-x:scope.second.alpha",
        "relation:scope_relation_table_0:103:scope.region-y:scope.second.alpha",
        "relation:scope_relation_table_0:116:scope.region-east:scope.second.alpha",
        "relation:scope_relation_table_0:129:scope.region-north:scope.second.alpha",
        "relation:scope_relation_table_0:142:scope.region-south:scope.second.alpha",
        "relation:scope_relation_table_0:155:scope.symbolic-unknown:scope.second.alpha",
        "relation:scope_relation_table_0:156:scope.second.alpha:scope.universal",
        "relation:scope_relation_table_0:157:scope.second.alpha:scope.org-acme",
        "relation:scope_relation_table_0:158:scope.second.alpha:scope.dept-research",
        "relation:scope_relation_table_0:159:scope.second.alpha:scope.dept-operations",
        "relation:scope_relation_table_0:160:scope.second.alpha:scope.tenant-a",
        "relation:scope_relation_table_0:161:scope.second.alpha:scope.tenant-b",
        "relation:scope_relation_table_0:162:scope.second.alpha:scope.region-x",
        "relation:scope_relation_table_0:163:scope.second.alpha:scope.region-y",
        "relation:scope_relation_table_0:164:scope.second.alpha:scope.region-east",
        "relation:scope_relation_table_0:165:scope.second.alpha:scope.region-north",
        "relation:scope_relation_table_0:166:scope.second.alpha:scope.region-south",
        "relation:scope_relation_table_0:167:scope.second.alpha:scope.symbolic-unknown",
        "relation:temporal_relation_table_0:032:subject-time.instant-0:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:049:subject-time.instant-100:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:066:subject-time.instant-101:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:083:subject-time.instant-124:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:100:subject-time.instant-130:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:117:subject-time.instant-300:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:134:subject-time.interval-100-124-closed:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:151:subject-time.interval-100-124-open:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:168:subject-time.interval-100-124-left-open:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:185:subject-time.interval-100-124-right-open:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:202:subject-time.interval-0-50-closed:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:219:subject-time.interval-200-220-closed:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:236:subject-time.periodic-even:subject-time.symbolic-unknown",
        "relation:temporal_relation_table_0:253:subject-time.periodic-odd:subject-time.symbolic-unknown",
    }
)


if len(BLOCKED_VECTOR_REQUESTS) != 4:  # import-time closed-census assertion
    raise RuntimeError("authorial vector blocker census drift")
if len(BLOCKED_HOSTILE_REQUESTS) != 8:
    raise RuntimeError("authorial hostile blocker census drift")
if set(BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS) != BLOCKED_HOSTILE_REQUESTS:
    raise RuntimeError("authorial hostile cross-field census drift")
if len(BLOCKED_RELATION_PATH_REQUESTS) != 38:
    raise RuntimeError("authorial relation-path blocker census drift")
if sum(EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS.values()) != 4590:
    raise RuntimeError("successor implementation count census drift")
