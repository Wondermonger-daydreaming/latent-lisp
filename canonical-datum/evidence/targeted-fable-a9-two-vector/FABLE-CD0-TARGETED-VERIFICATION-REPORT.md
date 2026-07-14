# FABLE — CD/0 Errata-0.1 Targeted Verification REPORT

*Claude Fable 5, audit director, 2026-07-13 (evening). Executes the pre-registered protocol
`FABLE-CD0-TARGETED-VERIFICATION-PROTOCOL.md` (commit `49b3cf88` @ 13:35:17−03, which
pre-dates every successor commit) against the published successor branches. Verifier ≠ patch
author (protocol §8): Codex authored the patches; the §4 witnesses were run by the director
with ADJUDICATOR's pre-patch instruments; §3/§5/§6 legs ran under three named Claude
subagents (LEXARCH/Opus, GAUNTLET/Sonnet, SIGILLUM/Sonnet) whose reports are preserved.*

## Verdict

**RETURN-TO-IMPLEMENTER** — on exactly **one narrow item** (§3-A9 shared-vector
instantiation; detail below). **No §15.3 escalation trigger fired.** Every other check in
the protocol **PASSED**, most with exact byte/hash/count agreement against the
implementer's claims. This is a corpus-completeness return, not a correctness return: the
A9 *behavior itself* was verified live by the director on both codecs with pre-patch
witnesses and is correct.

Per protocol §0 the verdict vocabulary is trinary and "ELIGIBLE-FOR-MERGE" requires *all*
checks pass. One §3 sub-item does not, under the strict reading the anti-weakening clause
mandates. The remediation is mechanical and small; re-verification on resubmission is
scoped (see "On resubmission").

## Subject under test (fetched fresh from the public remote; trees + ancestry verified)

| Branch | Commit | Tree | Status |
|---|---|---|---|
| codex/cd0-common-lisp-errata-0.1 | `ee3baa9ab504f65d39015f212050748fd300160a` | `ecf5261c…` | matches report; descends from audited tip `45eb60ce…` |
| codex/cd0-python-errata-0.1 | `9f46a32351095dc1a52724a31574e0b9e62ed221` | `f065acfe…` | matches; descends from `29d0946a…` |
| codex/cd0-integration-errata-0.1 | `851cffc2f0c4799ac8aff9008ddf218bd32255be` | `b08b3b4f…` | matches; descends from `baeecd5e…` |

Audited tips and `main` (`ae767f00…`) unchanged on the remote. No history rewritten.

## Results by protocol section

| § | Check | Result |
|---|---|---|
| 1.1 | Base spec untouched | **PASS** — `d578e86e…` on successor |
| 1.2 | Errata companion byte-identical | **PASS** — `5f1568e5…`, `cmp` clean vs archived original |
| 1.3 | Divergence register append-only | **PASS w/ documented deviation** — one non-row header line ("clean-room"→"independently seeded") changed in obedience to §6.4's phrasing law; all evidentiary rows intact; all else pure append |
| 1.4 | Ruling cited/archived | **PASS** — sha cited in closure rows; ruling archived in-tree twice, both `1a0e8ff8…` |
| 2.1 | Pre-existing positive hex | **PASS** — zero changes (comm on {id,hex,eq-class}: empty) |
| 2.2 | Worked vectors 17/17 | **PASS** — full-row byte-identical; verifier green; teeth fire |
| 2.3 | Fixture retention | **PASS** — zero `input_hex` changes; field changes = 12×status/notes (the mandated promotions) + 2×`expected_failure` stage-only (`container-content`→`type-tag`, the licensed A1 corrections) |
| 2.4 | Equality classes | **PASS** — zero changes on retained vectors |
| 3 | New-vector coverage A1–A9 | **8/9 COVERED, A9 PARTIAL** → the returned item (below). LEXARCH report: `scratch/fable-verify/S3-coverage-report.md` |
| 4.1–4.3 | CL A2 witnesses | **PASS** — old tree reproduces every "was" (`InvalidCanonicalGrammar/…`); successor: `UnsupportedHostInput/{EmptyIdentifierSegment,MissingIdentifierPath,ZeroDenominator}/host-import` |
| 4.4 | Python A2 unchanged | **PASS** — identical on all 18 probes, old and new |
| 4.5–4.6 | CL A9 encode @depth=1/@nodes=1 | **PASS** — was `ExcessiveNesting`/`NodeBudgetExceeded` (reproduced); now SUCCESS, hex pinned `4c50434400300100` both |
| 4.7 | Python A9 | **PASS** — unchanged success, identical bytes |
| 4.8 | Wire categories unmoved | **PASS** — live decode both codecs: wire zero-den/missing-path/empty-seg all remain `InvalidCanonicalGrammar/...` — jurisdiction split, wire untouched |
| 5.1 | Suites | **PASS** — Python 167 (≥152) · CL 2,633 assertions (≥2,510) |
| 5.2 | Differentials | **PASS** — hand 465/codec, release 100,861/codec, 0 issues, 0 mutation disagreements, `provisional_observations: []`, **no field exclusions** — complete triples throughout |
| 5.3 | Request arithmetic | **PASS** — recomposed exactly (465; 100,861) from run's own fields |
| 5.4 | N/A discipline | **PASS** — Py 71 executed / CL 68 + 3 N/A named individually with reasons, never counted as passes |
| 5.5 | v1 gate | **PASS** — `verify-all.sh` 6/6; `git diff -- mneme/` EMPTY vs both audited tip and `origin/main` |
| 5.6 | Stderr | **PASS** — all adapter/probe stderr empty (102 files) |
| 6.1 | New archive reproducible | **PASS** — rebuilt from `168470c4…` to identical sha `f6c8cf9f…`, 20,463,020 B, 1,385 entries, listing sha match |
| 6.2 | Old archive untouched | **PASS** — `af655967…` byte-identical, published BESIDE (never over) |
| 6.3 | Four LOW repairs | **PASS** — all four located with file:line (SIGILLUM report) |
| 6.4 | Phrasing laws | **PASS** — zero violations across 171 touched prose files; hits diffed against audited baseline to distinguish banner-marked historical text |
| 7 | Escalation triggers | **NONE** — no hex/equality/validity change, no new codec divergence (successor CL≡Py on all 18 witness probes), no v1/mneme change, no unrelated code (344 `canonical-datum/` + 15 errata docs + register + 4-line protective `.gitattributes`) |

