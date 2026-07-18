"""Live-capable successor emission runner for the Language-A 312-emission run.

ADDITIVE SUCCESSOR construction, REPAIRED to the single OpenRouter route under
ruling R15 (operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json;
R14's emission clause expired by its own route-change condition, its construction
and receipts-before-contact requirements carried forward unchanged).  This is the
single live entrypoint the pre-registration contemplates
(PREREG-v0.2.md :75 "The live-capable successor runner ... must refuse before a
worst-case reservation exceeds a ceiling").

It is REFUSAL-FIRST: every preflight gate refuses with a named condition before
any provider contact.  It touches the network only in ``--live`` mode, and only
after all gates pass, inside the R15 run window, under the R15 ceilings.

Byte-exact rendering is delegated to the FROZEN immutable renderer
(``tranche_b.compose_payload`` + ``validate_schedule``); the runner adds nothing
to the rendering contract.  See EMISSION-RUNNER-CONSTRUCTION.md for the
spec-ambiguity resolution (frozen ``tranche-b/templates/`` vs. the earlier
``prompts/`` copy).

Item-content discipline: the runner's CODE reads item task text and source
packets to render; it NEVER prints them.  Content-bearing evidence (payloads,
raw provider bodies) is written OUTSIDE the repo to owner-custody local storage.
Only content-free artifacts (census, run-record, actuals) are ever written into
the repo, and only into the per-attempt SCOPED subdir
``<--in-repo-census-dir>/<basename of --evidence-dir>`` when that flag is given.
A ``--dry-run`` with no ``--in-repo-census-dir`` writes nothing into the repo, as
before; a ``--dry-run`` *with* the flag writes the (content-free) mirror to a
scoped subdir so the mirror path is offline-provable (the gap EMITTER-III found:
the mirror had never run offline, so a post-spend ``FileExistsError`` there was
invisible to every receipt).  A pre-spend gate refuses if the scoped subdir is
already occupied, before any provider contact.
"""

import argparse
import json
import sys
from datetime import datetime, timedelta, timezone
from decimal import ROUND_HALF_EVEN, Decimal
from pathlib import Path

import tranche_b as tb
from conditions import PilotError, CostCeilingExceeded
from preauthorship import validate_record_digest
from util import (
    PACKET_ROOT,
    canonical_json_bytes,
    load_json,
    sha256_bytes,
    write_new_bytes,
)


# --------------------------------------------------------------------------- #
# Named refusal conditions (experiment-local; additive, do not extend the
# protected Language-A validator vocabulary in conditions.py).
# --------------------------------------------------------------------------- #
def _condition(name):
    return type(name, (PilotError,), {"condition": name})


BankIdentityRefused = _condition("BankIdentityRefused")
ItemConsistencyRefused = _condition("ItemConsistencyRefused")
ScheduleGateRefused = _condition("ScheduleGateRefused")
RunWindowRefused = _condition("RunWindowRefused")
AttemptCeilingRefused = _condition("AttemptCeilingRefused")
SpendReservationRefused = _condition("SpendReservationRefused")
R15RecordRefused = _condition("R15RecordRefused")
TransportBudgetExhausted = _condition("TransportBudgetExhausted")
SubjectBindingRefused = _condition("SubjectBindingRefused")
InRepoCensusTargetOccupied = _condition("InRepoCensusTargetOccupied")


# --------------------------------------------------------------------------- #
# Frozen constants (owner-sealed; cross-checked against R15 at gate time).
# --------------------------------------------------------------------------- #
BANK_IDENTITY = "84cb8673626d8b5502f87d83aa3e851b1ca032a2299548ac7e9307ba249d3c41"
R15_PATH = PACKET_ROOT / "operator/owner-decisions/OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1.json"
R15_RECORD_DIGEST = "sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0"
OWNER_SLOTS_PATH = PACKET_ROOT / "operator/owner-slots.json"

# The three content-free artifacts the in-repo mirror writes.  These filenames
# are also the pre-spend gate's targets (per-attempt scoped, see
# gate_in_repo_census_target / _write_census).
MIRROR_FILENAMES = ("EMISSION-CENSUS.json", "EMISSION-ACTUALS.json", "RUN-RECORD.md")

SCHEDULED_CALLS = 312
CORE_ARM_COUNT = 72          # per core arm (NL/PERSONA/SCAFFOLD/LANG-A)
SHAM_COUNT = 24
ATTEMPT_CEILING = 344
TRANSPORT_RETRY_CEILING = 32
OUTPUT_TOKEN_CAP = 768
SPEND_CEILING = Decimal("8.00")

