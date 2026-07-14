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
        "vector:LCI0-P029",
    }
)

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


if len(BLOCKED_VECTOR_REQUESTS) != 3:  # import-time closed-census assertion
    raise RuntimeError("authorial vector blocker census drift")
if len(BLOCKED_RELATION_PATH_REQUESTS) != 38:
    raise RuntimeError("authorial relation-path blocker census drift")
