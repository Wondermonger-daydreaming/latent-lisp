"""Machine-checkable Language-A Tranche B scoring constitution (SCORING-CONSTITUTION.md §11).

This module implements the deterministic, network-off scoring law: the §0 bank binding,
the §1 five-level substitution ban, the §3 total response-state classifier, the §4/§5
disagreement and adjudication law, the §7 exact-rational / canonical-decimal law, the §10
provenance and §2 blinded-projection law, the §15 owner-slot refusal gate, and the §11
delegation to the frozen ``analyze.py`` predicate encoding (aggregation and branch selection
are NEVER re-encoded here). Errors are typed conditions; summary lines are grep-stable.

Authorized for scoring-system design and pre-exposure validation only. No live scoring, no
provider calls, no key authorship, no exposure (SCORING-CONSTITUTION.md §13/§14).
"""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_EVEN, localcontext
from fractions import Fraction
from pathlib import Path

import analyze
from util import PACKET_ROOT, REPO_ROOT, canonical_json_bytes, load_json, sha256_bytes


HARNESS = Path(__file__).resolve().parent
FIXTURE_DIR = PACKET_ROOT / "controls/scoring-constitution-fixtures"
MUTATION_REGISTRY_PATH = PACKET_ROOT / "controls/scoring-constitution-mutations.json"


# --------------------------------------------------------------------------- §0
# Binding to the frozen bank and schedule.  Verbatim from SCORING-CONSTITUTION.md §0.
CONSTITUTION_VERSION = "lae-scoring-constitution/1.0.0"
FROZEN_BANK_COMMIT = "404a66a51c314e03ee50965411fd9f86192f846c"
FROZEN_BANK_TREE = "3694dae0d136662056b144874a3b51ecf82dfb0a"
FROZEN_FREEZE_MANIFEST_SHA256 = "a286b6082e4ac5089ad33e1edd9774d2a46c99207b343f29767eacf57eeb4d90"
FROZEN_SCHEDULE_BLOB = "ab0bb6d89ea32988b2f9245cc6b578245a979823"
FROZEN_SCHEDULE_ROW_DIGEST_LIST_SHA256 = "fee2d49c3ea3c8edcfc8081c1030cb5201342c2a540cf3c38320851e1558d665"
FROZEN_REQUEST_PARENT_BINDING_LIST_SHA256 = "a98472c9ae08d1f025b3fcd87b27e5106901e2ea5644e146cc72a2694f8738f4"

# --------------------------------------------------------------------------- §1
# Five levels and their record schema identities (SCORING-CONSTITUTION.md §1 table).
SCHEMA_ENVELOPE = "lae-envelope-disposition/1.0.0"
SCHEMA_CELL = "lae-cell-score/1.0.0"
SCHEMA_CONTRAST = "lae-contrast-estimate/1.0.0"
SCHEMA_STRATUM = "lae-stratum-report/1.0.0"
SCHEMA_BRANCH_RECEIPT = "lae-branch-receipt/1.0.0"
SCHEMA_INPUT = "lae-scoring-input/1.0.0"
LEVELS = {"L0": SCHEMA_ENVELOPE, "L1": SCHEMA_CELL, "L2": SCHEMA_CONTRAST,
          "L3": SCHEMA_STRATUM, "L4": SCHEMA_BRANCH_RECEIPT}

# --------------------------------------------------------------------------- §7
MARGINS = {"delta": Fraction(1, 10), "epsilon": Fraction(1, 20),
           "harm": Fraction(1, 10), "family_interaction": Fraction(3, 20)}
BOOTSTRAP_SEED = 1729
BOOTSTRAP_ITERATIONS = 800

# --------------------------------------------------------------------------- §3
# T09 safety-refusal lexicon — frozen, explicit, documented rule-based term list.
SAFETY_REFUSAL_TERMS = (
    "safety", "harmful", "harm to", "dangerous", "weapon", "illegal",
    "against my guidelines", "against our policy", "content policy", "cannot assist with that",
    "can't help with that", "i cannot help with", "i won't provide", "i will not provide",
    "not able to help with", "violates", "self-harm", "abuse", "exploitation",
)
_SAFETY_REGEX = re.compile("|".join(re.escape(term) for term in SAFETY_REFUSAL_TERMS), re.IGNORECASE)

# --------------------------------------------------------------------------- §2/§10
# Concealment set — fields a blind scorer must never see in cleartext (§2).  Any key here
# (or any key prefixed ``model_id_``) is salted-digested in a committed record's projection.
CONCEALMENT_FIELDS = (
    "provider_id", "model_id_requested", "model_id_returned", "arm", "condition",
    "subject_slot", "schedule_index", "randomization_seed_digest", "family",
    "answerability_role", "tags", "trap_class", "expected_direction", "owner_disposition",
    "ancestry", "exposure_history", "usage", "latency_ms", "billed_cost_usd",
    "other_responses", "other_rater_first_pass", "validator_findings",
)
SCORER_VISIBLE_FIELDS = (
    "assignment_id", "synthetic_only", "locked_response", "normalized_view", "native_view",
    "source_packet", "item_version", "task_statement", "arm_neutral_task",
)

# --------------------------------------------------------------------------- §10
PROVENANCE_FIELDS = (
    "constitution_version", "rubric_sha256", "schedule_row_digest", "envelope_digest",
    "scorer_pseudonym", "implementation_identity", "scoring_timestamp", "adjudication_lineage",
)


# =========================================================================== errors
class ScoringConstitutionError(RuntimeError):
    condition = "ScoringConstitutionError"

    def __init__(self, detail=""):
        super().__init__(f"{self.condition}: {detail}" if detail else self.condition)
        self.detail = detail


def _condition(name):
    return type(name, (ScoringConstitutionError,), {"condition": name})


