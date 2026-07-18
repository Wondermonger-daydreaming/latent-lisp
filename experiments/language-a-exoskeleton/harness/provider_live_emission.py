"""Live provider adapters for the Language-A 312-emission run.

ADDITIVE SUCCESSOR construction (ruling R14, OWNER-312-EMISSION-AUTHORIZED-v1).
This module is the ONLY place in the packet that is capable of contacting a
provider.  It is imported exclusively by ``run_emission.py``; no frozen file
imports it (one-renderer / one-emitter exclusivity, proven in the construction
notes).  It performs NO provider contact at import time and none at all unless
``run_emission.py`` is invoked in its explicit ``--live`` mode.

Three adapters, one per r5 subject-provider-model route
(operator/owner-slots.json slot ``subject-provider-model-routes``):

  (a) claude-haiku-4.5  -> Anthropic direct   POST https://api.anthropic.com/v1/messages   (ANTHROPIC_API_KEY)
  (b) gpt-5.6-luna      -> OpenAI API         POST https://api.openai.com/v1/chat/completions (OPENAI_API_KEY)
  (c) kimi-k3           -> Moonshot coding     POST https://api.kimi.com/coding/v1/messages   (KIMI_API_KEY, Anthropic-compatible)

Hard invariants enforced here:
  * ``max_tokens`` / output cap is HARD-CODED to 768 per attempt.
  * The full HTTP response envelope (status, headers, raw body bytes) is
    captured for owner-custody evidence; nothing is discarded.
  * An HTTP 200 whose body parses to a determinate envelope is FINAL for the
    call.  A null/empty content 200 is a determinate ``NULL_CONTENT`` outcome,
    never retried (the option-(a) idiom; aligns with SCORING-CONSTITUTION T11).
  * Transport errors (connect / read timeout / HTTP 5xx / HTTP 429) are the
    only retryable class; the retry budget is a GLOBAL ceiling owned by the
    caller (<=32 across the whole run).

Keys are read from /home/gauss/Claude-Code-Lab/.env at call time and are never
printed, logged, or written to any evidence artifact.
"""

import json
import time
import urllib.error
import urllib.request
from pathlib import Path


OUTPUT_TOKEN_CAP = 768  # hard-coded per attempt; the packet-wide output cap
ENV_PATH = Path("/home/gauss/Claude-Code-Lab/.env")


# --------------------------------------------------------------------------- #
# Key custody
# --------------------------------------------------------------------------- #
def load_env_keys(env_path=ENV_PATH):
    """Parse KEY=value lines from the lab .env.  Values are never returned to
    any caller that prints them; run_emission only ever holds them in memory to
    build request headers.  Split on the FIRST '=' only (the ``KIMI_API_KEY==``
    double-equals scar)."""
    keys = {}
    path = Path(env_path)
    if not path.exists():
        return keys
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or "=" not in stripped:
            continue
        if stripped.startswith("export "):
            stripped = stripped[len("export "):]
        name, _, value = stripped.partition("=")
        name = name.strip()
        value = value.strip().strip('"').strip("'")
        if name:
            keys[name] = value
    return keys


# --------------------------------------------------------------------------- #
# Transport result
# --------------------------------------------------------------------------- #
class TransportError(Exception):
    """A retryable transport failure (connect/read timeout, 5xx, 429)."""

    def __init__(self, kind, detail=""):
        super().__init__(f"{kind}: {detail}")
        self.kind = kind
        self.detail = detail


