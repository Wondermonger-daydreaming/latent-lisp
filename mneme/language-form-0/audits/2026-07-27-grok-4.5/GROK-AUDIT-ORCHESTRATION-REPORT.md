# Grok Audit — Orchestration Report

**Independent verification of Language Form /0, Candidate /0**
Orchestrated 2026-07-26 → 2026-07-27 by **Claude Opus 5 (1M context)**, commissioning seat.

> **What this document is.** The orchestration seat's account of *how the audit was
> run* — isolation, verification, harness design, interventions, artifact hashes.
> It **does not adjudicate the auditor's findings.** The auditor's own report is the
> record: `return/GROK-FORM0-STRANGER-AUDIT.md`. Where they differ, that governs.
>
> The verdict is quoted, never paraphrased.

---

## 0 · The auditor's verdict

```
FINDINGS — CANDIDATE REMAINS CONTINUABLE
```

Verbatim rationale from its report:

> *"Rationale: no reproducible semantic or public-API counterexample against
> B1-B14's core claims was obtained. Remaining findings are instrument/battery
> distribution honesty, display-abbreviation footguns already mitigated in the
> inhabited printer, and declared out-of-reach items (publish hooks, network
> identity). Those justify "FINDINGS" rather than a clean "NO REPRODUCIBLE
> FINDING" and do not rise sink to "REPAIR REQUIRED BEFORE FURTHER DEPENDENCE."*
>
> *Auditor authority ends here. No patches proposed. No adoption/freeze/merge
> advice. Prefer this over a polite false close."*

---

## 1 · Isolated workspace

`/home/gauss/Desktop/form0-grok-audit/` — outside the lab repository, outside all
git worktrees, outside the public mirror clone. Verified to contain no `CLAUDE.md`,
`AGENTS.md`, or `.git` at any depth, and none in `~/Desktop` above it.

```
input/       frozen packet + sidecar (copied, not moved)
target/      verified extraction — chmod a-w, filesystem-enforced read-only
scratch/     writable; all controlled variants and counterexamples
harness/     orchestration code, local config, teeth-check records
transcript/  OpenRouter events, model turns, tool calls/results, commands
return/      the auditor's report, its sidecar, run identity
```

---

## 2 · Packet and target verification — before any model call

| check | observed | expected |
|---|---|---|
| `sha256sum -c …zip.sha256` | `OK` | — |
| byte count | `250471910` | `250471910` ✓ |
| SHA-256 | `9cd6d6f3f8091466401a8fc26c9063fe375320e7804a2bb5c44e686974edc178` | ✓ |
| member count | `3876` | `3876` ✓ |
| `sha256sum -c SHA256SUMS.txt` from extraction root | **ALL 3875 CHECKSUMS VERIFY** | — |

Target then locked and baselined:

```
chmod -R a-w target/
write probe   -> touch: Permission denied  (exit 1, no file created)
baseline      3876-file manifest, digest 4cb881765759ecbf61535a476ac1be3b4923938998533d78888bf65f5ac203a1
```

No `BLOCKED` condition arose. Nothing was repaired, regenerated, or replaced.

---

## 3 · The harness

**Route selection.** No existing setup qualified. `hermes` (the Nous agent) injects
a SOUL and persistent memory — not context-clean. `codex` is OpenAI-routed, not
OpenRouter. `continue` is an IDE extension. So: option 3 of the commissioning
terms' preferred order — a small purpose-built OpenRouter tool-calling harness at
`harness/harness.py` (plus `harness/resume.py` for the context boundary).

**Credential handling.** The key is read at runtime from a file *outside* the audit
workspace and never written to any artifact, never passed as a command-line
argument, and never inherited by a subprocess: children receive an explicitly
constructed 10-variable environment. Verified — a sentinel `OPENROUTER_API_KEY`
value set in the harness process was invisible to the child (0 matches).

**Seven tools**, all paths resolving beneath `target/`, `scratch/`, `return/` only:
`list_directory`, `read_file` (line-numbered, paginated, continuation hints),
`search_text` (literal/regex, bounded, line-numbered), `file_metadata`,
`copy_to_scratch`, `run_command`, `write_audit_report`.