BankBindingMismatch = _condition("BankBindingMismatch")
TaxonomyFallthroughFailure = _condition("TaxonomyFallthroughFailure")
ClassifierOrderViolation = _condition("ClassifierOrderViolation")
StateMismatch = _condition("StateMismatch")
SafetyRefusalMisclassified = _condition("SafetyRefusalMisclassified")
DispositionMismatch = _condition("DispositionMismatch")
CensusClassMismatch = _condition("CensusClassMismatch")
DenominatorLawViolation = _condition("DenominatorLawViolation")
MissingMandatedFlag = _condition("MissingMandatedFlag")
FloatInCanonicalRecord = _condition("FloatInCanonicalRecord")
DecimalQuantizationError = _condition("DecimalQuantizationError")
RationalComparisonRequired = _condition("RationalComparisonRequired")
AdjudicationRequired = _condition("AdjudicationRequired")
TieRuleViolation = _condition("TieRuleViolation")
LevelSubstitution = _condition("LevelSubstitution")
BlindFieldLeak = _condition("BlindFieldLeak")
SwappedLabelAccepted = _condition("SwappedLabelAccepted")
ProvenanceIncomplete = _condition("ProvenanceIncomplete")
ScoringEligibilityRefused = _condition("ScoringEligibilityRefused")
SlotGateBypass = _condition("SlotGateBypass")
PostHocExclusion = _condition("PostHocExclusion")
PredicateReencodingForbidden = _condition("PredicateReencodingForbidden")
CensusUndercount = _condition("CensusUndercount")
MissingPairImputation = _condition("MissingPairImputation")
BootstrapParameterDrift = _condition("BootstrapParameterDrift")
ScoringMutationSurvived = _condition("ScoringMutationSurvived")

ALL_CONDITIONS = (
    BankBindingMismatch, TaxonomyFallthroughFailure, ClassifierOrderViolation, StateMismatch,
    SafetyRefusalMisclassified, DispositionMismatch, CensusClassMismatch, DenominatorLawViolation,
    MissingMandatedFlag, FloatInCanonicalRecord, DecimalQuantizationError, RationalComparisonRequired,
    AdjudicationRequired, TieRuleViolation, LevelSubstitution, BlindFieldLeak, SwappedLabelAccepted,
    ProvenanceIncomplete, ScoringEligibilityRefused, SlotGateBypass, PostHocExclusion,
    PredicateReencodingForbidden, CensusUndercount, MissingPairImputation, BootstrapParameterDrift,
    ScoringMutationSurvived,
)


# =========================================================================== §0 binding
def verify_bank_binding(repo_root, manifest_bytes=None):
    """Recompute the freeze-manifest sha256 and compare to the §0 constant (SCORING-CONSTITUTION.md §0)."""
    if manifest_bytes is None:
        packet = _packet_dir(repo_root)
        manifest_bytes = (packet / "evidence/tranche-b-item-bank-freeze/FREEZE-MANIFEST.json").read_bytes()
    digest = sha256_bytes(manifest_bytes)
    if digest != FROZEN_FREEZE_MANIFEST_SHA256:
        raise BankBindingMismatch(
            f"freeze-manifest sha256 {digest} != §0 {FROZEN_FREEZE_MANIFEST_SHA256}")
    return {"freeze_manifest_sha256": digest, "bank_commit": FROZEN_BANK_COMMIT,
            "bank_tree": FROZEN_BANK_TREE, "schedule_blob": FROZEN_SCHEDULE_BLOB}


def _packet_dir(repo_root):
    root = Path(repo_root)
    candidate = root / "experiments/language-a-exoskeleton"
    return candidate if candidate.exists() else root


# =========================================================================== §3 classifier
# (disposition, census_class, flags[0]==mandated flag) per SCORING-CONSTITUTION.md §3 table.
STATE_TABLE = {
    "T01": ("UNANALYZABLE-CENSUS", "experimenter/integrity", ["malformed_envelope"]),
    "T02": ("UNANALYZABLE-CENSUS", "provider-caused", ["encoding_failure"]),
    "T03": ("QUARANTINE-INTEGRITY", "integrity", ["duplicate_response"]),
    "T04": ("QUARANTINE-INTEGRITY", "integrity", ["replayed_response"]),
    "T05": ("UNANALYZABLE-CENSUS", "provider-caused", ["transport_failure"]),
    "T06": ("UNANALYZABLE-CENSUS", "provider-caused", ["provider_error"]),
    "T07": ("UNANALYZABLE-CENSUS", "provider-caused", ["timeout"]),
    "T08": ("QUARANTINE-INTEGRITY", "integrity", ["unexpected_tool_output"]),
    "T09": ("SCORE-ZERO-DISCHARGE", "analyzable", ["safety_refusal"]),
    "T10": ("SCORE-ZERO-DISCHARGE", "analyzable", ["refusal"]),
    "T11": ("SCORE-ZERO-DISCHARGE", "analyzable", ["empty_response"]),
    "T12": ("SCORE", "analyzable", ["truncation"]),
    "T13": ("SCORE-ZERO-DISCHARGE", "analyzable", ["unparseable"]),
    "T14": ("SCORE", "analyzable", ["partial"]),
    "T15": ("SCORE", "analyzable", ["complete"]),
    "T99": ("QUARANTINE-INTEGRITY", "integrity", ["authority_return"]),
}
STATE_ORDER = ("T01", "T02", "T03", "T04", "T05", "T06", "T07", "T08",
               "T09", "T10", "T11", "T12", "T13", "T14", "T15", "T99")
STATE_INDEX = {state: index for index, state in enumerate(STATE_ORDER)}

_REQUEST_SCHEMA = load_json(HARNESS / "request_schema.json")
_RESPONSE_SCHEMA = load_json(HARNESS / "response_schema.json")
try:  # jsonschema if available, else the hand-rolled required-fields+enum fallback below
    import jsonschema as _jsonschema
    _HAVE_JSONSCHEMA = True
except Exception:  # pragma: no cover - environment dependent
    _HAVE_JSONSCHEMA = False


def _hand_validate(instance, schema):
    if schema.get("type") == "object" and not isinstance(instance, dict):
        raise ValueError("not an object")
    for field in schema.get("required", []):
        if field not in instance:
            raise ValueError(f"missing required field {field}")
    for prop, spec in schema.get("properties", {}).items():
        if prop not in instance:
            continue
        value = instance[prop]
        if "enum" in spec and value not in spec["enum"]:
            raise ValueError(f"enum violation {prop}={value!r}")
        if spec.get("type") == "object":
            if not isinstance(value, dict):
                raise ValueError(f"{prop} not object")
            for req in spec.get("required", []):
                if req not in value:
                    raise ValueError(f"missing {prop}.{req}")
        if spec.get("type") == "integer" and not isinstance(value, int):
            raise ValueError(f"{prop} not integer")
        if spec.get("type") == "array" and not isinstance(value, list):
            raise ValueError(f"{prop} not array")
    return True


