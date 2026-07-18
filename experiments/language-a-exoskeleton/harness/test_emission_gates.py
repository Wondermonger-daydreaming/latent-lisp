"""Teeth checks for the Language-A emission runner's refusal gates.

Every gate is UNTESTED until it has been shown able to fire (TESSERA's practice:
"a gate that has never fired is untested, not passing").  Each check here PLANTS
a fault, asserts the named refusal FIRES, then asserts the CLEAN path PASSES.
Runs fully offline (no network, no keys, no provider contact).  Prints PASS/FAIL
lines and exits nonzero on any failure.

Item-content discipline: this script prints only gate names, exception types, and
counts -- never any item task text, source text, or rendered payload body.
"""

import json
import shutil
import sys
import tempfile
from datetime import timedelta
from decimal import Decimal
from pathlib import Path

import tranche_b as tb
import run_emission as re
from run_emission import (
    ReservationLedger, EmissionRunner, gate_bank_identity, gate_item_consistency,
    gate_run_window, gate_schedule, gate_r15_record, load_subject_binding,
    BankIdentityRefused, ItemConsistencyRefused, ScheduleGateRefused,
    RunWindowRefused, AttemptCeilingRefused, SpendReservationRefused,
    R15RecordRefused, TransportBudgetExhausted, SubjectBindingRefused,
    parse_iso_utc,
)
from provider_live_emission import MockProvider
from util import PACKET_ROOT, load_json

OUTSIDE_ROOT = Path("/home/gauss/Codex-Lab/emission-312-evidence")
RESULTS = []


def check(name, plant_fn, expected_exc, clean_fn):
    """plant_fn must raise expected_exc; clean_fn must NOT raise."""
    fired = False
    fired_detail = ""
    try:
        plant_fn()
    except expected_exc as exc:
        fired = True
        fired_detail = type(exc).__name__
    except Exception as exc:  # wrong exception type -> not a clean fire
        fired_detail = f"WRONG:{type(exc).__name__}"
    clean_ok = False
    clean_detail = ""
    try:
        clean_fn()
        clean_ok = True
    except Exception as exc:
        clean_detail = f"{type(exc).__name__}: {exc}"
    ok = fired and clean_ok
    RESULTS.append((name, ok))
    status = "PASS" if ok else "FAIL"
    print(f"[{status}] {name}: planted-fired={fired}({fired_detail or expected_exc.__name__}) "
          f"clean-passed={clean_ok}{'' if clean_ok else ' <- ' + clean_detail}")


def _real_context():
    bank = tb.load_public_bank()
    schedule = tb.strict_jsonl_load(tb.SCHEDULE_PATH)
    manifest, _ = tb.validate_template_files()
    return bank, schedule, manifest


def _fresh_evidence(subdir):
    path = Path(tempfile.mkdtemp(prefix=f"teeth-{subdir}-", dir=str(OUTSIDE_ROOT)))
    shutil.rmtree(path)
    return path


