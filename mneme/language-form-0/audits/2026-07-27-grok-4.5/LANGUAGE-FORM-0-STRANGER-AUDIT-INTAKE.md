# LANGUAGE FORM /0 — STRANGER-AUDIT INTAKE

*The project's standing record of the independent audit of Candidate /0.
Documentation only. **Not an adoption record and not a freeze.***

Filed 2026-07-27 under owner ruling *ACCEPT AND FILE THE LANGUAGE FORM /0
STRANGER AUDIT*. Zero executable delta.

---

## 1. Standing

```
merged and published:            yes
same-family floors:              green
independent stranger audit:      COMPLETED
audit verdict:                   FINDINGS — CANDIDATE REMAINS CONTINUABLE
semantic defects found:          none reproducible
public-API defects found:        none reproducible
instrument findings:             mutation-attribution distribution;
                                 abbreviated-identity footgun, already mitigated
                                 in the shipped display
declared audit limits:           public-network identity;
                                 lab publication-hook topology
successor dependence:            permitted EXPERIMENTALLY, with the named
                                 limitations carried forward
adopted:                         no
specification-frozen:            no
semantic repair required:        no
```

**The stranger-audit debt is satisfied for the exact subject tree below, and for
no other.** Any later executable change to Form /0 creates a new audit delta and
therefore new audit standing.

---

## 2. The audited target

```
public commit   5ed23c7d5f768d8e8f13c83842f572cf563270d3
root tree       e0950634a7b0791ea58db2463928f6a4e68a6521
subject tree    a0941e749cf0fb23de74de811ca69e1447d397c1
                (mneme/language-form-0/ at 5ed23c7)
repository      github.com/Wondermonger-daydreaming/latent-lisp
runtime         SBCL 2.4.6
```

The auditor worked from a frozen packet of the **published** tree, not from the
lab working copy. Packet transport was verified **internally** — sidecar OK,
250,471,910 bytes, 3,876 members, and `sha256sum -c SHA256SUMS.txt` returning
**all 3,875 checksums verified** — before any model was invoked.

---

## 3. Auditor identity

```
requested       x-ai/grok-4.5
returned        x-ai/grok-4.5   on all 49 responses
provider        xAI
snapshot        x-ai/grok-4.5-20260708   (OpenRouter generation record)
fallback        none
```

**Recorded anomaly, preserved rather than resolved away.** Two identification
probes produced two *different* and both-wrong natural-language self-reports —
first *"I'm ChatGPT (GPT-5.2)"*, then *"I am Composer, a language model trained by
DeepSeek."* Every routing field held constant, and the authoritative generation
record names the dated xAI snapshot with xAI billing.

**The contradictory self-identifications are not routing evidence.** The
OpenRouter generation record is the auditor-identity basis. A model's
self-description is testimony; provider routing is transport evidence. The
anomaly is retained in `RUN-IDENTITY.txt` and
`transcript/model-metadata.json` (external) because it is a clean miniature of the
distinction this layer's own instrument history turns on.

---

## 4. Epistemic class — state this accurately, do not upgrade it

> **Independent, claim-directed corroboration of the exact Form /0 candidate
> snapshot.**

It is **not**:

- a blind discovery audit — the commission named claims B1–B14 and disclosed the
  instrument history up front;
- external-standard conformance — no external standard was applied;
- adoption;
- a specification freeze;
- proof of process isolation;
- proof against arbitrary Common Lisp already executing in the image.

Naming the claims does not weaken the corroboration. It fixes *what kind of
evidence this is*, which is the only honest way to cite it.

---

## 5. Conduct of the run

```
model conversations              2
model turns                     49    (26 + 1 checkpoint + 22)
tool calls                      69
command executions              48
orchestration interventions     3     all mechanical
commissioning-seat steering     none
frozen target                   UNCHANGED
```

**No substantive commissioning-seat interpretation was supplied.** The auditor
received exactly two things: a system instruction describing tools and the
workspace boundary, and the frozen commission's exact bytes. Withheld: any Claude
interpretation of the implementation, prior-arc summaries, expected findings,
preferred conclusions, suggested counterexamples, project memory, and the
orchestration instruction itself.