# Worst-case reservation model: the SAME r6 "paranoid_upper" method (measured
# input bytes per call from the frozen renderer + 768 output cap, every call
# reserved at the single most-expensive input/output rate across the seats).
# R15 REPRICED the seats: kimi-k3 moved from free (Moonshot coding plan) to a
# paid OpenRouter seat at 3.00/15.00 USD/MTok, so kimi is now the most expensive
# on BOTH axes; the two max-rate constants move accordingly (method unchanged).
TOK_PER_BYTE = Decimal("1.0")        # 1 token/byte upper bound on input tokens
INPUT_ALLOWANCE = Decimal("1.05")
MAX_IN_RATE = Decimal("3.00")        # USD / MTok, most expensive input route (kimi-k3, R15)
MAX_OUT_RATE = Decimal("15.00")      # USD / MTok, most expensive output route (kimi-k3, R15)
MILLION = Decimal(1_000_000)
# Pre-R15 (r6 basis) worst-case, kept as a provenance anchor for the delta only.
R6_WORST_CASE_RESERVATION = Decimal("2.246177")

# Per-subject billed price table (R15 amended_price_basis), for post-hoc billed
# accounting.  haiku/luna == r6 basis; kimi-k3 repriced free -> 3.00/15.00.
PRICE_TABLE = {
    "claude-haiku-4.5": {"in": Decimal("1.00"), "out": Decimal("5.00")},
    "gpt-5.6-luna": {"in": Decimal("1.00"), "out": Decimal("6.00")},
    "kimi-k3": {"in": Decimal("3.00"), "out": Decimal("15.00")},
}


def usd(value):
    return value.quantize(Decimal("0.000001"), rounding=ROUND_HALF_EVEN)


def parse_iso_utc(text):
    return datetime.fromisoformat(text.replace("Z", "+00:00")).astimezone(timezone.utc)


# --------------------------------------------------------------------------- #
# Worst-case reservation ledger (refuse-before-reservation-exceeds-ceiling).
# --------------------------------------------------------------------------- #
class ReservationLedger:
    """The r6 global worst case, split into an additive per-call gate.

    The full 32-retry worst case is reserved up front as a constant liability
    (``retry_reserve``); each scheduled call then adds its own worst-case
    reservation.  A scheduled call is refused if committing it would push
    ``retry_reserve + cumulative_scheduled + this_call`` past the ceiling.
    Actual transport retries draw down the pre-reserved retry budget (already
    worst-cased) and never add new spend liability -- they only consume the
    attempt ceiling and the 32-retry ceiling.
    """

    def __init__(self, max_payload_bytes, *, spend_ceiling=SPEND_CEILING,
                 attempt_ceiling=ATTEMPT_CEILING, retry_ceiling=TRANSPORT_RETRY_CEILING):
        self.spend_ceiling = spend_ceiling
        self.attempt_ceiling = attempt_ceiling
        self.retry_ceiling = retry_ceiling
        self.max_payload_bytes = max_payload_bytes
        self.retry_reserve = self._retry_reserve(max_payload_bytes)
        self.cumulative_scheduled = Decimal("0")
        self.attempts = 0
        self.transport_retries = 0
        self.billed = Decimal("0")

    @staticmethod
    def _input_reservation(payload_bytes):
        tokens = Decimal(payload_bytes) * TOK_PER_BYTE * INPUT_ALLOWANCE
        return tokens * MAX_IN_RATE / MILLION

    @staticmethod
    def _output_reservation():
        return Decimal(OUTPUT_TOKEN_CAP) * MAX_OUT_RATE / MILLION

    def call_reservation(self, payload_bytes):
        return self._input_reservation(payload_bytes) + self._output_reservation()

    def _retry_reserve(self, max_bytes):
        retry_in = (Decimal(self.retry_ceiling * max_bytes) * TOK_PER_BYTE
                    * INPUT_ALLOWANCE * MAX_IN_RATE) / MILLION
        retry_out = (Decimal(self.retry_ceiling * OUTPUT_TOKEN_CAP) * MAX_OUT_RATE) / MILLION
        return retry_in + retry_out

    def worst_case_total(self):
        return self.retry_reserve + self.cumulative_scheduled

    # -- gates -------------------------------------------------------------- #
    def reserve_scheduled_call(self, payload_bytes):
        if self.attempts + 1 > self.attempt_ceiling:
            raise AttemptCeilingRefused(
                f"next attempt {self.attempts + 1} exceeds absolute ceiling {self.attempt_ceiling}")
        this_call = self.call_reservation(payload_bytes)
        projected = self.retry_reserve + self.cumulative_scheduled + this_call
        if projected > self.spend_ceiling:
            raise SpendReservationRefused(
                f"worst-case reservation {usd(projected)} would exceed USD {self.spend_ceiling}")
        self.cumulative_scheduled += this_call
        self.attempts += 1

    def reserve_transport_retry(self):
        if self.transport_retries + 1 > self.retry_ceiling:
            raise TransportBudgetExhausted(
                f"transport retry budget {self.retry_ceiling} exhausted")
        if self.attempts + 1 > self.attempt_ceiling:
            raise AttemptCeilingRefused(
                f"retry attempt {self.attempts + 1} exceeds absolute ceiling {self.attempt_ceiling}")
        self.transport_retries += 1
        self.attempts += 1

    def record_billed(self, amount_usd):
        candidate = self.billed + amount_usd
        if candidate > self.spend_ceiling:
            raise SpendReservationRefused(f"billed spend {usd(candidate)} exceeds USD {self.spend_ceiling}")
        self.billed = candidate