class LiveResponse:
    """A complete captured HTTP envelope from a provider.  ``final`` is always
    True at construction: a LiveResponse only exists for an HTTP 200 with a body
    we could read.  Retryable failures raise ``TransportError`` instead."""

    def __init__(self, *, http_status, headers, raw_body, subject, model_requested,
                 route, request_meta):
        self.http_status = http_status
        self.headers = dict(headers)
        self.raw_body = raw_body  # bytes, verbatim
        self.subject = subject
        self.model_requested = model_requested
        self.route = route
        self.request_meta = request_meta  # content-free description of the request (no payload text)

    # -- parsing helpers (content-free census extraction) ------------------- #
    def parsed(self):
        try:
            return json.loads(self.raw_body.decode("utf-8"))
        except (ValueError, UnicodeDecodeError):
            return None

    def census_fields(self):
        """Extract ONLY content-free census facts.  No response text is
        returned.  Returns a dict safe to write into an in-repo census."""
        body = self.parsed()
        fields = {
            "http_status": self.http_status,
            "model_id_returned": None,
            "finish_reason": None,
            "provider_request_id": self.headers.get("x-request-id")
            or self.headers.get("request-id"),
            "input_tokens": None,
            "output_tokens": None,
            "cached_input_tokens": None,
            "reasoning_tokens": None,
            "provider_reported_usage": False,
            "null_content": True,
            "raw_body_sha256": None,  # filled by caller (util.sha256_bytes)
            "raw_body_bytes": len(self.raw_body),
        }
        if body is None:
            fields["finish_reason"] = "unparseable-body"
            return fields
        # Anthropic / Kimi (Anthropic-compatible) shape
        if isinstance(body, dict) and body.get("type") == "message":
            fields["model_id_returned"] = body.get("model")
            fields["finish_reason"] = body.get("stop_reason")
            usage = body.get("usage") or {}
            fields["input_tokens"] = usage.get("input_tokens")
            fields["output_tokens"] = usage.get("output_tokens")
            fields["cached_input_tokens"] = usage.get("cache_read_input_tokens")
            fields["provider_reported_usage"] = bool(usage)
            content = body.get("content") or []
            text_units = [
                block for block in content
                if isinstance(block, dict) and block.get("type") == "text"
                and (block.get("text") or "").strip()
            ]
            fields["null_content"] = len(text_units) == 0
            return fields
        # OpenAI chat/completions shape
        if isinstance(body, dict) and "choices" in body:
            fields["model_id_returned"] = body.get("model")
            choices = body.get("choices") or []
            first = choices[0] if choices else {}
            fields["finish_reason"] = first.get("finish_reason")
            usage = body.get("usage") or {}
            fields["input_tokens"] = usage.get("prompt_tokens")
            fields["output_tokens"] = usage.get("completion_tokens")
            details = usage.get("prompt_tokens_details") or {}
            fields["cached_input_tokens"] = details.get("cached_tokens")
            comp_details = usage.get("completion_tokens_details") or {}
            fields["reasoning_tokens"] = comp_details.get("reasoning_tokens")
            fields["provider_reported_usage"] = bool(usage)
            message = (first.get("message") or {})
            text = message.get("content")
            fields["null_content"] = not (isinstance(text, str) and text.strip())
            return fields
        fields["finish_reason"] = "unrecognized-envelope"
        return fields

    def retention_disclosures(self):
        """Content-free retention/cache disclosure fields from response headers
        and top-level body flags, for the actuals record."""
        header_disclosures = {
            k: v for k, v in self.headers.items()
            if any(tok in k.lower() for tok in
                   ("cache", "retention", "store", "privacy", "data-policy", "ratelimit"))
        }
        body = self.parsed() or {}
        body_disclosures = {}
        if isinstance(body, dict):
            for key in ("store", "service_tier", "system_fingerprint"):
                if key in body:
                    body_disclosures[key] = body[key]
        return {"headers": header_disclosures, "body": body_disclosures}


# --------------------------------------------------------------------------- #
# Adapters
# --------------------------------------------------------------------------- #
RETRYABLE_HTTP = {429, 500, 502, 503, 504}


class BaseLiveAdapter:
    network_capable = True
    route = None
    subject = None
    key_env = None
    output_cap_field = "max_tokens"

    def __init__(self, api_key, *, timeout_s=120, opener=None):
        if not api_key:
            raise ValueError(f"{self.subject}: missing API key ({self.key_env})")
        self._api_key = api_key
        self.timeout_s = timeout_s
        # ``opener`` lets tests inject a transport without any network.
        self._opener = opener or self._urlopen

    # -- transport (single attempt; raises TransportError on retryable) ----- #
    def _urlopen(self, url, data, headers):
        request = urllib.request.Request(url, data=data, headers=headers, method="POST")
        try:
            with urllib.request.urlopen(request, timeout=self.timeout_s) as resp:
                return resp.status, dict(resp.headers.items()), resp.read()
        except urllib.error.HTTPError as exc:
            body = exc.read()
            if exc.code in RETRYABLE_HTTP:
                raise TransportError(f"http-{exc.code}", exc.reason) from exc
            # 4xx (non-429) is a determinate, non-retryable envelope.
            return exc.code, dict(exc.headers.items() if exc.headers else {}), body
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            raise TransportError("connect-or-timeout", str(exc)) from exc

    def _headers(self):
        raise NotImplementedError

    def _body(self, payload_text, model):
        raise NotImplementedError

    def emit(self, payload_bytes, *, model, request_meta):
        """One attempt.  Returns LiveResponse for any non-retryable HTTP status
        (including 4xx and 200); raises TransportError for the retryable class.
        ``payload_bytes`` are the byte-exact composed prompt; the text is sent to
        the provider but never returned to the caller in any content-free path."""
        payload_text = payload_bytes.decode("utf-8")
        body = json.dumps(self._body(payload_text, model)).encode("utf-8")
        status, headers, raw = self._opener(self._url, body, self._headers())
        if status in RETRYABLE_HTTP:
            raise TransportError(f"http-{status}", "retryable status from opener")
        return LiveResponse(
            http_status=status, headers=headers, raw_body=raw,
            subject=self.subject, model_requested=model, route=self.route,
            request_meta=request_meta,
        )


