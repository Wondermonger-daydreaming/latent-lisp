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
ODR43ExposureClassSetInvalid = _condition("ODR43ExposureClassSetInvalid")
ODR43AdoptionPayloadInvalid = _condition("ODR43AdoptionPayloadInvalid")
ODR60AdoptionPayloadMismatch = _condition("ODR60AdoptionPayloadMismatch")
OwnerAdoptionAuthorityMismatch = _condition("OwnerAdoptionAuthorityMismatch")
OwnerAdoptionGraphInvalid = _condition("OwnerAdoptionGraphInvalid")
DraftItemUsedAsFrozen = _condition("DraftItemUsedAsFrozen")
PreauthorshipStateViolation = _condition("PreauthorshipStateViolation")
FreezerDossierReferenceInvalid = _condition("FreezerDossierReferenceInvalid")
RejectedDraftPreservationViolation = _condition("RejectedDraftPreservationViolation")
MutationNotExercised = _condition("MutationNotExercised")

# Tranche B candidate-bank and network-off custody conditions.  These remain
# experiment-local and do not alter the protected Language-A validator's
# condition vocabulary.
CanonicalizationIdentityMismatch = _condition("CanonicalizationIdentityMismatch")
CanonicalPopulationMismatch = _condition("CanonicalPopulationMismatch")
TargetVisibilityViolation = _condition("TargetVisibilityViolation")
RendererContractViolation = _condition("RendererContractViolation")
RequestCustodyViolation = _condition("RequestCustodyViolation")
AuthorityBoundaryViolation = _condition("AuthorityBoundaryViolation")
TrancheBMutationNotExercised = _condition("TrancheBMutationNotExercised")

# TB-R1 request-path and replay-custody conditions.  These refine the existing
# RequestCustodyViolation contract so inherited callers that catch the broader
# condition remain compatible while successor evidence can name the exact
# failed binding.
ScheduleRowDigestMismatch = type(
    "ScheduleRowDigestMismatch", (RequestCustodyViolation,),
    {"condition": "ScheduleRowDigestMismatch"},
)
SchedulePopulationMismatch = type(
    "SchedulePopulationMismatch", (RequestCustodyViolation,),
    {"condition": "SchedulePopulationMismatch"},
)
ScheduleParentBindingMismatch = type(
    "ScheduleParentBindingMismatch", (RequestCustodyViolation,),
    {"condition": "ScheduleParentBindingMismatch"},
)
RequestParentBindingMismatch = type(
    "RequestParentBindingMismatch", (RequestCustodyViolation,),
    {"condition": "RequestParentBindingMismatch"},
)
RunParentBindingMismatch = type(
    "RunParentBindingMismatch", (RequestCustodyViolation,),
    {"condition": "RunParentBindingMismatch"},
)