# --------------------------------------------------------------------------- #
# Preflight gates
# --------------------------------------------------------------------------- #
def gate_bank_identity(root=PACKET_ROOT):
    path = Path(root) / "items/candidate/target-visible/items.jsonl"
    observed = sha256_bytes(path.read_bytes())
    if observed != BANK_IDENTITY:
        raise BankIdentityRefused(
            f"candidate bank identity {observed} != authorized {BANK_IDENTITY}")
    return observed


def gate_item_consistency(bank):
    """Each item's task.sha256 == sha256(task.utf8); target_surface digest
    consistent (task + \\0 + source packet), per the rendering obligations.
    Reads item content but emits NO content -- digests and ids only."""
    problems = []
    target_map = bank["maps"]["target-visible item"]
    for item_id, record in target_map.items():
        task_bytes = record["task"]["utf8"].encode("utf-8")
        if sha256_bytes(task_bytes) != record["task"]["sha256"]:
            problems.append(f"{item_id}: task.sha256 mismatch")
        packet = tb.source_packet_bytes(record)
        if sha256_bytes(packet) != record["source_packet_sha256"]:
            problems.append(f"{item_id}: source_packet_sha256 mismatch")
        surface = task_bytes + b"\0" + packet
        if sha256_bytes(surface) != record["target_surface_sha256"]:
            problems.append(f"{item_id}: target_surface_sha256 mismatch")
    if problems:
        raise ItemConsistencyRefused("; ".join(problems))
    return len(target_map)


def gate_schedule(schedule, bank, template_manifest):
    if len(schedule) != SCHEDULED_CALLS:
        raise ScheduleGateRefused(f"schedule row count {len(schedule)} != {SCHEDULED_CALLS}")
    counts = {}
    for row in schedule:
        counts[row["arm"]] = counts.get(row["arm"], 0) + 1
    expected = {"NL": CORE_ARM_COUNT, "PERSONA": CORE_ARM_COUNT,
                "SCAFFOLD": CORE_ARM_COUNT, "LANG-A": CORE_ARM_COUNT, "SHAM": SHAM_COUNT}
    if counts != expected:
        raise ScheduleGateRefused(f"arm/sham counts {counts} != design {expected}")
    try:
        tb.validate_schedule(schedule, bank, template_manifest)
    except PilotError as exc:
        raise ScheduleGateRefused(f"frozen schedule binding failed: {exc}") from exc
    return counts


def gate_run_window(now, window_open, window_close):
    if now < window_open:
        raise RunWindowRefused(f"clock {now.isoformat()} is before window open {window_open.isoformat()}")
    if now >= window_close:
        raise RunWindowRefused(f"clock {now.isoformat()} is at/after window close {window_close.isoformat()}")
    return now


def gate_in_repo_census_target(scoped_dir):
    """PRE-SPEND refusal for the in-repo content-free mirror.

    EMITTER-III walked the recipe forward and found the mirror write
    (``_write_census`` -> ``write_new_bytes`` with ``O_CREAT|O_EXCL``) crashed
    with ``FileExistsError`` AFTER the emission loop -- post-spend -- when the
    target dir already held a prior attempt's frozen census.  No receipt could
    see it because the mirror never ran offline, and the ``O_CREAT|O_EXCL``
    never-overwrite instinct fired too late to protect the spend.

    This gate moves that verdict to PREFLIGHT, before any provider contact: if
    any of the three scoped mirror targets already exists, refuse with the
    occupying path as the witness.  ``scoped_dir`` is the per-attempt subdir
    ``<in-repo-census-dir>/<basename-of-outside-evidence-dir>``, so a prior
    attempt's root-level record is never a target -- only a *re-run into the same
    attempt dir* is refused, turning a post-spend crash into a named,
    before-the-money refusal."""
    scoped = Path(scoped_dir)
    for name in MIRROR_FILENAMES:
        target = scoped / name
        if target.exists():
            raise InRepoCensusTargetOccupied(
                f"in-repo census target already occupied: {target}")
    return scoped


