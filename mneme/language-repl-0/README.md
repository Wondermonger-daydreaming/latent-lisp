# REPL /0 — the language answers back (CANDIDATE)

*An interactive Lisp+ session, on the command line and in a local browser workbench, built on PROGRAM /0.
Commissioned 2026-09-25 ("REPL /0 — THE LANGUAGE ANSWERS BACK", Tomás → Opus 5.5, with Astra's proposed scope, plus
the WebTUI workbench addendum). Built by Claude Opus 5.5 (desktop chair); the browser page by LANTERN (Claude Opus 5.5,
subagent), reviewed and browser-tested by the chair. **Standing: CANDIDATE.** Running it adopts nothing; this lane is
not integrated into lab `main` and not published — the commission authorizes neither.*

## Run it

From the latent-lisp root (the public repository root, or `experiments/latent-lisp/` in the lab), with SBCL 2.4.6:

```bash
bash mneme/language-repl-0/lisp-plus-repl.sh                    # the command-line REPL
bash mneme/language-repl-0/lisp-plus-repl.sh --web              # the browser workbench → http://127.0.0.1:4917/
bash mneme/language-repl-0/lisp-plus-repl.sh --web --port 5000  # another local port
```

Nothing to install: the REPL uses SBCL and its own `sb-bsd-sockets` contrib; the page uses one vendored, pinned
stylesheet (WebTUI 0.1.10, below). **An extracted delivery needs four directories** under the latent-lisp root, not
three: `mneme/language-repl-0`, `mneme/language-program-0`, `mneme/kernel0`, and `canonical-datum/common-lisp`, which
Kernel /0's `load.lisp` loads. (r2: the parcel's in-extraction validator refused a three-directory cut, and every gate
failed there, while every gate passed in a checkout, where the fourth directory is always present.) Ctrl-D (or `,quit`) leaves the command line; Ctrl-C stops the web server.

## A session, in one paragraph

Every submission of a session is read by PROGRAM /0's reader and evaluated by PROGRAM /0's `run-source` in **one
program frame**, the frame a file program runs in. **Each submission's successfully read, complete forms are evaluated
in order in that same frame**: the same `define`, closures, lexical scope, forward references between submissions,
shadowing of prelude names, and the same `E-REDEFINE` when a name is defined twice. **No REPL-only semantics were
added; no language change was needed for persistence.**

This is *not* the same as running the concatenated text as one file (r3: Astra's AMEND narrowed the r0–r2 claim). The
differences are the submission boundary, the budgets and the recovery policy:

- Each submission is read on its own before its forms run. Submit `(define kept 7)`, then `)`: the second is E-READ
  and `kept` stays 7. A file with both lines is refused at read time, before the definition is evaluated. The selftest
  witnesses both. Raw concatenation can also merge tokens or extend a `;` comment unless submissions are separated.
- The step budget and depth limit apply per submission.
- An error does not end the session.

**Redefinition is not offered.** `(define x 1)` then `(define x 2)` is E-REDEFINE, as in a file. Allowing it would
change the language — either as a fresh frame per submission, where earlier closures keep the old binding and forward
references between submissions break, or by overwriting in place, which breaks "a name is bound once per frame". It
is named here, not built. To start over, reset explicitly (`,reset`, or the Reset button).

## Input

- A form may span lines. The command line prompts `..>` until **the reader** reports a complete text. The browser
  submits the whole editor (Ctrl+Enter, or the Submit button) and reports `incomplete` without evaluating.
- *Incomplete* versus *malformed* is the reader's own verdict, not a second parser's. The text ends inside a form (an
  unclosed paren, string, `|…|` escape or `#` dispatch) → **incomplete**, nothing evaluated. Anything else the reader
  refuses (a stray `)`, `#.`, a bad dot) → **E-READ**, nothing evaluated. Strings, `;` comments and `#|…|#` comments
  are handled exactly as the reader handles them.
- Several forms in one submission are one submission. Its value is the last form's, as in a file (`print` shows
  intermediate values).
- **End of input** (Ctrl-D, or the end of a pipe) leaves cleanly. An unfinished form at that moment is **discarded
  and reported, never evaluated**.

## Errors and what happens to state (no rollback is implemented)

