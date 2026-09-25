// test-browser.mjs — REPL /0's defining sequence THROUGH A REAL BROWSER (CANDIDATE).
//
// Starts the real workbench with the one command (`lisp-plus-repl.sh --web`), opens it in
// headless Chromium, and does what a person does: types into the editor, presses keys,
// clicks buttons, reads what the page shows. Checks: a binding; a closure created, then
// reused in later submissions; a recoverable error; a successful continuation in the same
// session; multi-line input with Enter; incomplete input kept; print output shown as text;
// history recall; an explicit reset (cancel first, then confirm). Throughout: no console
// error, no page error, no Content-Security-Policy violation.
//
// A TEST TOOL, NOT A DEPENDENCY OF THE WORKBENCH. Requires Node and Playwright 1.55.0
// with its headless Chromium (the workbench itself needs neither):
//   npm install playwright@1.55.0 && npx playwright install chromium-headless-shell
//   NODE_PATH=<dir containing node_modules> node mneme/language-repl-0/test-browser.mjs [out-dir]
// out-dir (default: a temp dir) receives screenshots and the page's transcript text.
//
// Exit 0 iff every check passed. One line per check.

import { spawn } from 'node:child_process';
import { createRequire } from 'node:module';
import { mkdtempSync, writeFileSync, mkdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import net from 'node:net';

const require = createRequire(import.meta.url);
const { chromium } = require('playwright');

const HERE = dirname(fileURLToPath(import.meta.url));
const OUT = process.argv[2] || mkdtempSync(join(tmpdir(), 'repl0-browser-'));
mkdirSync(OUT, { recursive: true });

let pass = 0, fail = 0;
const ok = (c, name, detail) => {
  if (c) { pass++; console.log(`ok   ${name}`); }
  else { fail++; console.log(`FAIL ${name}${detail !== undefined ? '  — ' + detail : ''}`); }
  return c;
};

const freePort = () => new Promise((res) => {
  const s = net.createServer(); s.listen(0, '127.0.0.1', () => { const p = s.address().port; s.close(() => res(p)); });
});

const port = await freePort();
const server = spawn('bash', [join(HERE, 'lisp-plus-repl.sh'), '--web', '--port', String(port)], { stdio: ['ignore', 'pipe', 'pipe'] });
let serverOut = '';
// r3: the server dies with this process on EVERY path — a crashed run once left two orphaned servers.
process.on('exit', () => { try { server.kill('SIGTERM'); } catch (_) {} });
process.on('uncaughtException', (e) => {
  fail++; console.log(`FAIL the run did not complete  — ${String(e && e.message).split('\n')[0]}`);
  console.log(`repl0 test-browser: ${pass} passed, ${fail} failed`); process.exit(1);
});
process.on('unhandledRejection', (e) => { throw e; });
// A scenario that times out becomes a NAMED failure and the next scenario still runs.
const scenario = async (name, fn) => {
  try { await fn(); } catch (e) { ok(false, `${name} did not complete`, String(e && e.message).split('\n')[0]); }
};
server.stdout.on('data', (d) => { serverOut += d; });
server.stderr.on('data', (d) => { serverOut += d; });
for (let i = 0; i < 100 && !serverOut.includes('open http://127.0.0.1'); i++) await new Promise((r) => setTimeout(r, 200));
ok(serverOut.includes(`open http://127.0.0.1:${port}/`), `the one command started the workbench on 127.0.0.1:${port}`);

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });
const consoleErrors = [], pageErrors = [];
page.on('console', (m) => { if (m.type() === 'error' || m.type() === 'warning') consoleErrors.push(`${m.type()}: ${m.text()}`); });
page.on('pageerror', (e) => pageErrors.push(String(e)));
await page.addInitScript(() => {
  window.__csp = [];
  document.addEventListener('securitypolicyviolation', (e) => window.__csp.push(`${e.violatedDirective} ${e.blockedURI}`));
});

const entries = () => page.locator('#transcript article');
const lastEntry = () => entries().last();
async function submitWithKeys(text) {
  const before = await entries().count();
  await page.fill('#editor', text);
  await page.press('#editor', 'Control+Enter');
  await page.waitForFunction((n) => document.querySelectorAll('#transcript article').length > n
    || !document.getElementById('notice').hidden, before, { timeout: 15000 });
  return before;
}