def gate_r15_record(record):
    """Validate the R15 route-substitution record's own digest, pin it to the
    authorized digest, and confirm the OpenRouter route, window, boundary set,
    and amended subject routes it carries.  Supersedes the R14 gate: the runner
    refuses if R15 is missing/tampered or the clock is outside R15's window.
    Returns the window bounds and the subject -> OpenRouter model-id map read
    from the record itself (the ruling is the single source of truth for
    routing; the provider module's constant is only a drift guard)."""
    try:
        validate_record_digest(record)
    except PilotError as exc:
        raise R15RecordRefused(f"R15 record digest invalid: {exc}") from exc
    if record.get("record_digest") != R15_RECORD_DIGEST:
        raise R15RecordRefused(
            f"R15 record_digest {record.get('record_digest')} != authorized {R15_RECORD_DIGEST}")
    decision = record["exact_decision"]
    if decision.get("ruling") != "R15":
        raise R15RecordRefused(f"ruling {decision.get('ruling')!r} != R15")
    route = str(decision.get("route", ""))
    if "openrouter.ai" not in route.lower():
        raise R15RecordRefused("R15 route is not the OpenRouter route")
    effects = record.get("operational_effect", [])
    if "hold:no-scoring-no-key-exposure-no-merge" not in effects:
        raise R15RecordRefused("R15 boundary hold (no-scoring/no-key-exposure/no-merge) absent")
    routes = decision.get("amended_subject_routes") or []
    if len(routes) != len(tb.SUBJECT_SLOTS):
        raise R15RecordRefused(
            f"R15 amended_subject_routes lists {len(routes)} routes; expected {len(tb.SUBJECT_SLOTS)}")
    subject_model_ids = {}
    for entry in routes:
        subject = entry.get("subject")
        model_id = entry.get("openrouter_model_id")
        if not subject or not model_id:
            raise R15RecordRefused("R15 amended route missing subject/openrouter_model_id")
        subject_model_ids[subject] = model_id
    window = decision["run_window"]
    return {
        "window_open": parse_iso_utc(window["opens_utc"]),
        "window_close": parse_iso_utc(window["closes_utc"]),
        "odr41_rule": window["rule"],
        "subject_model_ids": subject_model_ids,
    }


def load_subject_binding(root=PACKET_ROOT):
    """Deterministic map SYNTHETIC-SUBJECT-N -> r5 subject/route by the r5
    record's OWN value-array ordering (slot ``subject-provider-model-routes``):
    ordinal N (1-based, parsed from the slot name) indexes value[N-1]."""
    slots = load_json(Path(root) / "operator/owner-slots.json")["slots"]
    r5 = next((s for s in slots if s["slot_id"] == "subject-provider-model-routes"), None)
    if r5 is None or r5.get("status") != "resolved":
        raise SubjectBindingRefused("r5 subject-provider-model-routes slot missing or unresolved")
    value = r5["value"]
    if len(value) != len(tb.SUBJECT_SLOTS):
        raise SubjectBindingRefused(f"r5 lists {len(value)} subjects; expected {len(tb.SUBJECT_SLOTS)}")
    binding = {}
    for slot in tb.SUBJECT_SLOTS:
        ordinal = int(slot.rsplit("-", 1)[1])
        entry = value[ordinal - 1]
        binding[slot] = {"subject": entry["subject"], "route": entry["route"], "r5_ordinal": ordinal}
    return binding


