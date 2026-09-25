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
cleanup() { kill "$SPID" 2>/dev/null; wait "$SPID" 2>/dev/null; rm -rf "$TMP"; }
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

echo "repl0 test-web: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
