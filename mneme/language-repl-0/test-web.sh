#!/usr/bin/env bash
# test-web.sh — REPL /0's browser-server checks THROUGH THE ONE COMMAND: start the real
# workbench (`lisp-plus-repl.sh --web`) on a free local port, drive the defining sequence
# over HTTP exactly as the page does, then attack the fence. One line per check.
#   bash mneme/language-repl-0/test-web.sh      (exit 0 iff every check passed)
# Needs curl and python3 (python3 only parses the JSON answers; it serves nothing).
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
PORT="$(python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()')"
BASE="http://127.0.0.1:$PORT"
bash "$HERE/lisp-plus-repl.sh" --web --port "$PORT" > "$TMP/server.out" 2> "$TMP/server.err" &
SPID=$!
DPID=""   # r5: the default-port server, if the check below starts one
cleanup() { kill "$SPID" ${DPID:+"$DPID"} 2>/dev/null; wait "$SPID" ${DPID:+"$DPID"} 2>/dev/null; rm -rf "$TMP"; }
trap cleanup EXIT
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1${2:+  — $2}"; }

for i in $(seq 1 100); do curl -s -o /dev/null "$BASE/" -H "Host: 127.0.0.1:$PORT" && break; sleep 0.2; done

# status of one request: code only (curl's own exit is checked too)
code() { curl -s -o "$TMP/body" -w '%{http_code}' "$@"; }
jget() { python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); exec("print("+sys.argv[2]+")")' "$TMP/body" "$1"; }

