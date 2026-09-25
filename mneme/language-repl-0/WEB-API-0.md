# REPL /0 — the local workbench's HTTP contract (CANDIDATE)

*The one contract between the browser page (`web/`) and the Lisp+ runtime (`repl0-web.lisp`). The page may rely on nothing
the server does not state here; the server sends nothing the runtime does not supply. Standing: CANDIDATE — part of the
REPL /0 candidate; adopts nothing.*

## Origin and fence

- The server binds **127.0.0.1 only**, on the port given at launch (default 4917). It is one SBCL process: the same image
  that runs the command-line REPL, the same session engine (`repl0.lisp`), the same reader and evaluator (PROGRAM /0).
- **Host header** must be `127.0.0.1:<port>` or `localhost:<port>`; anything else → `421`/`403` (DNS-rebinding fence).
- **Origin header**, when present, must be `http://127.0.0.1:<port>` or `http://localhost:<port>`; else `403`.
- **Every `/api/*` request** must carry `X-Lisp-Plus-Token: <token>` — a 64-hex-digit value generated per launch from
  `/dev/urandom` and delivered only inside the served page, in `<meta name="lisp-plus-token" content="…">`. Missing or wrong →
  `403`. (A custom header forces a CORS preflight; the server answers no `OPTIONS` and sends no `Access-Control-*` header, so
  no other origin can complete a call.)
- Static paths are a **fixed list**: `/`, `/app.js`, `/app.css`, `/vendor/webtui-css-0.1.10/full.css`, and `/favicon.ico`
  (answered `204 No Content`: there is no icon, said explicitly). Anything else → `404`.
  Methods other than those listed → `405`. Request bodies over 65,536 bytes → `413`. The whole request (header and
  body) must arrive within 10 s, each read within 2 s → `408` or a closed connection.
- Every response carries `Content-Security-Policy: default-src 'none'; script-src 'self'; style-src 'self'; connect-src 'self';
  img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'`, `X-Content-Type-Options: nosniff`,
  `Referrer-Policy: no-referrer`, `Cache-Control: no-store`. **So the page may use no inline `<script>`, no inline `<style>`,
  and no `style="…"` attributes in markup** (setting `element.style.x` from `app.js` is allowed by CSP).

## Endpoints

| Method + path | Body | Answer |
|---|---|---|
| `GET /api/session` | — | `200` `{ "session": Session, "runtime": Runtime }` |
| `POST /api/submit` | the source text, `Content-Type: text/plain;charset=utf-8`, UTF-8, ≤ 65,536 bytes; header `X-Lisp-Plus-Session: <the id the page shows>` | `200` `{ "session": Session, "result": Result }` — **always 200** for anything the language said (value, definition, incomplete input, language error, host fault, interruption); non-200 only for protocol refusals |
| `POST /api/reset` | empty; header `X-Lisp-Plus-Session: <the id the confirmation named>` | `200` `{ "session": Session, "runtime": Runtime }` — a **new** session (new `id`, `generation` + 1, no user bindings) |

**Session precondition (r3).** Submit and reset compare `X-Lisp-Plus-Session` with the current session BEFORE any
mutation: missing → `428`; different → `409` `{ "error", "before_mutation": true, "session": Session }` — the
current session, so the page can show it. Nothing is evaluated or reset on either.

Protocol refusals: `{ "error": "<plain sentence>", "before_mutation": true|false }` with `400 · 403 · 404 · 405 · 408 ·
409 · 413 · 415 · 421 · 428 · 431 · 500`. **`before_mutation: true` is the only statement that nothing happened** —
the server sets a flag immediately before the one call that mutates, and reports it on every refusal. `false` means
the mutation had begun. **Anything else — no answer, an unreadable or non-JSON body, a 2xx without the expected shape —
is an UNKNOWN outcome**: the page keeps the text, never resends, and offers a read-only `GET /api/session`, which shows
the current state but cannot identify which request produced it (r3, Astra's AMEND). **A 2xx whose body is valid JSON but not
the shape this contract states is also UNKNOWN** (r4): the page validates every answer before it changes anything.

## Session

```json
{ "id": "3f9c0a1e", "started": "2026-09-25T14:03:11-03:00", "generation": 1,
  "submissions": 4, "names": ["add5", "make-adder", "x"] }
```

- `id` — 8 hex digits, fresh per session; a reset changes it. `generation` — 1 for the first session of this server
  process, +1 per reset. `started` — local time the session began.
- `submissions` — count of submissions that were *evaluated or refused* (incomplete input is not a submission).
- `names` — the names bound by the user in this session's frame, sorted. Read from the session frame; prelude and
  primitive names are not listed.

## Runtime

```json
{ "language": "Lisp+ PROGRAM /0", "program0_version": 0, "repl_version": 0, "sbcl": "2.4.6",
  "step_budget": 1000000, "depth_limit": 4000, "max_source_bytes": 65536 }
```

## Result

```json
{ "index": 3, "status": "value", "forms": 1, "value": "(6 11)", "kind": "list",
  "output": "", "elapsed_ms": 2, "error": null, "fault": null, "note": null }
```

- `status` is exactly one of:
  - `"value"` — the last form produced a value; `value` is its rendering (PROGRAM /0's own `render`), `kind` one of
    `number string boolean empty-list list symbol keyword function primitive refusal host-value`.
  - `"defined"` — the last form was a top-level `define`; `value` is the name defined (`kind` null).
  - `"empty"` — the text held only whitespace/comments; nothing evaluated; `index` null.
  - `"incomplete"` — the reader reached the end of the text inside a form (an open paren, string or `|…|`); **nothing was
    evaluated**; `index` null; `note` says so. The page should keep the text in the editor.
  - `"language-error"` — PROGRAM /0 refused (reader or evaluator). `error` =
    `{ "code": "E-UNBOUND", "message": "unknown name `y`", "location": {"source": "in[3]", "line": 1, "column": 0} | null,
    "in": "(+ y 1)" | null, "within": ["…"], "frames": ["f", "g"], "explanation": "a name has no binding",
    "text": "<the full diagnostic exactly as the command line prints it>" }`.
  - `"host-fault"` — a condition that is not the language's own: a defect of the implementation, not of the program.
    `fault` = `{ "type": "…", "message": "…" }`.
  - `"interrupted"` — evaluation was interrupted (Ctrl-C reaches the command line; the page renders it if it ever
    arrives). `fault` carries the message; what ran before stays.
- `index` — this submission's number in the session (1, 2, …); its source name is `in[<index>]`. An error's
  `location` is the SUBMISSION location (the submitted top-level form's line:column), and `in` is the failing
  expression; a closure body carries no definition location.
- `forms` — top-level forms read (null for empty/incomplete).
- `output` — everything the program wrote with `print` during this submission, as text (may be `""`). Render as text.
- `elapsed_ms` — wall time of the evaluation, measured by the server.
- `state_note` — present on `language-error` and `host-fault`: what happened to the session state (forms before the failing
  one kept their effects; nothing is rolled back).

**What is NOT supplied** (the page must not invent it): steps used, per-form values of a multi-form submission, source
positions inside a form, types beyond `kind`, provenance, evidence, timings per form, any history the server keeps (the
server keeps none — history is the page's).