def _schema_valid(request, response):
    try:
        if _HAVE_JSONSCHEMA:
            _jsonschema.validate(request, _REQUEST_SCHEMA)
            _jsonschema.validate(response, _RESPONSE_SCHEMA)
        else:
            _hand_validate(request, _REQUEST_SCHEMA)
            _hand_validate(response, _RESPONSE_SCHEMA)
        return True
    except Exception:
        return False


def _utf8_ok(raw_bytes):
    if raw_bytes is None or isinstance(raw_bytes, str):
        return True
    try:
        raw_bytes.decode("utf-8")
        return True
    except Exception:
        return False


def _text(raw_bytes):
    if raw_bytes is None:
        return ""
    if isinstance(raw_bytes, str):
        return raw_bytes
    return raw_bytes.decode("utf-8", errors="replace")


def _anomaly_types(response):
    types = set()
    for anomaly in response.get("anomalies", []) or []:
        if isinstance(anomaly, str):
            types.add(anomaly.casefold())
        elif isinstance(anomaly, dict):
            for key in ("type", "name", "code", "kind"):
                if key in anomaly and isinstance(anomaly[key], str):
                    types.add(anomaly[key].casefold())
    return types


def _content_units(response, raw_bytes):
    if isinstance(response.get("content_units"), int):
        return response["content_units"]
    text = _text(raw_bytes).strip()
    if not text:
        return 0
    return sum(1 for line in text.splitlines() if line.strip()) or 1


def _opportunities(response):
    opp = response.get("opportunities")
    if isinstance(opp, dict) and "total" in opp and "discharged" in opp:
        return int(opp["total"]), int(opp["discharged"])
    if "opportunities_total" in response and "opportunities_discharged" in response:
        return int(response["opportunities_total"]), int(response["opportunities_discharged"])
    return None


def _both_raters_unparseable(response):
    if response.get("unparseable_adjudicated") is True:
        return True
    marks = response.get("rater_unparseable")
    return isinstance(marks, list) and len(marks) >= 2 and all(bool(m) for m in marks)


def _safety_refusal(response, raw_bytes):
    text = response.get("refusal_text") or _text(raw_bytes)
    if response.get("safety_classified") is True:
        return True
    return bool(_SAFETY_REGEX.search(text or ""))


def _detect_state(request, response, raw_bytes):
    if not _schema_valid(request, response):
        return "T01"
    if not _utf8_ok(raw_bytes):
        return "T02"
    types = _anomaly_types(response)
    if response.get("duplicate_envelope") is True or "duplicate" in types:
        return "T03"
    if response.get("replayed_response") is True or response.get("replay_of") or "replayed" in types or "replay" in types:
        return "T04"
    status = response.get("status")
    has_timeout = "timeout" in types
    if status == "transport-failure" and not has_timeout:
        return "T05"
    provider_error = bool(types & {"provider-error", "provider_error", "error", "provider-anomaly"})
    if provider_error and _content_units(response, raw_bytes) == 0:
        return "T06"
    if status == "transport-failure" and has_timeout:
        return "T07"
    if response.get("tool_calls") or response.get("structured_output") is not None or (types & {"tool-call", "tool_call", "structured-output"}):
        return "T08"
    if status == "refused":
        return "T09" if _safety_refusal(response, raw_bytes) else "T10"
    if status == "completed" and _content_units(response, raw_bytes) == 0:
        return "T11"
    if status == "truncated" or response.get("finish_reason") == "length":
        return "T12"
    if _both_raters_unparseable(response):
        return "T13"
    opp = _opportunities(response)
    if opp is not None:
        total, discharged = opp
        if total > 0 and discharged == total:
            return "T15"
        if discharged >= 1:
            return "T14"
        return "T13"
    # Valid envelope with no key/rater discharge metadata is not analyzable without the Cβ
    # key; it never falls through to ad hoc judgment — it returns to authority (T99).
    return "T99"


def classify_envelope(request_record, response_record, raw_bytes):
    """Total §3 classifier: (request, response, raw bytes) -> disposition record.

    First-match-wins over the fixed order; the terminal branch is T99 with authority return.
    Never raises and never deletes a cell: ``denominator_retained`` is always True (structural
    missingness is a schedule matter under §6, not an envelope state).
    """
    try:
        state = _detect_state(request_record, response_record, raw_bytes)
    except Exception:
        state = "T99"
    disposition, census_class, flags = STATE_TABLE[state]
    return {
        "schema_version": SCHEMA_ENVELOPE, "level": "L0", "state": state,
        "disposition": disposition, "census_class": census_class,
        "denominator_retained": True, "flags": list(flags),
    }


def validate_classification(result, request=None, response=None, raw=None):
    """Audit a claimed classification against the §3 table (and, if given, the recomputed state)."""
    state = result.get("state")
    if state not in STATE_TABLE:
        raise TaxonomyFallthroughFailure(f"state {state!r} not in the §3 taxonomy (classifier not total)")
    if request is not None and response is not None and raw is not None:
        real = classify_envelope(request, response, raw)["state"]
        if real != state:
            if real == "T99":
                raise TaxonomyFallthroughFailure(f"claimed {state} but input is unclassifiable (real T99)")
            if {real, state} <= {"T09", "T10"}:
                raise SafetyRefusalMisclassified(f"claimed {state}, safety-lexicon says {real}")
            if STATE_INDEX[real] < STATE_INDEX[state]:
                raise ClassifierOrderViolation(f"claimed {state} but earlier-precedence {real} matches first")
            raise StateMismatch(f"claimed {state}, real {real}")
    disposition, census_class, flags = STATE_TABLE[state]
    if result.get("disposition") != disposition:
        raise DispositionMismatch(f"{state}: disposition {result.get('disposition')!r} != {disposition!r}")
    if result.get("census_class") != census_class:
        raise CensusClassMismatch(f"{state}: census_class {result.get('census_class')!r} != {census_class!r}")
    if result.get("denominator_retained") is not True:
        raise DenominatorLawViolation(f"{state}: denominator not retained (§3: no disposition deletes a cell)")
    if flags[0] not in (result.get("flags") or []):
        raise MissingMandatedFlag(f"{state}: missing mandated flag {flags[0]!r}")
    return True