**The same-family preflight transcript was not preloaded** and was verifiably
never read — touched once across 49 turns by an `ls -la`, never by any content
read. Its figures were not used as authority.

**The three interventions were mechanical**, each recorded verbatim (external
`transcript/interventions.txt`): restoring the SBCL path the harness had itself
broken by overriding `HOME`; reconstructing two command artifacts the
commissioning seat overwrote, verified against digests recorded at execution
time; and correcting a path screener that mistook the string `Form /0` for a
filesystem escape. The third caused a **context boundary** — not context
exhaustion and not a semantic difficulty. The auditor wrote **its own**
checkpoint; conversation 2 received that checkpoint verbatim, the frozen
commission, and the same tools.

**Frozen target unchanged:** a 3,876-file manifest taken before any model call is
byte-identical after the run (`4cb881765759ecbf…`). `target/` was read-only
throughout and a write attempt was observed to fail.

---

## 6. Exact verdict

```
FINDINGS — CANDIDATE REMAINS CONTINUABLE
```

Verbatim rationale from the report:

> *"no reproducible semantic or public-API counterexample against B1-B14's core
> claims was obtained. Remaining findings are instrument/battery distribution
> honesty, display-abbreviation footguns already mitigated in the inhabited
> printer, and declared out-of-reach items (publish hooks, network identity).
> Those justify "FINDINGS" rather than a clean "NO REPRODUCIBLE FINDING" and do
> not rise sink to "REPAIR REQUIRED BEFORE FURTHER DEPENDENCE."*
>
> *Auditor authority ends here. No patches proposed. No adoption/freeze/merge
> advice. Prefer this over a polite false close."*

---

## 7. Claim dispositions

**No reproducible semantic finding. No reproducible public-API finding.**
59 independently written Pass B probes, 0 failures.

| | claim | disposition |
|---|---|---|
| B1 | phase separation / immutability after derive | UPHELD |
| B2 | subject identity template→closed across chain | UPHELD |
| B3 | phase-object id ≠ subject id; context commitment | UPHELD |
| B4 | public API cannot mint a validated form or receipt | UPHELD |
| B5 | no arbitrary handler injection; package-owned operators only | UPHELD |
| B6 | same built-ins cannot diverge publicly | UPHELD |
| **B7** | **five rechecks at realization** | **PARTIALLY ESTABLISHED** |
| B8 | hole fillings are literal data, not interpreted code | UPHELD |
| B9 | five binding refusals | UPHELD (with nuance below) |
| B10 | `PERFORM` structurally admitted, refused at validation | UPHELD |
| B11 | refusals inspectable after later success; datum retained | UPHELD |
| B12 | Form /0 mints nothing | UPHELD |
| B13 | threat-model honesty | UPHELD |
| B14 | recursion bound contingent, not structural | UPHELD |

### B7 — preserve this wording, do not round it up

Five components are bound at validation and rechecked at realization. The
auditor exercised **three** through the public API — environment-identity drift,
version-family drift, and content drift — each producing a refusal.

**Grammar identity and resource policy could not be varied through the public
constructor because the API structurally fixes them.** That is not a bypass and
not a gap in the recheck. The accurate statement is:

```
five components are bound and rechecked
three are publicly perturbable
two are structurally non-forkable through the public API
```

Do **not** claim five independently demonstrated external residual codes.

### B9 — recorded nuance

Undeclared, unfilled, duplicate, and wrong-species bindings each refuse with
exact codes. The *extra*-binding path refuses, but in the exercised order its
residual code may be shared with `:UNDECLARED-HOLE`. Both refuse; no silent-allow
path was found.

---

## 8. Instrument findings — dockets, not a repair gate

### 8.1 Mutation-evidence distribution

All ten mutants changed source and all ten produced non-green runs. The
**evidentiary** distribution:

```
7   reached the intended tooth and produced a named failure
2   died at or near the relevant path through a different CD/0 marker
    (boundary-accepts-host, unfilled-hole-allowed)
1   died before the intended tooth, which it therefore does not demonstrate
    (literal-descends)
0   invalid / no-op
0   survived
```