`run_command` enforces: cwd beneath `target/` or `scratch/`; command screening;
timeout; exit code returned; bounded stdout/stderr inline with the **complete**
output written to `transcript/commands/` and referenced by path; exact command,
cwd, start/end timestamps, byte counts and SHA-256 per stream; order preserved.

### 3.1 Teeth-check — twelve planted faults, before any model invocation

A gate that has never fired is untested, not passing. Every fault below was planted
deliberately and its refusal observed:

| planted fault | result |
|---|---|
| path traversal out of workspace | REFUSED (`resolve_path`) |
| absolute path to `Claude-Code-Lab` | REFUSED |
| absolute path to `~/.ssh` | REFUSED |
| write-intent into `target/` | REFUSED (`must_be_writable`) |
| read `input/` frozen packet | REFUSED (outside allowed roots) |
| `curl` | REFUSED (`screen_command`) |
| `git push` | REFUSED |
| command reading `Claude-Code-Lab` | REFUSED |
| command reading `.env` | REFUSED |
| absolute path outside roots | REFUSED |
| `cwd` outside `target/`\|`scratch/` | REFUSED (cwd check) |
| **command writing into `target/`** | **REFUSED at the FILESYSTEM layer** — `touch: Permission denied`, exit 1, no file, manifest identical |

All legitimate operations allowed and correct. Records:
`harness/teeth-check/TEETH-CHECK-RESULT.txt`.

**Limitation stated rather than glossed.** OS-level confinement was **not
available**: `bwrap` and `unshare` both fail with `setting up uid map: Permission
denied` inside this environment. Enforcement is therefore tool-layer path
resolution + command screening + filesystem permissions — **not** kernel-enforced
isolation. This is a real weakening of the sandbox claim and is recorded as such.

---

## 4 · Model identity — and an anomaly resolved on evidence, not testimony

```
requested            x-ai/grok-4.5
returned             x-ai/grok-4.5        on every one of 49 responses
provider metadata    xAI
authoritative record x-ai/grok-4.5-20260708, provider_name xAI, billed to xAI
                     GET /api/v1/generation?id=gen-1785097046-e1kLY73zz214Z7LFT77y
fallback             NONE
```

**The anomaly.** Two identification probes produced two *different* and *both wrong*
self-reports:

```
probe 1 (20:12 UTC)  "I'm ChatGPT (GPT-5.2); 2+2=4."
probe 2 (20:37 UTC)  "I am Composer, a language model trained by DeepSeek. 2+2=4."
```

The commissioning terms required stopping on fallback. **No fallback occurred** —
and the *instability* of the self-reports against the *constancy* of every routing
field is what settles it. A dated snapshot name and a billing provider are
mechanical facts about which upstream served the request; a model's claim about its
own identity is the single least reliable sentence it produces. Proceeded on the
generation record, with both facts recorded in `transcript/model-metadata.json`.

**Post-hoc note, flagged in the file itself:** the harness re-runs its
identification probe at startup and overwrites `model-metadata.json`, which
discarded the original annotation. It was **re-applied after the run** and is
labelled `_note` as such. The probe data in that file is the startup probe's own,
unmodified.

---

## 5 · What the auditor was given — and what it was not

**Given:** the system instruction (tools + workspace boundary, in the substance the
commissioning terms specified) and the **exact bytes** of
`~/Desktop/form0-stranger-audit/FRESH-AUDITOR-PROMPT.txt`.

```
system_instruction sha256  11c04f5b1da85c088b03427343bac75a0c1772d46c52f9a087693bdaa261fe38
frozen_prompt      sha256  b12faab2a49ca170402ae2f95a5ce461d418977dcfa6f66a15906a4b1187c57e
```

**Withheld:** any Claude interpretation of the implementation; summaries from
earlier Lisp+ sessions; expected findings; preferred conclusions; suggested
counterexamples; owner commentary absent from the frozen prompt; prior reports from
the construction arc; Language Obligation /0 material; project memory or boot
context; the orchestration instruction itself.

**`PREFLIGHT-TRANSCRIPT.txt` was not preloaded.** It sat in `target/`, readable, for
the entire run.

### 5.1 The anchoring discipline held — and this is verifiable, not asserted

Across 49 turns and 69 tool calls, `PREFLIGHT-TRANSCRIPT.txt` was touched **exactly
once**: an `ls -la` alongside the other packet documents at conversation 1 turn 4.
No `cat`, `head`, `tail`, `grep`, `awk`, `sed`, or `read_file` ever touched its
contents. Its own checkpoint marked the file:

```
target/PREFLIGHT-TRANSCRIPT.txt   *** NOT READ YET — keep unread until own numbers done ***
```

Its report states: *"PREFLIGHT-TRANSCRIPT.txt was kept unread until own tallies were
complete; its figures were not used as authority."*

**Consequence worth naming.** My preflight derived the language-floor aggregate as
654 by summing eleven runner-reported values, and marked those eleven figures
`COMPRESSED` — an explicit admission that I had *not* re-run the suites
individually. The auditor independently loaded all eleven suites, calibrated a raw
verdict counter per suite format, and arrived at **654**, with my number unread.
Two independent paths to one aggregate. The `COMPRESSED` marks functioned as a map
of where to look — which is the argument for confessing a shortcut rather than
smoothing it.

---

## 6 · Volume

```
model conversations   2      (see §8)
model turns          49      = 26 (conv 1) + 1 (checkpoint) + 22 (conv 2)
tool calls           69      run_command 48 · read_file 13 · list_directory 7
                             · write_audit_report 1
command executions   48      38 artifacts on disk; 10 calls rejected by the
                             screener before execution, so wrote none
tool-call errors     11      9 in conversation 1 (6 of them my screening defect)
                             0 in conversation 2 after the fix
total cost           $1.3735
elapsed              20:37:24Z → 00:37:48Z  (~4h)
```

**Response identifiers.** All 49 are in `transcript/model-turns.jsonl`. First
`gen-1785098513-stgUa075vIBB1PxPQIAj`; last
`gen-1785112493-bmGJ6upkJ3Hi3EuKnra9`; checkpoint request
`gen-1785105910-6nhvKkjjtaWOqH4Rlhzz`.

---

## 7 · Orchestration interventions — three, all mine

Recorded verbatim in `transcript/interventions.txt`. **None substantive:** no
interpretation of the artifact was supplied, no finding suggested, no verdict
steered. Ordinary tool execution is not recorded as intervention.

### #1 — SBCL was unavailable, and my own instruction said it was

The system wrapper resolves through `$HOME`:

```sh
exec env SBCL_HOME="$HOME/.local/sbcl-2.4.6/lib/sbcl" "$HOME/.local/sbcl-2.4.6/bin/sbcl" "$@"
```

The harness sets `HOME=scratch/` for subprocesses (part of keeping credentials out
of children), so the wrapper looked for SBCL *inside the scratch directory* and
every bare `sbcl` failed. This made the system instruction's promise — *"SBCL 2.4.6
is available as `sbcl`"* — **false**, and no floor suite could run.

The auditor diagnosed it correctly and unaided (turns 8–9: read the wrapper,
inspected `HOME`/`USER`, located the real interpreter) and built its own shim.
Repaired with two symlinks inside `scratch/` satisfying the wrapper's own `$HOME`
expansion — both bare `sbcl` and the auditor's shim then returned 2.4.6, so its
chosen approach was not overridden. **No message was injected into its
conversation**; the promised capability simply began working.

### #2 — I overwrote two of the auditor's command artifacts

Diagnosing #1, I imported the harness in a **separate process** and called
`run_command` directly. The command sequence counter is per-process and restarts at
1, so my probes clobbered `cmd-0001.txt` and `cmd-0002.txt` — the auditor's two
independent `SHA256SUMS.txt` verifications.

**Fully recovered.** Both calls' inline captures were complete rather than truncated
(3586/3586 and 431/431 bytes, cap 24000), so `tool-results.jsonl` held every byte.
Rebuilt and verified against the digests recorded *at execution time*:

```
cmd-0001.txt   stdout digest matches: True    stderr digest matches: True
cmd-0002.txt   stdout digest matches: True    stderr digest matches: True
```

Each rebuilt file carries a `*** RECONSTRUCTED ARTIFACT ***` banner. My stray
probes were moved to `harness/teeth-check/`. `transcript/commands/` holds only the
auditor's records. **No output bytes were lost.** Prevention: no harness tool
function is invoked from a separate process while a run is live.

### #3 — the screener refused to let the auditor name its subject

