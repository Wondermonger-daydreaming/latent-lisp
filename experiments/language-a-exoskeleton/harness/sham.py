from conditions import PilotAuthorityReturn


def classify_sham(uptake_rate, explicitly_discarded, semantic_leak, token_delta_fraction):
    if semantic_leak:
        return "SHAM-OPERATIVE"
    if uptake_rate < 0.70 or explicitly_discarded:
        return "SHAM-DISENGAGED"
    if uptake_rate >= 0.70 and token_delta_fraction <= 0.10:
        return "SHAM-VALID"
    raise PilotAuthorityReturn("SHAM tri-status does not classify adequate uptake with no leak but token burden outside 10%; exact freeze ruling required before exposure")