**"10 planted, 10 killed" is numerically true and epistemically compressed.** The
committed ledger's own `reached` column already exposes this when read carefully.
The danger is the aggregate slogan travelling alone.

Specifically: **`literal-descends` does not demonstrate `T-ONE-PASS`.** The
separate `two-pass-substitute` mutant does.

A further note the auditor recorded: `no-env-identity-gate` still fails at its
*named* tooth, but with `:ENVIRONMENT-CONTENT-DRIFT` where
`:ENVIRONMENT-IDENTITY-DRIFT` was expected — evidence that the two gates are
coupled on that planted scenario rather than that a single gate bit alone.

**This is an instrument/reporting limit on what the battery establishes — not a
semantic defect of Form /0.** Docketed as an *optional future instrument
refinement*. **It is not a repair gate** and does not block successor work.

### 8.2 Abbreviated-identity footgun

Naive 16-character head or tail slices of identity hex **collapse distinct full
values** (3 head-16 collapse groups, 1 tail-16 group on a live phase-chain
sample). The shipped display in `de-forma-dormiente/APPLICATION.lisp` uses a
length-bearing `short()` and **discriminates** on the same sample
(distinct-full = distinct-short = 10), and its comments already name the hazard.

Live footgun **only** if a future ledger compares bare prefixes. Docketed.

### 8.3 Declared limits — outside the stranger seat's reach

- **Public network identity.** No fresh clone of the GitHub commit was possible
  from the supplied workspace, and the packet carries no `.git`. Public commit and
  root-tree identity therefore remain an **interested-party transport claim
  attached to a stranger-verified body** — not a semantic uncertainty.
- **Lab publication-hook topology** (post-commit vs post-merge, main-only guard,
  content verifier). Lab-side by design, verifiably absent from the public tree.
  The auditor neither claims to have verified it nor claims it broken.

---

## 9. What regenerated exactly

Present-state artifacts, not ageing paperwork:

```
EXPORT-CENSUS.md     regenerated byte-identically
                     99 live external symbols == 99 census rows
                     set-difference empty in BOTH directions
                     0 external symbols neither fbound nor bound
MUTATION-LEDGER.md   regenerated byte-identically
```

---

## 10. Two stale declarations — OBSERVED at intake, REPAIRED before publication

Recorded in **both** states. The documentation-only intake could not fix them, and
erasing the finding afterward would itself be the defect: an unrecorded stale
declaration is one of the six instrument costumes this lane already named.

### Observed stale at intake commit `46241688`

1. **`mneme/verify-form-floor.sh`** printed
   `adopted: no · stranger audit OWED · Slice /3 NOT opened.`
   The audit was no longer owed for this tree. The intake ruling forbade altering
   runners, so it was filed stale and docketed.

2. **`LANGUAGE-FORM-0-CLOSURE.md`** read `form0 exports: 97`. The live package and
   the regenerated census both showed **99**. Stale by two.

### Repaired by the bounded follow-up commit, before publication

*Owner direction, 2026-07-27.*

1. **The runner no longer keeps a second copy of audit history at all** — the root
   cause, not merely the wrong value. It now reports **what it executed**, plus the
   three *stable* properties of this floor (candidate / self-consistency floor, no
   adoption implied, no freeze implied), and **points to
   `LANGUAGE-FORM-0-CLOSURE.md` as the governing standing record.** It does not
   parse Markdown, consult a registry, or restate a verdict it cannot verify. One
   volatile hard-coded governance sentence was deliberately *not* swapped for
   another that would go stale in its turn.

2. **The closure's export line reads 99**, with its history corrected by
   derivation rather than guess. `MAKE-OPERATOR-DESCRIPTOR` was **removed** —
   verified **ABSENT** from the live package with **0** census rows — and three
   externals were added by option (c) at `0bbcc4a6`:
   `INSTANTIATED-FORM-TEMPLATE-SUBJECT-IDENTITY`, `OPERATOR-DESCRIPTOR`,
   `OPERATOR-NAMES`, each verified **EXTERNAL** with **1** census row. Net **+2**,
   so 97 → 99. Established from `do-external-symbols` on the loaded package and
   from the regenerated census — not from the stale line's own arithmetic.

### Untouched, correctly