await page.goto(`http://127.0.0.1:${port}/`);
await page.waitForFunction(() => document.getElementById('s-id').textContent !== '…', null, { timeout: 15000 });
const sid = await page.textContent('#s-id');
ok(/^[0-9a-f]{8}$/.test(sid), `the page shows the session identity (${sid}, generation ${await page.textContent('#s-gen')})`);
ok((await page.textContent('#status')).startsWith('ready'), 'the evaluation status reads ready');
ok((await page.textContent('#runtime')).includes('Lisp+ PROGRAM /0'), 'the runtime line comes from the server');

// 1 — a binding
await submitWithKeys('(define rate 3)');
ok((await lastEntry().textContent()).includes('DEFINED') && (await lastEntry().textContent()).includes('rate'), 'in[1] a binding: DEFINED rate (Ctrl+Enter)');

// 2 — a closure factory typed over two lines: plain Enter inserts a newline
await page.fill('#editor', '');
await page.click('#editor');
await page.keyboard.type('(define (scale-by k)');
await page.keyboard.press('Enter');
await page.keyboard.type('  (lambda (x) (* x k)))');
ok((await page.inputValue('#editor')).includes('\n'), 'plain Enter inserted a newline (nothing was submitted)');
ok((await entries().count()) === 1, 'still one entry before submitting');
await page.press('#editor', 'Control+Enter');
await page.waitForFunction(() => document.querySelectorAll('#transcript article').length === 2);
ok((await lastEntry().textContent()).includes('DEFINED'), 'in[2] a two-line closure factory: DEFINED scale-by');

// 3 — create the closure, capturing rate, via the Submit button
await page.fill('#editor', '(define triple (scale-by rate))');
await page.click('#submit-btn');
await page.waitForFunction(() => document.querySelectorAll('#transcript article').length === 3);
ok((await lastEntry().textContent()).includes('triple'), 'in[3] the closure is created (Submit button)');

// 4 — reuse it with a list computation
await submitWithKeys('(map triple (range 1 6))');
ok((await lastEntry().locator('pre.value').textContent()) === '(3 6 9 12 15)', 'in[4] the closure reused: (map triple (range 1 6)) → (3 6 9 12 15)',
   await lastEntry().textContent());

// 5 — a recoverable error
await submitWithKeys('(triple "three")');
const errText = await lastEntry().textContent();
ok(errText.includes('LANGUAGE ERROR') && errText.includes('E-TYPE') && errText.includes('in[5]:1:0'), 'in[5] a recoverable error: LANGUAGE ERROR E-TYPE at in[5]:1:0', errText);
ok(errText.includes('session continues'), 'the error entry says what happened to the session state');

// 6 — continue in the same session
await submitWithKeys('(+ (triple rate) 1)');
ok((await lastEntry().locator('pre.value').textContent()) === '10', 'in[6] the same session continues: (+ (triple rate) 1) → 10');
ok((await page.textContent('#s-id')) === sid, 'the session identity did not change across the error');
const names = (await page.locator('#names li').allTextContents()).join(' ');
ok(names === 'rate scale-by triple', `the names panel lists the session's bindings (${names})`);

// 7 — print output is shown as TEXT, separate from the value
await submitWithKeys('(print "<b>not bold</b>" (triple 14))');
const outBlock = lastEntry().locator('pre.out');
ok((await outBlock.textContent()) === '<b>not bold</b> 42\n', 'print output arrives as text, markup unparsed');
ok((await lastEntry().locator('b').count()) === 0, 'no element was created from program output');

// 8 — incomplete input: nothing evaluated, text kept
const n8 = await entries().count();
await page.fill('#editor', '(list 1 2');
await page.press('#editor', 'Control+Enter');
await page.waitForFunction(() => !document.getElementById('notice').hidden);
ok((await entries().count()) === n8 && (await page.inputValue('#editor')) === '(list 1 2'
   && (await page.textContent('#notice')).includes('INCOMPLETE'), 'incomplete input: a notice, no entry, the text stays in the editor');

await page.screenshot({ path: join(OUT, 'workbench-1280.png'), fullPage: true });

// 9 — history recall
await page.fill('#editor', '');
await page.press('#editor', 'Alt+ArrowUp');
ok((await page.inputValue('#editor')).startsWith('(print'), 'Alt+Up recalls the newest submission');
await page.press('#editor', 'Alt+ArrowUp');
ok((await page.inputValue('#editor')) === '(+ (triple rate) 1)', 'Alt+Up again recalls the one before it');
await page.locator('#history button').last().click();
ok((await page.inputValue('#editor')) === '(define rate 3)', 'clicking the oldest history entry copies it into the editor');

// the transcript as the page shows it — kept for the review package
writeFileSync(join(OUT, 'browser-transcript.txt'), (await page.locator('#transcript').innerText()) + '\n');