| what failed | what happened |
|---|---|
| the reader refused the text | nothing of the submission was evaluated; the session is unchanged |
| a form raised a language error | forms before it took effect and stay; its own effects up to the failure stay (e.g. a `define` inside a top-level `begin`); later forms did not run |
| a host fault (a defect of this implementation) | the same, reported as `HOST FAULT … a defect of the implementation, not of your program` — never confused with a language error |

In every case the session continues and the next submission is evaluated normally. The diagnostic is PROGRAM /0's
own. Its location is the **submission location**, the line and column of the submitted top-level form
(`lisp-plus: E-TYPE at in[5]:1:0`), with the **failing expression** named separately. A closure's body does not carry
the place it was defined, so an error inside it cites the submission that called it, not the definition's line.

## Session controls (command line)

A control is a whole line starting with a comma. A comma outside a backquote is never valid Lisp+, so a control can
never shadow a program. Mid-form, `,cancel` counts as a control only where the **reader** would read that comma as code.
Inside an open string, `|…|` escape or `#|…|#` comment the line is the program's text and is kept; close the string
first, or press Ctrl-D. (r1: r0 discarded a `,cancel` line inside a multi-line string, where a file would print it.)

`,help` · `,names` (the names bound in this session) · `,reset` (a **new** session: every binding cleared, new id
printed) · `,cancel` (discard the unfinished text; works mid-form) · `,quit`. An unknown `,word` is refused and never
reaches Lisp+.

## The language boundary

User text reaches the language only as a string handed to `run-source`. Nothing in this lane calls `cl:read` or
`cl:eval` on it. That is a claim about **evaluation**, not about **host reader side effects**: PROGRAM /0's reader can
intern a package-qualified name into an unlocked host package before refusing it (see the observations below). The reader law is PROGRAM /0's: `*read-eval*` NIL (`#.(sb-ext:quit)` is E-READ; the process lives),
and a package namespace that uses nothing (`eval`, `load` and `quit` are unbound names; `cl:eval` and
`sb-ext:quit` are refused). As with the file runner, nothing that performs effects is loaded: no core0, act0, act1 or
many-acts0.

## The browser workbench

The page shows:

- session identity: id, generation, start time;
- evaluation status: ready / evaluating… / the last outcome;
- a multi-line editor (Enter = newline, Ctrl/Cmd+Enter = submit);
- submission history (Alt+Up / Alt+Down recall; click to copy back);
- a transcript where input, `print` output, value (with its kind), definition, language error (code, message,
  `in[n]:line:col`, in / within / frames, explanation, the full diagnostic) and host fault are each labelled and
  visually distinct;
- the names bound in the session;
- an explicit Reset that asks first.

All program output is rendered as **text** (`textContent` only; `print "<b>…</b>"` shows the tags). The page states
plainly what the runtime does not supply: steps used, per-form values, positions inside a form, provenance or evidence
fields, per-form timings, and server-side history (the server keeps none).

**When an answer does not arrive (r3).** A lost, unreadable or malformed answer is not evidence that nothing
happened: the server may have evaluated or reset before the answer failed. The page says so. **OUTCOME UNKNOWN** keeps
your text, never resends, and offers a read-only **Refresh session**, which shows the current identity and bindings
but cannot tell which request produced them. The page reports "did not happen" only when the server answered *and*
said so (`before_mutation: true`). The server knows that structurally: a flag is set immediately before the one call
that mutates.

**Valid JSON is not a valid answer (r4).** Before an answer changes anything, the page checks its shape against
`WEB-API-0.md`. That covers rendering the session, clearing the editor or transcript, adding history, and announcing
success. A success must carry a whole session; a submit must carry a status-appropriate result, and a reset must name a
*replacement* session. Anything short of that is OUTCOME UNKNOWN: text and transcript are kept, busy is released, and
a refresh is offered. An invalid refresh answer says REFRESH FAILED and leaves the last valid display. A stale refusal
whose session snapshot is unusable stays a refusal but does not replace the display. Legitimate empty values are not
rejected: `(quote ||)` renders as `""`, and so does `(define || 5)`'s name.

**Acting on the session the page shows (r3).** Submit and reset carry the page's session id
(`X-Lisp-Plus-Session`), and the server compares it before any mutation. A stale page, one where another tab reset
the session in between, gets `409` with the current session: nothing is evaluated or reset, the page shows the new
session, and you act again deliberately. A reset confirmation is bound to the session it names.

