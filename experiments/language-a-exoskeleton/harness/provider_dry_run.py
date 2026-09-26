import hashlib
import json

from provider_base import Provider


class DryRunProvider(Provider):
    network_capable = False
    provider_id = "provider:deterministic-dry-run"
    model_id = "synthetic-emitter/0"

    def emit(self, request, prompt_bytes):
        if not request.get("synthetic_only"):
            raise ValueError("dry-run provider accepts synthetic_only requests exclusively")
        material = request["call_id"].encode("utf-8") + b"\0" + prompt_bytes
        digest = hashlib.sha256(material).hexdigest()
        value = int(digest[:8], 16)
        opportunities = 4 + (value % 5)
        arm_bias = {"NL": 3, "PERSONA": 2, "SCAFFOLD": 1, "LANG-A": 1, "SHAM": 2}[request["arm"]]
        defect_total = min(opportunities, (value // 17 + arm_bias) % 4)
        artifact = {"kind": "synthetic-language-a-pilot-artifact", "answer": f"Synthetic response {digest[:16]}", "synthetic_score_facts": {
            "unsupported_assertions": defect_total, "scope_errors": 0, "version_errors": 0, "residue_erasures": 0,
            "scorable_opportunities": opportunities, "answerable_units": 2, "emitted_answerable_units": 2,
            "refusal": False, "abstention": False, "truncation": False, "over_bounding": False,
            "procedural_caveat_substitution": False, "unnecessary_abstention": False,
            "excessive_qualification": False, "omitted_supported_conclusion": False, "answer_utility": 3}}
        raw = json.dumps(artifact, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8") + b"\n"
        return {"raw_bytes": raw, "provider_request_id": f"dry-{digest[:20]}", "model_id_returned": self.model_id,
                "status": "completed", "finish_reason": "stop",
                "usage": {"input_tokens": None, "output_tokens": None, "cached_input_tokens": None, "reasoning_tokens": None, "provider_reported": False},
                "latency_ms": 0, "billed_cost_usd": "0.00"}
