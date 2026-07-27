# LANGUAGE FORM /1 — STRANGER-AUDIT INTAKE

*The project's standing record of the independent audit of Candidate /0.
Documentation only. **Not an adoption record and not a freeze.***

Filed 2026-07-27 under owner ruling *ACCEPT, FILE, MERGE AND PUBLISH LANGUAGE
FORM /1 CANDIDATE /0*. Zero executable delta.

---

## 1. Standing

```
stranger audit                   COMPLETED
audited target commit            9f37cd16654810e84670dfda71f10a72ad9b4cbd
audited subject tree             7c8a672f9c6f48005a3fe71ea2f1435b12740d22
verdict                          FINDINGS - CANDIDATE REMAINS CONTINUABLE

independent semantic defect
  requiring repair               none reproduced
independent public-API defect
  requiring repair               none reproduced

adopted                          no
specification frozen             no
governing floor                  unchanged — Form /1 retains its separately
                                 named local candidate runner and joins no
                                 verify-*.sh floor
experimental successor
  dependence                     permitted, with the residuals of §6 carried
                                 forward
```

**The stranger-audit debt is satisfied for the exact subject tree above, and for
no other.** Any later executable change to Form /1 creates a new audit delta and
therefore new audit standing.

**One pre-audit declaration is deliberately left stale.**
`LANGUAGE-FORM-1-OWNER-RULINGS.md` still reads `stranger audit: OWED` in its
standing block. That was true when written, the ruling filing this intake
permits only a link-only addition to that document, and **this intake is the
record that supersedes it.** Recorded here rather than smoothed there — an
unrecorded stale declaration is one of the costumes this lane has already
learned to name.

---

## 2. The audited target

```
commit                    9f37cd16654810e84670dfda71f10a72ad9b4cbd
repository root tree      f01ba833af89725ed4e58ff7ff8ab241b3351c1f
experiments/latent-lisp   f21ffb449a5df303dee35a46df03697ea6721e88
mneme/language-form-1     7c8a672f9c6f48005a3fe71ea2f1435b12740d22
branch                    language-form-1-candidate-0
policy / grammar          v3 / v1
runtime                   SBCL 2.4.6
```

The auditor worked from a frozen packet of this **unpublished lab branch**, not
from a public mirror — at audit time nothing under `mneme/language-form-1/` had
ever been published. Packet transport was verified before any model was invoked:
sidecar OK, 247,317,288 bytes, 3,907 members, internal manifest **3,906 / 3,906**
verifying both pre-run and post-run.

The auditor **independently re-derived** the subtree identity from the extracted
content (`git init && git add -A -f && git write-tree`) and obtained
`f21ffb44…` — MATCH, 3,901 tracked files — and re-derived it again after all its
work, unchanged.

---

## 3. Auditor identity and standing

```
requested model    x-ai/grok-4.5
returned model     x-ai/grok-4.5   on all 42 audit turns
upstream snapshot  x-ai/grok-4.5-20260708
provider           xAI
fallback           none  (allow_fallbacks=false on every call; a per-turn
                   mismatch guard was armed and never fired)
```

**Prior use, disclosed.** The same external model family previously audited
Language Form /0 in a separate, stateless run. **No conversation, checkpoint,
transcript, summary or substantive context from that run was reused.** This run
opened a new conversation whose entire initial context was two hashed items: a
generic tool-contract system instruction carrying no Form /0 or Form /1
substantive term (leak-scanned for `Form /1`, `NC-31`, `EG-4`, `B15`, `envelope`,
`injectiv`, `hollow`, `Review 1`, `65536`, `policy v3` — none present), and the
exact bytes of the packet's own `FRESH-AUDITOR-PROMPT.txt` (`641f7157…`).

**Recorded anomaly, preserved rather than resolved away.** The harness's
throwaway identity probe drew the natural-language reply, verbatim:

```
'DeepSeek-V3.2; 2+2=4.'
```

That is inconsistent with every piece of routing and generation metadata, on the
probe *and* on the first, middle and last audit turns fetched independently from
the generation endpoint. **The self-identification is preserved as a model
utterance and is not used as routing evidence; the stable OpenRouter generation
metadata governs auditor identity.** A model's self-description is testimony;
provider routing is transport evidence — the same distinction this layer's own
subject matter turns on. Neither the orchestrating seat nor this intake resolves
it; it is recorded as a fact of the run.

---

## 4. Epistemic class — state this accurately, do not upgrade it