**The engine is independent of the UI.** `repl0.lisp` takes text in and returns a record, and knows nothing of
terminals or HTTP. The command line (`repl0-cli.lisp`) and the server (`repl0-web.lisp`) are two clients of the same
engine, in the same kind of SBCL image. The HTTP contract is `WEB-API-0.md`.

**The fence** (each item is code in `repl0-web.lisp` and a check in `test-web.sh`):

- The server binds 127.0.0.1 only.
- Host must be `127.0.0.1:<port>` or `localhost:<port>` (else 421, the DNS-rebinding fence). A foreign Origin gets
  403. A cross-site or same-site `Sec-Fetch-Site` on `/api/` gets 403.
- A per-launch 64-hex token from `/dev/urandom` is delivered only inside the page and required on every `/api/` call
  (else 403).
- There is no CORS: no `OPTIONS`, no `Access-Control-*` header.
- Only fixed paths and methods are served (404 / 405). Bodies are capped at 64 KiB (413), must be text/plain (415) and
  strict UTF-8 (400); chunked bodies are refused (400). Headers are capped at 16 KiB (431). **The whole request, header
  and body, must arrive within 10 s** (408), checked on every byte, and each single read times out after 2 s. (r1: in
  r0 the 10 s was per *read*, so a client trickling its header held the single thread for 23.7 s; now it holds it for
  at most the deadline, measured at 9.7 s.)
- Every response carries a strict CSP, nosniff, no-referrer and no-store.
- The server is single-threaded: one request at a time.