// 10 — reset is explicit: cancel first, then confirm
await page.click('#reset-btn');
ok(await page.isVisible('#reset-confirm'), 'Reset asks for confirmation');
await page.click('#reset-no');
ok((await page.textContent('#s-id')) === sid && (await entries().count()) === 7, 'Cancel changes nothing');
await page.click('#reset-btn');
await page.click('#reset-yes');
await page.waitForFunction((old) => document.getElementById('s-id').textContent !== old, sid);
const sid2 = await page.textContent('#s-id');
ok(sid2 !== sid && (await page.textContent('#s-gen')) === '2' && (await entries().count()) === 0
   && (await page.locator('#names li').count()) === 0, `a confirmed reset: new session ${sid2}, generation 2, empty transcript and names`);
ok((await page.textContent('#reset-banner')).includes(sid2), 'the reset banner names the new session');
await submitWithKeys('rate');
ok((await lastEntry().textContent()).includes('E-UNBOUND'), 'after the reset the old binding is gone (E-UNBOUND)');

// 11 — narrow layout still renders
await page.setViewportSize({ width: 800, height: 900 });
await page.screenshot({ path: join(OUT, 'workbench-800.png'), fullPage: true });
const overflow = await page.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth);
ok(overflow <= 0, `at 800 px there is no horizontal page scroll (${overflow}px)`);

// the ordinary run, from the browser's side (before r3 injects failures on purpose)
ok(pageErrors.length === 0, 'no uncaught page error in the ordinary run', JSON.stringify(pageErrors));
ok(consoleErrors.length === 0, 'no console error or warning in the ordinary run', JSON.stringify(consoleErrors));
const consoleBefore = consoleErrors.length;

// ---- r3 (Astra's AMEND): an operation that COMPLETES on the server, then loses its answer ----
await page.setViewportSize({ width: 1280, height: 900 });
const noticeText = async () => (await page.textContent('#notice')) || '';
const sawUnknown = async (what) => {
  await page.waitForFunction(() => !document.getElementById('notice').hidden && /OUTCOME UNKNOWN/.test(document.getElementById('notice').textContent), null, { timeout: 15000 });
  const n = await noticeText();
  return n.includes('may or may not') && !n.includes('nothing was evaluated') && !n.includes('did not happen') && !n.includes('stands');
};
const namesNow = async (p) => (await p.locator('#names li').allTextContents()).join(' ');

let pageB, S1, S2, S3;
// A — submit completes, the response is DROPPED
await scenario('r3 A', async () => {
await page.route('**/api/submit', async (route) => { await route.fetch(); await route.abort('connectionreset'); }, { times: 1 });
const nA = await entries().count();
await page.fill('#editor', '(define committed-then-lost 42)');
await page.press('#editor', 'Control+Enter');
ok(await sawUnknown(), 'r3 A: a submit that completed but whose answer was dropped says OUTCOME UNKNOWN (not "nothing was evaluated")', await noticeText());
ok((await page.inputValue('#editor')) === '(define committed-then-lost 42)' && (await entries().count()) === nA, 'r3 A: the text is kept and no transcript entry is invented');
ok(!(await page.isDisabled('#submit-btn')), 'r3 A: the busy state is released');
await page.click('#notice .refresh-inline');
await page.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
ok((await namesNow(page)).includes('committed-then-lost'), 'r3 A: a read-only refresh shows the binding the lost request made (it happened)');
});

// B — submit completes, the answer is CORRUPTED (HTTP 200, not JSON)
await scenario('r3 B', async () => {
await page.route('**/api/submit', async (route) => { await route.fetch(); await route.fulfill({ status: 200, contentType: 'application/json', body: '{broken json' }); }, { times: 1 });
await page.fill('#editor', '(define committed-then-garbled 7)');
await page.press('#editor', 'Control+Enter');
ok(await sawUnknown(), 'r3 B: a completed submit with a corrupted 200 answer says OUTCOME UNKNOWN', await noticeText());
await page.click('#refresh-btn');
await page.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
ok((await namesNow(page)).includes('committed-then-garbled'), 'r3 B: and the refresh shows it did happen');
});

// C — reset completes, the response is DROPPED
await scenario('r3 C', async () => {
const sidC = await page.textContent('#s-id');
await page.route('**/api/reset', async (route) => { await route.fetch(); await route.abort('connectionreset'); }, { times: 1 });
await page.click('#reset-btn');
await page.click('#reset-yes');
ok(await sawUnknown(), 'r3 C: a reset that completed but whose answer was dropped says OUTCOME UNKNOWN (not "the old session stands")', await noticeText());
await page.click('#refresh-btn');
await page.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
ok((await page.textContent('#s-id')) !== sidC, 'r3 C: the refresh shows the reset did happen (a new session id)');
});