> **Independent external claim-directed corroboration** of the exact Form /1
> Candidate /0 snapshot.

It is **not**, and must not be cited as:

- a blind discovery audit — the commission named the claims and disclosed the
  instrument history up front;
- **second-family** external corroboration — the same model family audited
  Form /0; this is one family, twice, statelessly;
- external-standard conformance — no external standard was applied;
- adoption;
- a specification freeze;
- proof against false declarations by a trusted host;
- proof of operating-system isolation;
- exhaustive proof of identity injectivity;
- proof that 65,536 is future-proof.

Naming the claims does not weaken the corroboration. It fixes *what kind of
evidence this is*, which is the only honest way to cite it.

---

## 5. Conduct of the run

```
conversations                    1     (no continuation; no context boundary crossed)
model turns                     42     distinct response ids 42
tool calls                      77
commands executed               53     (see §7A on the 53/54 reconciliation)
duration                        2026-07-27T18:40:03Z → 18:58:18Z  (~18 min)
orchestration interventions      1     mechanical, post-run
commissioning-seat steering   none
frozen target                UNCHANGED
```

**No substantive commissioning-seat interpretation was supplied.** Withheld: any
Claude assessment of the implementation, owner commentary, prior-arc or Form /0
material, the Review 1 summary, project memory, expected findings, preferred
counterexamples and preferred verdict language. The auditor chose every file it
read through its own tools.

**The one intervention was mechanical and post-run.** The copied harness carried
a hardcoded `GROK-FORM0-STRANGER-AUDIT.md` filename; the report was corrected by
**rename only**, with `sha256` before and after the rename both
`b54a8ab1…c33cf7` — byte-identical. No model message was injected; no language,
whitespace, heading, token or conclusion was altered.

**Enforcement boundary, stated as what it is.** `target/` read-only at the
filesystem (mode 555/444, kernel-enforced, teeth-tested) and an explicitly
constructed subprocess environment carrying no credential are **genuine**.
Network egress and out-of-workspace denial are **command screening, NOT
operating-system isolation**: `unshare -rn` is denied in this environment
(`uid_map: Operation not permitted`), so no network namespace could be created.
**No sandboxing claim is made beyond that, and this intake does not upgrade it.**

---

## 6. Exact verdict

```
FINDINGS - CANDIDATE REMAINS CONTINUABLE
```

Verbatim rationale from the report:

> *"Saying the ugly part: this candidate is carefully self-instrumented
> same-family work that already published its own scars; after stranger
> cross-examination those scars remain roughly the scars it claimed, and the
> instruments — once hollow — are now mostly teeth. Continuable does not mean
> loved, frozen, or above suspicion. It means I could not force a blocking
> counterexample, with the method written down."*

---

## 7. The audit's positive results — recorded without inflation

Each of these was **independently derived by the auditor**, not read off a
preparer footer. Preparer figures are given second where the report gives both.

```
packet identity and target tree    independently reproduced  (f21ffb44…, 3901 files)
Form /1 selftest                   210 / 0        (preparer 210 / 0)
inhabited application
  (de-forma-petente)                68 / 0        (preparer  68 / 0)
export surface reconciled          133 externals  (live ↔ package.lisp, both
                                   directions, set-difference empty each way;
                                   regenerated census byte-identical)
refusal catalogue reconciled        37 protocol refusals
                                     3 induced integrity alarms
                                    40 total, disjoint, union = catalogue
verdict-liveness                   210 / 210 forced red, contiguous, no
                                   collateral red
identity census                  7,776 submissions
                                 2,592 distinct declared payloads
                                 2,592 identities
                                     0 collisions in the finite census
independent cross-field search        16 payloads → 0 collisions
condition partition                 20 classes
                                     3 executed escapes
                                    14 unreachable by source analysis
five claim-directed planted faults   all died at their INTENDED teeth
                                   (Door-1 counter / NC-10 args / NC-35 role /
                                    NC-20(a) / NC-21 escape); post-fault
                                    restoration green
existing governed floors           form floor      199 / 0  (3 floors)
  UNCHANGED                        language floor  654 / 0  (11 floors)
                                   verify-all      6 / 6
```

**The auditor independently reproduced the repaired forms of the two historically
hollow checks** — the drift-ceiling / CD/0 copy tripwire and NC-34
no-values-at-all — showing the OLD forms hollow under faithful aliasing and the
NEW forms discriminating in the same world.

### The one caveat that rides the liveness number forever