# =========================================================================== §7 decimal law
def canonical_decimal(value):
    """Quantize an exact Fraction to 6 fractional digits, ROUND_HALF_EVEN, no float pass-through (§7)."""
    if isinstance(value, bool) or not isinstance(value, (Fraction, int)):
        raise DecimalQuantizationError(f"canonical_decimal requires an exact Fraction/int, got {type(value).__name__}")
    frac = Fraction(value)
    with localcontext() as ctx:
        ctx.prec = 60
        dec = Decimal(frac.numerator) / Decimal(frac.denominator)
        quantized = dec.quantize(Decimal("0.000001"), rounding=ROUND_HALF_EVEN)
    text = format(quantized, "f")
    if text == "-0.000000":
        text = "0.000000"
    return text


def decimal_field(value):
    """Serialize an exact rational as {decimal string, integer numerator, integer denominator} (§7)."""
    frac = Fraction(value)
    return {"decimal": canonical_decimal(frac), "num": frac.numerator, "den": frac.denominator}


def compare_threshold(value, threshold):
    """Sign of (value - threshold) on EXACT rationals only (§7: comparisons never on quantized decimals)."""
    for name, operand in (("value", value), ("threshold", threshold)):
        if isinstance(operand, bool) or not isinstance(operand, (Fraction, int)):
            raise RationalComparisonRequired(f"{name} must be an exact Fraction/int, got {type(operand).__name__}")
    diff = Fraction(value) - Fraction(threshold)
    return (diff > 0) - (diff < 0)


def rational_le(value, threshold):
    return compare_threshold(value, threshold) <= 0


def rational_ge(value, threshold):
    return compare_threshold(value, threshold) >= 0


def _reject_non_canonical(node, path="$"):
    if isinstance(node, bool):
        return
    if isinstance(node, float):
        raise FloatInCanonicalRecord(f"{path}: float in canonical scoring record (serialize as decimal+num/den)")
    if isinstance(node, Fraction):
        raise FloatInCanonicalRecord(f"{path}: raw Fraction in canonical scoring record (serialize as decimal+num/den)")
    if isinstance(node, dict):
        for key, value in node.items():
            _reject_non_canonical(value, f"{path}.{key}")
    elif isinstance(node, (list, tuple)):
        for index, value in enumerate(node):
            _reject_non_canonical(value, f"{path}[{index}]")


def canonical_scoring_record_bytes(record):
    """Reject any float/Fraction, then serialize via util.canonical_json_bytes (§7)."""
    _reject_non_canonical(record)
    return canonical_json_bytes(record)


def assert_canonical_decimal(value, claimed):
    recomputed = canonical_decimal(value)
    if claimed != recomputed:
        raise DecimalQuantizationError(f"claimed {claimed!r} != HALF_EVEN {recomputed!r}")
    return True


def assert_rational_relation(value, threshold, claimed_relation):
    """Guard: threshold comparisons must be decided on exact rationals, not on the 6-digit decimals."""
    rational = {-1: "lt", 0: "eq", 1: "gt"}[compare_threshold(value, threshold)]
    decimal_value = Decimal(canonical_decimal(Fraction(value)))
    decimal_threshold = Decimal(canonical_decimal(Fraction(threshold)))
    quantized = {-1: "lt", 0: "eq", 1: "gt"}[(decimal_value > decimal_threshold) - (decimal_value < decimal_threshold)]
    if claimed_relation != rational:
        note = " (quantized decimals would flip the comparison)" if claimed_relation == quantized else ""
        raise RationalComparisonRequired(f"claimed {claimed_relation!r} != exact-rational {rational!r}{note}")
    return True


# =========================================================================== §4/§5 disagreement
def bank_dimension(a, b):
    """|a-b|==1 -> exact mean; a==b -> value; |a-b|>1 -> adjudication (SCORING-CONSTITUTION.md §4)."""
    a, b = int(a), int(b)
    distance = abs(a - b)
    if distance > 1:
        raise AdjudicationRequired(f"|{a}-{b}|={distance} > 1 requires adjudication (§4/§5)")
    if distance == 1:
        return Fraction(a + b, 2)
    return Fraction(a)


def validate_banked_dimension(a, b, claimed):
    recomputed = bank_dimension(a, b)
    if Fraction(claimed) != recomputed:
        raise TieRuleViolation(f"banked {Fraction(claimed)} != §4 rule {recomputed} for a={a}, b={b}")
    return True


def adjudicate(a, b, adjudicated_value, lineage):
    """Adjudication REPLACES the banked value and appends first-pass digests to lineage (§4/§5)."""
    a, b = int(a), int(b)
    value = Fraction(adjudicated_value)
    first_passes = [{"rater": "A", "value": a}, {"rater": "B", "value": b}]
    chain = list(lineage) + [sha256_bytes(canonical_json_bytes(fp)) for fp in first_passes]
    return {
        "banked_value": decimal_field(value), "adjudicated": True,
        "first_pass_a": a, "first_pass_b": b, "adjudication_lineage": chain,
        "first_pass_records_retained": True,
    }


# =========================================================================== §1 level ban
def validate_aggregation_inputs(records, expected_level):
    """Reject any aggregation input whose level field does not match the formula's input level (§1)."""
    if expected_level not in LEVELS:
        raise LevelSubstitution(f"unknown expected level {expected_level!r}")
    for index, record in enumerate(records):
        level = record.get("level")
        if level != expected_level:
            raise LevelSubstitution(f"input[{index}] level {level!r} != required {expected_level!r}")
    return True


# =========================================================================== §2/§10 blinding
def _is_concealed(key):
    return key in CONCEALMENT_FIELDS or key.startswith("model_id_")


def _blind_digest(salt, value):
    return "blind:" + sha256_bytes(salt + canonical_json_bytes(value))