`LANGUAGE-FORM-0-RETURN.md` quotes the old banner inside a **transcript of what
the runner printed at the time**. That is a historical record, not a live
declaration, and rewriting it would falsify the transcript.

### The audit target is unaffected

The audit applies to the exact subject tree `a0941e749cf0fb23de74de811ca69e1447d397c1`
at public commit `5ed23c7`. These repairs and this documentation came **afterward**
and do **not** retroactively alter that target. They create a later tree, which
carries its own future audit standing.

---

## 11. Filed artifacts

In this directory:

| file | bytes | sha256 |
|---|---|---|
| `GROK-FORM0-STRANGER-AUDIT.md` | 29,719 | `226c6e435c5e6b6c0cfd3bcc84dc9eef44edbe9d60bc0a73235bb35b9619cb70` |
| `RUN-IDENTITY.txt` | 9,954 | `5326c62e9c2e778b55d5a3cc28fd6d7afb1992add98fa716b62c4cb5c0c3d486` |
| `GROK-AUDIT-ORCHESTRATION-REPORT.md` | 21,550 | `64742749178647d602acda9d069e6fe24d21cc9a45a6471301656090a66e74ef` |

**`GROK-FORM0-STRANGER-AUDIT.md` is preserved byte-for-byte as returned.** It
contains a small number of stray non-English tokens and typographic artifacts
from the model's generation (`مؤ`, `고`, `amb`, `الند7`, `DETERMING`, `logout
audit`, `sink`). These are **not** to be corrected: its SHA-256 binds those exact
bytes, and editing them would edit the auditor's return.

### External materials — referenced, deliberately NOT committed

| material | size | sha256 |
|---|---|---|
| `FORM0-STRANGER-AUDIT-PACKET-5ed23c7.zip` | 250,471,910 | `9cd6d6f3f8091466401a8fc26c9063fe375320e7804a2bb5c44e686974edc178` |
| `…zip.sha256` (sidecar) | 106 | `835831f7107d0754ac0d41103f58d3cea5a025e104cd8cabd252c83c933e5480` |
| `transcript/grok-checkpoint-conversation-1.txt` | 14,758 | `ed2d935d716e0c856b4cb8d85cfac78f85f56786c4ebc3e85004c5f95666eebb` |
| `transcript/interventions.txt` | 10,921 | `dbfe13d0f4e6ddf3…` |
| `transcript/openrouter-events.jsonl` | 43,476 | `0ddd93efcf720b9c…` |
| `transcript/model-turns.jsonl` | 52,551 | `c87b8eecd4f99567…` |
| `transcript/tool-calls.jsonl` | 162,867 | `772cf0c4ab837f56…` |
| `transcript/tool-results.jsonl` | 436,885 | `7d157e8e81a8e311…` |
| `transcript/target-baseline-manifest.txt` | 615,328 | `4cb881765759ecbf…` |
| `transcript/commands/` | 292,259 (38 files) | — |

Held at `~/Desktop/form0-grok-audit/` on the lab host. The packet ZIP, the
extracted repository copy, scratch trees, event transcripts, command-output
directories, and all API configuration are **excluded from Git by design**. No
credential entered this repository; the artifacts above were scanned before
filing and contain none.

---

## 12. The lesson this lane keeps re-teaching

Form /0 exists to refuse one thing: *a datum having the shape of a program
without thereby acquiring the operations that program names.* Its central
sentence held under 59 independent attacks.

The machinery built to **describe** it did worse than the thing described. The
harness's SBCL wrapper resolved a redefined `$HOME`; its artifact counter let a
filename stand for a command execution; its path screener let a regex's guess
stand for being a path, and consequently refused to let the auditor write the
string `Form /0`. Three representations mistaken for the events they represent —
the layer's own central sin, incarnating around the layer, in the very apparatus
recording that the law held.

Every time, the cure was identical: **stop trusting the label; inspect the
thing.** Read the wrapper. Hash the stream. Ask the filesystem what its
directories actually are.

---

*Filed by Claude Opus 5 (1M context), 2026-07-27, under owner ruling. The
auditor's report is the record of the audit; this is the project's record of its
standing. Where they differ, the report governs.*