// ---- r4 (Astra's r3 AMEND): VALID JSON that is NOT a valid answer, after the real request completed ----
const transcriptSnapshot = async () => (await page.locator('#transcript').innerHTML());
// F — reset answered {} (her exact body): nothing cleared, nothing announced, refresh offered
await scenario('r4 F', async () => {
  await page.fill('#editor', '(define kept-through-f 1)');       // editor text that must survive
  const before = await transcriptSnapshot();
  const sidF = await page.textContent('#s-id');
  await page.route('**/api/reset', async (route) => { await route.fetch(); await route.fulfill({ status: 200, contentType: 'application/json', body: '{}' }); }, { times: 1 });
  await page.click('#reset-btn'); await page.click('#reset-yes');
  ok(await sawUnknown(), 'r4 F: a reset answered {} is OUTCOME UNKNOWN', await noticeText());
  ok((await transcriptSnapshot()) === before, 'r4 F: the transcript is preserved (not cleared)');
  ok(!(await page.textContent('#status')).includes('new session') && (await page.textContent('#s-id')) === sidF,
     'r4 F: no new session is announced and the displayed id is unchanged');
  ok((await page.inputValue('#editor')) === '(define kept-through-f 1)' && await page.isVisible('#notice .refresh-inline') && !(await page.isDisabled('#submit-btn')),
     'r4 F: the editor text is kept, a refresh is offered, busy is released');
  await page.click('#notice .refresh-inline');
  await page.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
  ok((await page.textContent('#s-id')) !== sidF, 'r4 F: the refresh then shows the real reset did happen');
});
// G — submit answered {"result":{"status":"value"}} (her exact body): no entry, editor kept
await scenario('r4 G', async () => {
  const before = await transcriptSnapshot();
  const nG = await entries().count();
  await page.route('**/api/submit', async (route) => { await route.fetch(); await route.fulfill({ status: 200, contentType: 'application/json', body: '{"result":{"status":"value"}}' }); }, { times: 1 });
  await page.fill('#editor', '(define committed-then-hollow 9)');
  await page.press('#editor', 'Control+Enter');
  ok(await sawUnknown(), 'r4 G: a submit answered {"result":{"status":"value"}} is OUTCOME UNKNOWN', await noticeText());
  ok((await entries().count()) === nG && (await transcriptSnapshot()) === before, 'r4 G: no entry is fabricated; the transcript is preserved');
  ok((await page.inputValue('#editor')) === '(define committed-then-hollow 9)' && !(await page.textContent('#status')).includes('VALUE'),
     'r4 G: the editor text is kept and no VALUE is announced');
  await page.click('#notice .refresh-inline');
  await page.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
  ok((await namesNow(page)).includes('committed-then-hollow'), 'r4 G: the refresh shows the definition did happen');
});
// H — an invalid REFRESH answer never announces REFRESHED or replaces the last valid display
await scenario('r4 H', async () => {
  const sidH = await page.textContent('#s-id'), namesH = await namesNow(page);
  await page.route('**/api/session', (route) => route.fulfill({ status: 200, contentType: 'application/json', body: '{"session":{"id":"zz"}}' }), { times: 1 });
  await page.click('#refresh-btn');
  await page.waitForFunction(() => /REFRESH FAILED/.test(document.getElementById('notice').textContent));
  ok(!(await noticeText()).includes('REFRESHED') && (await page.textContent('#s-id')) === sidH && (await namesNow(page)) === namesH,
     'r4 H: an invalid refresh answer says REFRESH FAILED and leaves the last valid display');
});
// I — a stale refusal whose session snapshot is unusable: the refusal stands, the display does not change
await scenario('r4 I', async () => {
  const sidI = await page.textContent('#s-id');
  await page.route('**/api/submit', (route) => route.fulfill({ status: 409, contentType: 'application/json',
    body: JSON.stringify({ error: 'stale page', before_mutation: true, session: {} }) }), { times: 1 });
  await page.fill('#editor', '(+ 1 1)');
  await page.press('#editor', 'Control+Enter');
  await page.waitForFunction(() => /STALE PAGE/.test(document.getElementById('notice').textContent));
  ok((await noticeText()).includes('unusable') && (await page.textContent('#s-id')) === sidI && (await noticeText()).includes('did not happen'),
     'r4 I: a stale refusal with an unusable snapshot stays a refusal and does not replace the display');
});
// J — a LEGITIMATE empty value is not rejected: (quote ||) renders as ""
await scenario('r4 J', async () => {
  const nJ = await entries().count();
  await submitWithKeys('(quote ||)');
  ok((await entries().count()) === nJ + 1 && (await lastEntry().textContent()).includes('VALUE') && (await noticeText()).indexOf('OUTCOME UNKNOWN') === -1,
     'r4 J: a legitimate empty value (quote ||) is a VALUE entry, not OUTCOME UNKNOWN');
});