**210 / 210 licenses exactly one sentence:** *every rendered verdict is connected
to the suite's failure result.* It establishes **connectedness, not predicate
soundness.** The instrument says so itself and the auditor confirmed it: **both
already-found hollow checks would have passed this sweep.** Do not let 210/210
travel as soundness.

---

## 8. Residuals and findings — carried forward exactly

### A. NC-31B — a declared limitation, never a repair

**Same denotation declaration plus different live anchors may retain identical
declared identities and produce opposite governed outcomes.**

The auditor's witness W1: the same denotation declaration identifier with
opposite live witnesses (`PLUT-7` vs `WRONG`) and identical sealed context
occurrence tags produced opposite `:GRANTED` / `:GOVERNED-REFUSAL` under an
identical submission occurrence identity when `:ACT-ID` and `:BY-ID` were held
fixed.

```
classification    trusted-host false declaration or identifier reuse
                  declared limitation
                  no cross-image certification earned
```

**NC-31A is the defect REPAIRED. NC-31B is the residual.** Never call B repaired
or certified.

### B. Envelope tightness — EG-4 holds; the published worst case was not maximal

The same-family "worst-case fixture" was **not globally maximal**. The stranger's
independent monochromatic large-declaration family found:

```
declaration 60000    DERIVE/2 invoked once · :GRANTED
                     receipt identity 61271 octets
declaration 60500    :SUBMISSION-ENVELOPE-EXCEEDED · DERIVE/2 invocations 0
declaration 70000    :IDENTITY-OCTETS-EXCEEDED at context sealing
                     DERIVE/2 invocations 0
```

Therefore:

- **EG-4 holds** on the tested families;
- **no post-invocation accounting failure was reproduced** (the audit's
  highest-value target, B15, was pursued and not found);
- **65,536 is tight, not generous** — the measured ratio is ~1.07×;
- **60,873 was the preparer's fixture maximum, not a demonstrated global
  maximum.**

**The envelope is not altered in this intake.**

### C. Condition escapes — three, executed, as designed

Preserved exactly:

```
PATTERN-USED-AS-GROUND
MALFORMED-STRUCTURED-PROPOSITION
UNBOUND-CONCLUSION-VARIABLE
```

These are Slice /1 escapes. They leave **no Form /1 semantic object** — they are
not converted into a petition-refusal and not laundered into a classified Form /1
success. That is the explicit escape law, independently confirmed.

### D. Predecessor observations — preserved separately, unrepaired here

- **`SLICE2:DERIVATION-BASIS-REFUSED`** — exported and never signalled. A
  predecessor false affordance; the Form /1 catalogue does not carry it.
- **Nine severe broad handler sites** — predecessor-layer observations. PF-5
  demonstrates that if Form /1 itself blanketed errors it would launder to a
  refusal, and that fault died at NC-21; no Form /1-path conversion into
  supervised success was shown.

**Both are recorded, not repaired, and are not repaired in this session.**

### E. Historical test scars — documentation/numbering residue

Checks historically described as **[46]** and **[129]** moved to later live
indices after suite growth (those positions now hold `NC-ANCHOR-01` and
`TRY-SUBMIT` arities). **The raw historical references remain correct for their
original snapshots**, and are documentation/numbering residue only when read as
current indices. This does not hollow the repaired teeth.

### F. Read-only target runner — a packaging limitation, not a semantic defect

The local runner writes tracked transcript files and therefore **cannot execute
fully in a frozen read-only target**: it exits 1 while still printing bodies. The
stranger worked around it with a writable scratch copy. **This is a
packaging/instrument-use limitation, not a Form /1 semantic defect.**

---

## 9. Two audit-metadata discrepancies — reconciled, with the raw artifacts unedited

**Neither `RUN-IDENTITY.txt` nor the auditor's report is edited.** The
clarifications live here.

### A. Command count — 53 vs 54

The raw artifacts report both numbers. The transcript resolves the distinction,
and this intake verified it against the bundle rather than restating it:

```
run_command tool requests        54    (tool-calls.jsonl)
commands actually executed       53    (command-sequence.state = 53)
pre-execution tool rejection      1    (turn 5, status "error")
command artifacts                53    (cmd-0001 … cmd-0053)
```

The rejected request used an **invalid working-directory path** and was refused
**before command execution**, returning
`path outside the audit workspace … Allowed roots: target/, scratch/, return/`.
It produced no command artifact.

