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