def blinded_projection(record, salt):
    """Replace every concealment-set field with a deterministic salted sha256 digest (§2/§10)."""
    if isinstance(salt, str):
        salt = salt.encode("utf-8")

    def walk(node):
        if isinstance(node, dict):
            return {key: (_blind_digest(salt, value) if _is_concealed(key) else walk(value))
                    for key, value in node.items()}
        if isinstance(node, list):
            return [walk(item) for item in node]
        return node

    return walk(record)


def validate_blinding(projected_record):
    """Guard: a committed projection must carry no concealment field in cleartext (§2/§10)."""
    def walk(node, path="$"):
        if isinstance(node, dict):
            for key, value in node.items():
                if _is_concealed(key):
                    if not (isinstance(value, str) and value.startswith("blind:")):
                        raise BlindFieldLeak(f"{path}.{key}: concealed field not blinded")
                else:
                    walk(value, f"{path}.{key}")
        elif isinstance(node, list):
            for index, value in enumerate(node):
                walk(value, f"{path}[{index}]")

    walk(projected_record)
    return True


def validate_scorer_packet(packet):
    """Guard: a scorer-visible packet may expose only §2's three permitted surfaces."""
    for key in packet:
        if _is_concealed(key) or key not in SCORER_VISIBLE_FIELDS:
            raise SwappedLabelAccepted(f"scorer packet exposes concealed/unauthorized field {key!r}")
    return True


# =========================================================================== §10 provenance
def validate_provenance(score_record):
    """Require every §10 provenance field on a score record."""
    provenance = score_record.get("provenance", score_record)
    missing = []
    for field in PROVENANCE_FIELDS:
        if field not in provenance:
            missing.append(field)
        elif field != "adjudication_lineage" and provenance[field] in (None, ""):
            missing.append(field)
        elif field == "adjudication_lineage" and provenance[field] is None:
            missing.append(field)
    if missing:
        raise ProvenanceIncomplete(",".join(missing))
    if provenance["constitution_version"] != CONSTITUTION_VERSION:
        raise ProvenanceIncomplete(f"constitution_version {provenance['constitution_version']!r} != {CONSTITUTION_VERSION!r}")
    return True


# =========================================================================== §6 census / pairs
def validate_census(census):
    """Every scheduled cell stays accounted for; no disposition deletes a cell (§3/§6)."""
    total = census["scheduled_total"]
    accounted = sum(census["class_counts"].values())
    if accounted != total:
        raise CensusUndercount(f"accounted {accounted} != scheduled {total} (a cell was deleted, not census-classed)")
    return True


def validate_paired_contrast(cells):
    """Paired contrasts use complete pairs only; incomplete pairs are never imputed (§6/§7)."""
    for cell in cells:
        if cell.get("imputed"):
            raise MissingPairImputation(cell.get("cell_id", "?"))
        for arm_record in (cell.get("arms") or {}).values():
            if isinstance(arm_record, dict) and arm_record.get("imputed"):
                raise MissingPairImputation(cell.get("cell_id", "?"))
        if cell.get("incomplete_pair") and cell.get("used_as_complete"):
            raise MissingPairImputation(cell.get("cell_id", "?"))
    return True


def assert_bootstrap_params(seed, iterations):
    if seed != BOOTSTRAP_SEED or iterations != BOOTSTRAP_ITERATIONS:
        raise BootstrapParameterDrift(f"seed={seed} iterations={iterations} != {BOOTSTRAP_SEED}/{BOOTSTRAP_ITERATIONS} (§7 disclosure §16)")
    return True


# =========================================================================== §6 post-hoc law
def validate_deviation(deviation):
    """A post-unblinding exclusion can only move results toward B-INCONCLUSIVE (§6)."""
    for field in ("actor", "cause", "affected_digests", "phase"):
        if field not in deviation or deviation[field] in (None, ""):
            raise PostHocExclusion(f"deviation missing append-only field {field!r}")
    if deviation["phase"] == "post-unblinding":
        target = deviation.get("moves_toward")
        if target not in (None, "B-INCONCLUSIVE"):
            raise PostHocExclusion(f"post-unblinding exclusion moves toward substantive branch {target!r}")
    return True


# =========================================================================== §15 slot gate
def _slot_resolved(slot):
    status = slot.get("status", "")
    if not status.startswith("resolved"):
        return False
    value = slot.get("value", "__present__")
    if value in (None, "", "TBD", "tbd", "TODO"):
        return False
    return True


def unresolved_scoring_slots(repo_root=REPO_ROOT):
    packet = _packet_dir(repo_root)
    scoring = load_json(packet / "operator/scoring-owner-slots.json")
    owner = load_json(packet / "operator/owner-slots.json")
    owner_status = {slot["slot_id"]: slot for slot in owner["slots"]}
    unresolved = []
    for slot in scoring["slots"]:
        resolved = _slot_resolved(slot)
        binds = slot.get("binds", "new")
        if isinstance(binds, str) and binds.startswith("operator/owner-slots.json#"):
            reference = binds.split("#", 1)[1]
            bound = owner_status.get(reference)
            if bound is not None and bound.get("status") != "resolved":
                resolved = False
        if not resolved:
            unresolved.append(slot["slot_id"])
    return unresolved


def scoring_eligibility(repo_root=REPO_ROOT):
    """Mechanical §15 gate: REFUSE while any scoring-facing slot is unresolved."""
    unresolved = unresolved_scoring_slots(repo_root)
    if unresolved:
        raise ScoringEligibilityRefused("unresolved scoring-facing slots: " + ", ".join(unresolved))
    return {"eligible": True, "unresolved": []}


def assert_register_eligibility(scoring_register):
    """Guard: a forged eligibility flag never overrides an unresolved slot (§15)."""
    forged = bool(scoring_register.get("eligible") or scoring_register.get("scoring_eligible"))
    unresolved = [slot["slot_id"] for slot in scoring_register["slots"] if not _slot_resolved(slot)]
    if unresolved:
        if forged:
            raise SlotGateBypass("register claims eligibility while unresolved: " + ",".join(unresolved))
        raise ScoringEligibilityRefused(",".join(unresolved))
    return True