**Therefore `command executions 54` in `RUN-IDENTITY.txt` is an
orchestration-metadata overcount by one** — it carried the request count into the
execution row. `transcript/run-summary.json` (`"command_executions": 53`) and the
orchestration report (`commands 53`) are correct.

### B. Prior exposure — interpret narrowly

The auditor's report says *"Prior exposure: NONE."* **Interpret that narrowly as:
no prior context in this audit conversation.** The same model family had
previously audited Form /0 in a separate stateless run, as `RUN-IDENTITY.txt`
correctly discloses under PRIOR-USE DISCLOSURE. **Do not describe this as a
second independent external model family.**

### C. Mode-manifest sequencing — an orchestration artifact, not a target mutation

The orchestration baseline was captured **before** `chmod` made the target
read-only, so the file-mode column differs between the baseline and post-run
manifests. Verified at intake rather than assumed:

```
rows                           3,907 in both manifests; path sets identical
fields differing               exactly one column, in every row
that column                    the file mode
  baseline value  "1204"   ==  0644  (writable)
  post-run value  "674"    ==  0444  (read-only)
                 (int("1204",8)=644 · int("674",8)=444; the live target
                  still stats as 444 today)
content hashes                 IDENTICAL in all 3,907 rows
sizes                          IDENTICAL in all 3,907 rows
reconstructed Git tree         f21ffb44… pre-run and post-run, MATCH
```

*(The manifest generator is not in the artifact bundle, so the column's rendering
convention is established from its values against the live target, not read from
its source.)*

**Recorded as an orchestration sequencing artifact. The target was not mutated.**

---

## 10. Verification re-run at intake

Run from the audit-intake branch, on the merge-base tree, under SBCL 2.4.6
operation-checked through the wrapper (`(lisp-implementation-version)` → `2.4.6`):

```
run-form1-candidate.sh          exit 0
  form1-selftest                210 checks passed /  0 failed   exit 0
  de-forma-petente               68 checks passed /  0 failed   exit 0
check-form1-transcript.sh       exit 0    RECONCILIATION CLEAN
CONDITION-PARTITION.lisp         70 checks passed /  0 failed   exit 0
IDENTITY-INJECTIVITY.lisp       170 checks passed /  0 failed   exit 0
  7,776 submissions · 2,592 distinct declared payloads
  2,592 distinct identity values · 0 collisions
  2,592 declared-residual groups (the NC-31B shape — NOT collisions)

verify-form-floor.sh             3 floors ·  199 checks / 0 failed   exit 0
verify-language-floor.sh        11 floors ·  654 checks / 0 failed   exit 0
verify-all.sh                    6 / 6 suites green                  exit 0
```

**Every figure the ruling expected was reproduced exactly.**

Two facts about *this* re-run worth keeping:

1. **The runner rewrote all four `RUN-*.txt` transcripts and they came back
   byte-identical to the committed captures** — `git diff` reports nothing for
   the whole Form /1 directory after the run. The recorded transcripts are
   reproducible, not merely archived.
2. **The three governed floors mention Form /1 nowhere.** `verify-form-floor.sh`
   still names Form /0 Candidate /0 as its subject. That is the mechanical proof
   of the standing claim in §1: **Form /1 was not added to a governing floor.**

Executable delta against the audited target `9f37cd16`, measured rather than
asserted:

```
git diff --name-only 9f37cd16 -- '*.lisp' '*.asd' '*.sh'    (empty)
git diff --name-only 9f37cd16                                exactly one file:
    LANGUAGE-FORM-1-OWNER-RULINGS.md   (+16 lines, the permitted link-only pointer)
```

No package export, grammar, policy, identity, receipt, condition or test
changed.

---

## 11. Filed artifacts

In this directory, **preserved byte-for-byte as returned**:

| file | bytes | sha256 |
|---|---|---|
| `GROK-FORM1-STRANGER-AUDIT.md` | 23,776 | `b54a8ab13099fcaaf1b8d8513ba84f2ac69c0c15e0d82c634745364da1c33cf7` |
| `GROK-FORM1-STRANGER-AUDIT.md.sha256` | 95 | `6ebe4595d18660d07342b58b2e3926e41dc349f3329c459c7902b0aef98e8ef6` |
| `RUN-IDENTITY.txt` | 4,558 | `ce2f0e3c49deb1975bb446dd737e8318df6cb843162634fdb96ed5a27938c733` |
| `GROK-FORM1-AUDIT-ORCHESTRATION-REPORT.md` | 7,260 | `aa26d9ddcecc1b7f04dc4021e2cf2cb9011ff51f36a23536b68a218588ff659d` |