`screen_command` treated any whitespace-preceded `/` as an absolute path. The
audited system's own naming convention uses spaced slashes — **`Form /0`**,
`Slice /1`, `Kernel /0` — so any command containing a comment or `echo` naming the
subject was rejected as a path escape. Bare `/` in comments, `//` in URLs, and
arithmetic division failed identically.

Six of the auditor's nine conversation-1 errors, four consecutively at turns 22–25,
while it was doing the heart of Pass A. Its turn-23 message: *"The runner is
rejecting path strings that contain `/0`. Working around that constraint."*

Corrected in source — a `/`-token is a candidate path only if its first segment is a
real top-level directory on this host — and teeth-checked at **19 cases**: all six
false rejections now pass, all eight real escapes still refused, all five
legitimate verification commands allowed. Applying it required a fresh process,
hence §8.

---

## 8 · Context boundary — this audit used more than one conversation

**Not a context-length limit and not a target defect.** At the boundary the context
held 110k of 500k tokens. Conversation 1 stalled on intervention #3, mine.

Procedure followed — the commissioning terms' own:

1. **Conversation 1 reconstructed exactly** from the transcript: 65 messages, all 37
   `tool_calls` matched to replies, 0 misordered. Verified before spending anything.
2. **The auditor wrote its own checkpoint.** I wrote no substantive summary on its
   behalf.
   ```
   14,663 chars · sha256 ed2d935d716e0c856b4cb8d85cfac78f85f56786c4ebc3e85004c5f95666eebb
   transcript/grok-checkpoint-conversation-1.txt
   ```
3. **Boundary recorded** in `transcript/context-boundaries.txt` with both
   conversations' response identifiers.
4. **Conversation 2 seeded with only:** the system instruction plus a *mechanical*
   harness addendum (the path filter was a bug and is fixed; each `run_command` is a
   separate `bash -c`), the frozen prompt unchanged, and the auditor's own
   checkpoint verbatim.
5. **Command counter seeded at 14** so no conversation-1 record could be
   overwritten; conversation 2 artifacts begin at `cmd-0015`.

A multi-conversation audit is **not** represented anywhere as a single
uninterrupted context.

**Effect of the fix:** conversation 2 ran **20 consecutive commands at exit 0**,
zero screening rejections, and completed both passes.

### 8.1 One thing the checkpoint contains that I could not have written

> *"Do NOT re-interpret earlier FAIL_COUNT=14 from first botched pipeline (comment
> noise)."*

The auditor is warning its own successor context away from a number **it** produced
and **it** later invalidated — an instrument its own tooling had briefly lied
through. Had I written the checkpoint, I would have recorded "3875 verified" and
that scar would have vanished. This is precisely what the "no substantive summary on
the auditor's behalf" rule protects.

---

## 9 · The final report

```
path        return/GROK-FORM0-STRANGER-AUDIT.md
bytes       29719
SHA-256     226c6e435c5e6b6c0cfd3bcc84dc9eef44edbe9d60bc0a73235bb35b9619cb70
sidecar     return/GROK-FORM0-STRANGER-AUDIT.md.sha256   (verified OK)
```

**Saved byte-for-byte as returned.** Not polished, shortened, corrected or
reformatted. It contains a small number of stray non-English tokens and typographic
artifacts from the model's generation — `مؤ`, `고`, `amb`, `الند7`, `DETERMING`,
`logout audit`, `sink`, and some irregular whitespace. These were **left exactly as
produced**; correcting them would have edited the auditor's return, which the
commissioning terms forbid. They are noted here so no reader mistakes them for
corruption in transit — the sidecar hash confirms the bytes are as delivered.

### 9.1 Shape of what it returned (structure only — no adjudication)

All ten required return items are present. Pass A: A1–A10 each with a status.
Pass B: B1–B14 each with a disposition — **12 UPHELD, 1 PARTIALLY ESTABLISHED (B7),
1 UPHELD with a coding nuance (B9)**. Findings classified into the six required
categories. Six witnessed items W1–W6. A §10 *"what this audit explicitly does not
establish"* running to some fourteen enumerated open doors.

It reports 59 local Pass B probes with 0 failures, states that no semantic or
public-API counterexample succeeded, and classifies its remaining findings as
instrument/battery-distribution honesty, a documented display-abbreviation hazard,
and declared out-of-reach items.

**Read its report for the content.** This section describes its shape so the owner
knows the return is complete, not what its findings mean.

