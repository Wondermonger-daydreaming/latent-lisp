"""Live provider adapters for the Language-A 312-emission run.

ADDITIVE SUCCESSOR construction, REPAIRED to the single OpenRouter route under
owner ruling R15 (OWNER-ROUTE-SUBSTITUTION-AND-REEMISSION-v1,
record_digest sha256:fb40c815b0eede11c60765973cdac72c196196bf71d6bedf272da003a3beb2d0).
This module is the ONLY place in the packet that is capable of contacting a
provider.  It is imported exclusively by ``run_emission.py``; no frozen file
imports it (one-renderer / one-emitter exclusivity, proven in the construction
notes).  It performs NO provider contact at import time and none at all unless
``run_emission.py`` is invoked in its explicit ``--live`` mode.

R15 repair (2026-07-18): the three direct adapters (Anthropic-direct 404,
OpenAI-direct 429 insufficient_quota, Moonshot-direct 401 authentication_error;
all three verified failures quoted from R15 ``attempt_01_record``) are replaced
by ONE ``OpenRouterAdapter`` on the lab's funded, sandbox-verified OpenRouter
route, parameterized by the three R15 ``amended_subject_routes`` model ids:

  (a) claude-haiku-4.5  -> anthropic/claude-haiku-4.5   (Claude-family)
  (b) gpt-5.6-luna      -> openai/gpt-5.6-luna          (GPT-family)
  (c) kimi-k3           -> moonshotai/kimi-k3           (Kimi-family, reasoning-class)

All three go to POST https://openrouter.ai/api/v1/chat/completions with
``Authorization: Bearer OPENROUTER_API_KEY``.

Hard invariants enforced here:
  * ``max_tokens`` / output cap is HARD-CODED to 768 per attempt.  OpenRouter
    accepts ``max_tokens`` for all three routes, so the earlier OpenAI-direct
    ``max_completion_tokens`` concern is OBSOLETE on this route (one output-cap
    field for every subject).
  * The full HTTP response envelope (status, headers, raw body bytes) is
    captured for owner-custody evidence; nothing is discarded.
  * An HTTP 200 whose body parses to a determinate envelope is FINAL for the
    call.  A null/empty content 200 is a determinate ``NULL_CONTENT`` outcome,
    never retried (the option-(a) idiom; aligns with SCORING-CONSTITUTION T11).
    kimi-k3 reasoning exhaustion under the 768 cap lands here as a determinate
    census entry (R15 bounded-unknown), not a rerun license.
  * Transport errors (connect / read timeout / HTTP 5xx / HTTP 429) are the
    only retryable class; the retry budget is a GLOBAL ceiling owned by the
    caller (<=32 across the whole run).
  * The serving provider OpenRouter used for each call (its top-level
    ``provider`` field) is captured into the census as an emission actual
    (R15 ``serving_provider_rule``): family identity is declared at the model
    level, not the serving level; the serving provider is dynamic and recorded.

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
            "serving_provider": None,  # OpenRouter top-level 'provider' (R15 serving_provider_rule)
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
        # OpenRouter records the upstream that served the call at the top level;
        # capture it regardless of the response envelope shape.
        if isinstance(body, dict):
            fields["serving_provider"] = body.get("provider")
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


# R15 amended_subject_routes: one funded OpenRouter route, three model ids.  The
# runner passes the model id it read from the R15 record itself; this constant is
# the documented default and a drift guard (build_adapter refuses a mismatch).
OPENROUTER_ROUTE = "OpenRouter route (openrouter.ai/api/v1/chat/completions)"
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
OPENROUTER_KEY_ENV = "OPENROUTER_API_KEY"
OPENROUTER_MODEL_IDS = {
    "claude-haiku-4.5": "anthropic/claude-haiku-4.5",
    "gpt-5.6-luna": "openai/gpt-5.6-luna",
    "kimi-k3": "moonshotai/kimi-k3",
}


class OpenRouterAdapter(BaseLiveAdapter):
    """Single funded route for all three subjects (R15).  Parameterized by the
    subject and its OpenRouter model id; the OpenAI-compatible chat/completions
    surface accepts ``max_tokens`` (value 768) for every model on this route, so
    there is one output-cap field (the OpenAI-direct ``max_completion_tokens``
    concern is obsolete here)."""

    route = OPENROUTER_ROUTE
    key_env = OPENROUTER_KEY_ENV
    _url = OPENROUTER_URL
    output_cap_field = "max_tokens"

    def __init__(self, api_key, *, subject, model_id, **kwargs):
        super().__init__(api_key, **kwargs)
        self.subject = subject
        self.model_id = model_id

    def _headers(self):
        return {
            "Authorization": f"Bearer {self._api_key}",
            "content-type": "application/json",
        }

    def _body(self, payload_text, model):
        # The wire model is always the OpenRouter model id (``model`` from the
        # caller is the subject label, kept only for census/request_meta).
        return {
            "model": self.model_id,
            "max_tokens": OUTPUT_TOKEN_CAP,
            "temperature": 0,
            "messages": [{"role": "user", "content": payload_text}],
        }


def build_adapter(subject, keys, *, model_id=None, **kwargs):
    """Construct the single OpenRouter adapter for ``subject``.  ``model_id`` is
    the R15 amended route id (the runner supplies it from the R15 record); if
    omitted it defaults to the documented constant, and a supplied id that
    disagrees with the constant is refused as a route-drift error."""
    default_id = OPENROUTER_MODEL_IDS.get(subject)
    if default_id is None:
        raise ValueError(f"no OpenRouter route for subject {subject!r}")
    if model_id is None:
        model_id = default_id
    elif model_id != default_id:
        raise ValueError(
            f"R15 model id {model_id!r} for {subject!r} disagrees with adapter default {default_id!r}")
    return OpenRouterAdapter(keys.get(OPENROUTER_KEY_ENV), subject=subject, model_id=model_id, **kwargs)


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
        # Mirror the OpenRouter chat/completions envelope (the ONLY live shape on
        # this route), including the top-level serving ``provider`` field so the
        # dry-run exercises the real census-extraction path (R15 serving_provider).
        if self.mode == "null-content":
            # Simulate reasoning exhaustion under the 768 cap (kimi-k3 idiom):
            # a determinate empty-content 200, never retried.
            body = {"id": f"mock-{digest[:16]}",
                    "provider": "MockRouter (offline, no network)",
                    "model": model + "-actual",
                    "choices": [{"index": 0, "finish_reason": "length",
                                 "message": {"role": "assistant", "content": ""}}],
                    "usage": {"prompt_tokens": 10, "completion_tokens": 0,
                              "completion_tokens_details": {"reasoning_tokens": 768}}}
        else:
            body = {"id": f"mock-{digest[:16]}",
                    "provider": "MockRouter (offline, no network)",
                    "model": model + "-actual",
                    "choices": [{"index": 0, "finish_reason": "stop",
                                 "message": {"role": "assistant",
                                             "content": f"MOCK OFFLINE ARTIFACT {digest[:12]} (no target contact)"}}],
                    "usage": {"prompt_tokens": 10, "completion_tokens": 5}}
        raw = json.dumps(body, sort_keys=True, separators=(",", ":")).encode("utf-8")
        return LiveResponse(
            http_status=200, headers={"x-request-id": f"mock-{digest[:16]}"},
            raw_body=raw, subject=subject, model_requested=model,
            route=OPENROUTER_ROUTE + " [mock:no-network]", request_meta=request_meta,
        )


def _hexdigest(text):
    import hashlib
    return hashlib.sha256(text.encode("utf-8")).hexdigest()
