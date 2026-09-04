class PilotError(RuntimeError):
    condition = "PilotError"

    def __init__(self, detail=""):
        super().__init__(f"{self.condition}: {detail}" if detail else self.condition)
        self.detail = detail


def _condition(name):
    return type(name, (PilotError,), {"condition": name})


ManifestMismatch = _condition("ManifestMismatch")
UnmanifestedFrozenArtifact = _condition("UnmanifestedFrozenArtifact")
DuplicateExperimentId = _condition("DuplicateExperimentId")
DanglingArtifactReference = _condition("DanglingArtifactReference")
ScheduleReplayDiverged = _condition("ScheduleReplayDiverged")
ProtectedScopeModified = _condition("ProtectedScopeModified")
KeyExposureBoundaryViolated = _condition("KeyExposureBoundaryViolated")
ValidatorTranscriptUnexpected = _condition("ValidatorTranscriptUnexpected")
ScorerMutationSurvived = _condition("ScorerMutationSurvived")
SilentRetryDetected = _condition("SilentRetryDetected")
IncompleteRunCensus = _condition("IncompleteRunCensus")
CostCeilingExceeded = _condition("CostCeilingExceeded")
LineageSearchIncomplete = _condition("LineageSearchIncomplete")
ReceiptDigestMismatch = _condition("ReceiptDigestMismatch")
NetworkAccessForbidden = _condition("NetworkAccessForbidden")
OwnerResolutionRequired = _condition("OwnerResolutionRequired")
SchemaViolation = _condition("SchemaViolation")
SyntheticOnlyViolation = _condition("SyntheticOnlyViolation")
ImmutableArtifactExists = _condition("ImmutableArtifactExists")
ForbiddenUnboundedClaim = _condition("ForbiddenUnboundedClaim")
MissingClaimCeilingRider = _condition("MissingClaimCeilingRider")
InconclusiveNarratedAsNull = _condition("InconclusiveNarratedAsNull")
LocalizedHarmOvergeneralized = _condition("LocalizedHarmOvergeneralized")
ShamDiagnosticOverclaimed = _condition("ShamDiagnosticOverclaimed")
GraderFirebreakViolated = _condition("GraderFirebreakViolated")
PilotAuthorityReturn = _condition("PILOT-AUTHORITY-RETURN")

# Pre-authorship repair conditions.  These are experiment-local failures; they
# do not extend the protected Language-A condition vocabulary.
PreauthorshipSchemaViolation = _condition("PreauthorshipSchemaViolation")
RecordDigestMismatch = _condition("RecordDigestMismatch")
DuplicateDraftId = _condition("DuplicateDraftId")
WrongRecordVersion = _condition("WrongRecordVersion")
MutableFilenameIdentity = _condition("MutableFilenameIdentity")
SourceComponentMissing = _condition("SourceComponentMissing")
ParentDigestMismatch = _condition("ParentDigestMismatch")
PredecessorDigestMismatch = _condition("PredecessorDigestMismatch")
MissingLineageActor = _condition("MissingLineageActor")
UnloggedRead = _condition("UnloggedRead")
LineageChronologyViolation = _condition("LineageChronologyViolation")
ImmutableSuccessorViolation = _condition("ImmutableSuccessorViolation")
PrivateRoleLeak = _condition("PrivateRoleLeak")
ExpectedAnswerLeak = _condition("ExpectedAnswerLeak")
TrapDataLeak = _condition("TrapDataLeak")
ScorableOpportunityLeak = _condition("ScorableOpportunityLeak")
CatchabilityWitnessLeak = _condition("CatchabilityWitnessLeak")
TaintedAncestry = _condition("TaintedAncestry")
ExcludedFixtureDerivative = _condition("ExcludedFixtureDerivative")
KeyAuthorBoundaryViolation = _condition("KeyAuthorBoundaryViolation")
MovingBankHandoff = _condition("MovingBankHandoff")
OwnerDecisionUnresolved = _condition("OwnerDecisionUnresolved")
OwnerDecisionForgery = _condition("OwnerDecisionForgery")
DraftItemUsedAsFrozen = _condition("DraftItemUsedAsFrozen")
PreauthorshipStateViolation = _condition("PreauthorshipStateViolation")
RejectedDraftPreservationViolation = _condition("RejectedDraftPreservationViolation")
MutationNotExercised = _condition("MutationNotExercised")