# --------------------------------------------------------------------------- #
def run():
    bank, schedule, manifest = _real_context()
    # Window bounds come from the R15 record itself so the probes' clock always
    # sits inside the authorized window (R15: 04:59:07Z .. 16:59:07Z).
    r15_window = load_json(re.R15_PATH)["exact_decision"]["run_window"]
    window_open = parse_iso_utc(r15_window["opens_utc"])
    window_close = parse_iso_utc(r15_window["closes_utc"])
    inside = window_open + timedelta(hours=1)

    def _payload_byte_census():
        """Per-call payload byte lengths from the frozen renderer (no content)."""
        runner = EmissionRunner(now_fn=lambda: inside)
        ctx = runner.preflight()
        _, render_census = runner.prerender(ctx)
        return [entry["payload_bytes"] for entry in render_census]

    # 1. tampered bank digest
    def plant_bank():
        tmp = Path(tempfile.mkdtemp(dir=str(OUTSIDE_ROOT)))
        target = tmp / "items/candidate/target-visible"
        target.mkdir(parents=True)
        (target / "items.jsonl").write_bytes(b'{"tampered":true}\n')
        try:
            gate_bank_identity(tmp)
        finally:
            shutil.rmtree(tmp)
    check("bank-identity gate", plant_bank, BankIdentityRefused,
          lambda: gate_bank_identity(PACKET_ROOT))

    # 2. oversized schedule (313 rows)
    check("schedule gate: oversized",
          lambda: gate_schedule(schedule + schedule[:1], bank, manifest),
          ScheduleGateRefused,
          lambda: gate_schedule(schedule, bank, manifest))

    # 3. schedule mutation (valid counts, broken frozen binding)
    def plant_sched_mut():
        mutated = [dict(r) for r in schedule]
        # swap two item_ids -> counts unchanged, authoritative binding breaks
        mutated[0]["item_id"], mutated[1]["item_id"] = mutated[1]["item_id"], mutated[0]["item_id"]
        gate_schedule(mutated, bank, manifest)
    check("schedule gate: mutated binding", plant_sched_mut, ScheduleGateRefused,
          lambda: gate_schedule(schedule, bank, manifest))

    # 4. clock at/after window close
    check("run-window gate: past close",
          lambda: gate_run_window(window_close, window_open, window_close),
          RunWindowRefused,
          lambda: gate_run_window(inside, window_open, window_close))

    # 5. clock before window open
    check("run-window gate: before open",
          lambda: gate_run_window(window_open - timedelta(seconds=1), window_open, window_close),
          RunWindowRefused,
          lambda: gate_run_window(inside, window_open, window_close))

    # 6. spend reservation overflow (huge worst-case call refused BEFORE contact)
    def plant_spend():
        ledger = ReservationLedger(max_payload_bytes=200_000_000)  # retry reserve alone >> 8.00
        ledger.reserve_scheduled_call(3175)
    check("spend gate: worst-case overflow", plant_spend, SpendReservationRefused,
          lambda: ReservationLedger(max_payload_bytes=3175).reserve_scheduled_call(3175))

    # 7. attempt ceiling (attempt 345 refused)
    def plant_attempt():
        ledger = ReservationLedger(max_payload_bytes=3175)
        ledger.attempts = 344
        ledger.reserve_scheduled_call(3175)
    def clean_attempt():
        ledger = ReservationLedger(max_payload_bytes=3175)
        ledger.attempts = 342
        ledger.reserve_scheduled_call(3175)  # attempt 343, fine
    check("attempt-ceiling gate: 345", plant_attempt, AttemptCeilingRefused, clean_attempt)

    # 8. R15 record tampered (in-memory copy) -> digest mismatch refuses
    real_r15 = load_json(re.R15_PATH)
    def plant_r15():
        tampered = json.loads(json.dumps(real_r15))
        tampered["exact_decision"]["run_window"]["closes_utc"] = "2099-01-01T00:00:00Z"
        gate_r15_record(tampered)
    check("R15-record gate: tampered", plant_r15, R15RecordRefused,
          lambda: gate_r15_record(json.loads(json.dumps(real_r15))))

    # 9. item internal-consistency (tampered task digest)
    def plant_item():
        fake_bank = {"maps": {"target-visible item": {
            "X-01": {"task": {"utf8": "abc", "sha256": "0" * 64},
                     "source_packet_sha256": "0" * 64, "target_surface_sha256": "0" * 64,
                     "sources": [{"component_id": "S1", "content": {"utf8": "s", "sha256": "0" * 64}}],
                     "derived_views": []}}}}
        gate_item_consistency(fake_bank)
    check("item-consistency gate: bad task digest", plant_item, ItemConsistencyRefused,
          lambda: gate_item_consistency(bank))

    # 10. subject-binding: wrong r5 subject count
    def plant_binding():
        tmp = Path(tempfile.mkdtemp(dir=str(OUTSIDE_ROOT)))
        (tmp / "operator").mkdir(parents=True)
        slots = load_json(re.OWNER_SLOTS_PATH)
        for slot in slots["slots"]:
            if slot["slot_id"] == "subject-provider-model-routes":
                slot["value"] = slot["value"][:2]  # drop one subject
        (tmp / "operator/owner-slots.json").write_text(json.dumps(slots), encoding="utf-8")
        try:
            load_subject_binding(tmp)
        finally:
            shutil.rmtree(tmp)
    check("subject-binding gate: wrong count", plant_binding, SubjectBindingRefused,
          lambda: load_subject_binding(PACKET_ROOT))

    # 11. null-content envelope -> determinate NULL_CONTENT census entry, NO retry, run continues
    def null_content_probe():
        evd = _fresh_evidence("null")
        runner = EmissionRunner(now_fn=lambda: inside)
        summary, census = runner.run(
            evd, mode="dry-run",
            provider_factory=lambda subject: MockProvider(mode="null-content"))
        shutil.rmtree(evd, ignore_errors=True)
        assert summary["run_state"] == "complete", summary["run_state"]
        assert summary["emitted"] == 312, summary["emitted"]
        assert summary["attempts"] == 312, f"attempts={summary['attempts']} (retry on null-content!)"
        assert summary["transport_retries"] == 0, summary["transport_retries"]
        assert all(r["null_content"] for r in census), "some rows not null_content"
        assert all(r["state"] == "null-content" for r in census)
    # This is a single-path assertion (not a plant/clean pair): wrap so the
    # framework records PASS iff it runs clean.
    _assert_check("null-content: determinate, no retry, continues", null_content_probe)

    # 12. transport-retry exhaustion -> honest stop with partial census
    def transport_exhaustion_probe():
        evd = _fresh_evidence("transport")
        runner = EmissionRunner(now_fn=lambda: inside)
        runner._sleep = lambda seconds: None  # no real backoff in test
        summary, census = runner.run(
            evd, mode="dry-run",
            provider_factory=lambda subject: MockProvider(mode="transport-always"))
        shutil.rmtree(evd, ignore_errors=True)
        assert summary["run_state"] == "stopped", summary["run_state"]
        assert summary["transport_retries"] == 32, summary["transport_retries"]
        assert "TransportBudgetExhausted" in (summary["stop_reason"] or "")
        assert summary["emitted"] < 312, summary["emitted"]  # partial census
    _assert_check("transport-exhaustion: honest partial stop", transport_exhaustion_probe)

    # 13. CLEAN full pipeline -> 312/312, worst-case byte-exact, attempts 312,
    #     R15-repriced worst-case in band AND strictly under the 8.00 ceiling.
    def clean_full_probe():
        evd = _fresh_evidence("clean")
        runner = EmissionRunner(now_fn=lambda: inside)
        summary, census = runner.run(evd, mode="dry-run")
        shutil.rmtree(evd, ignore_errors=True)
        assert summary["run_state"] == "complete", summary["run_state"]
        assert summary["rendered"] == 312 and summary["emitted"] == 312
        assert summary["attempts"] == 312 and summary["transport_retries"] == 0
        wc = Decimal(summary["worst_case_reservation_usd"])
        assert wc == Decimal("5.944873"), wc  # R15-repriced byte-exact worst case
        assert wc < Decimal("8.00"), wc        # spend ceiling UNCHANGED
    _assert_check("clean full dry-run: 312/312, worst-case USD 5.944873 < 8.00",
                  clean_full_probe)

    # 14. serving-provider + openrouter model id captured in mock census rows
    #     (R15 serving_provider_rule proven on the offline path).
    def serving_provider_probe():
        evd = _fresh_evidence("serving")
        runner = EmissionRunner(now_fn=lambda: inside)
        summary, census = runner.run(evd, mode="dry-run")
        shutil.rmtree(evd, ignore_errors=True)
        expected_ids = {"claude-haiku-4.5": "anthropic/claude-haiku-4.5",
                        "gpt-5.6-luna": "openai/gpt-5.6-luna",
                        "kimi-k3": "moonshotai/kimi-k3"}
        assert all(r.get("serving_provider") == "MockRouter (offline, no network)"
                   for r in census), "serving_provider missing from a census row"
        assert all(r.get("openrouter_model_id") == expected_ids[r["subject"]]
                   for r in census), "openrouter_model_id mismatch in a census row"
        assert all("openrouter.ai" in (r.get("route") or "") for r in census), "route not OpenRouter"
    _assert_check("serving-provider capture: lands in mock census rows",
                  serving_provider_probe)

    # 15. price-table worst-case assertion: repriced constants recompute byte-exact
    def price_table_probe():
        # Independent recomputation of the worst case from the frozen byte census,
        # asserting the R15 max-rate constants (kimi 3.00/15.00) are in force.
        assert re.MAX_IN_RATE == Decimal("3.00"), re.MAX_IN_RATE
        assert re.MAX_OUT_RATE == Decimal("15.00"), re.MAX_OUT_RATE
        assert re.PRICE_TABLE["kimi-k3"] == {"in": Decimal("3.00"), "out": Decimal("15.00")}
        ledger = ReservationLedger(max_payload_bytes=3175)
        for entry_bytes in _payload_byte_census():
            ledger.reserve_scheduled_call(entry_bytes)
        wc = re.usd(ledger.worst_case_total())
        assert wc == Decimal("5.944873"), wc
        assert wc < re.SPEND_CEILING, (wc, re.SPEND_CEILING)
    _assert_check("price-table worst-case: byte-exact 5.944873 under 8.00 ceiling",
                  price_table_probe)

    # -- summary ---------------------------------------------------------- #
    total = len(RESULTS)
    passed = sum(1 for _, ok in RESULTS if ok)
    print(f"\nTEETH CHECKS: {passed}/{total} PASS")
    return 0 if passed == total else 1


def _assert_check(name, fn):
    ok = False
    detail = ""
    try:
        fn()
        ok = True
    except Exception as exc:
        detail = f"{type(exc).__name__}: {exc}"
    RESULTS.append((name, ok))
    print(f"[{'PASS' if ok else 'FAIL'}] {name}{'' if ok else ' <- ' + detail}")


if __name__ == "__main__":
    sys.exit(run())