# =========================================================================== §11 delegation
def _paired_fractions(rows):
    arms_in_contrasts = {arm for pair in analyze.CONTRASTS.values() for arm in pair}
    by_cell = defaultdict(dict)
    for row in rows:
        if row["arm"] in arms_in_contrasts:
            by_cell[(row["item_id"], row["family"], row["subject_slot"])][row["arm"]] = \
                Fraction(int(row["defect_total"]), int(row["scorable_opportunities"]))
    cells = {}
    for key, arms in by_cell.items():
        cells[key] = {}
        for name, (left, right) in analyze.CONTRASTS.items():
            if left in arms and right in arms:
                cells[key][name] = arms[left] - arms[right]
    return cells


def assert_delegated_branch(payload, local_banked):
    """Guard: branch selection is analyze.py's alone; a local predicate re-encoding is forbidden (§0/§11)."""
    delegated = analyze.analyze(payload)["banked_branch"]
    if local_banked != delegated:
        raise PredicateReencodingForbidden(f"local branch {local_banked!r} != delegated {delegated!r} (§0 forbids re-encoding)")
    return True


def run_analysis(payload, seed=BOOTSTRAP_SEED, iterations=BOOTSTRAP_ITERATIONS):
    """Delegate aggregation/branch selection to the frozen analyze.py, then re-serialize its
    verdict as an lae-branch-receipt/1.0.0 record under the §7 decimal law.  Threshold
    comparisons remain analyze.py's; primary estimates are carried as exact rationals too."""
    assert_bootstrap_params(seed, iterations)
    delegated = analyze.analyze(payload, seed, iterations)
    rows = payload["rows"] if isinstance(payload, dict) else payload
    cells = _paired_fractions(rows)
    estimates = {}
    for name in analyze.CONTRASTS:
        diffs = [cells[key][name] for key in cells if name in cells[key]]
        if diffs:
            mean = sum(diffs, Fraction(0)) / len(diffs)
            estimates[name] = {"paired_cells": len(diffs), **decimal_field(mean)}
        else:
            estimates[name] = {"paired_cells": 0, "decimal": None, "num": None, "den": None}
    record = {
        "schema_version": SCHEMA_BRANCH_RECEIPT, "level": "L4", "synthetic_only": True,
        "delegated_predicate_encoding": "harness/analyze.py",
        "delegated_banked_branch": delegated["banked_branch"],
        "delegated_all_predicates": delegated["all_predicates"],
        "delegated_receipt_sha256": delegated["receipt_sha256"],
        "branch_precedence": delegated["branch_precedence"],
        "bootstrap_seed": seed, "bootstrap_iterations": iterations,
        "margins": {name: decimal_field(value) for name, value in MARGINS.items()},
        "primary_estimates_exact_rational": estimates,
        "threshold_comparisons_performed_by": "harness/analyze.py (single-point predicate encoding)",
    }
    record["receipt_sha256"] = sha256_bytes(canonical_scoring_record_bytes(record))
    return record


# =========================================================================== synthetic helpers
def demo_request(**overrides):
    """A schema-valid synthetic L0 request envelope (synthetic_only; no live provider exists)."""
    record = {
        "run_id": "SYNTH-RUN", "call_id": "SYNTH-CALL", "item_id": "SYNTH-ITEM",
        "item_version": "v1", "arm": "NL", "prompt_artifact_version": "v1",
        "subject_slot": "SYNTHETIC-SUBJECT-1", "provider_id": "synthetic-provider",
        "model_id_requested": "synthetic-model",
        "parameters": {"temperature": 0, "top_p": 1, "max_output_tokens": 256, "seed": 1, "tools": []},
        "schedule_index": 0, "randomization_seed_digest": "0" * 64,
        "request_bytes_sha256": "0" * 64, "attempt": 1, "retry_parent": None,
        "synthetic_only": True,
    }
    record.update(overrides)
    return record


def demo_response(status="completed", **overrides):
    """A schema-valid synthetic L0 response envelope (synthetic_only)."""
    record = {
        "call_id": "SYNTH-CALL", "provider_request_id": "synthetic-req",
        "model_id_returned": "synthetic-model", "started_at": "2026-07-16T00:00:00Z",
        "completed_at": "2026-07-16T00:00:01Z", "status": status, "finish_reason": "stop",
        "raw_response_path": "synthetic://response", "raw_response_bytes": 12,
        "raw_response_sha256": "0" * 64, "usage": {"input_tokens": 1, "output_tokens": 1},
        "price_table_version": "synthetic", "billed_cost_usd": 0, "latency_ms": 1,
        "operator_actor_id": "synthetic-operator", "anomalies": [], "synthetic_only": True,
    }
    record.update(overrides)
    return record