---

## 10 · Transcript artifacts

All under `transcript/`.

| artifact | bytes | sha256 (first 16) |
|---|---|---|
| `openrouter-events.jsonl` | 43,476 | `0ddd93efcf720b9c` |
| `model-turns.jsonl` | 52,551 | `c87b8eecd4f99567` |
| `tool-calls.jsonl` | 162,867 | `772cf0c4ab837f56` |
| `tool-results.jsonl` | 436,885 | `7d157e8e81a8e311` |
| `model-metadata.json` | 2,374 | `04d959ef0528e01d` |
| `interventions.txt` | 10,921 | `dbfe13d0f4e6ddf3` |
| `context-boundaries.txt` | 1,107 | `041da4557f5b652c` |
| `grok-checkpoint-conversation-1.txt` | 14,758 | `ed2d935d716e0c85` |
| `target-baseline-manifest.txt` | 615,328 | `4cb881765759ecbf` |
| `commands/` | 292,259 (38 files) | — |

`openrouter-events.jsonl` preserves request/response metadata sufficient to
reproduce the chronology — model, provider, response id, usage, finish reason,
timestamps — and stores **no credential and no hidden internal reasoning**.
`tool-calls.jsonl` carries turn, tool, exact arguments, timestamp, and the
corresponding result identifier. `tool-results.jsonl` carries the tool-call
identifier, status, returned output, the complete-output artifact path where output
was capped, and an output digest.

---

## 11 · State confirmations

```
frozen target     UNCHANGED — 3876-file manifest taken before any model call is
                  byte-identical after the run:
                  4cb881765759ecbf61535a476ac1be3b4923938998533d78888bf65f5ac203a1
                  target/ was chmod a-w throughout; a write attempt was OBSERVED
                  to fail with Permission denied.

frozen packet     UNCHANGED — both copies (input/ and the original at
                  ~/Desktop/form0-stranger-audit/) verify OK against the sidecar.

lab repository    experiments/latent-lisp tree UNCHANGED — b907b8b2365fbd9cca6...
                  HEAD moved aeb81077 -> a057a59c during the session: the
                  session-checkpoint Stop hook locally committed one line in
                  tools/ledger/agents.jsonl (a subagent spawn record). 1 file,
                  1 insertion, NOT pushed. origin/main still aeb81077. Nothing
                  under experiments/ was touched by this audit.

public mirror     UNCHANGED — origin/main = 5ed23c7d5f768d8e8f13c83842f572cf563270d3.
                  No push occurred from this session.
```

---

## 12 · What the orchestration seat did not do

No part of the audit was performed, supplemented, or adjudicated. No implementation
file was selected for the auditor. No defect was suggested. No counterexample was
recommended. No implementation question was answered. No failed command was
reinterpreted. The subject was not modified. No discovered finding was repaired. The
auditor's conclusions were not edited, and no supplementary finding has been added
after it finished.

The three interventions were mechanical repairs to my own harness, each recorded
verbatim with its scope and its limits.

---

## 13 · A note on the interventions, since all three are one defect

All three interventions are the same failure wearing different clothes, and it is
the failure the audited artifact exists to refuse: **a secondary representation
standing in for the event it represents.**

- **#1** — a wrapper's `$HOME` stood for the user's home directory, after I had
  redefined `HOME` underneath it.
- **#2** — a **filename** stood for a command execution; `cmd-0001.txt` labelled a
  slot in a per-process counter, and I read it as identifying a call.
- **#3** — a **regex's guess** at "this looks like a path" stood for *being* a path,
  and the false positive was generated by the audited layer's own name.

Each was fixed the same way: consult the thing itself rather than its resemblance —
read the wrapper, hash the streams, ask the filesystem what its top-level
directories actually are.

The recovery in #2 is worth more than the error. Because the harness records a
SHA-256 of every stream **at execution time** alongside a bounded inline copy, an
unrecoverable loss became a *verifiable* reconstruction: I could prove the rebuilt
bytes were the original bytes rather than assert it. A transcript storing only
artifact files would have lost those commands permanently; one storing only the
inline copy could not have proven the copy faithful. It took both.

---

*Orchestration report by Claude Opus 5 (1M context), 2026-07-27. The auditor's
report is the record of the audit; this is the record of the run.*
