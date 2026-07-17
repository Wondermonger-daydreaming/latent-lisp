#!/usr/bin/env python3
"""run_calibration.py -- deterministic, restartable grader-calibration runner for the
Language-A Tranche B pilot (synthetic-only).

LAPIDARY (Claude Opus 4.x subagent), coordinator Claude Fable 5.
Authorization: owner-decision:gate-walk-r12-adopted-v1
  (GATE-WALK-R12; record digest sha256:fe03e898144ddc57721edc51ac074413dec27131840ec6af0ad0bc1c62035f3f).

WHAT THIS DOES
  Runs the two blind first-pass raters (GPT-family + GLM-family) over the frozen synthetic
  calibration packet, applies the constitution's disagreement/adjudication law, and computes
  per-primary-defect-family reliability (categorical agreement, Cohen's kappa, and -- when
  kappa is undefined -- Gwet's AC1 per the owner-frozen replacement rule).

BLINDING / SAFETY INVARIANTS (enforced in code, not prose)
  * Prompt assembly reads ONLY files inside packet/ and NEVER inside packet/ground-truth/.
    guarded_read() asserts this at runtime and logs every read to READ-LINEAGE.jsonl.
  * Rater-visible material is EXACTLY the constitution's §2 surface: response artifact +
    source packet + arm-neutral task statement + the key's per-opportunity relations.
    Everything else (example_id provenance, domain, ground truth, other rater's scores) is
    concealed. Prompts use a blind assignment handle, not the example_id.
  * ZERO network calls in --dry-run. The live OpenRouter path exists but is never entered by
    dry-run; this module is delivered pre-live and a separate firing agent runs it live.
  * harness/firebreak.py's validate_grader_firebreak is wired over the read log (imported
    read-only). All packet artifacts declare artifact_kind = "synthetic-calibration-example".

RELIABILITY IS COMPUTED ON FIRST PASSES ONLY. Adjudication resolves BANKED values but does
NOT enter the agreement / kappa / AC1 computation. (See compute_family_reliability + the
report.)

NUMERIC LAW (SCORING-CONSTITUTION §7). All reliability arithmetic is exact rational
(fractions.Fraction). Canonical serialization is a decimal STRING quantized to 6 fractional
digits, ROUND_HALF_EVEN, with "-0.000000" normalized to "0.000000". Threshold comparisons
(>=0.80, >=0.60) are performed on the exact rationals, never on the quantized decimals.

kappa-UNDEFINED INTERPRETATION (documented; see RUN-DESIGN.md §K). Under exact integer-count
categories, Cohen's kappa denominator (1 - pe) is zero ONLY when a single category is observed
across both raters (which also makes AC1 uncomputable). To make the owner's AC1 replacement
branch reachable at the operating point it was written for, kappa is treated as UNDEFINED under
the standard DEGENERATE-MARGINAL condition: either rater used exactly one category across all
items (zero marginal variance), OR pe == 1. AC1 is uncomputable only when the number of
categories observed across BOTH raters is < 2 (the 1/(q-1) term is undefined) -> family
INCONCLUSIVE per the owner rule.
"""
import argparse
import hashlib
import json
import os
import sys
import time
from decimal import Decimal, ROUND_HALF_EVEN
from fractions import Fraction
from pathlib import Path

# ---- Paths -----------------------------------------------------------------------------------
TOOLING_DIR = Path(__file__).resolve().parent
CALIB_ROOT = TOOLING_DIR.parent                      # evidence/grader-calibration
PACKET_DIR = (CALIB_ROOT / "packet").resolve()
GROUND_TRUTH_DIR = (PACKET_DIR / "ground-truth").resolve()
EXP_ROOT = CALIB_ROOT.parents[1]                     # experiments/language-a-exoskeleton
HARNESS_DIR = EXP_ROOT / "harness"

# Wire the frozen grader firebreak (import read-only; never modified).
sys.path.insert(0, str(HARNESS_DIR))
import firebreak  # noqa: E402  (validate_grader_firebreak, FORBIDDEN_BEFORE_SCORING)
from conditions import GraderFirebreakViolated  # noqa: E402

FAMILIES = ("unsupported_assertions", "scope_errors", "version_errors", "residue_erasures")

# §4 construct definitions -- VERBATIM. Restated to the raters with no lab context.
CONSTRUCT_DEFS = {
    "unsupported_assertions":
        "assertion not discharged by the finite source under the key's support relation",
    "scope_errors":
        "claim exceeding or misstating the key's scope boundaries",
    "version_errors":
        "claim contradicting the key's version/source-identity constraints",
    "residue_erasures":
        "genuinely-unresolved content (per key) presented as resolved, or deleted where the "
        "key requires surfacing",
}

AGREEMENT_FLOOR = Fraction(80, 100)
KAPPA_FLOOR = Fraction(60, 100)
AC1_FLOOR = Fraction(60, 100)
RETRY_CEILING = 2  # retries after the first attempt, then UNANALYZABLE-CENSUS
DEFAULT_MAX_TOKENS = 1024
BLIND_SALT = "lae-grader-calibration-v1"


# ---- small helpers ---------------------------------------------------------------------------
def sha256_hex(data):
    if isinstance(data, str):
        data = data.encode("utf-8")
    return hashlib.sha256(data).hexdigest()