# --------------------------------------------------------------------------- #
# Runner
# --------------------------------------------------------------------------- #
class EmissionRunner:
    def __init__(self, root=PACKET_ROOT, now_fn=None):
        self.root = Path(root)
        self.now_fn = now_fn or (lambda: datetime.now(timezone.utc))

    def preflight(self, scoped_census_dir=None):
        r15 = load_json(R15_PATH)
        window = gate_r15_record(r15)
        bank_identity = gate_bank_identity(self.root)
        bank = tb.load_public_bank(root=self.root)
        item_count = gate_item_consistency(bank)
        schedule = tb.strict_jsonl_load(self.root / "tranche-b/schedule.jsonl")
        template_manifest, template_files = tb.validate_template_files(root=self.root)
        arm_counts = gate_schedule(schedule, bank, template_manifest)
        subject_binding = load_subject_binding(self.root)
        now = gate_run_window(self.now_fn(), window["window_open"], window["window_close"])
        # PRE-SPEND: refuse before any provider contact if the per-attempt in-repo
        # mirror target is already occupied (only checked when a mirror dir is in
        # play; exercised in BOTH dry-run and live for testability).
        if scoped_census_dir is not None:
            gate_in_repo_census_target(scoped_census_dir)
        return {
            "r15": r15, "window": window, "now": now,
            "subject_model_ids": window["subject_model_ids"],
            "bank": bank, "bank_identity": bank_identity, "item_count": item_count,
            "schedule": schedule, "template_manifest": template_manifest,
            "template_files": template_files, "arm_counts": arm_counts,
            "subject_binding": subject_binding,
            "scoped_census_dir": Path(scoped_census_dir) if scoped_census_dir is not None else None,
        }

    def prerender(self, ctx):
        """Deterministic offline render of all 312 payloads.  Records per-call
        byte lengths + digests (needed by the reservation ledger up front) and
        keeps the payload bytes in memory keyed by call_id.  No content printed."""
        bank = ctx["bank"]
        target_map = bank["maps"]["target-visible item"]
        files = ctx["template_files"]
        system, wrapper = files["system"], files["wrapper"]
        payloads = {}
        census = []
        for row in ctx["schedule"]:
            item = tb.TargetVisibleItem.from_record(target_map[row["item_id"]])
            template = files[row["arm"]]
            payload = tb.compose_payload(item, system, template, wrapper)
            payloads[row["call_id"]] = payload
            census.append({
                "call_id": row["call_id"], "schedule_index": row["schedule_index"],
                "arm": row["arm"], "item_id": row["item_id"],
                "subject_slot": row["subject_slot"], "payload_bytes": len(payload),
                "payload_sha256": sha256_bytes(payload),
            })
        return payloads, census

    def run(self, evidence_dir, *, mode="dry-run", provider_factory=None,
            keys=None, in_repo_census_dir=None):
        if mode not in ("dry-run", "live"):
            raise ValueError("mode must be 'dry-run' or 'live'")
        # Per-attempt scoping: the in-repo content-free mirror lands in a subdir
        # named for the outside evidence dir, so a prior attempt's root-level
        # frozen record is never a write target.  Resolved BEFORE preflight so the
        # pre-spend occupancy gate can check it.
        scoped_census_dir = None
        if in_repo_census_dir is not None:
            scoped_census_dir = Path(in_repo_census_dir) / Path(evidence_dir).name
        ctx = self.preflight(scoped_census_dir=scoped_census_dir)
        payloads, render_census = self.prerender(ctx)
        rendered = len(render_census)
        max_bytes = max(entry["payload_bytes"] for entry in render_census)
        total_bytes = sum(entry["payload_bytes"] for entry in render_census)
        ledger = ReservationLedger(max_bytes)

        evidence_dir = Path(evidence_dir)
        (evidence_dir / "payloads").mkdir(parents=True, exist_ok=True)
        (evidence_dir / "requests").mkdir(parents=True, exist_ok=True)
        (evidence_dir / "raw-responses").mkdir(parents=True, exist_ok=True)

        subject_model_ids = ctx["subject_model_ids"]
        provider_factory = provider_factory or self._default_provider_factory(
            mode, keys, subject_model_ids)
        providers = {}
        call_census = []
        run_state = "complete"
        stop_reason = None

        for row in ctx["schedule"]:
            call_id = row["call_id"]
            payload = payloads[call_id]
            binding = ctx["subject_binding"][row["subject_slot"]]
            subject = binding["subject"]
            model_id = subject_model_ids.get(subject)
            # ---- refuse-before-reservation gate (per scheduled call) ------- #
            try:
                ledger.reserve_scheduled_call(len(payload))
            except (SpendReservationRefused, AttemptCeilingRefused) as exc:
                run_state, stop_reason = "stopped", f"{type(exc).__name__}: {exc}"
                break

            provider = providers.get(subject)
            if provider is None:
                provider = provider_factory(subject)
                providers[subject] = provider

            request_meta = {
                "call_id": call_id, "subject": subject,
                "route": "OpenRouter route (openrouter.ai/api/v1/chat/completions)",
                "openrouter_model_id": model_id,
                "model_requested": subject, "arm": row["arm"], "item_id": row["item_id"],
                "schedule_index": row["schedule_index"],
                "payload_sha256": sha256_bytes(payload),
                "target_visible_item_sha256": row["target_visible_item_sha256"],
                "schedule_row_sha256": row["schedule_row_sha256"],
            }

            # ---- emission with global transport-retry policy --------------- #
            outcome = self._emit_with_retries(provider, payload, subject, request_meta, ledger)
            if outcome["state"] == "transport-exhausted":
                self._write_call_evidence(evidence_dir, call_id, payload, request_meta, outcome)
                call_census.append(self._census_row(row, binding, outcome, ledger, model_id=model_id))
                run_state, stop_reason = "stopped", "TransportBudgetExhausted: partial census"
                break

            self._write_call_evidence(evidence_dir, call_id, payload, request_meta, outcome)
            billed = self._billed_cost(subject, outcome)
            if billed is not None:
                ledger.record_billed(billed)
            call_census.append(self._census_row(row, binding, outcome, ledger, billed, model_id=model_id))

        worst_case_total = usd(ledger.worst_case_total())
        summary = {
            "schema_version": "lae-emission-run-summary/1.0.0",
            "mode": mode, "run_state": run_state, "stop_reason": stop_reason,
            "scheduled_calls": SCHEDULED_CALLS, "rendered": rendered,
            "emitted": len(call_census),
            "total_payload_bytes": total_bytes, "max_payload_bytes": max_bytes,
            "attempts": ledger.attempts, "attempt_ceiling": ATTEMPT_CEILING,
            "transport_retries": ledger.transport_retries,
            "transport_retry_ceiling": TRANSPORT_RETRY_CEILING,
            "worst_case_reservation_usd": str(worst_case_total),
            "r6_worst_case_reservation_usd": str(R6_WORST_CASE_RESERVATION),
            "worst_case_delta_usd": str(usd(worst_case_total - R6_WORST_CASE_RESERVATION)),
            "spend_ceiling_usd": str(SPEND_CEILING),
            "billed_cost_usd": str(usd(ledger.billed)),
            "window_open_utc": ctx["window"]["window_open"].isoformat(),
            "window_close_utc": ctx["window"]["window_close"].isoformat(),
            "clock_utc": ctx["now"].isoformat(),
            "subject_binding": {slot: {"subject": b["subject"],
                                        "route": "OpenRouter route (openrouter.ai/api/v1/chat/completions)",
                                        "openrouter_model_id": ctx["subject_model_ids"].get(b["subject"]),
                                        "r5_ordinal": b["r5_ordinal"]}
                                 for slot, b in ctx["subject_binding"].items()},
        }
        self._write_census(evidence_dir, summary, call_census, ctx, scoped_census_dir)
        return summary, call_census

    # -- emission helpers --------------------------------------------------- #
    def _emit_with_retries(self, provider, payload, subject, request_meta, ledger):
        from provider_live_emission import TransportError
        backoff = 0.5
        while True:
            try:
                response = provider.emit(payload, model=subject, request_meta=request_meta)
            except TransportError as exc:
                try:
                    ledger.reserve_transport_retry()
                except (TransportBudgetExhausted, AttemptCeilingRefused):
                    return {"state": "transport-exhausted", "detail": str(exc),
                            "census_fields": None, "raw_body": None, "headers": {},
                            "retention": {"headers": {}, "body": {}}}
                self._sleep(backoff)
                backoff = min(backoff * 2, 16.0)
                continue
            fields = response.census_fields()
            fields["raw_body_sha256"] = sha256_bytes(response.raw_body)
            state = "null-content" if fields.get("null_content") else "emitted"
            return {"state": state, "census_fields": fields,
                    "raw_body": response.raw_body, "headers": response.headers,
                    "retention": response.retention_disclosures(),
                    "model_requested": response.model_requested, "route": response.route}

    def _sleep(self, seconds):
        # Overridable no-op-able hook; real runs back off, tests inject 0.
        import time
        time.sleep(seconds)

    def _billed_cost(self, subject, outcome):
        fields = outcome.get("census_fields")
        if not fields or not fields.get("provider_reported_usage"):
            return None
        price = PRICE_TABLE.get(subject)
        if price is None:
            return None
        in_tok = Decimal(fields.get("input_tokens") or 0)
        out_tok = Decimal(fields.get("output_tokens") or 0)
        return (in_tok * price["in"] + out_tok * price["out"]) / MILLION

    def _census_row(self, row, binding, outcome, ledger, billed=None, *, model_id=None):
        fields = outcome.get("census_fields") or {}
        return {
            "call_id": row["call_id"], "schedule_index": row["schedule_index"],
            "arm": row["arm"], "item_id": row["item_id"],
            "subject_slot": row["subject_slot"], "subject": binding["subject"],
            "route": outcome.get("route") or "OpenRouter route (openrouter.ai/api/v1/chat/completions)",
            "openrouter_model_id": model_id, "state": outcome["state"],
            "http_status": fields.get("http_status"),
            "finish_reason": fields.get("finish_reason"),
            "model_id_returned": fields.get("model_id_returned"),
            "serving_provider": fields.get("serving_provider"),
            "provider_request_id": fields.get("provider_request_id"),
            "input_tokens": fields.get("input_tokens"),
            "output_tokens": fields.get("output_tokens"),
            "cached_input_tokens": fields.get("cached_input_tokens"),
            "reasoning_tokens": fields.get("reasoning_tokens"),
            "provider_reported_usage": fields.get("provider_reported_usage", False),
            "null_content": fields.get("null_content"),
            "raw_response_sha256": fields.get("raw_body_sha256"),
            "raw_response_bytes": fields.get("raw_body_bytes"),
            "billed_cost_usd": str(usd(billed)) if billed is not None else None,
            "cumulative_billed_usd": str(usd(ledger.billed)),
        }

    def _write_call_evidence(self, evidence_dir, call_id, payload, request_meta, outcome):
        """Content-bearing evidence -> OUTSIDE-repo owner custody only."""
        write_new_bytes(evidence_dir / "payloads" / f"{call_id}.bin", payload)
        write_new_bytes(evidence_dir / "requests" / f"{call_id}.json",
                        canonical_json_bytes(request_meta))
        if outcome.get("raw_body") is not None:
            write_new_bytes(evidence_dir / "raw-responses" / f"{call_id}.bin",
                            outcome["raw_body"])
            meta = {"call_id": call_id, "headers": outcome.get("headers", {}),
                    "retention_disclosures": outcome.get("retention", {}),
                    "census_fields": outcome.get("census_fields")}
            write_new_bytes(evidence_dir / "raw-responses" / f"{call_id}.meta.json",
                            canonical_json_bytes(meta))

    def _write_census(self, evidence_dir, summary, call_census, ctx, scoped_census_dir):
        # Content-free census always lands beside the (outside) evidence.
        census = {"schema_version": "lae-emission-census/1.0.0",
                  "summary": summary, "records": call_census}
        write_new_bytes(evidence_dir / "EMISSION-CENSUS.json", canonical_json_bytes(census))
        actuals = self._actuals_record(summary, call_census, ctx)
        write_new_bytes(evidence_dir / "EMISSION-ACTUALS.json", canonical_json_bytes(actuals))
        write_new_bytes(evidence_dir / "RUN-RECORD.md",
                        self._run_record_md(summary).encode("utf-8"))
        # In-repo content-free mirror -> the per-attempt SCOPED subdir (occupancy
        # already refused pre-spend by gate_in_repo_census_target).  Written
        # whenever a mirror dir was supplied, in BOTH modes: --live for the real
        # record, --dry-run so the mirror path is offline-provable (the very gap
        # EMITTER-III found -- the mirror had never run offline).  Content-free only.
        if scoped_census_dir is not None:
            repo_dir = Path(scoped_census_dir)
            write_new_bytes(repo_dir / "EMISSION-CENSUS.json", canonical_json_bytes(census))
            write_new_bytes(repo_dir / "EMISSION-ACTUALS.json", canonical_json_bytes(actuals))
            write_new_bytes(repo_dir / "RUN-RECORD.md",
                            self._run_record_md(summary).encode("utf-8"))

    def _actuals_record(self, summary, call_census, ctx):
        return {
            "schema_version": "lae-emission-actuals/1.0.0",
            "mode": summary["mode"],
            "subject_binding_rule": ("SYNTHETIC-SUBJECT-N -> r5 subject-provider-model-routes "
                                     "value[N-1] (r5 record's own value-array ordering)"),
            "subject_binding": summary["subject_binding"],
            "settings": {"max_output_tokens": OUTPUT_TOKEN_CAP, "temperature": 0,
                         "note": "provider settings recorded-as-deferred per Erratum-01 / GATE-WALK-R12; "
                                 "exact per-provider actuals close at emission"},
            "tokenizer_census": [
                {"call_id": r["call_id"], "subject": r["subject"],
                 "openrouter_model_id": r.get("openrouter_model_id"),
                 "serving_provider": r.get("serving_provider"),
                 "input_tokens": r["input_tokens"], "output_tokens": r["output_tokens"],
                 "provider_reported_usage": r["provider_reported_usage"]}
                for r in call_census
            ],
            "retention_cache_disclosures": ("captured per-call in the OUTSIDE-repo raw-response "
                                            "meta files (headers + body flags); summarized here as pending "
                                            "exact confirmation per r6-closed-v2"),
            "worst_case_reservation_usd": summary["worst_case_reservation_usd"],
            "worst_case_delta_usd": summary["worst_case_delta_usd"],
            "billed_cost_usd": summary["billed_cost_usd"],
        }

    def _run_record_md(self, summary):
        return (
            f"# Language-A 312-Emission Run Record ({summary['mode']})\n\n"
            f"- run_state: **{summary['run_state']}**"
            + (f" ({summary['stop_reason']})" if summary["stop_reason"] else "") + "\n"
            f"- scheduled / rendered / emitted: {summary['scheduled_calls']} / "
            f"{summary['rendered']} / {summary['emitted']}\n"
            f"- attempts / ceiling: {summary['attempts']} / {summary['attempt_ceiling']}\n"
            f"- transport retries / ceiling: {summary['transport_retries']} / "
            f"{summary['transport_retry_ceiling']}\n"
            f"- worst-case reservation: USD {summary['worst_case_reservation_usd']} "
            f"(r6 {summary['r6_worst_case_reservation_usd']}, delta "
            f"{summary['worst_case_delta_usd']})\n"
            f"- billed: USD {summary['billed_cost_usd']} / ceiling USD {summary['spend_ceiling_usd']}\n"
            f"- window: {summary['window_open_utc']} .. {summary['window_close_utc']} "
            f"(clock {summary['clock_utc']})\n\n"
            "Content-bearing evidence (payloads, raw provider bodies) is in owner-custody local "
            "storage OUTSIDE the repository. This record is content-free.\n"
        )

    def _default_provider_factory(self, mode, keys, subject_model_ids):
        if mode == "dry-run":
            from provider_live_emission import MockProvider
            return lambda subject: MockProvider(mode="normal")
        from provider_live_emission import build_adapter, load_env_keys
        resolved_keys = keys or load_env_keys()
        return lambda subject: build_adapter(
            subject, resolved_keys, model_id=subject_model_ids.get(subject))


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #
def main(argv=None):
    parser = argparse.ArgumentParser(description="Language-A live-capable successor emission runner")
    parser.add_argument("--dry-run", action="store_true",
                        help="full pipeline against the offline MockProvider (no network, no keys)")
    parser.add_argument("--live", action="store_true",
                        help="real provider emission (the later hand, under fresh receipts)")
    parser.add_argument("--evidence-dir", required=True,
                        help="OUTSIDE-repo owner-custody evidence directory")
    parser.add_argument("--in-repo-census-dir", default=None,
                        help="repo dir for the content-free census mirror (e.g. evidence/emission-312); "
                             "the mirror lands in a per-attempt subdir <dir>/<basename of --evidence-dir>. "
                             "Honoured in --live and --dry-run (dry-run makes the mirror offline-provable). "
                             "Refuses pre-spend if that scoped subdir is already occupied.")
    args = parser.parse_args(argv)

    if args.dry_run == args.live:
        parser.error("exactly one of --dry-run / --live is required")

    if args.dry_run:
        # Freeze the clock inside the R15 window so the gate is exercised (not
        # bypassed) without depending on wall-clock timing of the build.
        r15 = load_json(R15_PATH)
        open_utc = parse_iso_utc(r15["exact_decision"]["run_window"]["opens_utc"])
        runner = EmissionRunner(now_fn=lambda: open_utc + timedelta(seconds=1))
        summary, _ = runner.run(args.evidence_dir, mode="dry-run",
                                in_repo_census_dir=args.in_repo_census_dir)
    else:
        runner = EmissionRunner()
        summary, _ = runner.run(args.evidence_dir, mode="live",
                                in_repo_census_dir=args.in_repo_census_dir)

    print(f"EMISSION-RUN [{summary['mode']}]: {summary['run_state']} "
          f"rendered={summary['rendered']}/{summary['scheduled_calls']} "
          f"emitted={summary['emitted']} "
          f"worst_case_usd={summary['worst_case_reservation_usd']} "
          f"(r6={summary['r6_worst_case_reservation_usd']} "
          f"delta={summary['worst_case_delta_usd']}) "
          f"attempts={summary['attempts']}/{summary['attempt_ceiling']}")
    return 0 if summary["run_state"] == "complete" else 2


if __name__ == "__main__":
    sys.exit(main())