// D — two tabs: a stale CONFIRMATION cannot reset the other tab's session
await scenario('r3 D', async () => {
pageB = await browser.newPage({ viewport: { width: 1280, height: 900 } });
pageB.on('pageerror', (e) => pageErrors.push('B: ' + String(e)));
await pageB.goto(`http://127.0.0.1:${port}/`);
await pageB.waitForFunction(() => document.getElementById('s-id').textContent !== '…');
S1 = await page.textContent('#s-id');
ok((await pageB.textContent('#s-id')) === S1, `r3 D: two tabs show the same session ${S1}`);
await page.click('#reset-btn');                                   // tab A opens a confirmation naming S1
ok((await page.textContent('#reset-question')).includes(S1), 'r3 D: tab A\'s confirmation names S1');
await pageB.click('#reset-btn'); await pageB.click('#reset-yes'); // tab B resets → S2
await pageB.waitForFunction((old) => document.getElementById('s-id').textContent !== old, S1);
S2 = await pageB.textContent('#s-id');
await pageB.fill('#editor', '(define tab-b-work 1)'); await pageB.press('#editor', 'Control+Enter');
await pageB.waitForFunction(() => document.querySelectorAll('#transcript article').length === 1);
await page.click('#reset-yes');                                   // tab A confirms its stale S1 prompt
await page.waitForFunction(() => /STALE PAGE/.test(document.getElementById('notice').textContent), null, { timeout: 15000 });
ok((await page.textContent('#s-id')) === S2, `r3 D: tab A is refused and now shows the current session ${S2}`);
ok((await page.locator('#transcript .session-divider').last().textContent()).includes(S1) && !(await page.isVisible('#reset-banner')),
   'r3 D: tab A marks its transcript as the OLD session\'s and hides a banner naming another session');
await pageB.click('#refresh-btn'); await pageB.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
ok((await pageB.textContent('#s-id')) === S2 && (await namesNow(pageB)).includes('tab-b-work'), 'r3 D: S2 and tab B\'s work survive the stale confirmation');
});

// E — two tabs: a stale SUBMISSION cannot execute in the replacement session
await scenario('r3 E', async () => {
if (!pageB) throw new Error('tab B was not opened (r3 D did not get that far)');
await pageB.click('#reset-btn'); await pageB.click('#reset-yes');  // tab B resets → S3; tab A still shows S2
await pageB.waitForFunction((old) => document.getElementById('s-id').textContent !== old, S2);
S3 = await pageB.textContent('#s-id');
await page.fill('#editor', '(define from-stale-tab-a 1)');
await page.press('#editor', 'Control+Enter');
await page.waitForFunction(() => /STALE PAGE/.test(document.getElementById('notice').textContent), null, { timeout: 15000 });
ok((await page.inputValue('#editor')) === '(define from-stale-tab-a 1)' && (await page.textContent('#s-id')) === S3,
   `r3 E: tab A's stale submission is refused, its text kept, and it now shows ${S3}`);
await pageB.click('#refresh-btn'); await pageB.waitForFunction(() => /REFRESHED/.test(document.getElementById('notice').textContent));
ok(!(await namesNow(pageB)).includes('from-stale-tab-a'), 'r3 E: the stale submission did NOT run in the replacement session');
await page.screenshot({ path: join(OUT, 'workbench-r3-stale.png'), fullPage: false });
});
if (pageB) await pageB.close();

// the whole run, from the browser's side
const csp = await page.evaluate(() => window.__csp);
ok(csp.length === 0, 'no Content-Security-Policy violation (whole run)', JSON.stringify(csp));
ok(pageErrors.length === 0, 'no uncaught page error (whole run, both tabs)', JSON.stringify(pageErrors));
const extra = consoleErrors.slice(consoleBefore);
ok(extra.every((m) => /Failed to load resource|ERR_CONNECTION_RESET|409/.test(m)),
   `r3: the only console messages are the failures injected on purpose (${extra.length})`, JSON.stringify(extra));

await browser.close();
server.kill('SIGTERM');
console.log(`artifacts: ${OUT}`);
console.log(`repl0 test-browser: ${pass} passed, ${fail} failed`);
process.exit(fail === 0 ? 0 : 1);
