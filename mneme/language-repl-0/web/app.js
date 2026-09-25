// REPL /0 browser workbench — vanilla JS, no dependencies, no build step.
// Contract: ../WEB-API-0.md. Every server-supplied string reaches the DOM through
// textContent / createTextNode only (see el() below); no HTML is ever parsed from data.
'use strict';

(function () {
  var tokenMeta = document.querySelector('meta[name="lisp-plus-token"]');
  var TOKEN = tokenMeta ? (tokenMeta.getAttribute('content') || '') : '';

  function $(id) { return document.getElementById(id); }

  // Build an element. Attribute values go through setAttribute; children that are
  // strings/numbers become text nodes. This is the only DOM-construction path.
  function el(tag, attrs) {
    var e = document.createElement(tag);
    if (attrs) {
      Object.keys(attrs).forEach(function (k) {
        var v = attrs[k];
        if (v === null || v === undefined || v === false) return;
        if (k === 'class') e.className = v;
        else e.setAttribute(k, v === true ? '' : String(v));
      });
    }
    for (var i = 2; i < arguments.length; i++) {
      var c = arguments[i];
      if (c === null || c === undefined || c === false) continue;
      if (typeof c === 'string' || typeof c === 'number') e.appendChild(document.createTextNode(String(c)));
      else e.appendChild(c);
    }
    return e;
  }

  function str(v) { return v === null || v === undefined ? '' : String(v); }

  var editor = $('editor');
  var submitBtn = $('submit-btn');
  var resetBtn = $('reset-btn');
  var statusEl = $('status');
  var noticeEl = $('notice');
  var transcriptEl = $('transcript');

  var state = {
    session: null,
    runtime: null,
    history: [],   // oldest -> newest: { generation, index, text }
    histPos: -1,   // -1 = the draft; 0 = newest
    draft: '',
    busy: false
  };

  // ---------- protocol ----------

  // r3 (Astra's AMEND, 2026-09-25): an answer that does not arrive is not evidence that
  // nothing happened. Every call ends in exactly one of:
  //   data     a readable JSON object from a 2xx answer;
  //   Refusal  the server answered AND said the state was not changed (before_mutation === true);
  //   Unknown  anything else — no answer, an unreadable or non-JSON body, a refusal that does not
  //            say, a 2xx without the expected shape. The page never turns Unknown into "nothing
  //            was evaluated"; it keeps the text, never resubmits, and offers a read-only refresh.
  function Refusal(status, message, data) { this.kind = 'refusal'; this.status = status; this.message = message; this.data = data; }
  function Unknown(status, message) { this.kind = 'unknown'; this.status = status; this.message = message; }

  function api(method, path, body, sessionId) {
    var headers = { 'X-Lisp-Plus-Token': TOKEN };
    if (sessionId !== undefined) headers['X-Lisp-Plus-Session'] = sessionId;
    var init = { method: method, headers: headers, cache: 'no-store', credentials: 'same-origin' };
    if (body !== undefined) {
      headers['Content-Type'] = 'text/plain;charset=utf-8';
      init.body = body;
    }
    return fetch(path, init).then(function (resp) {
      return resp.text().then(function (text) {
        var data = null;
        try { data = JSON.parse(text); } catch (_) { data = null; }
        if (!resp.ok) {
          var msg = data && typeof data.error === 'string' ? data.error : 'HTTP ' + resp.status + ' with no readable {error}';
          if (data && data.before_mutation === true) throw new Refusal(resp.status, msg, data);
          throw new Unknown(resp.status, msg);
        }
        if (!data || typeof data !== 'object') throw new Unknown(resp.status, 'the answer was not a readable JSON object');
        return data;
      }, function (err) {
        throw new Unknown(resp.status, 'the answer could not be read (' + str(err && err.message) + ')');
      });
    }, function (err) {
      throw new Unknown(null, 'no answer arrived (' + str(err && err.message) + ')');
    });
  }

  // ---------- shape: validate an answer BEFORE it changes anything (r4, Astra's r3 AMEND) ----------
  // Valid JSON is not a valid answer. Each check returns null (valid) or the first reason it is not.
  // Legitimate zero, empty-string and null values the contract (WEB-API-0.md) permits are accepted.
  function isInt(v, min) { return typeof v === 'number' && Math.floor(v) === v && v >= min; }
  function isStr(v) { return typeof v === 'string'; }
  function isObj(v) { return v !== null && typeof v === 'object' && !Array.isArray(v); }
  function strList(v) { return Array.isArray(v) && v.every(isStr); }

  function sessionShape(x) {
    if (!isObj(x)) return 'no session object';
    if (!(isStr(x.id) && /^[0-9a-f]{8}$/.test(x.id))) return 'the session has no valid id';
    if (!isInt(x.generation, 1)) return 'the session has no valid generation';
    if (!isStr(x.started) || x.started === '') return 'the session has no start time';
    if (!isInt(x.submissions, 0)) return 'the session has no valid submission count';
    if (!strList(x.names)) return 'the session has no valid names list';
    return null;
  }

  function runtimeShape(x) {
    if (!isObj(x)) return 'no runtime object';
    if (!isStr(x.language) || !isStr(x.sbcl)) return 'the runtime lacks its language or sbcl';
    if (!isInt(x.program0_version, 0) || !isInt(x.repl_version, 0)) return 'the runtime lacks its versions';
    if (!isInt(x.step_budget, 1) || !isInt(x.depth_limit, 1) || !isInt(x.max_source_bytes, 1)) return 'the runtime lacks its limits';
    return null;
  }

  var KINDS = ['number', 'string', 'boolean', 'empty-list', 'list', 'symbol', 'keyword', 'function', 'primitive', 'refusal', 'host-value', 'host-object'];

  function errorShape(e) {
    if (!isObj(e)) return 'a language error without its error object';
    if (!isStr(e.code) || e.code === '' || !isStr(e.message) || !isStr(e.text)) return 'the error lacks its code, message or text';
    if (e.location !== null) {
      if (!isObj(e.location) || !isStr(e.location.source) || !isInt(e.location.line, 1) || !isInt(e.location.column, 0)) return 'the error location is malformed';
    }
    if (!(e['in'] === null || isStr(e['in']))) return 'the failing expression is malformed';
    if (!strList(e.within) || !strList(e.frames)) return 'the error\'s within/frames are malformed';
    if (!(e.explanation === null || isStr(e.explanation))) return 'the error explanation is malformed';
    return null;
  }

  function faultShape(f) {
    return isObj(f) && isStr(f.type) && isStr(f.message) ? null : 'a fault without its type and message';
  }

  function resultShape(r) {
    if (!isObj(r)) return 'no result object';
    var st = r.status;
    if (st === 'incomplete' || st === 'empty') {
      if (r.index !== null) return 'an ' + st + ' result that carries an index';
      if (!isStr(r.note)) return 'an ' + st + ' result without its note';
      return null;
    }
    if (['value', 'defined', 'language-error', 'host-fault', 'interrupted'].indexOf(st) === -1) return 'an unknown result status "' + str(st) + '"';
    if (!isInt(r.index, 1)) return 'a ' + st + ' result without a valid index';
    if (!isStr(r.output)) return 'a ' + st + ' result without its output field';
    if (!(r.elapsed_ms === null || isInt(r.elapsed_ms, 0))) return 'a malformed elapsed time';
    if (st === 'value') {
      if (!isInt(r.forms, 1)) return 'a value result without its form count';
      if (!isStr(r.value)) return 'a value result without its value';   // "" is legitimate: (quote ||) renders empty
      if (KINDS.indexOf(r.kind) === -1) return 'a value result without a known kind';
      return null;
    }
    if (st === 'defined') {
      if (!isInt(r.forms, 1)) return 'a definition result without its form count';
      if (!isStr(r.value)) return 'a definition result without the name defined';   // "" is legitimate: (define || 5)
      return null;
    }
    if (!(r.forms === null || isInt(r.forms, 0))) return 'a malformed form count';
    if (!isStr(r.state_note)) return 'a failed result without its session-state note';
    if (st === 'language-error') return errorShape(r.error);
    return faultShape(r.fault);
  }

  // Throws UNKNOWN (the existing path) naming the first defect; returns nothing when the answer is whole.
  function requireShape(what, reason) {
    if (reason) throw new Unknown(200, 'the answer to ' + what + ' was valid JSON but not a valid answer (' + reason + ')');
  }

  // ---------- header ----------

  function setStatus(text) { statusEl.textContent = text; }

  function renderSession(s) {
    if (!s || typeof s !== 'object') return;
    var prev = state.session;
    state.session = s;
    // r3: when the session changes under the page, the transcript above belongs to ANOTHER session — say so
    if (prev && prev.id !== s.id) {
      if (transcriptEl.children.length > 0) {
        transcriptEl.appendChild(el('p', { class: 'session-divider', role: 'note' },
          'session changed: the entries above were made in session ' + str(prev.id) + ' (generation ' + str(prev.generation) +
          '); the current session is ' + str(s.id) + ' (generation ' + str(s.generation) + ')'));
      }
      var banner = $('reset-banner');
      if (!banner.hidden && banner.textContent.indexOf(str(s.id)) === -1) banner.hidden = true;
    }
    $('s-id').textContent = str(s.id);
    $('s-gen').textContent = str(s.generation);
    $('s-started').textContent = str(s.started);
    $('s-subs').textContent = str(s.submissions);
    renderNames(Array.isArray(s.names) ? s.names : []);
    return prev;
  }

  function fmtNum(n) { return typeof n === 'number' ? n.toLocaleString('en-US') : str(n); }

  function renderRuntime(r) {
    if (!r || typeof r !== 'object') return;
    state.runtime = r;
    $('runtime').textContent = 'runtime: ' + str(r.language) +
      ' · program0 v' + str(r.program0_version) +
      ' · repl v' + str(r.repl_version) +
      ' · SBCL ' + str(r.sbcl) +
      ' · step budget ' + fmtNum(r.step_budget) +
      ' · depth limit ' + fmtNum(r.depth_limit) +
      ' · max source ' + fmtNum(r.max_source_bytes) + ' bytes';
  }

  function renderNames(names) {
    var ul = $('names');
    ul.replaceChildren();
    names.forEach(function (n) { ul.appendChild(el('li', null, el('code', null, str(n)))); });
    $('names-empty').hidden = names.length > 0;
  }

  // ---------- notices ----------

  // kind: 'incomplete' | 'empty' | 'protocol' | 'info'
  function showNotice(kind, label, text) {
    noticeEl.replaceChildren(
      el('span', { 'is-': 'badge', 'variant-': kind === 'protocol' ? 'foreground0' : 'background3', class: 'badge-' + kind }, label),
      document.createTextNode(' ' + text)
    );
    noticeEl.className = 'notice notice-' + kind;
    noticeEl.hidden = false;
  }

  function clearNotice() { noticeEl.hidden = true; noticeEl.replaceChildren(); }

  function httpLabel(e) { return e && e.status ? 'HTTP ' + e.status : 'no HTTP answer'; }

  // The server answered and said it changed nothing.
  function showRefusal(e, what) {
    showNotice('protocol', 'REFUSED', httpLabel(e) + ': ' + str(e.message) +
      ' — the server says it changed nothing; ' + what + ' did not happen.');
  }

  // No established outcome. Keep everything; offer a read-only refresh; never retry.
  function showUnknown(e, what) {
    var What = what.charAt(0).toUpperCase() + what.slice(1);
    showNotice('unknown', 'OUTCOME UNKNOWN', httpLabel(e) + ': ' + str(e && e.message) + '. ' + What +
      ' may or may not have happened. ' + (what === 'this submission' ? 'Your text is kept. ' : '') +
      'Nothing is resent automatically. ');
    var btn = el('button', { type: 'button', 'size-': 'small', class: 'refresh-inline' }, 'Refresh session (read-only)');
    btn.addEventListener('click', refresh);
    noticeEl.appendChild(btn);
  }

  // The page acted on a session that is no longer the server's. Nothing happened; show the current one.
  function showStale(e, what) {
    // The refusal is established (before_mutation), but its snapshot of the current session is shown
    // only if it is a whole session (r4); an unusable snapshot never replaces the display.
    var cur = e.data && e.data.session;
    var usable = sessionShape(cur) === null;
    if (usable) renderSession(cur);
    var What = what.charAt(0).toUpperCase() + what.slice(1);
    showNotice('stale', 'STALE PAGE', str(e.message) + '. ' +
      (usable ? 'The page now shows session ' + str(cur.id) + ' (generation ' + str(cur.generation) + '). '
              : 'The server\'s snapshot of the current session was unusable, so the display is unchanged; use Refresh. ') +
      What + ' did not happen; review, then act again deliberately.');
    if (!usable) {
      var btn = el('button', { type: 'button', 'size-': 'small', class: 'refresh-inline' }, 'Refresh session (read-only)');
      btn.addEventListener('click', refresh);
      noticeEl.appendChild(btn);
    }
  }

  function showFailure(e, what) {
    if (e && e.kind === 'refusal' && e.status === 409) { showStale(e, what); return 'stale page (' + what + ' did not happen)'; }
    if (e && e.kind === 'refusal') { showRefusal(e, what); return 'refused (' + what + ' did not happen)'; }
    if (!e || e.kind !== 'unknown') e = new Unknown(null, 'the page could not process the answer (' + str(e && e.message) + ')');
    showUnknown(e, what);
    return 'OUTCOME UNKNOWN (' + what + ')';
  }

  // ---------- transcript ----------

  function block(kind, label, body) {
    return el('div', { class: 'block block-' + kind }, el('div', { class: 'block-label' }, label), body);
  }

  function field(name, value) {
    return el('div', { class: 'field' }, el('span', { class: 'k' }, name), ' ', value);
  }

  function preText(text, cls) {
    return el('pre', { 'size-': 'small', class: cls || null }, str(text));
  }

  function listOf(items) {
    if (!Array.isArray(items) || items.length === 0) return el('span', { class: 'dim' }, '(none)');
    var ul = el('ul', { class: 'inline-list plain' });
    items.forEach(function (it) { ul.appendChild(el('li', null, el('code', null, str(it)))); });
    return ul;
  }

  function renderLanguageError(r) {
    var e = r.error || {};
    var loc = e.location;
    var locText = loc && typeof loc === 'object'
      ? str(loc.source) + ':' + str(loc.line) + ':' + str(loc.column)
      : null;
    var body = el('div', null,
      el('div', { class: 'result-head' },
        el('span', { 'is-': 'badge', 'variant-': 'foreground0', class: 'badge-error' }, 'LANGUAGE ERROR'), ' ',
        el('span', { 'is-': 'badge', 'variant-': 'background3', class: 'code' }, str(e.code) || '(no code)')),
      el('p', { class: 'err-message' }, str(e.message)),
      field('submission location:', locText ? el('code', null, locText) : el('span', { class: 'dim' }, 'no location supplied')),
      field('failing expression:', e['in'] !== null && e['in'] !== undefined ? el('code', null, str(e['in'])) : el('span', { class: 'dim' }, '(not supplied)')),
      field('within:', listOf(e.within)),
      field('frames:', listOf(e.frames)),
      e.explanation ? field('explanation:', el('span', null, str(e.explanation))) : null
    );
    if (e.text) {
      body.appendChild(el('details', { class: 'diag' },
        el('summary', null, 'full diagnostic, as the command line prints it'),
        preText(e.text)));
    }
    return block('error', 'result', body);
  }

  function renderHostFault(r) {
    var f = r.fault || {};
    return block('fault', 'result', el('div', null,
      el('div', { class: 'result-head' },
        el('span', { 'is-': 'badge', 'variant-': 'foreground0', class: 'badge-fault' }, 'HOST FAULT'), ' ',
        el('strong', null, 'a defect of the implementation, not an error in your program')),
      field('type:', el('code', null, str(f.type))),
      field('message:', el('span', null, str(f.message)))
    ));
  }

  function renderResultBlock(r) {
    if (r.status === 'value') {
      return block('value', 'result', el('div', null,
        el('div', { class: 'result-head' },
          el('span', { 'is-': 'badge', 'variant-': 'foreground0', class: 'badge-value' }, 'VALUE'), ' ',
          el('span', { class: 'dim' }, 'kind: ' + (r.kind === null || r.kind === undefined ? '(not supplied)' : str(r.kind)))),
        preText(r.value, 'value')));
    }
    if (r.status === 'defined') {
      return block('defined', 'result', el('div', { class: 'result-head' },
        el('span', { 'is-': 'badge', 'variant-': 'foreground1', class: 'badge-defined' }, 'DEFINED'), ' ',
        el('code', null, str(r.value))));
    }
    if (r.status === 'language-error') return renderLanguageError(r);
    if (r.status === 'interrupted') {
      var f = r.fault || {};
      return block('fault', 'result', el('div', null,
        el('div', { class: 'result-head' },
          el('span', { 'is-': 'badge', 'variant-': 'foreground0', class: 'badge-fault' }, 'INTERRUPTED'), ' ',
          el('span', null, str(f.message)))));
    }
    return renderHostFault(r);
  }

  function renderEntry(r, text) {
    var idx = 'in[' + str(r.index) + ']';
    var failed = r.status === 'language-error' || r.status === 'host-fault' || r.status === 'interrupted';
    var meta = [];
    if (r.forms !== null && r.forms !== undefined) meta.push(str(r.forms) + (r.forms === 1 ? ' form' : ' forms'));
    if (r.elapsed_ms !== null && r.elapsed_ms !== undefined) meta.push(str(r.elapsed_ms) + ' ms');

    var art = el('article', {
      class: 'entry entry-' + r.status,
      'box-': failed ? 'double' : 'round',
      'aria-label': idx + ' ' + r.status
    },
      el('div', { class: 'entry-head' },
        el('span', { 'is-': 'badge', 'variant-': 'background2', class: 'in-label' }, idx),
        el('span', { class: 'meta small' }, meta.join(' · '))),
      block('input', 'input', preText(text, 'src'))
    );
    if (typeof r.output === 'string' && r.output.length > 0) {
      art.appendChild(block('output', 'output (print)', preText(r.output, 'out')));
    }
    art.appendChild(renderResultBlock(r));
    if (r.state_note) art.appendChild(field('session state:', el('span', null, str(r.state_note))));
    if (r.note) art.appendChild(field('note:', el('span', null, str(r.note))));
    return art;
  }

  function appendEntry(node) {
    transcriptEl.appendChild(node);
    $('transcript-empty').hidden = true;
    node.scrollIntoView({ block: 'nearest' });
  }

  // ---------- history ----------

  function firstLine(text, max) {
    var t = text.replace(/^\s+/, '');
    var nl = t.indexOf('\n');
    var line = nl === -1 ? t : t.slice(0, nl);
    var more = nl !== -1 && t.slice(nl).trim().length > 0;
    if (line.length > max) { line = line.slice(0, max); more = true; }
    return line + (more ? ' …' : '');
  }

  function renderHistory() {
    var ul = $('history');
    ul.replaceChildren();
    for (var i = state.history.length - 1; i >= 0; i--) {
      (function (h) {
        var label = 'g' + h.generation + ' in[' + h.index + ']';
        var btn = el('button', { type: 'button', class: 'hist-item', title: h.text },
          el('span', { class: 'hist-idx' }, label), ' ', el('span', { class: 'hist-text' }, firstLine(h.text, 40)));
        btn.addEventListener('click', function () {
          editor.value = h.text;
          state.histPos = -1;
          $('recall-line').textContent = 'copied ' + label + ' into the editor (not submitted)';
          editor.focus();
        });
        ul.appendChild(el('li', null, btn));
      })(state.history[i]);
    }
    $('history-empty').hidden = state.history.length > 0;
  }

  function recall(dir) {
    var n = state.history.length;
    if (n === 0) { $('recall-line').textContent = 'no earlier submissions to recall'; return; }
    if (state.histPos === -1 && dir > 0) state.draft = editor.value;
    var next = state.histPos + dir;
    if (next > n - 1) next = n - 1;
    if (next < -1) next = -1;
    state.histPos = next;
    if (next === -1) {
      editor.value = state.draft;
      $('recall-line').textContent = 'back to your draft';
    } else {
      var h = state.history[n - 1 - next];
      editor.value = h.text;
      $('recall-line').textContent = 'recalled g' + h.generation + ' in[' + h.index + '] (' + (next + 1) + ' of ' + n + ', newest first)';
    }
    editor.setSelectionRange(editor.value.length, editor.value.length);
  }

  // ---------- actions ----------

  function setBusy(b) {
    state.busy = b;
    submitBtn.disabled = b;
    resetBtn.disabled = b;
    $('reset-yes').disabled = b;
    $('refresh-btn').disabled = b;
    transcriptEl.setAttribute('aria-busy', b ? 'true' : 'false');
  }

  function noteSessionChange(prev, s, byReset) {
    if (!byReset && prev && s && prev.id !== s.id) {
      showNotice('info', 'SESSION CHANGED', 'the server now reports session ' + str(s.id) +
        ' (generation ' + str(s.generation) + '); this page did not reset it (was ' + str(prev.id) + ')');
    }
  }

  function lastLabel(r) {
    var what = { 'value': 'VALUE', 'defined': 'DEFINED', 'language-error': 'LANGUAGE ERROR', 'host-fault': 'HOST FAULT', 'interrupted': 'INTERRUPTED' }[r.status];
    return 'ready · last: in[' + str(r.index) + '] ' + what + (r.elapsed_ms !== null && r.elapsed_ms !== undefined ? ' (' + str(r.elapsed_ms) + ' ms)' : '');
  }

  function handleResult(r, text) {
    if (!r || typeof r !== 'object') throw new Unknown(200, 'the answer carried no result');
    if (r.status === 'incomplete') {
      showNotice('incomplete', 'INCOMPLETE', 'nothing was evaluated; the input ends inside a form. Your text is still in the editor.' +
        (r.note ? ' Server note: ' + str(r.note) : ''));
      setStatus('ready · last: incomplete input (nothing evaluated)');
      return;
    }
    if (r.status === 'empty') {
      showNotice('empty', 'EMPTY', 'only whitespace or comments; nothing was evaluated and nothing was added.');
      setStatus('ready · last: empty input (nothing evaluated)');
      return;
    }
    if (['value', 'defined', 'language-error', 'host-fault', 'interrupted'].indexOf(r.status) === -1) {
      throw new Unknown(200, 'the answer carried an unknown result status "' + str(r.status) + '"');
    }
    appendEntry(renderEntry(r, text));
    state.history.push({ generation: state.session ? state.session.generation : '?', index: r.index, text: text });
    state.histPos = -1;
    state.draft = '';
    renderHistory();
    editor.value = '';
    $('recall-line').textContent = '';
    setStatus(lastLabel(r));
  }

  function release(focusEl) { return function () { setBusy(false); if (focusEl) focusEl.focus(); }; }

  function submit() {
    if (state.busy) return;
    if (!state.session) {
      showNotice('protocol', 'NO SESSION', 'this page has not read a session yet; refresh first. Nothing was sent.');
      return;
    }
    var text = editor.value;
    var expected = state.session.id;          // bound to the session this page SHOWS (r3)
    setBusy(true);
    setStatus('evaluating…');
    clearNotice();
    api('POST', '/api/submit', text, expected).then(function (data) {
      requireShape('this submission', sessionShape(data.session) || resultShape(data.result));   // before ANY change (r4)
      var prev = state.session;
      renderSession(data.session);
      noteSessionChange(prev, data.session, false);
      handleResult(data.result, text);
    }).then(null, function (e) {
      setStatus('ready · last: ' + showFailure(e, 'this submission'));
    }).then(release(editor), release(editor));
  }

  // Read-only: shows the CURRENT session; it cannot say which request produced it.
  function refresh() {
    if (state.busy) return;
    var before = state.session ? state.session.id : null;
    setBusy(true);
    api('GET', '/api/session').then(function (data) {
      requireShape('the refresh', sessionShape(data.session) || runtimeShape(data.runtime));  // an invalid answer never replaces the display (r4)
      renderSession(data.session);
      renderRuntime(data.runtime);
      var s = data.session;
      var n = Array.isArray(s.names) ? s.names.length : 0;
      showNotice('info', 'REFRESHED', 'current session ' + str(s.id) + ' (generation ' + str(s.generation) + '), ' +
        str(s.submissions) + ' submissions, ' + n + (n === 1 ? ' name' : ' names') +
        (before && before !== s.id ? ' — the page was showing ' + before : '') +
        '. A refresh shows the current state; it cannot tell which request produced it.');
      setStatus('ready · refreshed');
    }).then(null, function (e) {
      showNotice('unknown', 'REFRESH FAILED', httpLabel(e) + ': ' + str(e && e.message) + '. The display may be out of date.');
      setStatus('ready · refresh failed');
    }).then(release(null), release(null));
  }

  function openResetConfirm() {
    var s = state.session;
    var n = s && Array.isArray(s.names) ? s.names.length : 0;
    state.resetFor = s ? s.id : null;        // the confirmation names THIS session, and the request carries it (r3)
    $('reset-question').textContent = 'Reset session ' + (s ? str(s.id) : '?') + '? Every binding in it (' + n +
      (n === 1 ? ' name' : ' names') + ') is discarded and a new session starts. This cannot be undone.';
    $('reset-confirm').hidden = false;
    resetBtn.hidden = true;
    $('reset-no').focus();
  }

  function closeResetConfirm() {
    $('reset-confirm').hidden = true;
    resetBtn.hidden = false;
  }

  function doReset() {
    if (state.busy) return;
    if (!state.resetFor) { closeResetConfirm(); showNotice('protocol', 'NO SESSION', 'no session was named; nothing was sent.'); return; }
    setBusy(true);
    setStatus('resetting…');
    clearNotice();
    var resetFor = state.resetFor;
    api('POST', '/api/reset', undefined, resetFor).then(function (data) {
      requireShape('the reset', sessionShape(data.session) || runtimeShape(data.runtime) ||
        (data.session.id === resetFor ? 'it names the session that was to be replaced' : null));   // before clearing anything (r4)
      closeResetConfirm();
      transcriptEl.replaceChildren();          // this page's own reset: the old transcript goes, no divider needed
      renderSession(data.session);
      renderRuntime(data.runtime);
      $('transcript-empty').hidden = false;
      var s = data.session;
      var banner = $('reset-banner');
      banner.replaceChildren(
        el('span', { 'is-': 'badge', 'variant-': 'foreground0' }, 'RESET'),
        document.createTextNode(' '),
        el('strong', null, 'new session ' + str(s.id) + ' (generation ' + str(s.generation) + ')'),
        document.createTextNode(' — all bindings cleared'));
      banner.hidden = false;
      setStatus('ready · new session ' + str(s.id));
    }).then(null, function (e) {
      closeResetConfirm();
      setStatus('ready · last: ' + showFailure(e, 'the reset'));
    }).then(release(resetBtn), release(resetBtn));
  }

  // ---------- wiring ----------

  editor.addEventListener('keydown', function (ev) {
    if (ev.key === 'Enter' && (ev.ctrlKey || ev.metaKey)) {
      ev.preventDefault();
      submit();
      return;
    }
    if (ev.altKey && (ev.key === 'ArrowUp' || ev.key === 'ArrowDown')) {
      ev.preventDefault();
      recall(ev.key === 'ArrowUp' ? 1 : -1);
    }
  });
  submitBtn.addEventListener('click', submit);
  resetBtn.addEventListener('click', openResetConfirm);
  $('reset-no').addEventListener('click', function () { closeResetConfirm(); resetBtn.focus(); });
  $('reset-yes').addEventListener('click', doReset);
  $('refresh-btn').addEventListener('click', refresh);
  $('reset-confirm').addEventListener('keydown', function (ev) {
    if (ev.key === 'Escape') { closeResetConfirm(); resetBtn.focus(); }
  });

  renderHistory();
  api('GET', '/api/session').then(function (data) {
    requireShape('the first session read', sessionShape(data.session) || runtimeShape(data.runtime));
    renderSession(data.session);
    renderRuntime(data.runtime);
    setStatus('ready');
  }).then(null, function (e) {
    showNotice('unknown', 'NO SESSION', httpLabel(e) + ': ' + str(e && e.message) + '. Use Refresh to try again.');
    setStatus('no session read yet');
  });
})();