# =========================================================================== mutation registry
def _mutation_handlers():
    handlers = {}

    def bank_binding_mismatch():
        verify_bank_binding(REPO_ROOT, manifest_bytes=b"tampered-freeze-manifest\n")
    handlers["mutation:scoring-bank-binding-mismatch"] = bank_binding_mismatch

    def float_smuggled():
        canonical_scoring_record_bytes({"burden": 0.5, "level": "L1"})
    handlers["mutation:scoring-float-smuggled-into-canonical-record"] = float_smuggled

    def decimal_half_even():
        # 0.0000005 == 1/2000000: HALF_EVEN -> 0.000000 (0 is even); a HALF_UP claim is 0.000001.
        assert_canonical_decimal(Fraction(1, 2_000_000), "0.000001")
    handlers["mutation:scoring-decimal-half-even-violation"] = decimal_half_even

    def quantized_comparison():
        # 0.0999995 quantizes to 0.100000 == 0.10; the exact rational is strictly below 0.10.
        assert_rational_relation(Fraction(199999, 2_000_000), Fraction(1, 10), "eq")
    handlers["mutation:scoring-quantization-of-comparison-values"] = quantized_comparison

    def tie_rule_violation():
        validate_banked_dimension(2, 3, Fraction(3))  # rule says exact mean 5/2
    handlers["mutation:scoring-tie-rule-violation"] = tie_rule_violation

    def adjudication_skip():
        bank_dimension(2, 5)  # |a-b|=3 -> adjudication required
    handlers["mutation:scoring-adjudication-skip-at-distance-two"] = adjudication_skip

    def level_substitution():
        validate_aggregation_inputs([{"level": "L2", "note": "secondary-pooled"}], "L2-primary" if False else "L1")
    handlers["mutation:scoring-level-substitution"] = level_substitution

    def aggregate_input_wrong_level():
        records = [{"level": "L2"}, {"level": "L2"}, {"level": "L1"}]
        validate_aggregation_inputs(records, "L2")
    handlers["mutation:scoring-aggregate-input-wrong-level"] = aggregate_input_wrong_level

    def blind_field_leak():
        validate_blinding({"arm": "LANG-A", "burden": {"decimal": "0.100000"}})
    handlers["mutation:scoring-blind-field-leak-in-projection"] = blind_field_leak

    def swapped_label_accepted():
        validate_scorer_packet({"locked_response": "text", "arm": "NL"})
    handlers["mutation:scoring-swapped-label-acceptance"] = swapped_label_accepted

    def provenance_drop():
        record = {
            "constitution_version": CONSTITUTION_VERSION, "schedule_row_digest": "0" * 64,
            "envelope_digest": "0" * 64, "scorer_pseudonym": "RATER-1",
            "implementation_identity": "0" * 64, "scoring_timestamp": "2026-07-16T00:00:00Z",
            "adjudication_lineage": [],  # rubric_sha256 dropped
        }
        validate_provenance(record)
    handlers["mutation:scoring-provenance-field-drop"] = provenance_drop

    def slot_gate_bypass():
        register = {"eligible": True, "slots": [{"slot_id": "role-assignments", "status": "unresolved"}]}
        assert_register_eligibility(register)
    handlers["mutation:scoring-slot-gate-bypass"] = slot_gate_bypass

    def post_hoc_exclusion():
        validate_deviation({"actor": "analyst", "cause": "looks-noisy", "affected_digests": ["0" * 64],
                            "phase": "post-unblinding", "moves_toward": "B-NOTATION"})
    handlers["mutation:scoring-post-hoc-exclusion"] = post_hoc_exclusion

    def census_undercount():
        validate_census({"scheduled_total": 312, "class_counts": {"analyzable": 300, "unanalyzable": 8, "quarantined": 3}})
    handlers["mutation:scoring-census-undercount"] = census_undercount

    def missing_pair_imputation():
        validate_paired_contrast([{"cell_id": "c1", "arms": {"LANG-A": {"burden": 1}, "SCAFFOLD": {"imputed": True}}}])
    handlers["mutation:scoring-missing-pair-imputation"] = missing_pair_imputation

    def seed_drift():
        assert_bootstrap_params(1730, 800)
    handlers["mutation:scoring-seed-drift"] = seed_drift

    def iterations_drift():
        assert_bootstrap_params(1729, 799)
    handlers["mutation:scoring-iterations-drift"] = iterations_drift

    def predicate_reencoding_drift():
        fixture = load_json(FIXTURE_DIR / "branch-null-exact.json")
        assert_delegated_branch({"rows": fixture["rows"], "gates": fixture["gates"]}, "B-NOTATION")
    handlers["mutation:scoring-predicate-reencoding-drift"] = predicate_reencoding_drift

    def classifier_order_violation():
        request = demo_request()
        response = demo_response(status="refused", refusal_text="unsafe", duplicate_envelope=True)  # real T03
        validate_classification({"state": "T09"}, request, response, "refused")
    handlers["mutation:scoring-classifier-order-violation"] = classifier_order_violation

    def denominator_shrink_on_refusal():
        result = {"state": "T10", "disposition": "SCORE-ZERO-DISCHARGE", "census_class": "analyzable",
                  "denominator_retained": False, "flags": ["refusal"]}
        validate_classification(result)
    handlers["mutation:scoring-denominator-shrink-on-refusal"] = denominator_shrink_on_refusal

    def unparseable_not_zero_discharge():
        result = {"state": "T13", "disposition": "SCORE", "census_class": "analyzable",
                  "denominator_retained": True, "flags": ["unparseable"]}
        validate_classification(result)
    handlers["mutation:scoring-unparseable-not-zero-discharge"] = unparseable_not_zero_discharge

    def duplicate_envelope_acceptance():
        result = {"state": "T03", "disposition": "SCORE", "census_class": "integrity",
                  "denominator_retained": True, "flags": ["duplicate_response"]}
        validate_classification(result)
    handlers["mutation:scoring-duplicate-envelope-acceptance"] = duplicate_envelope_acceptance

    def replay_acceptance():
        result = {"state": "T04", "disposition": "SCORE", "census_class": "integrity",
                  "denominator_retained": True, "flags": ["replayed_response"]}
        validate_classification(result)
    handlers["mutation:scoring-replay-acceptance"] = replay_acceptance

    def safety_refusal_misclass():
        request = demo_request()
        response = demo_response(status="refused", refusal_text="I can't help with that; it is harmful")  # real T09
        validate_classification({"state": "T10"}, request, response, "refused")
    handlers["mutation:scoring-safety-refusal-misclassification"] = safety_refusal_misclass

    def t99_fallthrough_failure():
        request = demo_request()
        response = demo_response(status="completed", content_units=3)  # no discharge metadata -> real T99
        validate_classification({"state": "T15"}, request, response, "answer text")
    handlers["mutation:scoring-t99-fallthrough-failure"] = t99_fallthrough_failure

    return handlers


def _validate_registry_contract(registry, handlers):
    declared = [row["id"] for row in registry.get("mutations", [])]
    if len(declared) != len(set(declared)):
        raise ScoringMutationSurvived("duplicate mutation declaration")
    if registry.get("declared_unexecuted") or registry.get("undeclared_executed"):
        raise ScoringMutationSurvived("registry carries declared/executed discrepancy")
    if set(declared) != set(handlers):
        missing = sorted(set(declared) - set(handlers))
        extra = sorted(set(handlers) - set(declared))
        raise ScoringMutationSurvived(f"declared/handler mismatch missing={missing} extra={extra}")


def _expect_failure(callable_, expected):
    try:
        callable_()
    except expected as exc:
        return exc.condition
    except Exception as exc:  # wrong condition == not a clean kill
        raise ScoringMutationSurvived(f"wrong condition {type(exc).__name__}: {exc}") from exc
    raise ScoringMutationSurvived(f"mutation survived; expected {expected.__name__}")