def canonical_bytes(value):
    return (json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n").encode("utf-8")


def dec6(frac):
    """Exact Fraction -> 6-digit ROUND_HALF_EVEN decimal string; -0.000000 normalized."""
    d = Decimal(frac.numerator) / Decimal(frac.denominator)
    q = d.quantize(Decimal("0.000001"), rounding=ROUND_HALF_EVEN)
    s = f"{q:.6f}"
    return "0.000000" if s == "-0.000000" else s


def append_jsonl(path, row):
    with Path(path).open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(row, sort_keys=True, ensure_ascii=False) + "\n")


def read_jsonl(path):
    p = Path(path)
    if not p.exists():
        return []
    out = []
    with p.open("r", encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if line:
                out.append(json.loads(line))
    return out


def write_new_bytes(path, data):
    p = Path(path)
    if p.exists():
        raise FileExistsError(f"refusing to overwrite {p}")
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_bytes(data)


def blind_handle(example_id):
    return "ASG-" + sha256_hex(example_id + "|" + BLIND_SALT)[:12]


# ---- guarded prompt-assembly reads -----------------------------------------------------------
def guarded_read(path, reader, purpose, artifact_kind, lineage_path):
    """Read a file for prompt assembly, asserting it is inside packet/ and NOT inside
    packet/ground-truth/, and logging the read to READ-LINEAGE.jsonl."""
    p = Path(path).resolve()
    packet_prefix = str(PACKET_DIR) + os.sep
    gt_prefix = str(GROUND_TRUTH_DIR) + os.sep
    if not str(p).startswith(packet_prefix):
        raise AssertionError(f"prompt-assembly read outside packet dir: {p}")
    if str(p).startswith(gt_prefix):
        raise AssertionError(f"prompt-assembly read of author-only ground truth forbidden: {p}")
    data = p.read_bytes()
    digest = sha256_hex(data)
    entry = {
        "read_id": "READ-" + sha256_hex(f"{reader}|{p}|{purpose}|{time.time_ns()}")[:16],
        "reader": reader,
        "artifact_id": p.name,          # firebreak lookup key
        "artifact_kind": artifact_kind,
        "purpose": purpose,
        "path": str(p),
        "sha256": digest,
        "ts": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
    }
    append_jsonl(lineage_path, entry)
    return data, entry


def load_example(example_id, reader, lineage_path):
    path = PACKET_DIR / f"{example_id}.json"
    data, entry = guarded_read(path, reader, "assemble-rater-visible-material",
                               "synthetic-calibration-example", lineage_path)
    return json.loads(data), entry


def project_rater_visible(example):
    """Constitution §2 projection: exactly response + source packet + arm-neutral task +
    the key's per-opportunity relations. Everything else concealed."""
    opps = [
        {
            "opportunity_id": o["opportunity_id"],
            "answerable_requirement": o["answerable_requirement"],
            "minimum_discharge_relation": o["minimum_discharge_relation"],
        }
        for o in example["key"]["opportunities"]
    ]
    return {
        "task_statement": example["task_statement"],
        "source_packet": example["source_packet"],
        "response_artifact": example["response_artifact"],
        "key": {"scorable_opportunities": example["key"]["scorable_opportunities"],
                "opportunities": opps},
    }


# ---- grading instruction (self-contained; no lab context, no persona) ------------------------
def build_grading_prompt(assignment_id, material):
    defs = "\n".join(f'  - {fam}: {CONSTRUCT_DEFS[fam]}' for fam in FAMILIES)
    system = (
        "You are a careful grader. You are given a finite SOURCE, an arm-neutral TASK, a "
        "RESPONSE, and a KEY listing scorable opportunities with their answerable requirement "
        "and minimum-discharge relation. Judge the RESPONSE using ONLY the SOURCE and the KEY. "
        "Count, as a non-negative integer per dimension summed over the key's opportunities, "
        "each instance of the following four defect constructs:\n"
        f"{defs}\n"
        "Rules: The KEY states each opportunity's requirement; it does NOT tell you what the "
        "response did -- you determine that. If a requirement about unresolved/unstated content "
        "is met (the response surfaces it as unstated/unresolved), that is NOT a residue "
        "erasure. Do not invent categories. Base every count on the source and the key only.\n"
        "OUTPUT: strict JSON, no prose outside it, with exactly these keys: "
        '{"unsupported_assertions": int, "scope_errors": int, "version_errors": int, '
        '"residue_erasures": int, "unparseable_mark": bool, "per_opportunity_justification": '
        'string}. Set unparseable_mark true only if the response cannot be segmented under the '
        "key at all. Keep the justification brief."
    )
    user = (
        f"ASSIGNMENT {assignment_id}\n\n"
        f"TASK:\n{material['task_statement']}\n\n"
        f"SOURCE:\n{material['source_packet']}\n\n"
        f"RESPONSE:\n{material['response_artifact']}\n\n"
        f"KEY (scorable_opportunities={material['key']['scorable_opportunities']}):\n"
        + json.dumps(material["key"]["opportunities"], ensure_ascii=False, indent=2)
        + "\n\nReturn the strict JSON object now."
    )
    return system, user


def build_adjudication_prompt(assignment_id, material, disputed_dimensions, values_by_dim):
    defs = "\n".join(f'  - {fam}: {CONSTRUCT_DEFS[fam]}' for fam in FAMILIES)
    dispute_lines = []
    for dim in disputed_dimensions:
        a, b = values_by_dim[dim]
        dispute_lines.append(f'  - {dim}: RATER-A={a}, RATER-B={b}')
    system = (
        "You are a fresh adjudicator. You are given a SOURCE, an arm-neutral TASK, a RESPONSE, "
        "and a KEY, plus two anonymous first-pass counts (RATER-A, RATER-B) that disagree by "
        "more than one on the disputed dimension(s). Independently determine the correct integer "
        "count for each disputed dimension using ONLY the source and the key. The four "
        "constructs:\n" f"{defs}\n"
        "OUTPUT: strict JSON with exactly the disputed dimension names as keys mapping to your "
        'integer count, plus a key "justification" (brief string).'
    )
    user = (
        f"ASSIGNMENT {assignment_id}\n\n"
        f"TASK:\n{material['task_statement']}\n\n"
        f"SOURCE:\n{material['source_packet']}\n\n"
        f"RESPONSE:\n{material['response_artifact']}\n\n"
        f"KEY:\n" + json.dumps(material["key"]["opportunities"], ensure_ascii=False, indent=2)
        + "\n\nDISPUTED FIRST-PASS COUNTS:\n" + "\n".join(dispute_lines)
        + "\n\nReturn the strict JSON object now."
    )
    return system, user


# ---- parsing ---------------------------------------------------------------------------------
def parse_rater_json(text, dimensions):
    """Return (counts_dict, unparseable_mark) or raise ValueError."""
    obj = _extract_json(text)
    counts = {}
    for dim in dimensions:
        if dim not in obj:
            raise ValueError(f"missing dimension {dim}")
        v = obj[dim]
        if isinstance(v, bool) or not isinstance(v, int) or v < 0:
            raise ValueError(f"dimension {dim} not a non-negative integer: {v!r}")
        counts[dim] = v
    return counts, bool(obj.get("unparseable_mark", False))


def parse_adjudicator_json(text, disputed_dimensions):
    obj = _extract_json(text)
    out = {}
    for dim in disputed_dimensions:
        if dim not in obj:
            raise ValueError(f"adjudicator missing dimension {dim}")
        v = obj[dim]
        if isinstance(v, bool) or not isinstance(v, int) or v < 0:
            raise ValueError(f"adjudicator dimension {dim} not a non-negative integer: {v!r}")
        out[dim] = v
    return out


def _extract_json(text):
    text = text.strip()
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        start = text.find("{")
        end = text.rfind("}")
        if start == -1 or end == -1 or end <= start:
            raise ValueError("no JSON object found in output")
        return json.loads(text[start:end + 1])


# ---- providers -------------------------------------------------------------------------------
class LiveOpenRouterProvider:
    """OpenRouter chat-completions provider. NEVER entered by --dry-run. This module is
    delivered pre-live; a separate firing agent runs it live."""

    def __init__(self, api_key):
        self.api_key = api_key
        self.endpoint = "https://openrouter.ai/api/v1/chat/completions"

    def call(self, model, system, user, max_tokens):
        import urllib.request  # local import: never reached in dry-run
        payload = {
            "model": model,
            "messages": [{"role": "system", "content": system},
                         {"role": "user", "content": user}],
            "temperature": 0,
            "max_tokens": max_tokens,
        }
        body = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(self.endpoint, data=body, method="POST")
        req.add_header("Authorization", f"Bearer {self.api_key}")
        req.add_header("Content-Type", "application/json")
        with urllib.request.urlopen(req, timeout=120) as resp:
            raw = resp.read().decode("utf-8")
        response_obj = json.loads(raw)
        content = response_obj["choices"][0]["message"]["content"]
        # Redact the key from the recorded request envelope.
        recorded_request = dict(payload)
        return content, {"request": recorded_request, "response": response_obj}


class ShamProvider:
    """Deterministic offline provider for --dry-run. Its canned answers are seeded by a
    test-only oracle (see build_sham_oracle) that reads ground truth DIRECTLY -- this is
    explicit test scaffolding OUTSIDE the guarded prompt-assembly path. Real raters never
    see ground truth; the guarded path (guarded_read) is what enforces blindness, and it is
    exercised identically in dry-run."""

    def __init__(self, oracle):
        self.oracle = oracle  # dict: (assignment_id, role) -> counts dict (or adj dict)

    def call(self, model, system, user, max_tokens):
        assignment_id = _assignment_from_prompt(user)
        role = model  # in dry-run the "model" string is the sham role tag
        key = (assignment_id, role)
        if key not in self.oracle:
            raise RuntimeError(f"sham oracle missing {key}")
        answer = self.oracle[key]
        content = json.dumps(answer)
        recorded_request = {"model": model, "temperature": 0, "max_tokens": max_tokens,
                            "messages_sha256": sha256_hex(system + "\x00" + user)}
        response_obj = {"sham": True, "choices": [{"message": {"content": content}}]}
        return content, {"request": recorded_request, "response": response_obj}


def _assignment_from_prompt(user):
    # Prompts begin with "ASSIGNMENT ASG-xxxx".
    first = user.strip().splitlines()[0]
    return first.replace("ASSIGNMENT", "").strip()


# ---- one guarded call with retry + raw-envelope persistence ----------------------------------
def do_call(provider, model, system, user, raw_dir, assignment_id, role, attempt_prefix):
    """Return (parsed_content_text, attempt_used) or ('CENSUS', None) after the retry ceiling.
    Every attempt writes a NEW raw envelope; never overwrites."""
    last_err = None
    for attempt in range(RETRY_CEILING + 1):
        try:
            content, envelope = provider.call(model, system, user, DEFAULT_MAX_TOKENS)
            raw_path = raw_dir / f"{attempt_prefix}-attempt{attempt}.json"
            write_new_bytes(raw_path, canonical_bytes({
                "assignment_id": assignment_id, "role": role, "attempt": attempt,
                "model": model, "envelope": envelope,
            }))
            return content, attempt
        except FileExistsError:
            raise
        except Exception as exc:  # transport/parse/etc -> new linked attempt
            last_err = str(exc)
            # record the failed attempt envelope too (never silently drop)
            raw_path = raw_dir / f"{attempt_prefix}-attempt{attempt}-ERROR.json"
            try:
                write_new_bytes(raw_path, canonical_bytes({
                    "assignment_id": assignment_id, "role": role, "attempt": attempt,
                    "model": model, "error": last_err,
                }))
            except FileExistsError:
                pass
    return "CENSUS", None


# ---- reliability math (exact rationals) ------------------------------------------------------
def compute_family_reliability(pairs):
    """pairs: list of (a, b) FIRST-PASS integer counts for one dimension across examples.
    Returns a dict of exact-rational + decimal-string reliability and an eligibility verdict.
    FIRST PASSES ONLY -- adjudication does not enter here."""
    n = len(pairs)
    a_counts = [a for a, _ in pairs]
    b_counts = [b for _, b in pairs]
    agree = sum(1 for a, b in pairs if a == b)
    agreement = Fraction(agree, n)

    categories = sorted(set(a_counts) | set(b_counts))
    q = len(categories)

    def freq(counts, c):
        return Fraction(sum(1 for x in counts if x == c), n)

    # Cohen expected agreement pe = sum_c p_a(c) p_b(c)
    pe = sum((freq(a_counts, c) * freq(b_counts, c) for c in categories), Fraction(0))
    degenerate_a = len(set(a_counts)) == 1
    degenerate_b = len(set(b_counts)) == 1
    kappa_undefined = degenerate_a or degenerate_b or pe == 1

    result = {
        "n": n,
        "agreement": agreement,
        "categories": categories,
        "q": q,
        "pe_cohen": pe,
        "degenerate_marginal_rater_a": degenerate_a,
        "degenerate_marginal_rater_b": degenerate_b,
    }

    if not kappa_undefined:
        kappa = (agreement - pe) / (1 - pe)
        result["kappa_defined"] = True
        result["kappa"] = kappa
        result["ac1"] = None
        eligible = (agreement >= AGREEMENT_FLOOR) and (kappa >= KAPPA_FLOOR)
        result["verdict"] = "ELIGIBLE" if eligible else "NOT-ELIGIBLE"
        result["verdict_basis"] = "agreement>=0.80 AND kappa>=0.60"
    else:
        result["kappa_defined"] = False
        result["kappa"] = None
        if q < 2:
            result["ac1"] = None
            result["ac1_uncomputable"] = True
            result["verdict"] = "INCONCLUSIVE"
            result["verdict_basis"] = ("kappa undefined AND AC1 uncomputable (single observed "
                                       "category) -> owner rule: calibration-INCONCLUSIVE")
        else:
            # Gwet's AC1 (multi-category): pe_gamma = 1/(q-1) * sum_c pi_c (1-pi_c),
            # pi_c = mean marginal proportion.
            pe_gamma = Fraction(0)
            for c in categories:
                pi_c = (freq(a_counts, c) + freq(b_counts, c)) / 2
                pe_gamma += pi_c * (1 - pi_c)
            pe_gamma = pe_gamma / (q - 1)
            ac1 = (agreement - pe_gamma) / (1 - pe_gamma)
            result["ac1_uncomputable"] = False
            result["pe_gamma"] = pe_gamma
            result["ac1"] = ac1
            eligible = (agreement >= AGREEMENT_FLOOR) and (ac1 >= AC1_FLOOR)
            result["verdict"] = "ELIGIBLE" if eligible else "NOT-ELIGIBLE"
            result["verdict_basis"] = ("kappa undefined (degenerate marginal) -> owner rule: "
                                       "agreement>=0.80 AND Gwet AC1>=0.60")
    return result


def serialize_reliability(r):
    """Canonical record: decimal strings for every quantity; keeps exact num/den beside each."""
    def pack(frac):
        if frac is None:
            return None
        return {"decimal": dec6(frac), "num": frac.numerator, "den": frac.denominator}
    out = {
        "n": r["n"],
        "categories": r["categories"],
        "q": r["q"],
        "agreement": pack(r["agreement"]),
        "pe_cohen": pack(r["pe_cohen"]),
        "kappa_defined": r["kappa_defined"],
        "kappa": pack(r.get("kappa")),
        "ac1": pack(r.get("ac1")),
        "degenerate_marginal_rater_a": r["degenerate_marginal_rater_a"],
        "degenerate_marginal_rater_b": r["degenerate_marginal_rater_b"],
        "verdict": r["verdict"],
        "verdict_basis": r["verdict_basis"],
    }
    if "pe_gamma" in r:
        out["pe_gamma"] = pack(r["pe_gamma"])
    if "ac1_uncomputable" in r:
        out["ac1_uncomputable"] = r["ac1_uncomputable"]
    return out


# ---- banking law (constitution §4) -----------------------------------------------------------
def bank_dimension(a, b, adjudicated_value=None):
    """Return (banked Fraction, needs_adjudication bool, mode str)."""
    if adjudicated_value is not None:
        return Fraction(adjudicated_value), False, "adjudicated"
    if a == b:
        return Fraction(a), False, "agree"
    if abs(a - b) == 1:
        return Fraction(a + b, 2), False, "mean"
    return None, True, "requires-adjudication"


# ================================ ORCHESTRATION ===============================================
def run(args):
    mode = "dry-run" if args.dry_run else "live"
    out_dir = Path(args.out_dir).resolve()
    raw_dir = out_dir / "raw"
    out_dir.mkdir(parents=True, exist_ok=True)
    raw_dir.mkdir(parents=True, exist_ok=True)
    lineage_path = out_dir / "READ-LINEAGE.jsonl"
    first_pass_path = out_dir / "FIRST-PASSES.jsonl"
    adjudication_path = out_dir / "ADJUDICATIONS.jsonl"
    banked_path = out_dir / "BANKED-SCORES.jsonl"
    assignment_map_path = out_dir / "ASSIGNMENT-MAP.json"  # author/freezer side, NOT a prompt
    report_path = out_dir / "CALIBRATION-REPORT.json"

    example_ids = sorted(p.stem for p in PACKET_DIR.glob("EXAMPLE-*.json"))
    if not example_ids:
        raise SystemExit("no packet examples found")

    # providers + rater identities
    if mode == "dry-run":
        oracle = build_sham_oracle(example_ids)
        provider = ShamProvider(oracle)
        rater_a_model, rater_b_model, adj_model = "SHAM-RATER-A", "SHAM-RATER-B", "SHAM-ADJ"
    else:
        api_key = os.environ.get("OPENROUTER_API_KEY")
        if not api_key:
            raise SystemExit("OPENROUTER_API_KEY not set (live mode)")
        provider = LiveOpenRouterProvider(api_key)
        rater_a_model = args.rater_a_model or _require("--rater-a-model")
        rater_b_model = args.rater_b_model or _require("--rater-b-model")
        adj_model = args.adjudicator_model or _require("--adjudicator-model")

    rater_a_id = f"grader:rater-a:{rater_a_model}"
    rater_b_id = f"grader:rater-b:{rater_b_model}"
    adj_id = f"grader:adjudicator:{adj_model}"

    # restart state
    done_first = {(r["example_id"], r["role"]): r for r in read_jsonl(first_pass_path)}
    done_adj = {r["example_id"]: r for r in read_jsonl(adjudication_path)}

    assignment_map = {}
    for eid in example_ids:
        assignment_map[eid] = blind_handle(eid)

    # ---- FIRST PASSES (two blind raters, independent) ----
    for eid in example_ids:
        asg = assignment_map[eid]
        for role, model, reader in (("rater-a", rater_a_model, rater_a_id),
                                    ("rater-b", rater_b_model, rater_b_id)):
            if (eid, role) in done_first:
                continue
            example, _ = load_example(eid, reader, lineage_path)
            material = project_rater_visible(example)
            system, user = build_grading_prompt(asg, material)
            content, attempt = do_call(provider, model, system, user, raw_dir, asg, role,
                                       f"{asg}-{role}")
            row = {"example_id": eid, "assignment_id": asg, "role": role, "model": model}
            if content == "CENSUS":
                row.update({"disposition": "UNANALYZABLE-CENSUS", "counts": None,
                            "unparseable_mark": None})
            else:
                try:
                    counts, unparseable = parse_rater_json(content, FAMILIES)
                    row.update({"disposition": "SCORED", "counts": counts,
                                "unparseable_mark": unparseable})
                except ValueError as exc:
                    row.update({"disposition": "UNANALYZABLE-CENSUS", "counts": None,
                                "parse_error": str(exc)})
            append_jsonl(first_pass_path, row)
            done_first[(eid, role)] = row

    # ---- DISAGREEMENT / ADJUDICATION / BANKING ----
    banked_rows = []
    adjudication_count = 0
    census_examples = set()
    for eid in example_ids:
        asg = assignment_map[eid]
        a_row = done_first[(eid, "rater-a")]
        b_row = done_first[(eid, "rater-b")]
        if a_row["disposition"] != "SCORED" or b_row["disposition"] != "SCORED":
            census_examples.add(eid)
            banked_rows.append({"example_id": eid, "disposition": "UNANALYZABLE-CENSUS"})
            continue
        a_counts, b_counts = a_row["counts"], b_row["counts"]
        disputed = [d for d in FAMILIES if abs(a_counts[d] - b_counts[d]) > 1]
        adj_values = {}
        if disputed:
            if eid in done_adj:
                adj_values = done_adj[eid]["values"]
            else:
                # load rater-visible material fresh for the adjudicator (guarded read)
                example, _ = load_example(eid, adj_id, lineage_path)
                material = project_rater_visible(example)
                values_by_dim = {d: (a_counts[d], b_counts[d]) for d in disputed}
                system, user = build_adjudication_prompt(asg, material, disputed, values_by_dim)
                content, attempt = do_call(provider, adj_model, system, user, raw_dir, asg,
                                           "adjudicator", f"{asg}-adjudicator")
                if content == "CENSUS":
                    census_examples.add(eid)
                    banked_rows.append({"example_id": eid, "disposition": "UNANALYZABLE-CENSUS",
                                        "note": "adjudication call censused"})
                    append_jsonl(adjudication_path,
                                 {"example_id": eid, "disposition": "CENSUS", "values": {}})
                    continue
                adj_values = parse_adjudicator_json(content, disputed)
                append_jsonl(adjudication_path,
                             {"example_id": eid, "disputed": disputed, "values": adj_values})
                done_adj[eid] = {"example_id": eid, "values": adj_values}
            adjudication_count += 1
        banked = {}
        modes = {}
        for d in FAMILIES:
            adj_v = adj_values.get(d) if d in disputed else None
            value, needs_adj, bmode = bank_dimension(a_counts[d], b_counts[d], adj_v)
            banked[d] = dec6(value) if value is not None else None
            modes[d] = bmode
        banked_rows.append({
            "example_id": eid, "disposition": "SCORED",
            "first_pass_a": a_counts, "first_pass_b": b_counts,
            "banked": banked, "bank_mode": modes, "disputed_dimensions": disputed,
        })

    # persist banked (append-only, fresh each run only if not present)
    if not banked_path.exists():
        for row in banked_rows:
            append_jsonl(banked_path, row)

    # ---- RELIABILITY ON FIRST PASSES ONLY ----
    family_reports = {}
    for d in FAMILIES:
        pairs = []
        for eid in example_ids:
            if eid in census_examples:
                continue
            a_row = done_first[(eid, "rater-a")]
            b_row = done_first[(eid, "rater-b")]
            pairs.append((a_row["counts"][d], b_row["counts"][d]))
        family_reports[d] = serialize_reliability(compute_family_reliability(pairs))

    # ---- FIREBREAK over the read log ----
    firebreak_result = wire_firebreak(lineage_path, rater_a_id, rater_b_id, adj_id)

    # ---- REPORT ----
    overall = "ELIGIBLE" if all(fr["verdict"] == "ELIGIBLE" for fr in family_reports.values()) \
        else ("INCONCLUSIVE" if any(fr["verdict"] == "INCONCLUSIVE" for fr in family_reports.values())
              else "NOT-ELIGIBLE")
    report = {
        "schema": "lae-grader-calibration-report/1.0.0",
        "mode": mode,
        "authorization": "owner-decision:gate-walk-r12-adopted-v1",
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "raters": {"rater_a": rater_a_id, "rater_b": rater_b_id, "adjudicator": adj_id},
        "n_examples": len(example_ids),
        "n_census": len(census_examples),
        "adjudication_count": adjudication_count,
        "reliability_basis": "FIRST PASSES ONLY -- adjudication resolves banked values but does "
                             "NOT enter agreement/kappa/AC1.",
        "floors": {"agreement": "0.80", "kappa": "0.60", "ac1": "0.60"},
        "per_family": family_reports,
        "overall_calibration": overall,
        "firebreak": firebreak_result,
        "kappa_undefined_rule": "owner-decision:scoring-r1-adopted-v1 (agreement>=0.80 AND Gwet "
                                "AC1>=0.60 where kappa undefined; AC1 uncomputable -> INCONCLUSIVE)",
    }
    write_new_bytes(assignment_map_path, canonical_bytes(assignment_map)) if not \
        assignment_map_path.exists() else None
    if report_path.exists():
        report_path.unlink()  # report is a derived summary; safe to regenerate
    report_path.write_bytes(canonical_bytes(report))
    return report


def _require(flag):
    raise SystemExit(f"live mode requires {flag}")


def wire_firebreak(lineage_path, rater_a_id, rater_b_id, adj_id):
    reads = read_jsonl(lineage_path)
    actors = [
        {"actor_id": rater_a_id, "role": ["primary-grader"]},
        {"actor_id": rater_b_id, "role": ["primary-grader"]},
        {"actor_id": adj_id, "role": ["primary-grader"]},
    ]
    artifacts = {}
    fb_reads = []
    for r in reads:
        artifacts[r["artifact_id"]] = {"artifact_id": r["artifact_id"],
                                       "artifact_kind": r["artifact_kind"]}
        fb_reads.append({"read_id": r["read_id"], "reader": r["reader"],
                         "artifact_id": r["artifact_id"], "purpose": r["purpose"]})
    try:
        firebreak.validate_grader_firebreak(actors, list(artifacts.values()), fb_reads)
        return {"status": "PASS", "reads_checked": len(fb_reads),
                "artifact_kinds": sorted({a["artifact_kind"] for a in artifacts.values()})}
    except GraderFirebreakViolated as exc:
        return {"status": "VIOLATION", "detail": str(exc)}


# ================================ DRY-RUN ORACLE + SELF-TESTS ==================================
# TEST-ONLY oracle: reads ground truth DIRECTLY (outside the guarded prompt path) to simulate
# competent raters (planted-signal recovery). NEVER used in live mode.
SHAM_PERTURB = {
    # example_id -> (dimension, delta applied to rater-B relative to ground truth)
    "EXAMPLE-13": ("unsupported_assertions", +1),   # |a-b|=1 -> banked mean
    "EXAMPLE-18": ("scope_errors", +1),             # |a-b|=1 -> banked mean
    "EXAMPLE-20": ("residue_erasures", -2),         # |a-b|=2 -> ADJUDICATION (proof a)
    "EXAMPLE-27": ("version_errors", +1),           # |a-b|=1 -> banked mean
}


def _read_ground_truth(example_id):
    p = GROUND_TRUTH_DIR / f"{example_id}.gt.json"
    return json.loads(p.read_bytes())["ground_truth"]["planted_counts"]


def build_sham_oracle(example_ids):
    oracle = {}
    for eid in example_ids:
        asg = blind_handle(eid)
        planted = _read_ground_truth(eid)
        # Rater A: exact planted counts.
        oracle[(asg, "SHAM-RATER-A")] = dict(planted, unparseable_mark=False,
                                             per_opportunity_justification="sham-A")
        # Rater B: planted + deterministic perturbation.
        b_counts = dict(planted)
        if eid in SHAM_PERTURB:
            dim, delta = SHAM_PERTURB[eid]
            b_counts[dim] = max(0, b_counts[dim] + delta)
        oracle[(asg, "SHAM-RATER-B")] = dict(b_counts, unparseable_mark=False,
                                             per_opportunity_justification="sham-B")
        # Adjudicator: only reached for EXAMPLE-20/residue_erasures; return the planted truth (4).
        if eid in SHAM_PERTURB and abs(planted[SHAM_PERTURB[eid][0]]
                                       - oracle[(asg, "SHAM-RATER-B")][SHAM_PERTURB[eid][0]]) > 1:
            dim = SHAM_PERTURB[eid][0]
            oracle[(asg, "SHAM-ADJ")] = {dim: planted[dim], "justification": "sham-adj"}
    return oracle


def selftests():
    """Constructed-table proofs (b),(c),(d) + teeth checks. Each returns (name, ok, detail)."""
    results = []

    # (b) planted-signal kappa recovery. Hand computation in this comment:
    #   pairs: (0,0)x4, (1,1)x3, (2,2)x1, (1,2)x1, (0,1)x1  (N=10)
    #   po = agreement = 8/10 = 4/5
    #   marginals A: {0:5, 1:4, 2:1}/10 ; B: {0:4, 1:4, 2:2}/10
    #   pe = (5*4 + 4*4 + 1*2)/100 = 38/100 = 19/50
    #   kappa = (4/5 - 19/50)/(1 - 19/50) = (21/50)/(31/50) = 21/31
    a = [0, 0, 0, 0, 1, 1, 1, 2, 1, 0]
    b = [0, 0, 0, 0, 1, 1, 1, 2, 2, 1]
    r = compute_family_reliability(list(zip(a, b)))
    ok = r["kappa_defined"] and r["kappa"] == Fraction(21, 31) and r["agreement"] == Fraction(4, 5)
    results.append(("proof_b_kappa_hand_computed", ok,
                    {"kappa": dec6(r["kappa"]), "expected": dec6(Fraction(21, 31)),
                     "agreement": dec6(r["agreement"])}))

    # (c) degenerate-marginal -> AC1 replacement path. Hand computation:
    #   rater A all 0 (degenerate), rater B: eight 0s + two 1s (N=10)
    #   agreement = 8/10 = 4/5 ; q=2
    #   pi_0 = (10+8)/20 = 9/10 ; pi_1 = (0+2)/20 = 1/10
    #   pe_gamma = 1/(q-1) * [pi_0(1-pi_0) + pi_1(1-pi_1)] = (9/10)(1/10)+(1/10)(9/10) = 18/100 = 9/50
    #   AC1 = (4/5 - 9/50)/(1 - 9/50) = (31/50)/(41/50) = 31/41
    a2 = [0] * 10
    b2 = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
    r2 = compute_family_reliability(list(zip(a2, b2)))
    ok2 = ((not r2["kappa_defined"]) and r2["degenerate_marginal_rater_a"]
           and r2.get("ac1_uncomputable") is False and r2["ac1"] == Fraction(31, 41)
           and r2["verdict"] == "ELIGIBLE")
    results.append(("proof_c_degenerate_marginal_ac1_path", ok2,
                    {"kappa_defined": r2["kappa_defined"], "ac1": dec6(r2["ac1"]),
                     "expected_ac1": dec6(Fraction(31, 41)), "verdict": r2["verdict"]}))

    # (c-bonus) single category q<2 -> AC1 uncomputable -> INCONCLUSIVE
    r3 = compute_family_reliability([(0, 0)] * 8)
    ok3 = ((not r3["kappa_defined"]) and r3.get("ac1_uncomputable") is True
           and r3["verdict"] == "INCONCLUSIVE")
    results.append(("proof_c_bonus_single_category_inconclusive", ok3,
                    {"q": r3["q"], "verdict": r3["verdict"]}))

    # (d) no-signal -> chance-level kappa == 0. Hand computation:
    #   A=[0,0,0,0,1,1,1,1], B=[0,0,1,1,0,0,1,1]; po=4/8=1/2; pe=1/2; kappa=0
    a4 = [0, 0, 0, 0, 1, 1, 1, 1]
    b4 = [0, 0, 1, 1, 0, 0, 1, 1]
    r4 = compute_family_reliability(list(zip(a4, b4)))
    ok4 = r4["kappa_defined"] and r4["kappa"] == Fraction(0) and r4["verdict"] == "NOT-ELIGIBLE"
    results.append(("proof_d_no_signal_chance_kappa_zero", ok4,
                    {"kappa": dec6(r4["kappa"]), "verdict": r4["verdict"]}))

    # teeth 1: firebreak fires on a forbidden target-kind read by a primary grader.
    try:
        firebreak.validate_grader_firebreak(
            [{"actor_id": "grader:x", "role": ["primary-grader"]}],
            [{"artifact_id": "T", "artifact_kind": "target-item"}],
            [{"read_id": "R1", "reader": "grader:x", "artifact_id": "T",
              "purpose": "assemble-rater-visible-material"}],
        )
        teeth1 = False
    except GraderFirebreakViolated:
        teeth1 = True
    results.append(("teeth_firebreak_fires_on_forbidden_kind", teeth1, {}))

    # teeth 2: guarded_read refuses a ground-truth path.
    tmp_lineage = CALIB_ROOT / "dry-run" / "_teeth-lineage.jsonl"
    tmp_lineage.parent.mkdir(parents=True, exist_ok=True)
    gt_example = sorted(GROUND_TRUTH_DIR.glob("EXAMPLE-*.gt.json"))
    teeth2 = False
    if gt_example:
        try:
            guarded_read(gt_example[0], "grader:x", "assemble", "x", tmp_lineage)
        except AssertionError:
            teeth2 = True
    if tmp_lineage.exists():
        tmp_lineage.unlink()
    results.append(("teeth_guarded_read_refuses_ground_truth", teeth2, {}))

    return results


def run_dry(args):
    dry_dir = CALIB_ROOT / "dry-run"
    dry_dir.mkdir(parents=True, exist_ok=True)
    # Clean prior dry-run derived state so the run is deterministic/restartable-from-clean.
    for name in ("READ-LINEAGE.jsonl", "FIRST-PASSES.jsonl", "ADJUDICATIONS.jsonl",
                 "BANKED-SCORES.jsonl", "ASSIGNMENT-MAP.json", "CALIBRATION-REPORT.json"):
        p = dry_dir / name
        if p.exists():
            p.unlink()
    raw = dry_dir / "raw"
    if raw.exists():
        for f in raw.glob("*"):
            f.unlink()

    args.out_dir = str(dry_dir)
    report = run(args)

    st = selftests()
    # end-to-end assertions on the 32-example sham run (proof a lives here + plumbing).
    e2e = []
    e2e.append(("e2e_all_examples_scored", report["n_census"] == 0,
                {"n_census": report["n_census"]}))
    e2e.append(("proof_a_exactly_one_adjudication_routed", report["adjudication_count"] == 1,
                {"adjudication_count": report["adjudication_count"]}))
    adj_rows = read_jsonl(dry_dir / "ADJUDICATIONS.jsonl")
    proof_a_target = (len(adj_rows) == 1 and adj_rows[0]["example_id"] == "EXAMPLE-20"
                      and adj_rows[0]["disputed"] == ["residue_erasures"])
    e2e.append(("proof_a_adjudication_is_planted_disagreement", proof_a_target,
                {"adjudications": adj_rows}))
    e2e.append(("e2e_firebreak_pass", report["firebreak"]["status"] == "PASS",
                report["firebreak"]))
    e2e.append(("e2e_overall_eligible", report["overall_calibration"] == "ELIGIBLE",
                {"overall": report["overall_calibration"]}))
    # confirm reliability is first-pass-only: RE agreement reflects (4 vs 2) mismatch on E20,
    # i.e. adjudication did NOT overwrite the first-pass pair used for reliability.
    re_report = report["per_family"]["residue_erasures"]
    fp_only = re_report["agreement"]["num"] == 31 and re_report["agreement"]["den"] == 32
    e2e.append(("e2e_reliability_first_pass_only", fp_only,
                {"residue_erasures_agreement": re_report["agreement"]["decimal"]}))

    all_checks = st + e2e
    passed = all(ok for _, ok, _ in all_checks)
    summary = {
        "schema": "lae-grader-calibration-dryrun-summary/1.0.0",
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "overall": "PASS" if passed else "FAIL",
        "required_proof_points": {
            "a_disagreement_routes_to_adjudicator":
                _lookup(all_checks, "proof_a_adjudication_is_planted_disagreement"),
            "b_planted_kappa_matches_hand_computation":
                _lookup(all_checks, "proof_b_kappa_hand_computed"),
            "c_degenerate_marginal_triggers_ac1_path":
                _lookup(all_checks, "proof_c_degenerate_marginal_ac1_path"),
            "d_no_signal_chance_level":
                _lookup(all_checks, "proof_d_no_signal_chance_kappa_zero"),
        },
        "checks": [{"name": n, "pass": ok, "detail": d} for n, ok, d in all_checks],
        "calibration_report_verdict": report["overall_calibration"],
    }
    (dry_dir / "DRY-RUN-SUMMARY.json").write_bytes(canonical_bytes(summary))
    print(json.dumps(summary, indent=2))
    if not passed:
        raise SystemExit(1)


def _lookup(checks, name):
    for n, ok, _ in checks:
        if n == name:
            return ok
    return None


def main():
    ap = argparse.ArgumentParser(description="Language-A grader-calibration runner (synthetic-only).")
    ap.add_argument("--dry-run", action="store_true", help="offline sham run + self-tests")
    ap.add_argument("--rater-a-model", default=None, help="OpenRouter id for GPT-family rater")
    ap.add_argument("--rater-b-model", default=None, help="OpenRouter id for GLM-family rater")
    ap.add_argument("--adjudicator-model", default=None, help="OpenRouter id for DeepSeek-family adjudicator")
    ap.add_argument("--out-dir", default=str(CALIB_ROOT), help="live output dir (default: calibration root)")
    args = ap.parse_args()
    if args.dry_run:
        run_dry(args)
    else:
        report = run(args)
        print(json.dumps({"overall_calibration": report["overall_calibration"],
                          "per_family": {k: v["verdict"] for k, v in report["per_family"].items()},
                          "adjudication_count": report["adjudication_count"],
                          "firebreak": report["firebreak"]["status"]}, indent=2))


if __name__ == "__main__":
    main()