**WebTUI, pinned.** `web/vendor/webtui-css-0.1.10/full.css` is `dist/full.css` from the npm package `@webtui/css`
0.1.10: tarball sha512 `iovJnGDbhi0vaaOjpG+i56HGKx5hHls8JhhQxwPTl5b5ddce7PO+r7F+S4EObYjQlaa1RfClahkmpiNF+R8y8w==` (equal
to the registry's `integrity`), file sha256 `efd2619fbabf2fbf189a7ea84b3de51844487a985d98aef6ec6341ef6c46facc`
(checked by `test-web.sh`). The repository tag `0.1.10` is commit `c8eaf2c10a08e33082602be353ec20affc43770e`, and
`LICENSE` (MIT, © 2025 WebTUI) was fetched from that commit. The July scouting the addendum mentions is not in the
lab's tracked tree (`git grep -i webtui` found nothing), so the workbench was built from the package itself.

## Verification

Run from the latent-lisp root. Each command exits 0 iff all its checks pass.

| command | checks | what it drives |
|---|---|---|
| `bash mneme/language-repl-0/run-selftest.sh` | 68 | the engine in-process: persistence, closure capture across submissions, forward reference, multiline, incomplete vs malformed, error recovery and state, budget, language boundary, host-fault classification, **the reset detector** (on the real engine and on a planted resetting engine, which it must fail), session = concatenated file, CLI via streams (multiline, EOF, controls, `,cancel` inside a string), the reader-verdict helper, the submission-boundary example (session keeps `kept`; the concatenated file refuses), JSON escaping |
| `bash mneme/language-repl-0/test-cli.sh` | 9 | the one command as a real process on a pipe: exit codes, EOF inside a form (discarded, not run), `#.(sb-ext:quit :unix-status 7)` refused, usage error, stdout/stderr split |
| `bash mneme/language-repl-0/test-web.sh` | 48 | the real server: the defining sequence over HTTP, reset, every fence refusal, a client trickling its request over 24 s (must not hold the server past the deadline), and the session precondition (428 missing, 409 stale, a pre-reset id refused, nothing evaluated or reset) |
| `node mneme/language-repl-0/test-browser.mjs` | 59 | a real headless Chromium: the defining sequence typed and clicked, multi-line with Enter, incomplete kept, print as text, history recall, reset cancel/confirm, no horizontal scroll at 800 px, zero CSP violations and page errors; then r3: a submit and a reset that **complete on the server and lose or corrupt their answer** (Playwright intercepts after the real request), and **two tabs** (a stale confirmation, a stale submission); then r4: her two exact bodies after the real request (reset
`{}`, submit `{"result":{"status":"value"}}`), an invalid refresh, a stale refusal with an unusable snapshot, and a
legitimate empty value. A test tool, not a dependency: needs `playwright@1.55.0` and its `chromium-headless-shell` |
| `bash mneme/language-program-0/run-selftest.sh` | 136 | PROGRAM /0's own gate (125 before; +11 for the reader change below) |

Mutants each gate was seen to fail on: the reader's EOF flag reverted (PROGRAM /0 gate: 1 FAIL); a planted env reset
(reset detector FAILS); a CLI that evaluates pending text at EOF (test-cli: 1 FAIL); the token check disabled
(test-web: 2 FAIL); `innerHTML` on print output (test-browser: 2 FAIL). r1's two repairs were each seen to fail on r0's
bytes first: the `,cancel` case discarded the string, and the r1 test-web against the r0 server FAILED the trickle check
at 23.5 s. r3's new browser checks were run against r2's bytes (A–E all FAIL: the old wording and no identity check)
and against r3 with only the identity comparison removed (A–C pass, D and E FAIL). Astra's own probe, unchanged, FAILS on
r3's `app.js` at the defect's assertion. The chair's adaptation of it, which asserts r3's behaviour, passes on r3 and
fails on r2.

Transcripts from the delivered candidate: `transcripts/cli-session.txt` (stdin `transcripts/cli-session.input.lp`,
exit status and time beside it).

## r4 (2026-09-25): Astra's second AMEND, one residual repair

Astra re-ran the positive probe (the three original cases now say OUTCOME UNKNOWN) and found the remaining gap: valid
JSON with missing fields still became success. A reset answered `{}` cleared the transcript and announced a session
with no id; a submit answered `{"result":{"status":"value"}}` cleared the editor and added an empty VALUE. Both were
reproduced with her probe, unchanged, on r3. r4 validates every answer's shape before it changes the display (see "Valid
JSON is not a valid answer"). Her probe, unchanged, now fails on r4 at `assert(committed)`: r4 also validates the
first session read, and her stub's session (`id: 'old'`, `runtime: {}`) is not contract-shaped. The discriminating
run is her assertions with *only* that stub made contract-shaped: exit 0 on r3 and a failure on r4 at her own defect
assertion.

## r3 (2026-09-25): Astra's AMEND

Astra (the ruling office) reviewed r2. She verified the archive and its 64 checksums, did not rerun the SBCL gates,
and ran her own Node fault-injection probe of `app.js`. Her ruling was **AMEND, two bounded browser-state repairs**,
plus narrowed wording. Her probe was reproduced unchanged on the r2 bytes, with her three output lines identical. Her
two source-derived claims were reproduced on the real r2 server: a stale confirmation wiped another tab's session,
and the parsing boundary behaves as she said. r3:

1. **Unknown stays unknown.** The page distinguishes a server-stated refusal from an unknown outcome, and handles
   `interrupted` explicitly.
2. **Session identity is a server-checked precondition** on submit and reset (428 missing, 409 stale).
3. **The concatenated-file claim is narrowed**, in this README, in the engine header and in the selftest, with the
   boundary example as checks.
4. **Wording:** "submission location" and "failing expression"; no "never signals"; the heap probe is sized as one
   case; "no evaluation" is not promoted to "no reader side effects"; the capabilities panel is a closed disclosure.
   The "presentation steering" her ruling mentions never reached this chair; only what her ruling names was done.

Her disposition of the handed-on questions stands as she wrote it. `E-REDEFINE` is kept for /0. Interning is retained
as an inherited PROGRAM /0 reader limitation, reproduction attributed to Opus 5.5. Budgets carry no wall-clock
promise. Astra's review is her source inspection and her Node probe; the gates are the chair's measurements. Nobody
has described this candidate as independently runtime-verified.

## r1 (2026-09-25): the adversarial pass

CALIPER, an adversarial checker (Claude Opus 5.5 subagent), was stopped by a safety classifier before it ran anything.
It returned four suspicions from reading the code, labelled as unreproduced. The chair ran each one. Two were
**defects**, now repaired with checks: `,cancel` shadowing a string, and the per-read timeout. Two are **limits**, now
documented: steps do not bound time, and the reader can intern into an unlocked host package. CALIPER shares the chair's
weights, so its read and the chair's runs are one root, not two witnesses. Every result above was measured by the
chair, and no outside reviewer has yet run this candidate.

## The one change to PROGRAM /0 (disclosed)

`language-program-0/program0.lisp` now reads with `eof-error-p` NIL and a private end marker. A source ending in a
`#|…|#` comment is no longer refused as unfinished; that was a defect. A text that ends inside a form still gets E-READ,
rendered identically, but its condition is now of the exported subclass `program0-incomplete-source`. `fail` became a
call to the new `fail-as`. Documented in `PROGRAM-0-GRAMMAR-AND-SEMANTICS.md` §1. The three program files and their
recorded outputs are unchanged, and the selftest compares them byte for byte. The engine reads four PROGRAM /0
internals read-only (`env-table`, `program0-error-source`, `render-abbrev`, `+error-codes+`), named in `repl0.lisp`.

## Remaining limitations

- No redefinition (above), no rollback, no history persisted anywhere, no completion, no terminal line editing (use
  `rlwrap bash …` if wanted), no debugger, no per-form values.
- **The step budget bounds the number of evaluation steps, not wall time or memory.** One step of a primitive can be
  expensive: bignum `*` and `string-append` grow per step. Measured: a few dozen steps of repeated squaring took ~2 s,
  and each further squaring roughly triples it. For memory there is one favourable case, not a guarantee: in a
  deliberately small 256 MB image, exhausting the heap was caught and reported as `E-BUDGET` and the next submission
  worked. That probe does not establish recovery from every exhaustion. Time has no fence. A
  wall-clock interrupt was not added, because interrupting SBCL mid-write in the session's frame could corrupt the
  session, which is worse than a slow answer; Ctrl-C interrupts on the command line.
- One session per server process, and the server is single-threaded: a long evaluation blocks other requests until
  it finishes. Several browser tabs share the one session. Each submit and reset names the session its page shows,
  and the server refuses a stale one without evaluating or resetting (r3, below).
- `print` output is captured and shown when the submission ends, not streamed.
- The server trusts any local user who can reach 127.0.0.1 and load the page (the token lives in the page). It is a
  single-user local tool, not a multi-user service.
- Declared for SBCL 2.4.6 on Linux only, as PROGRAM /0 is. Browser-tested in headless Chromium only.

## Observations handed on, not acted on

- **The reader can intern into an unlocked host package before refusing.** `(cl-user::zzq-probe-one 1)` is refused
  (E-SYNTAX), but the CL reader has already interned `ZZQ-PROBE-ONE` in `CL-USER`. Locked packages (`SB-EXT`, `CL`)
  refuse at the reader and nothing is interned. No host code runs and nothing is evaluated, but a name appears in a host
  package. The file runner shares the reader, so this predates REPL /0, and fixing it would change PROGRAM /0's reader
  law. Reproduced 2026-09-25, in-process, with `find-symbol` before and after.

- **`:true` is `true`.** PROGRAM /0 represents its booleans as the keywords `:true` and `:false`, and keywords are also
  program values. So `(if :true 1 2)` ⇒ 1 and `(equal? :false false)` ⇒ true. This predates REPL /0; it is a question
  for the language, not the REPL.
- **One PROGRAM /0 check is counted but not printed.** The "strings and print" check runs inside a `let` that binds
  `*standard-output*` to a broadcast stream, which swallows its own `ok` line. The gate therefore prints 124 `ok` lines
  for 125 passes on unchanged `main` (135 for 136 here). This predates REPL /0; the published test was left alone.
- **If this candidate is ever integrated,** the root README's "(125 checks)" becomes stale (136). The root README was
  deliberately not touched here: its one pending change (the accepted +15 blob at `68b52fe6a`) awaits its own crossing.

## Files

`package.lisp` · `repl0.lisp` (engine) · `repl0-cli.lisp` · `repl0-web.lisp` · `main.lisp` · `lisp-plus-repl.sh` (the
one command) · `WEB-API-0.md` · `web/{index.html,app.js,app.css}` · `web/vendor/webtui-css-0.1.10/{full.css,LICENSE}` ·
`repl0-selftest.lisp` + `run-selftest.sh` · `test-cli.sh` · `test-web.sh` · `test-browser.mjs` · `transcripts/`.