**The auditor's report is preserved exactly as returned.** It contains a small
number of stray tokens and typographic artifacts from the model's generation
(`Frois`, `腿`, `accountéd`, `nota`, `ologiques`, `censes`, `sink`,
`` Form `1 ``). **These are not to be corrected**: its SHA-256 binds those exact
bytes, and editing them would edit the auditor's return.

### External materials — referenced by identity, deliberately NOT committed

| material | bytes | sha256 |
|---|---|---|
| `FORM1-STRANGER-AUDIT-PACKET-9f37cd16.zip` | 247,317,288 | `94b8d2c8deb193f14474ced34e9dfaf386789af08fc36e38ae1c6040a71210f5` |
| `…PACKET…zip.sha256` (sidecar) | 107 | — |
| `FORM1-GROK-AUDIT-ARTIFACTS-9f37cd16.zip` | 829,369 | `086b566bd3c4d6b86a8fd1bc9c0ef0d8b9a2c183a1f6034764a33dd5104ec230` |
| `…ARTIFACTS…zip.sha256` (sidecar) | 106 | `038bea0257eea0f9560eb49524cd057dd51a0a624ab915e079f2c6a6d0302d5b` |
| `transcript/openrouter-events.jsonl` | 36,668 | `7858f5bdafe4179caba0b6ab6177f293e999c5d28866959cd32c72985e5aa083` |
| `transcript/model-turns.jsonl` | 31,293 | `2f975b8e9b83bd8d239f756c5ddbf28706079cfe2896a0d52e928e4efe9c0da6` |
| `transcript/tool-calls.jsonl` | 179,988 | `5802029b8eea756ccf8ab4042fd8d5ac100eb81ebc58d0fa1b6929c88bc5d251` |
| `transcript/tool-results.jsonl` | 552,490 | `c16e92cc4005a11bee3ff7707f9b4fb8d4a9112e0600de7f7e5972d7d811e467` |
| `transcript/target-baseline-manifest.txt` | 658,028 | `c2b8f5ab4036333f85305ecb674fadeaece3297bc7c87c13525cce4ac69e2a5f` |
| `transcript/target-post-manifest.txt` | 654,187 | `2d8346a548701355aec87263f7ead4d7edd34c051b91d808a0cbc7e8ae12b33e` |
| `transcript/enforcement-boundary.txt` | 1,389 | `00acebd7a9df4f7804c0195297a2bb38f541dbc8bdd5ce006890be688ecd1c2e` |
| `transcript/interventions.txt` | 1,355 | `f149cf8e3892ed1621c9190730f18e0ba871d6a3b0cabada979d5f55cebb624a` |
| `transcript/generation-metadata-audit-turns.json` | 803 | `1bbfedbb35a9d67421c9ea7312f4c46ab2d23f8934f31ed6a45cf3d5a01055b3` |
| `transcript/run-summary.json` | 345 | `342555f96028040b88eabbe1f5f01cb82bf97898d86a234894879f9c2dc101d4` |
| `transcript/commands/` (53 files) | 1,949,126 | — |
| `scratch/` (auditor's own experiments) | 2,440,667,059 (18,929 files) | — |

Held at `~/Desktop/form1-grok-audit/` and `~/Desktop/` on the lab host. The
236 MB packet, the artifact ZIP, the extracted repository copy, scratch trees,
frozen target copies, command transcripts, OpenRouter event JSONL, model-turn
JSONL, tool-call/result JSONL, credentials and all API configuration are
**excluded from Git by design**. No credential entered this repository.

---

## 12. What this intake does not do

It does not adopt Form /1, freeze its specification, add it to a governing floor,
repair the predecessor broad handlers, remove `DERIVATION-BASIS-REFUSED`, alter
the identity envelope, add a `MAX-DECLARATION-OCTETS`, commission another
stranger, or open Form /2.

It records that an outside came, worked for eighteen minutes with the method
written down, could not force a blocking counterexample, and **found one thing
the preparer's own worst case had missed** — that the envelope's margin is
1.07×, not the 4.13× the earlier fixture suggested. The candidate is continuable.
Continuable is not the same as trusted, and the difference is the whole point of
having asked someone else.

---

*Filed by Claude Opus 5 (1M context), 2026-07-27, under owner ruling. The
auditor's report is the record of the audit; this is the project's record of its
standing. Where they differ, the report governs.*
