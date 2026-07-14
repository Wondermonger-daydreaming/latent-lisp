"""Immutable LCI/0 value views and typed normative failures."""

from __future__ import annotations

from dataclasses import dataclass, field
from types import MappingProxyType
from typing import Any, Mapping

import cd0


AUTHORIZED_LCI_FAILURE_CODES = frozenset(
    {
        "AdmissibilityUndetermined",
        "AmbiguousIdentifier",
        "BasisMismatch",
        "ClaimIdCacheMismatch",
        "ClaimProfileMismatch",
        "ClaimTargetMismatch",
        "CorpusCompletionInsufficient",
        "CorpusRevisionIdentityInsufficient",
        "IdentityBearingLoss",
        "IdentityPolicyMismatch",
        "InterpretationFrameMismatch",
        "InvalidBasis",
        "InvalidClaimLocation",
        "InvalidClaimRecord",
        "InvalidInterpretationFrame",
        "InvalidProposition",
        "InvalidScope",
        "InvalidStableReference",
        "InvalidSubjectTime",
        "InvalidWarrantTarget",
        "LCIAggregatePayloadBudgetExceeded",
        "LCIIdentifierSegmentBudgetExceeded",
        "LCIMaxNestingExceeded",
        "LCINodeCountExceeded",
        "LCIRecordFieldBudgetExceeded",
        "LCISequenceLengthBudgetExceeded",
        "LegacyFingerprintNotClaimId",
        "LegacyWarrantInert",
        "LineageUnverified",
        "MeaningChangingNormalizerVersionReuse",
        "MigrationInputSizeExceeded",
        "MissingRequiredField",
        "MutableReference",
        "NormalizerContentIdentityMismatch",
        "NormalizerRevisionEvidenceMissing",
        "PremiseMismatch",
        "PrivilegedRestorationAttempt",
        "ProcedureIdentityInsufficient",
        "ProcedureMismatch",
        "ProfileLocationMismatch",
        "ProjectionNonDeterminism",
        "PropositionLocationInconsistent",
        "PropositionMismatch",
        "PropositionNormalizationWorkExceeded",
        "RecursiveUnsupportedNestedVersion",
        "ReplayAuthorizationRequired",
        "RepresentedLossAccountSizeExceeded",
        "RepresentedLossRequired",
        "ScopeDisjoint",
        "ScopeIncompatible",
        "ScopeNarrowingCoverageInsufficient",
        "ScopeNarrowingNotDeclared",
        "ScopeOverlapInsufficient",
        "ScopeRelationUnknown",
        "ScopeRelationWorkExceeded",
        "ScopeWideningForbidden",
        "SelfDeclaredClaimId",
        "SemanticIdentifierMappingMismatch",
        "StableReferenceMaterialBudgetExceeded",
        "SubjectTimeMismatch",
        "TargetBoundaryMismatch",
        "TargetBoundaryMissing",
        "TargetBoundaryUnknown",
        "TargetBoundaryWorkExceeded",
        "TargetSchemaKindMismatch",
        "TemporalCoverageInsufficient",
        "TemporalRelationWorkExceeded",
        "TranslationBoundaryMismatch",
        "UnclassifiedAsOf",
        "UnexpectedUnit",
        "UnknownField",
        "UnnormalizedProposition",
        "UnresolvedAlias",
        "UnresolvedRelativeTime",
        "UnsupportedClaimProfile",
        "UnsupportedIdentityPolicy",
        "UnsupportedInterpretationFrame",
        "UnsupportedLCIVersion",
        "UnsupportedLegacyForm",
        "UnsupportedReferenceScheme",
        "UnsupportedRepresentedLossAccountSchema",
        "UnsupportedScopeCalculus",
        "UnsupportedTargetKind",
        "UnsupportedTemporalModel",
    }
)


class FixtureAuthorityGap(RuntimeError):
    """The frozen package defines no normative LCI result for this path."""


class FixtureIntegrityError(RuntimeError):
    """Internal fixture/package state contradicts a sealed invariant."""


@dataclass(frozen=True, slots=True)
class LCIFailure(Exception):
    category: str
    code: str
    stage: str
    path: tuple[str, ...] = ()
    context: tuple[tuple[str, Any], ...] = ()

    def __post_init__(self) -> None:
        if self.code not in AUTHORIZED_LCI_FAILURE_CODES:
            raise FixtureIntegrityError(
                f"unauthorized LCI failure code construction: {self.code!r}"
            )
        Exception.__init__(self, f"{self.category}/{self.code}/{self.stage}")

    @property
    def comparison_key(self) -> tuple[str, str, str, tuple[str, ...]]:
        return (self.category, self.code, self.stage, self.path)

    def as_dict(self) -> dict[str, Any]:
        return {
            "category": self.category,
            "code": self.code,
            "stage": self.stage,
            "path": list(self.path),
        }


@dataclass(frozen=True, slots=True)
class LCIValue:
    datum: cd0.Datum
    canonical_bytes: bytes

    @property
    def canonical_hex(self) -> str:
        return self.canonical_bytes.hex()


@dataclass(frozen=True, slots=True)
class StableRef(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class LCIIdentityPolicy(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class ClaimProfileRef(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class Scope(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class SubjectTime(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class WorldBasis(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class DatasetSlice(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class SemanticBoundary(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class CorpusBasis(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class InterpretationFrame(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class ClaimLocation(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class ClaimIdEnvelope(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class WarrantTarget(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class ClaimLineageEdge(LCIValue):
    """Inert lineage data; this type conveys no authority."""


@dataclass(frozen=True, slots=True)
class RepresentedLoss(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class MigrationResult(LCIValue):
    inert: bool = True
    live_warrants: tuple[()] = ()


@dataclass(frozen=True, slots=True)
class ClaimOccurrence(LCIValue):
    pass


@dataclass(frozen=True, slots=True)
class RelationResult:
    relation: str | None = None
    failure: LCIFailure | None = None

    @property
    def success(self) -> bool:
        return self.failure is None and self.relation in {"exact-target", "supports-by-scope-narrowing"}

    @property
    def code(self) -> str | None:
        return None if self.failure is None else self.failure.code


@dataclass(frozen=True, slots=True)
class PolicyDecision:
    accepted: bool
    code: str
    hard_inadmissible: bool = False
    policy_consulted: bool = True
    details: Mapping[str, Any] = field(default_factory=lambda: MappingProxyType({}))


def id_key(value: cd0.Identifier) -> tuple[tuple[str, ...], tuple[str, ...]]:
    return (value.namespace, value.path)


def record_map(value: cd0.Datum) -> dict[tuple[tuple[str, ...], tuple[str, ...]], cd0.Datum]:
    if type(value) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture record shape")
    return {id_key(key): item for key, item in value.fields}


def field_by_path(value: cd0.Datum, name: str, default: Any = ...):
    if type(value) is not cd0.Record:
        if default is ...:
            raise FixtureAuthorityGap("unsupported fixture record shape")
        return default
    matches = [item for key, item in value.fields if key.path == (name,)]
    if len(matches) == 1:
        return matches[0]
    if default is not ...:
        return default
    raise LCIFailure("invalid-input", "MissingRequiredField", "shape", (name,))


def scalar(value: cd0.Datum) -> Any:
    if type(value) in (cd0.Boolean, cd0.Integer, cd0.String, cd0.ByteString):
        return value.value
    if type(value) is cd0.Identifier:
        return "/".join(value.path)
    if type(value) is cd0.Unit:
        return None
    raise FixtureAuthorityGap("unsupported fixture scalar shape")
