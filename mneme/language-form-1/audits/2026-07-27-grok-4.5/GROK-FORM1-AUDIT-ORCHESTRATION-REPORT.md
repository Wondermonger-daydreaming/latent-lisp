# ORCHESTRATION REPORT — LANGUAGE FORM /1 STRANGER AUDIT

*Written by the commissioning seat. This report covers the ORCHESTRATION ONLY.
It contains no assessment of the auditor's findings, no interpretation of Form /1,
and no adjudication of the verdict. Those are not this seat's to give.*

```
audit target   9f37cd16654810e84670dfda71f10a72ad9b4cbd
auditor        x-ai/grok-4.5  (transport evidence; see the discrepancy below)
verdict        FINDINGS - CANDIDATE REMAINS CONTINUABLE
conversations  1        model turns 42        tool calls 77        commands 53
duration       2026-07-27T18:40:03Z -> 18:58:18Z   (~18 minutes)
cost           see return/RUN-IDENTITY.txt
```

## 1. Pre-launch gates — all passed, none skipped

| gate | result |
|---|---|
| packet sidecar | OK |
| bytes / members / sha256 | 247,317,288 / 3907 / `94b8d2c8…` — all MATCH |
| internal manifest, from the extraction root | **3906 / 3906 verify** |
| disposable subtree reconstruction | `f21ffb44…` MATCH |
| `target/` frozen | mode 555; writes and deletes refuse at the filesystem |
| baseline manifest | 3,907 rows |
| harness teeth-check | **25 passed / 0 failed** |
| model identity probe (separate conversation) | `x-ai/grok-4.5`, xAI, no fallback |

## 2. The three named defects — repaired, and each shown able to fail

**A — SBCL / HOME.** The installed wrapper is
`exec env SBCL_HOME="$HOME/.local/sbcl-2.4.6/lib/sbcl" "$HOME/.local/sbcl-2.4.6/bin/sbcl"`,
so the Form /0 harness's `HOME=scratch` made **both** of those paths resolve into
the scratch directory. Repaired by bypassing the wrapper: the real SBCL bin
directory goes first on `PATH` and `SBCL_HOME` is exported explicitly, so `HOME`
can stay inside `scratch/` for hygiene. Verified through the **exact environment
the auditor receives** — `SBCL 2.4.6`, and `--eval` operation-checked rather than
only `--version`. A **planted fault** reproduced the old configuration and
confirmed it breaks SBCL (exit 127), so the repair is load-bearing rather than
decorative.

**B — command artifact identities.** The counter moved from a process-local list
into a single shared state file incremented under an exclusive `flock`. 64
concurrent claims across 8 processes yielded 64 unique ids; a **new** process
continues at 65 rather than restarting at 1; and the artifact writer now raises
rather than overwriting an existing `cmd-NNNN.txt`.

**C — path screening.** The first-segment-must-be-a-real-toplevel-directory test
was kept, and a **relative-traversal limb** was added that the absolute-path
screen structurally could not see. Teeth-tested in both directions: `Form /1`,
`Slice /2`, URLs, `expr 10 / 2`, `a/b/c` all pass; ten genuine escapes — including
`cd ../../.. && ls`, `cat ../../../../etc/shadow`, `ls ../../form0-grok-audit` —
all refuse.

**The teeth-check found a real false positive that reading had not.** A blanket
`openrouter` deny pattern, added to protect credentials, also blocked the auditor
from typing an ordinary URL — which the commission explicitly requires to remain
usable. Narrowed to key-shaped patterns; network egress is still denied by the
`curl`/`wget`/`nc`/`ssh`/`scp`/`rsync` rules. This was caught by executing the
gate, not by inspecting it.

## 3. Enforcement boundary — stated as what it is

Filesystem read-only on `target/` and the explicitly-constructed subprocess
environment are **genuine, kernel-level**. Network and out-of-workspace denial is
**command screening, not operating-system isolation**: `unshare -rn` was attempted
and is denied in this environment (`uid_map: Operation not permitted`), so no
network namespace could be created. **No sandboxing claim is made beyond that.**
Full statement: `transcript/enforcement-boundary.txt`.

## 4. Context isolation

The initial context contained exactly two items, both hashed:

1. a **generic tool-contract system instruction**, leak-scanned and containing no
   Form /0 or Form /1 substantive term (`Form /1`, `NC-31`, `EG-4`, `B15`,
   `envelope`, `injectiv`, `hollow`, `Review 1`, `65536`, `policy v3` — none present);
2. the **exact bytes** of the packet's own `FRESH-AUDITOR-PROMPT.txt`
   (`641f7157…`, 4,774 bytes).

No do-not-read-yet document was preloaded. No Claude assessment, owner commentary,
expected finding, prior Form /0 material, Review 1 summary, project memory or
preferred verdict language entered the conversation. The auditor chose every file
it read through tools. It asked the seat for no substantive interpretation, and
none was given.

## 5. Interventions — one, mechanical, post-run

**INTERVENTION 1 — harness filename defect.** `write_audit_report()` in the
copied harness carried a hardcoded `GROK-FORM0-STRANGER-AUDIT.md`. Detected after
the audit had completed; it did not affect the run. Corrected by **rename only**:

```
sha256 before rename  b54a8ab13099fcaaf1b8d8513ba84f2ac69c0c15e0d82c634745364da1c33cf7
sha256 after  rename  b54a8ab13099fcaaf1b8d8513ba84f2ac69c0c15e0d82c634745364da1c33cf7
```

Byte-identical. **No model message was injected. No language, whitespace,
heading, token or conclusion was altered.** The sidecar was regenerated from the
report's exact bytes. Verbatim record: `transcript/interventions.txt`.

Ordinary tool execution is not counted as intervention. There were no others.

## 6. The self-identification discrepancy — recorded, not adjudicated

The harness probe's throwaway identity question drew the natural-language reply
`"DeepSeek-V3.2; 2+2=4."`. That is inconsistent with **every** piece of routing
and generation metadata, which reports `x-ai/grok-4.5`, snapshot
`x-ai/grok-4.5-20260708`, provider `xAI`, fallback forbidden and none detected —
on the probe **and** on the first, middle and last audit turns, fetched
independently from OpenRouter's generation endpoint.

The commission directs that natural-language self-identification is **not** to be
relied upon and that routing and generation metadata are the transport evidence.
On that instruction the auditor identity is `x-ai/grok-4.5`. **The discrepancy is
reported in full because it is a fact of this run, and this seat has no authority
to resolve it.**

## 7. Target preservation

```
internal manifest, post-run          3906 / 3906 verify
every sha256 and size, all 3907      IDENTICAL to baseline (0 differing rows)
subtree identity, re-derived         f21ffb449a5df303dee35a46df03697ea6721e88  MATCH
auditor experiments                  confined to scratch/ (20,469 entries)
```

The mode column differs between the baseline and post manifests. That is this
orchestration's own `chmod -R a-w` freeze, applied **after** the baseline was
captured — a sequencing artifact of the seat, not an auditor modification. Stated
rather than smoothed.

```
Claude-Code-Lab main   6e960adc · 0 tracked modifications · 0 unpushed
Form /1 candidate      9f37cd16 · 0 modifications · NOT merged into main
public mirror          8aa4a2e  · 0 files under language-form-1 — nothing published
```

## 8. What this report does not do

It does not evaluate the auditor's findings, agree or disagree with the verdict,
repair anything, merge anything, publish anything, or launch a second auditor.
The report in `return/` is the auditor's, unedited.