def execute_mutations():
    registry = load_json(MUTATION_REGISTRY_PATH)
    handlers = _mutation_handlers()
    _validate_registry_contract(registry, handlers)
    condition_by_name = {condition.__name__: condition for condition in ALL_CONDITIONS}
    results = []
    for declaration in registry["mutations"]:
        mutation_id = declaration["id"]
        expected = condition_by_name[declaration["expected_condition"]]
        observed = _expect_failure(handlers[mutation_id], expected)
        results.append({"id": mutation_id, "expected_condition": expected.__name__,
                        "observed_condition": observed, "executed": True, "killed": True})
    return results


# =========================================================================== fixtures / verify
def evaluate_fixture(fixture):
    """Return the observed outcome for a fixture, dispatched on its ``kind`` (§12)."""
    kind = fixture["kind"]
    if kind == "envelope":
        raw = fixture["raw"]
        if isinstance(raw, dict) and raw.get("__bytes_hex__"):
            raw = bytes.fromhex(raw["__bytes_hex__"])
        result = classify_envelope(fixture["request"], fixture["response"], raw)
        return {"state": result["state"], "disposition": result["disposition"],
                "census_class": result["census_class"], "denominator_retained": result["denominator_retained"]}
    if kind == "branch":
        record = run_analysis({"rows": fixture["rows"], "gates": fixture["gates"]})
        return {"banked_branch": record["delegated_banked_branch"]}
    if kind == "disagreement":
        a, b = fixture["a"], fixture["b"]
        try:
            value = bank_dimension(a, b)
        except AdjudicationRequired:
            return {"result": "adjudication-required"}
        return {"result": "banked", "decimal": canonical_decimal(value), "num": value.numerator, "den": value.denominator}
    if kind == "projection":
        projected = blinded_projection(fixture["record"], bytes.fromhex(fixture["salt_hex"]))
        concealed = sorted(key for key in fixture["record"] if _is_concealed(key))
        deterministic = projected == blinded_projection(fixture["record"], bytes.fromhex(fixture["salt_hex"]))
        blinded_ok = True
        try:
            validate_blinding(projected)
        except BlindFieldLeak:
            blinded_ok = False
        return {"concealed": concealed, "deterministic": deterministic, "blinded": blinded_ok}
    if kind == "provenance":
        try:
            validate_provenance(fixture["record"])
        except ProvenanceIncomplete:
            return {"valid": False}
        return {"valid": True}
    if kind == "scorer-packet":
        try:
            validate_scorer_packet(fixture["packet"])
        except SwappedLabelAccepted:
            return {"accepted": False}
        return {"accepted": True}
    if kind == "deviation":
        try:
            validate_deviation(fixture["deviation"])
        except PostHocExclusion:
            return {"rejected": True}
        return {"rejected": False}
    if kind == "census":
        try:
            validate_census(fixture["census"])
        except CensusUndercount:
            return {"valid": False}
        return {"valid": True}
    raise ScoringConstitutionError(f"unknown fixture kind {kind!r}")


def _run_fixture_suite():
    index = load_json(FIXTURE_DIR / "INDEX.json")
    count = 0
    for entry in index["fixtures"]:
        fixture = load_json(FIXTURE_DIR / entry["file"])
        observed = evaluate_fixture(fixture)
        expected = entry["expected_outcome"]
        for key, value in expected.items():
            if observed.get(key) != value:
                raise ScoringConstitutionError(
                    f"fixture {entry['file']} expected {key}={value!r}, observed {observed.get(key)!r}")
        count += 1
    return count


def _classifier_self_check():
    """Exercise every §3 state and confirm first-match classification (totality proof)."""
    cases = {
        "T01": (demo_request(arm="INVALID-ARM"), demo_response(), "x"),
        "T02": (demo_request(), demo_response(), b"\xff\xfe\x00"),
        "T03": (demo_request(), demo_response(duplicate_envelope=True), "dup"),
        "T04": (demo_request(), demo_response(replayed_response=True), "replay"),
        "T05": (demo_request(), demo_response(status="transport-failure"), ""),
        "T06": (demo_request(), demo_response(status="completed", anomalies=[{"type": "provider-error"}], content_units=0), ""),
        "T07": (demo_request(), demo_response(status="transport-failure", anomalies=[{"type": "timeout"}]), ""),
        "T08": (demo_request(), demo_response(tool_calls=[{"name": "search"}]), "tool"),
        "T09": (demo_request(), demo_response(status="refused", refusal_text="this is harmful"), "refused"),
        "T10": (demo_request(), demo_response(status="refused", refusal_text="I would rather not"), "no"),
        "T11": (demo_request(), demo_response(status="completed", content_units=0), ""),
        "T12": (demo_request(), demo_response(status="truncated"), "cut short"),
        "T13": (demo_request(), demo_response(status="completed", rater_unparseable=[True, True], content_units=2), "blob"),
        "T14": (demo_request(), demo_response(status="completed", opportunities={"total": 4, "discharged": 2}, content_units=4), "partial"),
        "T15": (demo_request(), demo_response(status="completed", opportunities={"total": 4, "discharged": 4}, content_units=4), "complete"),
        "T99": (demo_request(), demo_response(status="completed", content_units=3), "answer with no key metadata"),
    }
    seen = []
    for expected_state, (request, response, raw) in cases.items():
        observed = classify_envelope(request, response, raw)["state"]
        if observed != expected_state:
            raise StateMismatch(f"self-check: expected {expected_state}, got {observed}")
        seen.append(expected_state)
    return seen


def verify():
    verify_bank_binding(REPO_ROOT)
    classifier_states = _classifier_self_check()
    fixtures = _run_fixture_suite()
    mutations = execute_mutations()
    unresolved = unresolved_scoring_slots(REPO_ROOT)
    print(f"SCORING-CONSTITUTION-VERIFY: PASS classifier={len(classifier_states)} "
          f"fixtures={fixtures} mutations={len(mutations)} slots-unresolved={len(unresolved)}")
    return {"classifier": len(classifier_states), "fixtures": fixtures,
            "mutations": len(mutations), "slots_unresolved": len(unresolved)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("verify",))
    args = parser.parse_args()
    if args.command == "verify":
        verify()


if __name__ == "__main__":
    main()