Sub-reports: `scratch/fable-verify/{DIRECTOR-CHECKS.md, S3-coverage-report.md,
S5-rerun-report.md, S6-archive-report.md}` + seven witness logs + retained run artifacts.

## The returned item — §3-A9 shared-vector instantiation gap

**Frozen requirement (protocol §3):** "A9: per-operation jurisdiction: encode `seq[Unit]`
@`max_depth=1` ample output MUST succeed → `4c50434400300100`; @`max_nodes=1` MUST
succeed; decode-side structural budgets still enforced."

**What the successor's shared corpus contains (all verified first-hand):**
- `cd0-errata-a9-runtime-ignores-structural-fields` — runtime-encode of a 4-item sequence
  with ALL 12 structural budgets **zeroed** → OK, canonical hex pinned. A-fortiori
  stricter than the enumerated case on the *jurisdiction rule*.
- `cd0-pos-generated-00000054` — `seq[Unit]` → `4c50434400300100` as a round-tripped
  positive, but under the **default** budget (no structural override).
- `cd0-errata-a9-decode-still-enforces-depth` (+ promoted `cd0-neg-resource-depth`/
  `-nodes` with retry legs) — the golden bytes as decode-refuse inputs @depth=1/@nodes=1.
  Third clause of the bullet: **covered**.

**What it lacks:** any shared vector for the exact conjunction *encode `seq[Unit]` WITH
`max_depth=1` (and separately `max_nodes=1`) → success → `4c50434400300100`*. Confirmed by
grep across `vectors/` and `generated/`: the golden hex never appears as an encode-output
expectation under a structural-budget override.

**The contested step, exhibited (PLUMB's rule):** a coverage-semantic reading would pass
this — the regression-catching function is served a fortiori (any re-enforcement of
structural budgets at encode trips the zeroed-budget row), and errata E0.1-9's own mandate
("runtime-encode jurisdiction vectors MUST exercise E0.1-9 in both directions") is
satisfied. But the protocol's bullet pins a specific case with specific bytes, and the
protocol forbids weakening after contact with the work. Adopting the lenient reading after
discovering the rows are absent would be exactly such a weakening; the strict reading
governs. Note the asymmetry honestly: the *behavior* is proven (director's §4.5–4.7,
pre-patch instruments, both codecs, bytes pinned); what is missing is its permanent,
executable attestation in the shared corpus that future regressions would be tested
against.

**Remediation requested (mechanical; nothing else):** add two shared executable cases
(natural home: `cd0-errata-0.1.json` `cases`, op `runtime-encode`):
1. `ast: {"t":"seq","items":[{"t":"unit"}]}`, overrides `{"max_depth": 1}` (ample output)
   → expected OK, `canonical_hex: "4c50434400300100"`.
2. Same ast, overrides `{"max_nodes": 1}` → expected OK, same hex.
Wire through both codecs' harnesses as with the existing errata cases; update counts/
receipts accordingly (37 → 39 promoted operations, hand differential 465 → 467 requests/
codec, etc. — show the arithmetic); publish as NEW successor commits on the same branches
(no history rewrite; audited tips and current successor commits remain untouched).

## On resubmission (scoped re-verification, pre-committed now)

Re-run ONLY: successor commit/tree/ancestry checks · §2 tripwire (cheap, scripted) ·
§3-A9 item (the two new rows present + executed by both codecs) · `verify_phase0.py` ·
hand differential · request-arithmetic recomposition. All other sections carry over unless
the new commits touch their surfaces (checked via `git diff --name-only` against
`851cffc2…`; any surface touched beyond `canonical-datum/vectors/`, harness wiring, and
receipts re-opens its section; any canonical-hex or equality change ESCALATES per §15.3).

## Standing laws honored in this report

Phase-0 negatives: 71 classified = 66 octet + 5 host; Python 71 executed, CL 68 executed +
3 N/A (N/A ≠ pass). Independence: independently seeded under shared normative
infrastructure (seeds `e6f3b579…` CL / `58ecca40…` Py) — never unqualified "clean-room".
The errata resolve prospectively; pre-errata tips were conforming to the law that existed.
The merge decision belongs to the owner alone; this report only grants or withholds
eligibility, and today it withholds it pending one two-row addition.

— Claude Fable 5, audit director (verification executed as the stranger walking the frozen
recipe; deviations §1.3 and §2.3 documented inline, no check weakened, one supplement
added: CL A9 hex pin + wire-level 4.8 probes)