c=$(code -D "$TMP/h" "$BASE/")
[ "$c" = 200 ] && ok "GET / serves the page" || bad "GET /" "$c"
TOKEN="$(grep -o 'name="lisp-plus-token" content="[0-9a-f]*"' "$TMP/body" | grep -o '[0-9a-f]\{64\}')"
[ ${#TOKEN} -eq 64 ] && ok "the page carries a 64-hex per-launch token" || bad "token" "${#TOKEN}"
grep -qi "^content-security-policy: default-src 'none'" "$TMP/h" && ok "a strict CSP header is sent" || bad "csp"
! grep -qi '^access-control-' "$TMP/h" && ok "no Access-Control-* header" || bad "cors header"
grep -q '__LISP_PLUS_TOKEN__' "$TMP/body" && bad "placeholder left in page" || ok "the token placeholder was substituted"

for p in app.js app.css vendor/webtui-css-0.1.10/full.css; do
  c=$(code "$BASE/$p"); if [ "$c" = 200 ] && cmp -s "$TMP/body" "$HERE/web/$p"; then ok "GET /$p is byte-equal to web/$p"; else bad "GET /$p" "$c"; fi
done
[ "$(sha256sum < "$HERE/web/vendor/webtui-css-0.1.10/full.css" | cut -c1-64)" = efd2619fbabf2fbf189a7ea84b3de51844487a985d98aef6ec6341ef6c46facc ] \
  && ok "the vendored WebTUI 0.1.10 full.css matches its pinned sha256" || bad "webtui pin"

H=(-H "X-Lisp-Plus-Token: $TOKEN")
sub() { code -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $SID" -H 'Content-Type: text/plain;charset=utf-8' --data-binary "$1" "$BASE/api/submit"; }

c=$(code "${H[@]}" "$BASE/api/session")
[ "$c" = 200 ] && [ "$(jget 'd["session"]["generation"]')" = 1 ] && ok "GET /api/session: generation 1" || bad "session" "$c"
SID="$(jget 'd["session"]["id"]')"

# ---- r3: the session precondition, before any mutation (Astra's AMEND) ----
c=$(code -X POST "${H[@]}" -H 'Content-Type: text/plain' --data-binary '(define no-header 1)' "$BASE/api/submit")
[ "$c" = 428 ] && [ "$(jget 'd["before_mutation"]')" = True ] && ok "submit without X-Lisp-Plus-Session → 428, before_mutation true" || bad "428" "$c $(cat "$TMP/body")"
c=$(code -X POST "${H[@]}" -H "X-Lisp-Plus-Session: deadbeef" -H 'Content-Type: text/plain' --data-binary '(define stale-one 1)' "$BASE/api/submit")
[ "$c" = 409 ] && [ "$(jget 'd["before_mutation"]')" = True ] && [ "$(jget 'd["session"]["id"]')" = "$SID" ] \
  && ok "submit naming a stale session → 409 carrying the CURRENT session" || bad "409 submit" "$c $(cat "$TMP/body")"
c=$(code -X POST "${H[@]}" -H "X-Lisp-Plus-Session: deadbeef" "$BASE/api/reset")
[ "$c" = 409 ] && ok "reset naming a stale session → 409" || bad "409 reset" "$c"
code "${H[@]}" "$BASE/api/session" >/dev/null
[ "$(jget 'd["session"]["id"]')" = "$SID" ] && [ "$(jget 'd["session"]["names"]')" = "[]" ] && [ "$(jget 'd["session"]["submissions"]')" = 0 ] \
  && ok "after the three refusals: same session, nothing evaluated, nothing reset" || bad "precondition state" "$(cat "$TMP/body")"

# ---- the defining sequence, over HTTP ----
sub '(define rate 3)' >/dev/null; [ "$(jget 'd["result"]["status"]')" = defined ] && ok "submit: a binding (defined)" || bad "define"
sub "$(printf '(define (scale-by k)\n  (lambda (x) (* x k)))')" >/dev/null; [ "$(jget 'd["result"]["status"]')" = defined ] && ok "submit: a multi-line closure factory" || bad "factory"
sub '(define triple (scale-by rate))' >/dev/null
sub '(map triple (list 1 2 3))' >/dev/null; [ "$(jget 'd["result"]["value"]')" = "(3 6 9)" ] && ok "submit: the closure reused across submissions → (3 6 9)" || bad "closure" "$(cat "$TMP/body")"
sub '(triple "x")' >/dev/null
[ "$(jget 'd["result"]["status"]')" = language-error ] && [ "$(jget 'd["result"]["error"]["code"]')" = E-TYPE ] \
  && [ "$(jget 'd["result"]["error"]["location"]["source"]')" = "in[5]" ] && ok "submit: a recoverable error, E-TYPE at in[5]" || bad "error" "$(cat "$TMP/body")"
sub '(+ (triple rate) 1)' >/dev/null; [ "$(jget 'd["result"]["value"]')" = 10 ] && ok "submit: the same session continues → 10" || bad "continue"
[ "$(jget 'd["session"]["id"]')" = "$SID" ] && [ "$(jget 'sorted(d["session"]["names"])')" = "['rate', 'scale-by', 'triple']" ] && ok "the session id is unchanged and names = rate scale-by triple" || bad "names" "$(jget 'd["session"]')"
sub '(print "out" 7) 8' >/dev/null; [ "$(jget 'repr(d["result"]["output"])')" = "'out 7\n'" ] && [ "$(jget 'd["result"]["value"]')" = 8 ] && ok "print output and value arrive as separate fields" || bad "output"
sub '(list 1' >/dev/null; [ "$(jget 'd["result"]["status"]')" = incomplete ] && [ "$(jget 'd["result"]["index"]')" = None ] && ok "incomplete input: nothing evaluated, no index" || bad "incomplete"
sub '#.(sb-ext:quit)' >/dev/null; [ "$(jget 'd["result"]["error"]["code"]')" = E-READ ] && ok "#.(sb-ext:quit) is E-READ and the server lives" || bad "read-eval"
sub '(eval 1)' >/dev/null; [ "$(jget 'd["result"]["error"]["code"]')" = E-UNBOUND ] && ok "eval is not the host's eval" || bad "eval"

# ---- reset is explicit and real ----
c=$(code -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $SID" "$BASE/api/reset")
[ "$c" = 200 ] && [ "$(jget 'd["session"]["generation"]')" = 2 ] && [ "$(jget 'd["session"]["id"]')" != "$SID" ] && [ "$(jget 'd["session"]["names"]')" = "[]" ] \
  && ok "POST /api/reset: new id, generation 2, no names" || bad "reset" "$c"
OLDSID="$SID"; SID="$(jget 'd["session"]["id"]')"
c=$(code -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $OLDSID" -H 'Content-Type: text/plain' --data-binary '(define from-a-stale-tab 1)' "$BASE/api/submit")
[ "$c" = 409 ] && ok "a submit still naming the PRE-reset session is refused (a stale tab cannot run in the new one)" || bad "stale after reset" "$c"
sub 'rate' >/dev/null; [ "$(jget 'd["result"]["error"]["code"]')" = E-UNBOUND ] && ok "after reset the old binding is gone" || bad "after reset"

# ---- r5 (G-H, Astra 2026-09-30): the rest of WEB-API-0.md, asserted field by field ----
# Expected values come from WEB-API-0.md, and for renderings and diagnostics from PROGRAM /0's
# README §7 and specification §2 (which WEB-API-0.md defers to). Where the contract is silent,
# nothing here copies the implementation's output into an expectation.
CSP="default-src 'none'; script-src 'self'; style-src 'self'; connect-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
export CSP
jok() { python3 -c 'import json,sys,re,os,datetime; d=json.load(open(sys.argv[1])); sys.exit(0 if eval(sys.argv[2]) else 1)' "$TMP/body" "$1" 2>/dev/null; }
cat > "$TMP/hdr4.py" <<'PY'
# exit 0 iff the header block in argv[1] (CRLF lines, status line first) carries the four
# headers WEB-API-0.md puts on every response, each with exactly its stated value
import os, sys
want = {"content-security-policy": os.environ["CSP"], "x-content-type-options": "nosniff",
        "referrer-policy": "no-referrer", "cache-control": "no-store"}
got = {}
for line in open(sys.argv[1], "rb").read().decode("latin-1").split("\r\n")[1:]:   # bytes: text mode would fold CRLF
    if not line: break
    k, _, v = line.partition(":")
    got.setdefault(k.strip().lower(), []).append(v.strip())
cors = any(k.startswith("access-control-") for k in got)   # WEB-API-0.md: "sends no Access-Control-* header"
sys.exit(0 if not cors and all(got.get(k) and all(x == v for x in got[k]) for k, v in want.items()) else 1)
PY
hdr4() { [ -s "$1" ] && python3 "$TMP/hdr4.py" "$1"; }   # the four headers, exact, and no Access-Control-*
DOC_CSP="$(python3 -c 'import re,sys; m=re.search(r"`Content-Security-Policy: ([^`]*)`", open(sys.argv[1]).read()); print(" ".join(m.group(1).split()) if m else "")' "$HERE/WEB-API-0.md")"
[ -n "$DOC_CSP" ] && [ "$DOC_CSP" = "$CSP" ] && ok "the CSP this suite expects is the one WEB-API-0.md states, byte for byte" || bad "csp source" "WEB-API-0.md: '$DOC_CSP'"

# the four headers on every success kind, and the favicon's explicit 204
rm -f "$TMP/h"; c=$(code -D "$TMP/h" "$BASE/"); [ "$c" = 200 ] && hdr4 "$TMP/h" && ok "the page (GET /) carries the exact CSP, nosniff, no-referrer, no-store" || bad "page headers" "$c"
hs=""; for p in app.js app.css vendor/webtui-css-0.1.10/full.css; do rm -f "$TMP/h"; c=$(code -D "$TMP/h" "$BASE/$p"); { [ "$c" = 200 ] && hdr4 "$TMP/h"; } || hs="$hs /$p:$c"; done
[ -z "$hs" ] && ok "each static asset carries the four headers" || bad "static headers" "$hs"
rm -f "$TMP/h" "$TMP/body"; c=$(code -D "$TMP/h" "$BASE/favicon.ico")
[ "$c" = 204 ] && [ ! -s "$TMP/body" ] && hdr4 "$TMP/h" && ok "GET /favicon.ico → 204 No Content, no body, the four headers" || bad "favicon" "$c"
rm -f "$TMP/h"; c=$(code -D "$TMP/h" "${H[@]}" "$BASE/api/session"); [ "$c" = 200 ] && hdr4 "$TMP/h" && ok "GET /api/session carries the four headers" || bad "session headers" "$c"

# Runtime — the object WEB-API-0.md states, field by field (json.dumps keeps 0 distinct from false)
export RT_WANT='{"language": "Lisp+ PROGRAM /0", "program0_version": 0, "repl_version": 0, "sbcl": "2.4.6", "step_budget": 1000000, "depth_limit": 4000, "max_source_bytes": 65536}'
RT_OK='isinstance(d.get("runtime"), dict) and all(json.dumps(d["runtime"].get(k)) == json.dumps(v) for k, v in json.loads(os.environ["RT_WANT"]).items())'
jok "$RT_OK" && ok "GET /api/session: Runtime = Lisp+ PROGRAM /0, versions 0/0, SBCL 2.4.6, steps 1000000, depth 4000, 65536 bytes" || bad "runtime" "$(jget 'd.get("runtime")')"

# a fresh session (generation 3), so every index below follows from the contract alone
T_BEFORE=$(date +%s); rm -f "$TMP/h"
c=$(code -D "$TMP/h" -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $SID" "$BASE/api/reset"); T_AFTER=$(date +%s)
[ "$c" = 200 ] && hdr4 "$TMP/h" && jok "$RT_OK" && ok "POST /api/reset answers with the four headers and the same Runtime object" || bad "reset runtime" "$c"
SID="$(jget 'd["session"]["id"]')"; export T_BEFORE T_AFTER SID
jok 're.fullmatch("[0-9a-fA-F]{8}", d["session"]["id"]) and d["session"]["generation"] == 3 and d["session"]["submissions"] == 0 and d["session"]["names"] == []' \
  && ok "the new session: an 8-hex id, generation 3, submissions 0, no names" || bad "session 3" "$(jget 'd["session"]')"
jok '(lambda s: s.tzinfo is not None and s.utcoffset() == datetime.datetime.fromtimestamp(s.timestamp()).astimezone().utcoffset() and int(os.environ["T_BEFORE"]) - 2 <= s.timestamp() <= int(os.environ["T_AFTER"]) + 2)(datetime.datetime.fromisoformat(d["session"]["started"]))' \
  && ok "session.started is the local time (this host's offset) at which the reset began the session" || bad "started" "$(jget 'd["session"]["started"]') ($T_BEFORE..$T_AFTER)"

subh() { rm -f "$TMP/h"; code -D "$TMP/h" -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $SID" -H 'Content-Type: text/plain;charset=utf-8' --data-binary "$1" "$BASE/api/submit"; }
c=$(subh '(define (f x) (+ x nosuch))')
[ "$c" = 200 ] && hdr4 "$TMP/h" && jok 'd["result"]["status"] == "defined" and d["result"]["value"] == "f" and d["result"]["kind"] is None and d["result"]["index"] == 1 and d["result"]["forms"] == 1' \
  && ok "defined: value is the name (f), kind null, index 1, forms 1; a submit answer carries the four headers" || bad "defined" "$c $(cat "$TMP/body")"
subh '(f 10)' >/dev/null
jok 'd["result"]["status"] == "language-error" and d["result"]["index"] == 2 and d["result"]["error"]["code"] == "E-UNBOUND" and d["result"]["error"]["message"] == "unknown name `nosuch`" and d["result"]["error"]["location"] == {"source": "in[2]", "line": 1, "column": 0} and d["result"]["error"]["in"] == "nosuch" and d["result"]["error"]["within"] == ["(+ x nosuch)", "(f 10)"] and d["result"]["error"]["frames"] == ["f"] and d["result"]["error"]["explanation"] == "a name has no binding"' \
  && ok "language-error: code, message, location {in[2],1,0}, in, within, frames, explanation (PROGRAM README §7's example)" || bad "error record" "$(jget 'd["result"]["error"]')"
jok 'd["result"]["error"]["text"] == "lisp-plus: E-UNBOUND at in[2]:1:0\n  unknown name `nosuch`\n  in: nosuch\n  within: (+ x nosuch) · (f 10)\n  frames: f\n  (a name has no binding)"' \
  && ok "error.text is the full diagnostic, beginning lisp-plus: E-UNBOUND at in[2]:1:0" || bad "error text" "$(jget 'repr(d["result"]["error"]["text"])')"
jok 'd["result"]["value"] is None and d["result"]["kind"] is None and d["result"]["fault"] is None and isinstance(d["result"]["state_note"], str) and d["result"]["state_note"].strip() != "" and isinstance(d["result"]["elapsed_ms"], int)' \
  && ok "language-error: a state_note is present, value/kind/fault null, elapsed_ms a number" || bad "error fields" "$(cat "$TMP/body")"
python3 -c 'import json,sys; sys.stdout.write(json.load(open(sys.argv[1]))["result"]["error"]["text"])' "$TMP/body" > "$TMP/webtext" 2>/dev/null
printf '(define (f x) (+ x nosuch))\n(f 10)\n' | bash "$HERE/lisp-plus-repl.sh" > "$TMP/cli.out" 2>/dev/null
python3 -c 'import sys; t=open(sys.argv[1]).read(); c=open(sys.argv[2]).read(); sys.exit(0 if t and ("\n" + t + "\n") in c else 1)' "$TMP/webtext" "$TMP/cli.out" \
  && ok "error.text is exactly what the command line prints for the same two submissions" || bad "text vs cli" "$(tr '\n' '|' < "$TMP/cli.out" | head -c 400)"
subh "$(printf '(define ok-before 1)\n  (f 10)\n(define never-bound 2)')" >/dev/null
jok 'd["result"]["index"] == 3 and d["result"]["forms"] == 3 and d["result"]["error"]["location"] == {"source": "in[3]", "line": 2, "column": 2} and d["result"]["error"]["text"].startswith("lisp-plus: E-UNBOUND at in[3]:2:2\n")' \
  && ok "a closure's error cites the SUBMISSION location in[3]:2:2 (the calling form); forms counts all 3 read" || bad "submission location" "$(jget 'd["result"]')"
jok '"ok-before" in d["session"]["names"] and "never-bound" not in d["session"]["names"] and d["result"]["state_note"].strip() != ""' \
  && ok "state after the error: the form before it stays (ok-before), the form after it did not run (never-bound)" || bad "no rollback" "$(jget 'd["session"]')"
subh ')' >/dev/null
jok 'd["result"]["status"] == "language-error" and d["result"]["error"]["code"] == "E-READ" and d["result"]["index"] == 4 and d["session"]["submissions"] == 4 and isinstance(d["result"]["state_note"], str) and d["result"]["state_note"].strip() != ""' \
  && ok "a reader refusal is a submission: index 4, submissions 4, with a state_note" || bad "read refusal" "$(cat "$TMP/body")"
subh '(define partial-one 1) (list 1' >/dev/null
jok 'd["result"]["status"] == "incomplete" and d["result"]["index"] is None and d["result"]["forms"] is None and isinstance(d["result"]["note"], str) and d["result"]["note"].strip() != "" and d["session"]["submissions"] == 4 and "partial-one" not in d["session"]["names"]' \
  && ok "incomplete: index null, forms null, a note; not counted; its complete first form was NOT evaluated" || bad "incomplete" "$(cat "$TMP/body")"
subh "$(printf '  ; only a comment\n\n')" >/dev/null
jok 'd["result"]["status"] == "empty" and d["result"]["index"] is None and d["result"]["value"] is None and d["session"]["submissions"] == 4' \
  && ok "empty: index null, no value, nothing evaluated, not counted (forms: see FINDING F1 in the r5 report)" || bad "empty" "$(cat "$TMP/body")"
subh '(define a-one 1) (define a-two 2) (+ a-one a-two)' >/dev/null
jok 'd["result"]["status"] == "value" and d["result"]["index"] == 5 and d["result"]["forms"] == 3 and d["result"]["value"] == "3" and d["result"]["kind"] == "number" and d["result"]["output"] == "" and isinstance(d["result"]["elapsed_ms"], int) and not isinstance(d["result"]["elapsed_ms"], bool) and d["result"]["elapsed_ms"] >= 0 and d["result"]["error"] is None and d["result"]["fault"] is None' \
  && ok "value: index 5 (incomplete and empty took none), forms 3, value 3, output \"\", elapsed_ms a number, error and fault null" || bad "value fields" "$(cat "$TMP/body")"

# every kind WEB-API-0.md lists, with PROGRAM /0 §2's written form where the spec gives it
kindchk() { subh "$1" >/dev/null
  K="$2" R="$3" python3 -c 'import json,os,sys; r=json.load(open(sys.argv[1]))["result"]; sys.exit(0 if r["status"] == "value" and r["kind"] == os.environ["K"] and r["value"] == os.environ["R"] else 1)' "$TMP/body" 2>/dev/null \
    && ok "kind $2: $1 → $3" || bad "kind $2" "$(cat "$TMP/body")"; }
kindchk '(/ 1 3)' number '1/3'
kindchk '(string-append "a" "b")' string '"ab"'
kindchk '(= 1 1)' boolean 'true'
kindchk '(list)' empty-list '()'
kindchk '(list 1 (list 2) "s")' list '(1 (2) "s")'
kindchk '(quote abc)' symbol 'abc'
kindchk ':mode' keyword ':mode'
subh '(define (sq x) (* x x))' >/dev/null
kindchk 'sq' function '#<function sq>'
kindchk '+' primitive '#<primitive +>'
kindchk '(kernel0/determinacy :mode :determinate)' host-value '#<kernel0 determinacy>'
subh '(kernel0/determinacy :mode :determinate :confidence 0.8)' >/dev/null
jok 'd["result"]["status"] == "value" and d["result"]["kind"] == "refusal" and d["result"]["value"].startswith("#<refused ") and d["result"]["value"].endswith(" requirement K0E-33>")' \
  && ok "kind refusal: the kernel's K0E-33 answer arrives as a value, #<refused … requirement K0E-33>" || bad "kind refusal" "$(cat "$TMP/body")"

# the Session object: names sorted and only the user's; submissions = evaluated or refused
subh '(define zeta 1)' >/dev/null; subh '(define alpha 1)' >/dev/null
jok 'd["session"]["names"] == ["a-one", "a-two", "alpha", "f", "ok-before", "sq", "zeta"] and d["session"]["id"] == os.environ["SID"]' \
  && ok "session.names: exactly the user's names, sorted (zeta was defined before alpha); no prelude or primitive name" || bad "names sorted" "$(jget 'd["session"]["names"]')"
jok 'd["session"]["submissions"] == d["result"]["index"] == 19' \
  && ok "session.submissions = 19 = the last index: every evaluated or refused submission, no incomplete or empty one" || bad "submissions" "$(jget 'd["session"]["submissions"]') / $(jget 'd["result"]["index"]')"

# ---- the fence ----
c=$(code "$BASE/api/session"); [ "$c" = 403 ] && ok "no token → 403" || bad "no token" "$c"
c=$(code -H "X-Lisp-Plus-Token: $(printf '0%.0s' $(seq 64))" "$BASE/api/session"); [ "$c" = 403 ] && ok "wrong token → 403" || bad "wrong token" "$c"
c=$(code "${H[@]}" -H "Host: evil.example:$PORT" "$BASE/api/session"); [ "$c" = 421 ] && ok "foreign Host (DNS rebinding) → 421" || bad "host" "$c"
c=$(code -H "Host: evil.example" "$BASE/"); [ "$c" = 421 ] && ok "foreign Host on the page itself → 421 (the token never leaves)" || bad "host page" "$c"
c=$(code "${H[@]}" -H "Origin: http://evil.example" "$BASE/api/session"); [ "$c" = 403 ] && ok "foreign Origin → 403" || bad "origin" "$c"
c=$(code "${H[@]}" -H "Origin: http://127.0.0.1:1" "$BASE/api/session"); [ "$c" = 403 ] && ok "another local port's Origin → 403" || bad "origin port" "$c"
c=$(code "${H[@]}" -H "Sec-Fetch-Site: cross-site" "$BASE/api/session"); [ "$c" = 403 ] && ok "Sec-Fetch-Site: cross-site → 403" || bad "sfs" "$c"
c=$(code "${H[@]}" -H "Sec-Fetch-Site: same-site" "$BASE/api/session"); [ "$c" = 403 ] && ok "Sec-Fetch-Site: same-site (another port) → 403" || bad "sfs same-site" "$c"
c=$(code -X OPTIONS "$BASE/api/submit"); [ "$c" = 403 ] || [ "$c" = 405 ] && ok "OPTIONS (a CORS preflight) is refused ($c)" || bad "options" "$c"
c=$(code "${H[@]}" "$BASE/api/submit"); [ "$c" = 405 ] && ok "GET /api/submit → 405" || bad "get submit" "$c"
c=$(code "$BASE/etc/passwd"); [ "$c" = 404 ] && ok "an unlisted path → 404" || bad "path" "$c"
c=$(code --path-as-is "$BASE/../../etc/passwd"); [ "$c" = 404 ] && ok "a traversal path → 404" || bad "traversal" "$c"
c=$(code "$BASE/?x=1"); [ "$c" = 404 ] && ok "a query string is not a listed path → 404" || bad "query" "$c"
c=$(code -X POST "${H[@]}" -H 'Content-Type: text/html' --data-binary '(+ 1 1)' "$BASE/api/submit"); [ "$c" = 415 ] && [ "$(jget 'd["before_mutation"]')" = True ] && ok "text/html body → 415, and the refusal says before_mutation" || bad "ctype" "$c"
head -c 70000 /dev/zero | tr '\0' ' ' > "$TMP/big"
c=$(code -X POST "${H[@]}" -H 'Content-Type: text/plain' --data-binary @"$TMP/big" "$BASE/api/submit"); [ "$c" = 413 ] && ok "a body over 64 KiB → 413" || bad "size" "$c"
printf '(list "\xff")' > "$TMP/bad"
c=$(code -X POST "${H[@]}" -H 'Content-Type: text/plain' --data-binary @"$TMP/bad" "$BASE/api/submit"); [ "$c" = 400 ] && ok "invalid UTF-8 → 400" || bad "utf8" "$c"
c=$(code -X POST "${H[@]}" -H 'Content-Type: text/plain' -H 'Transfer-Encoding: chunked' --data-binary '(+ 1 1)' "$BASE/api/submit"); [ "$c" = 400 ] && ok "a chunked body → 400" || bad "chunked" "$c"
c=$(code "${H[@]}" -H "X-Lisp-Plus-Token: $TOKEN" "$BASE/api/session"); [ "$c" = 400 ] && ok "a repeated token header → 400 (ambiguity is refused)" || bad "dup header" "$c"
c=$(code "${H[@]}" "$BASE/api/session"); [ "$c" = 200 ] && ok "after every refusal the server still answers" || bad "alive" "$c"

# ---- r5 (G-H): each protocol refusal's body and headers, and the store it leaves ----
# Every request below is valid except for the one fault named, and each carries a `define`:
# if anything were evaluated, a leaked-* name would appear. The store is the witness of
# before_mutation: true, read before and after.
refchk() { local want="$1" label="$2" c; shift 2; rm -f "$TMP/body" "$TMP/h"; c=$(code -D "$TMP/h" "$@")
  if [ "$c" = "$want" ] && jok 'isinstance(d.get("error"), str) and d["error"].strip() != "" and d.get("before_mutation") is True' && hdr4 "$TMP/h"
  then ok "$label → $want, body {error: <sentence>, before_mutation: true}, the four headers"; else bad "$label" "$c $(head -c 300 "$TMP/body" 2>/dev/null)"; fi; }
code "${H[@]}" "$BASE/api/session" >/dev/null; cp "$TMP/body" "$TMP/store-before.json"
SUBMIT=(-X POST -H "X-Lisp-Plus-Session: $SID" -H 'Content-Type: text/plain;charset=utf-8')
printf '(define leaked-utf8 "\xff")' > "$TMP/bad8"
{ printf '(define leaked-big 1)'; head -c 70000 /dev/zero | tr '\0' ' '; } > "$TMP/big2"
python3 -c 'print("X-Big: " + "a" * 20000)' > "$TMP/hdr20k"; python3 -c 'print("X-Big: " + "a" * 12000)' > "$TMP/hdr12k"
refchk 400 "invalid UTF-8 in a submit" "${H[@]}" "${SUBMIT[@]}" --data-binary @"$TMP/bad8" "$BASE/api/submit"
refchk 400 "a chunked submit" "${H[@]}" "${SUBMIT[@]}" -H 'Transfer-Encoding: chunked' --data-binary '(define leaked-chunked 1)' "$BASE/api/submit"
refchk 403 "a submit with a wrong token" -H "X-Lisp-Plus-Token: $(printf 'f%.0s' $(seq 64))" "${SUBMIT[@]}" --data-binary '(define leaked-token 1)' "$BASE/api/submit"
refchk 403 "a submit from a foreign Origin" "${H[@]}" "${SUBMIT[@]}" -H 'Origin: http://evil.example' --data-binary '(define leaked-origin 1)' "$BASE/api/submit"
refchk 404 "an unlisted path" "$BASE/nope"
refchk 405 "GET /api/reset" "${H[@]}" -H "X-Lisp-Plus-Session: $SID" "$BASE/api/reset"
refchk 413 "a submit over 64 KiB" "${H[@]}" "${SUBMIT[@]}" --data-binary @"$TMP/big2" "$BASE/api/submit"
refchk 415 "a text/html submit" "${H[@]}" -X POST -H "X-Lisp-Plus-Session: $SID" -H 'Content-Type: text/html' --data-binary '(define leaked-ctype 1)' "$BASE/api/submit"
refchk 421 "a submit to a foreign Host" "${H[@]}" "${SUBMIT[@]}" -H "Host: evil.example:$PORT" --data-binary '(define leaked-host 1)' "$BASE/api/submit"
refchk 428 "a submit without X-Lisp-Plus-Session" "${H[@]}" -X POST -H 'Content-Type: text/plain' --data-binary '(define leaked-428 1)' "$BASE/api/submit"
refchk 409 "a submit naming a stale session" "${H[@]}" -X POST -H 'X-Lisp-Plus-Session: 0badc0de' -H 'Content-Type: text/plain' --data-binary '(define leaked-409 1)' "$BASE/api/submit"
refchk 409 "a reset naming a stale session" "${H[@]}" -X POST -H 'X-Lisp-Plus-Session: 0badc0de' "$BASE/api/reset"
refchk 431 "a submit whose header block is over 16 KiB" "${H[@]}" "${SUBMIT[@]}" -H @"$TMP/hdr20k" --data-binary '(define leaked-431 1)' "$BASE/api/submit"
c=$(code "${H[@]}" -H @"$TMP/hdr12k" "$BASE/api/session"); [ "$c" = 200 ] && ok "a 12 KiB header block is under the 16 KiB cap: served (200)" || bad "12k header" "$c"
# the fence's other half: what WEB-API-0.md says IS accepted
c=$(code -H "Host: localhost:$PORT" "$BASE/"); [ "$c" = 200 ] && ok "Host: localhost:<port> is accepted (200)" || bad "localhost host" "$c"
c1=$(code "${H[@]}" -H "Origin: http://127.0.0.1:$PORT" "$BASE/api/session"); c2=$(code "${H[@]}" -H "Origin: http://localhost:$PORT" "$BASE/api/session")
[ "$c1" = 200 ] && [ "$c2" = 200 ] && ok "the page's own Origin, http://127.0.0.1:<port> or http://localhost:<port>, is accepted" || bad "own origin" "$c1 $c2"
c=$(code "${H[@]}" -H "Sec-Fetch-Site: same-origin" "$BASE/api/session"); [ "$c" = 200 ] && ok "Sec-Fetch-Site: same-origin on /api/ is accepted (200)" || bad "sfs same-origin" "$c"
code "${H[@]}" "$BASE/api/session" >/dev/null   # the store, read on its own (not through the 12 KiB request above)
python3 -c 'import json,sys; a=json.load(open(sys.argv[1]))["session"]; b=json.load(open(sys.argv[2]))["session"]; sys.exit(0 if a == b and not any(n.startswith("leaked") for n in b["names"]) else 1)' "$TMP/store-before.json" "$TMP/body" 2>/dev/null \
  && ok "after the thirteen refusals the session is identical (id, generation, submissions, names): before_mutation: true was true" || bad "store after refusals" "$(cat "$TMP/body")"
c=$(code "${H[@]}" "$BASE/api/session"); [ "$c" = 200 ] && ok "after these refusals the server still answers" || bad "alive after r5 refusals" "$c"

# ---- bound to loopback only ----
if command -v ss >/dev/null; then
  L="$(ss -ltn "( sport = :$PORT )" | awk 'NR>1{print $4}')"
  [ "$L" = "127.0.0.1:$PORT" ] && ok "listening on 127.0.0.1:$PORT only (ss: $L)" || bad "bind" "$L"
else bad "ss not available; the bind address was not measured"; fi

# ---- r1: a client trickling its request cannot hold the single thread past the deadline ----
python3 - "$PORT" > "$TMP/trickle" 2>&1 <<'PY'
import socket, sys, time, threading, urllib.request
port = int(sys.argv[1]); head = b"GET / HTTP/1.1\r\nHost: 127.0.0.1:%d\r\nX-Slow: " % port
got = {}
def trickle():
    s = socket.create_connection(("127.0.0.1", port))
    try:
        for ch in head:
            s.send(bytes([ch])); time.sleep(24.0 / len(head))
        s.send(b"\r\n\r\n"); got["answer"] = s.recv(40)
    except Exception as e:
        got["answer"] = repr(e)
    finally:
        s.close()
th = threading.Thread(target=trickle); th.start(); time.sleep(0.5)
t1 = time.time(); urllib.request.urlopen("http://127.0.0.1:%d/" % port, timeout=60).read()
print("waited %.1f" % (time.time() - t1)); th.join(); print("trickler got", got.get("answer"))
PY
W="$(grep -o 'waited [0-9.]*' "$TMP/trickle" | cut -d' ' -f2)"
python3 -c "import sys; sys.exit(0 if float('${W:-99}') <= 13.0 else 1)" \
  && ok "a client trickling its header over 24 s holds the server at most the deadline (a normal request waited ${W} s)" \
  || bad "trickle" "a normal request waited ${W:-?} s: $(tr '\n' ' ' < "$TMP/trickle")"

# ---- r5 (G-H): the two timeouts, measured on the stalled client itself ----
# WEB-API-0.md: "The whole request (header and body) must arrive within 10 s, each read within
# 2 s → 408 or a closed connection." Either outcome is accepted; its time is what is bounded.
# The check above measures the hold on OTHER clients; these measure the slow client's own
# outcome, the per-read bound, and that a slow-but-legal client is still served.
cat > "$TMP/slow.py" <<'PY'
import json, os, select, socket, sys, time
port, mode = int(sys.argv[1]), sys.argv[2]
HOST = b"Host: 127.0.0.1:%d\r\n" % port
def shape(data):
    """For a response in DATA: its status, whether it has the four headers and the refusal body."""
    head, _, body = data.partition(b"\r\n\r\n")
    lines = head.decode("latin-1").split("\r\n")
    status = lines[0].split(" ")[1] if lines and len(lines[0].split(" ")) > 1 else "?"
    got = {}
    for line in lines[1:]:
        k, _, v = line.partition(":"); got.setdefault(k.strip().lower(), []).append(v.strip())
    want = {"content-security-policy": os.environ["CSP"], "x-content-type-options": "nosniff",
            "referrer-policy": "no-referrer", "cache-control": "no-store"}
    h4 = not any(k.startswith("access-control-") for k in got) and all(got.get(k) and all(x == v for x in got[k]) for k, v in want.items())
    try:
        b = json.loads(body.decode("utf-8")); ref = isinstance(b.get("error"), str) and b["error"].strip() != "" and b.get("before_mutation") is True
    except Exception:
        ref = False
    return status, h4, ref
def outcome(s, wait):
    """Wait up to WAIT s for an answer or a close. → (what, data)"""
    data = b""; s.settimeout(wait)
    try:
        while True:
            chunk = s.recv(4096)
            if not chunk: return ("answer" if data else "closed"), data
            data += chunk
    except socket.timeout:
        return ("answer" if data else "still-open"), data
    except ConnectionResetError:
        return ("answer" if data else "reset"), data
def report(what, t, data):
    st, h4, ref = shape(data) if data else ("", False, False)
    print(json.dumps({"what": what, "t": round(t, 2), "status": st, "h4": h4, "refusal": ref}))
s = socket.create_connection(("127.0.0.1", port)); t0 = time.time()
if mode == "stall-header":          # half a header, then silence
    s.sendall(b"GET / HTTP/1.1\r\n" + HOST); t1 = time.time(); what, data = outcome(s, 15.0); report(what, time.time() - t1, data)
elif mode == "stall-body":          # a whole header and a COMPLETE form, but not the whole body; then silence
    body = b"(define stalled-body 1)" + b" " * 10    # a server that evaluated a partial body would bind stalled-body
    s.sendall(b"POST /api/submit HTTP/1.1\r\n" + HOST + b"X-Lisp-Plus-Token: " + sys.argv[3].encode() + b"\r\nX-Lisp-Plus-Session: "
              + sys.argv[4].encode() + b"\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n" % len(body) + body[:-10])
    t1 = time.time(); what, data = outcome(s, 15.0); report(what, time.time() - t1, data)
elif mode == "pause":               # a pause inside the header, shorter than the per-read bound
    s.sendall(b"GET /favicon.ico HTTP/1.1\r\n"); time.sleep(float(sys.argv[3])); s.sendall(HOST + b"\r\n")
    what, data = outcome(s, 15.0); report(what, time.time() - t0, data)
elif mode == "trickle-complete":    # a header trickled over N s, inside the whole-request deadline
    req = b"GET /favicon.ico HTTP/1.1\r\n" + HOST + b"X-Slow: ssssss\r\n\r\n"
    for ch in req:
        s.sendall(bytes([ch])); time.sleep(float(sys.argv[3]) / len(req))
    what, data = outcome(s, 15.0); report(what, time.time() - t0, data)
elif mode == "trickle-forever":     # one byte per 0.4 s, never finishing; look for an answer before each byte
    s.sendall(b"GET / HTTP/1.1\r\n" + HOST + b"X-Slow: "); what, data = "still-open", b""
    while time.time() - t0 < 30:
        if select.select([s], [], [], 0.4)[0]:
            what, data = outcome(s, 3.0); break
        try: s.send(b"s")
        except (BrokenPipeError, ConnectionResetError): what = "reset"; break
    report(what, time.time() - t0, data)
s.close()
PY
slow() { python3 "$TMP/slow.py" "$PORT" "$@" 2>&1 | tail -1; }
sv() { python3 -c 'import json,sys; d=json.loads(sys.argv[1]); sys.exit(0 if eval(sys.argv[2]) else 1)' "$1" "$2" 2>/dev/null; }
R="$(slow stall-header)"
sv "$R" '(d["what"] in ("closed", "reset") or (d["status"] == "408" and d["h4"] and d["refusal"])) and 1.5 <= d["t"] <= 5.0' \
  && ok "a client that stalls inside its header gets 408 or a close at the 2 s per-read bound, not the 10 s deadline ($R)" || bad "stall header" "$R"
code "${H[@]}" "$BASE/api/session" >/dev/null; cp "$TMP/body" "$TMP/store-before.json"
R="$(slow stall-body "$TOKEN" "$SID")"
sv "$R" '(d["what"] in ("closed", "reset") or (d["status"] == "408" and d["h4"] and d["refusal"])) and 1.5 <= d["t"] <= 5.0' \
  && ok "a submit that stalls inside its body gets 408 or a close at the per-read bound ($R)" || bad "stall body" "$R"
code "${H[@]}" "$BASE/api/session" >/dev/null
python3 -c 'import json,sys; a=json.load(open(sys.argv[1]))["session"]; b=json.load(open(sys.argv[2]))["session"]; sys.exit(0 if a == b and "stalled-body" not in b["names"] else 1)' "$TMP/store-before.json" "$TMP/body" 2>/dev/null \
  && ok "the stalled submit evaluated nothing: the session is identical" || bad "store after stall" "$(cat "$TMP/body")"
R="$(slow pause 1.0)"
sv "$R" 'd["what"] == "answer" and d["status"] == "204"' && ok "a 1 s pause inside the header is within the per-read bound: served ($R)" || bad "pause" "$R"
R="$(slow trickle-complete 6)"
sv "$R" 'd["what"] == "answer" and d["status"] == "204" and d["t"] >= 5.5' && ok "a request trickled over 6 s, inside the 10 s deadline, is served ($R)" || bad "trickle complete" "$R"
R="$(slow trickle-forever)"
sv "$R" '(d["what"] in ("closed", "reset") or (d["status"] == "408" and d["h4"] and d["refusal"])) and 9.0 <= d["t"] <= 13.0' \
  && ok "a client that never finishes its header gets 408 or a close at the 10 s deadline; a 408 has the refusal shape and the four headers ($R)" || bad "trickle forever" "$R"
S0=$(date +%s.%N); c=$(code "$BASE/favicon.ico"); S1=$(date +%s.%N)
[ "$c" = 204 ] && python3 -c "import sys; sys.exit(0 if $S1 - $S0 < 3.0 else 1)" && ok "after the stalled clients the server answers the next request at once" || bad "alive after stalls" "$c"

# ---- the default port (README: http://127.0.0.1:4917/; WEB-API-0.md: default 4917), only when it is free ----
if ! ss -ltn '( sport = :4917 )' 2>/dev/null | grep -q ':4917' && \
   python3 -c 'import socket; s=socket.socket(); s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); s.bind(("127.0.0.1", 4917)); s.close()' 2>/dev/null; then
  bash "$HERE/lisp-plus-repl.sh" --web > "$TMP/default.out" 2> "$TMP/default.err" &
  DPID=$!
  for i in $(seq 1 100); do grep -q 'http://127.0.0.1:4917/' "$TMP/default.out" 2>/dev/null && break; kill -0 "$DPID" 2>/dev/null || break; sleep 0.2; done
  c=$(curl -s -o "$TMP/dpage" -w '%{http_code}' http://127.0.0.1:4917/)
  if ! kill -0 "$DPID" 2>/dev/null && grep -q 'cannot listen on 127.0.0.1:4917' "$TMP/default.err" 2>/dev/null; then
    echo "skip 4917 was taken between the probe and the bind (another process); the default was NOT measured (not counted)"
  else
    kill -0 "$DPID" 2>/dev/null && grep -q 'http://127.0.0.1:4917/' "$TMP/default.out" && [ "$c" = 200 ] && grep -q 'name="lisp-plus-token" content="[0-9a-f]\{64\}"' "$TMP/dpage" \
      && ok "with no --port the workbench listens on 127.0.0.1:4917 and serves its page" || bad "default port" "$c $(cat "$TMP/default.out" "$TMP/default.err" 2>/dev/null | tr '\n' '|' | head -c 300)"
  fi
  kill "$DPID" 2>/dev/null; wait "$DPID" 2>/dev/null; DPID=""
else
  echo "skip the default port 4917 is in use on this host; the default was NOT measured (not counted)"
fi

# ---- r2 (TELLTALE, Claude Opus 5.5, subagent of the laptop chair; R2-WORK-ORDER items 2, 13 and 14) ----
# Appended before the summary so no earlier line moves. The main server ($PORT) is still up and $SID is
# still its current session.
#
# F-4, an empty submission's WIRE answer. WEB-API-0.md, verbatim:
#   "`empty` — the text held only whitespace/comments; nothing evaluated; `index` null."
#   "`forms` — top-level forms read (null for empty/incomplete)."
#   "`submissions` — count of submissions that were *evaluated or refused* (incomplete input is not a submission)."
# Astra (r1 disposition): "Add a real HTTP assertion distinguishing zero from null, preserving null index,
# unchanged submission count and session state. Incomplete input remains null too." Each body is parsed as
# JSON and forms is tested with `is None`: 0 is not None, and a missing key raises, which fails the check.
# Each text's bytes are written to a file and sent with --data-binary @file (curl sends Content-Length: 0
# for the empty one).
F4TXT="$TMP/f4"; mkdir -p "$F4TXT"
: > "$F4TXT/empty"
printf '  \n\t\n   ' > "$F4TXT/whitespace"
printf '; a line comment\n  #| a block comment |#\n' > "$F4TXT/comments"
printf '(list 1' > "$F4TXT/incomplete"
f4sub() { rm -f "$TMP/h"; code -D "$TMP/h" -X POST "${H[@]}" -H "X-Lisp-Plus-Session: $SID" -H 'Content-Type: text/plain;charset=utf-8' --data-binary @"$1" "$BASE/api/submit"; }
f4wire() { grep -o '"forms":[^,}]*' "$TMP/body" 2>/dev/null | head -1; }
subh '(define f4-kept 17)' >/dev/null
code "${H[@]}" "$BASE/api/session" >/dev/null; cp "$TMP/body" "$TMP/f4-before.json"; export F4_BEFORE="$TMP/f4-before.json"
F4_SNAP='d["session"] == json.load(open(os.environ["F4_BEFORE"]))["session"] and "f4-kept" in d["session"]["names"]'
for k in empty whitespace comments; do
  c=$(f4sub "$F4TXT/$k")
  { [ "$c" = 200 ] && jok '"forms" in d["result"] and d["result"]["forms"] is None'; } \
    && ok "F-4 wire, $k text ($(wc -c < "$F4TXT/$k") bytes): result.forms is JSON null, not 0" || bad "F-4 wire, $k text: forms" "HTTP $c, wire $(f4wire)"
  { [ "$c" = 200 ] && jok 'd["result"]["status"] == "empty" and d["result"]["index"] is None and '"$F4_SNAP"; } \
    && ok "F-4, $k text: 200, status empty, index null, not counted; the answer's session equals the one before (id, generation, submissions, names; f4-kept bound)" \
    || bad "F-4, $k text: status, index, session" "HTTP $c $(head -c 400 "$TMP/body")"
done
c=$(f4sub "$F4TXT/incomplete")
{ [ "$c" = 200 ] && jok 'd["result"]["status"] == "incomplete" and "forms" in d["result"] and d["result"]["forms"] is None and d["result"]["index"] is None and '"$F4_SNAP"; } \
  && ok "F-4, incomplete text: forms is JSON null too (not 0), index null, not counted, the answer's session unchanged" || bad "F-4, incomplete text" "HTTP $c, wire $(f4wire) $(head -c 300 "$TMP/body")"
code "${H[@]}" "$BASE/api/session" >/dev/null
jok "$F4_SNAP" && ok "F-4: after the three empty and the one incomplete submission, GET /api/session equals the snapshot taken before them" || bad "F-4: session after" "$(jget 'd["session"]')"
subh '(+ f4-kept 1)' >/dev/null
jok 'd["result"]["status"] == "value" and d["result"]["value"] == "18" and d["result"]["index"] == json.load(open(os.environ["F4_BEFORE"]))["session"]["submissions"] + 1' \
  && ok "F-4: the binding made before them answers ((+ f4-kept 1) → 18) at the index next after the snapshot's count: the empty ones took none" || bad "F-4: binding after" "$(cat "$TMP/body")"

# Items 13 and 14: the 16 KiB header cap at its exact boundary, over a raw socket, every byte chosen here.
# At r1b, WEB-API-0.md listed 431 among the protocol refusals but stated no size and no counting rule, and the README
# said "Headers are capped at 16 KiB (431)" (r2 pins the rule in both). The counting rule is READ FROM THE CODE, as the work order
# asks (repl0-web.lisp: +max-header-bytes+ = 16384 at L32; read-header-block, L188–203): every byte from
# the first byte of the request line through the CR LF CR LF that ends the header goes into one buffer;
# before a byte is added, a buffer already holding 16,384 bytes is refused with 431 (L195–196); the end is
# recognised only after the byte is added (L198–201). So a head of exactly 16,384 bytes, its end included,
# is served, and a head of 16,385 is refused when its 16,385th byte arrives. The pair discriminates: had
# the request line, a CRLF or the terminating blank line gone uncounted, the 16,385-byte head would be
# served; had the cap been "fewer than 16,384", the 16,384-byte head would be refused. GET, no body, so
# the refused request leaves no unread byte behind to race the answer with a reset. The refusal's shape
# is WEB-API-0.md's: {error: <plain sentence>, before_mutation: true}, with the four headers.
cat > "$TMP/hb.py" <<'PY'
import json, os, socket, sys
port, token, total = int(sys.argv[1]), sys.argv[2].encode(), int(sys.argv[3])
fixed = b"GET /api/session HTTP/1.1\r\nHost: 127.0.0.1:%d\r\nX-Lisp-Plus-Token: %s\r\nX-Pad: " % (port, token)
end = b"\r\n\r\n"
head = fixed + b"p" * (total - len(fixed) - len(end)) + end
s = socket.create_connection(("127.0.0.1", port)); s.settimeout(10.0)
data, err = b"", None
try:
    s.sendall(head)
    while True:
        chunk = s.recv(65536)
        if not chunk:
            break
        data += chunk
except OSError as e:
    err = repr(e)
finally:
    s.close()
hd, _, body = data.partition(b"\r\n\r\n")
lines = hd.decode("latin-1").split("\r\n")
parts = lines[0].split(" ") if lines and lines[0] else []
status = parts[1] if len(parts) > 1 else ""
got = {}
for line in lines[1:]:
    k, _, v = line.partition(":")
    got.setdefault(k.strip().lower(), []).append(v.strip())
want = {"content-security-policy": os.environ["CSP"], "x-content-type-options": "nosniff",
        "referrer-policy": "no-referrer", "cache-control": "no-store"}
h4 = not any(k.startswith("access-control-") for k in got) and all(got.get(k) and all(x == v for x in got[k]) for k, v in want.items())
try:
    b = json.loads(body.decode("utf-8"))
except Exception:
    b = None
refusal = isinstance(b, dict) and isinstance(b.get("error"), str) and b["error"].strip() != "" and b.get("before_mutation") is True
session_ok = isinstance(b, dict) and isinstance(b.get("session"), dict) and isinstance(b.get("runtime"), dict)
print(json.dumps({"sent": len(head), "request_line": len(b"GET /api/session HTTP/1.1\r\n"), "crlf": head.count(b"\r\n"),
                  "one_end": head.endswith(end) and head.count(end) == 1, "status": status, "h4": h4,
                  "refusal": refusal, "session_ok": session_ok, "err": err}))
PY
R="$(python3 "$TMP/hb.py" "$PORT" "$TOKEN" 16384 2>&1 | tail -1)"
sv "$R" 'd["sent"] == 16384 and d["one_end"] and d["status"] == "200" and d["h4"] and d["session_ok"]' \
  && ok "header cap: a head of exactly 16,384 bytes (request line, every CRLF and the blank line counted) is served, 200 with the session ($R)" || bad "header cap at 16,384" "$R"
R="$(python3 "$TMP/hb.py" "$PORT" "$TOKEN" 16385 2>&1 | tail -1)"
sv "$R" 'd["sent"] == 16385 and d["one_end"] and d["status"] == "431" and d["h4"] and d["refusal"]' \
  && ok "header cap: a head of 16,385 bytes, one more, is refused, 431 {error, before_mutation: true} with the four headers ($R)" || bad "header cap at 16,385" "$R"

echo "repl0 test-web: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