class AnthropicDirectAdapter(BaseLiveAdapter):
    route = "Anthropic direct route"
    subject = "claude-haiku-4.5"
    key_env = "ANTHROPIC_API_KEY"
    _url = "https://api.anthropic.com/v1/messages"
    output_cap_field = "max_tokens"

    def _headers(self):
        return {
            "x-api-key": self._api_key,
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
        }

    def _body(self, payload_text, model):
        return {
            "model": model,
            "max_tokens": OUTPUT_TOKEN_CAP,
            "temperature": 0,
            "messages": [{"role": "user", "content": payload_text}],
        }


class OpenAIAdapter(BaseLiveAdapter):
    route = "OpenAI API route"
    subject = "gpt-5.6-luna"
    key_env = "OPENAI_API_KEY"
    _url = "https://api.openai.com/v1/chat/completions"
    # gpt-5.6 is a reasoning-era model: the output cap field is
    # ``max_completion_tokens`` (VALUE stays 768).  Confirmed-at-emission actual.
    output_cap_field = "max_completion_tokens"

    def _headers(self):
        return {
            "Authorization": f"Bearer {self._api_key}",
            "content-type": "application/json",
        }

    def _body(self, payload_text, model):
        return {
            "model": model,
            "max_completion_tokens": OUTPUT_TOKEN_CAP,
            "messages": [{"role": "user", "content": payload_text}],
        }


class MoonshotKimiAdapter(BaseLiveAdapter):
    route = "Moonshot kimi.com coding route (Anthropic-compatible, api.kimi.com/coding/)"
    subject = "kimi-k3"
    key_env = "KIMI_API_KEY"
    _url = "https://api.kimi.com/coding/v1/messages"
    output_cap_field = "max_tokens"

    def _headers(self):
        # Anthropic-compatible surface: x-api-key + anthropic-version.
        return {
            "x-api-key": self._api_key,
            "Authorization": f"Bearer {self._api_key}",
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
        }

    def _body(self, payload_text, model):
        return {
            "model": model,
            "max_tokens": OUTPUT_TOKEN_CAP,
            "temperature": 0,
            "messages": [{"role": "user", "content": payload_text}],
        }


SUBJECT_ADAPTERS = {
    "claude-haiku-4.5": AnthropicDirectAdapter,
    "gpt-5.6-luna": OpenAIAdapter,
    "kimi-k3": MoonshotKimiAdapter,
}


def build_adapter(subject, keys, **kwargs):
    cls = SUBJECT_ADAPTERS.get(subject)
    if cls is None:
        raise ValueError(f"no live adapter for subject {subject!r}")
    return cls(keys.get(cls.key_env), **kwargs)


# --------------------------------------------------------------------------- #
# Mock provider (dry-run + teeth checks).  NO network, NO keys.
# --------------------------------------------------------------------------- #
class MockProvider:
    """Deterministic offline stand-in for the live adapters.  Modes let the
    teeth-check plant provider-level faults (null content, permanent transport
    failure).  It never touches the network and needs no key."""

    network_capable = False

    def __init__(self, mode="normal"):
        self.mode = mode
        self.attempts = 0

    def emit(self, payload_bytes, *, model, request_meta):
        self.attempts += 1
        if self.mode == "transport-always":
            raise TransportError("connect-or-timeout", "mock permanent transport failure")
        subject = request_meta.get("subject")
        digest = _hexdigest(request_meta.get("call_id", "") + model)
        if self.mode == "null-content":
            body = {"type": "message", "model": model + "-actual",
                    "stop_reason": "end_turn",
                    "usage": {"input_tokens": 10, "output_tokens": 0},
                    "content": []}
        else:
            body = {"type": "message", "model": model + "-actual",
                    "stop_reason": "end_turn",
                    "usage": {"input_tokens": 10, "output_tokens": 5},
                    "content": [{"type": "text",
                                 "text": f"MOCK OFFLINE ARTIFACT {digest[:12]} (no target contact)"}]}
        raw = json.dumps(body, sort_keys=True, separators=(",", ":")).encode("utf-8")
        return LiveResponse(
            http_status=200, headers={"x-request-id": f"mock-{digest[:16]}"},
            raw_body=raw, subject=subject, model_requested=model,
            route="mock:no-network", request_meta=request_meta,
        )


def _hexdigest(text):
    import hashlib
    return hashlib.sha256(text.encode("utf-8")).hexdigest()
