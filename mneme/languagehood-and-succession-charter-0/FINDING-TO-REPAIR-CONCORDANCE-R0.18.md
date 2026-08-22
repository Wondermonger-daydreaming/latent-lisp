# FINDING-TO-REPAIR CONCORDANCE — R0.18 (the profile)

**CANDIDATE R0.18 — 2026-08-12.** Mapping from the owner's
restricted-input-profile commission (filed verbatim:
`OWNER-COMMISSION-CHARTER-0-R0.18-2026-08-12-FILED.md`) to its
implementation. This is the TERMINAL checker repair of the R0.5–R0.18 arc:
the open-ended rendering model is not extended but REPLACED. R0 through
R0.17 preserved byte- and mode-identical (eighteen strata green at seal).
The census and everything constitutional carried closed. **Nothing adopted;
evidence zero. The owner docket is, per the same commission, now presented
for disposition.**

## The commission → the implementation

| Commissioned element | Implementation in `validate_status_grammar_v17.py` |
|---|---|
| "UTF-8 in a declared normalization form" | **P1**: the source must equal its own Unicode NFC normalization; refusal otherwise |
| "no Unicode format characters (Cf) or bidi controls" | **P2**: no Cf anywhere (all bidi controls are Cf), no Co, no Cc except newline and tab — source-level, document-wide |
| "no character entities inside reserved words such as Status" | **P3, strengthened to the whole document**: no character references anywhere, including code (`&#...;`, `&#x...;`, `&name;`; a bare `&` stays legal) — strictly stronger than the commissioned minimum, and simpler to audit |
| "no raw HTML" | **P4**: any `html_block` or `html_inline` token refuses — no visibility hearing, no tag taxonomy, no projection |
| "only a specified subset of Markdown constructs" | **P5**: an explicit token allowlist — paragraphs, headings, blockquotes, lists, GFM tables, code fences/blocks, thematic breaks; inline text, escapes, code spans, strong, emphasis, strikethrough, links, breaks (images removed post-adversarially, B6). Everything else refused by name |
| "mechanically canonical tables and Status declarations; immediate refusal of anything outside that subset" | The campaign-inherited semantics retained WITHIN the language: recursive strong inventory, whole-surface order-invariant exact-one, symmetric `**`/`__` ambiguity on the visible stream, header/descendant rules, status-cell and non-status-cell policies, code screens, sub-annotation/em-dash/bare-REFUSED screens. Any construct the walk cannot represent refuses unconditionally — the risk-gated fallback is deleted; refusal needs no risk assessment in a closed language |
| "The goblin is denied admission at the gate instead of receiving a forty-page visibility hearing" | DELETED from v16: the raw-HTML visibility projection, the inline element stacks, the exact-tag-identity machinery, the Cf-comparison policy, `html_inline_role`, `project_html_block` — those inputs are no longer interpreted at all; they are not in the language. v17 is smaller than v16 |

## Controls: restructured, every change named

**All 72 inherited negatives remain violations** — 25 of them (the raw-HTML,
entity, and Cf witnesses of R12–R16) are now caught at the profile gate
instead of by rendering semantics; each carries a `[now: profile Px]` tag in
its self-test label. Same verdict, cheaper trial.

**11 former positives are RECLASSIFIED as negatives** — they were
companions of the rendering model, demonstrating that out-of-language
constructs could be *interpreted* safely; under the profile they are
correctly *refused*. Each is listed in the self-test under
`RECLASSIFIED (was positive)` with its former identity: entity-bearing
valid carrier · comment in unrelated header · unrelated raw HTML beside
carrier · raw-HTML inline attribute · HTML-block attribute · matched raw
strong carrier · nested raw annotation · matched raw strong header ·
nested raw header annotation · script-confined Status text · br-separated
`Sta<br>tus`.

**New controls:** five profile-gate teeth (P1 non-NFC · P2 control
character · P2 format character far from Status · P3 entity in plain
prose · P4 raw HTML far from Status — each law demonstrated able to fire),
and two in-profile nested-strong negatives (mixed-delimiter
`**NOTE __Status: MYSTERY__**` prose carrier; nested descendant Status
header) preserving the R15/R16 category with in-language witnesses. Two
in-profile positives replace the reclassified annotation companions
(`**see __note__**` beside a valid carrier; nested non-Status header
annotation with no phantom column).

**Adversarial pass (owner's standing ask honored) — THE GATE BROKE, AND
WAS REPAIRED BEFORE SEAL.** An independent same-root Opus red-team agent
(PORTCULLIS) was commissioned to break v17 before sealing. Its report is
filed in-lane verbatim as `PORTCULLIS-REDTEAM-R0.18.md` (543 lines, every
finding backed by a recorded run). Headline: with three injections
appended to the REAL governed charter, the canonical invocation returned
CLEAN under both parsers while rendering reader-visible violations.
Adjudication of all findings, each named:

- **REPAIRED before seal** — B1 confusable carrier (`Ѕtatus` with
  U+0405): fixed by **P2b, the declared letter repertoire** — non-ASCII
  letters refuse unless in the declared set {α, β, δ} (exactly what the
  governed corpus uses; a closed alphabet, no confusable folding). B3
  prefix-anchored header evasion: a header ENDING with the word Status
  without starting with it now refuses as ambiguous ("Current Status"
  cannot silently decommission a column); prefix classification — the
  charter's own convention — is unchanged, and the claim ceiling's
  mid-phrase "…per status…" header stays legal (verified). B4 asymmetric
  tripwire: the ambiguity pattern now tolerates mixed delimiter runs
  (`**_status` trips like `_**status`). B8 the `\r` ban could never fire
  through file input (universal-newline translation) — run() now reads
  `newline=''` and a CRLF control proves the law live. B9 dash-leading
  filenames were silently dropped — now an explicit error. C1 `--expect`
  died on colon-bearing paths — now rsplit. F1 the raw CHARREF scan
  refused backslash-escaped `\&sect;`, which renders as literal text —
  the scan now respects escaping by backslash parity. B6 image alt-text
  asymmetry — the image construct is REMOVED from the allowlist (the
  corpus has none; the language shrinks).
- **ADJUDICATED NOT DEFECTS, with corpus evidence** — B2/B5 (free
  strong legend labels on carrier-less surfaces and in non-Status
  cells): LEGAL BY THE CHARTER'S OWN DESIGN — the charter writes
  free-standing `**REFUSED CLAIM under current evidence**` in prose and
  the evidence ledger writes `**ADOPTED LAW**` in non-Status cells; a
  document-wide ban was tested against the corpus and would refuse the
  constitution itself. Exact-one is a per-declaration/per-cell law.
  **Recorded for the owner docket as a spec-scope question, not
  repaired.** B7 (the two declared parsers disagree on verdicts for ~20
  of 33 tested flanking characters): a CLEAN certificate is relative to
  the parse model NAMED IN THE CLEAN LINE — documented property; both
  versions are run on every canonical certification. B10 (link titles
  and reference definitions invisible): consistent with the destination
  policy — invisible metadata never counts. F2-F6, C2-C4: false
  refusals that are the profile working as commissioned, and cosmetic
  robustness notes — held as documented behavior.
- **Replay after repair:** the headline attack now yields NOT CLEAN —
  the homoglyph refuses at P2b, the renamed column refuses as an
  ambiguous header; the list-item legend passes as adjudicated-legal.

Same-root by construction — a design-level check, not an independent
audit; the fresh-weights outside remains Sol.

**Totals (actual, post-repair): SELF-TEST PASS — 94 negatives caught /
31 positives clean**, executed under BOTH declared parser versions (4.0.0
and 3.0.0), identical totals. (Arithmetic: 72 inherited + 11 reclassified
+ 5 gate teeth + 2 in-profile nested + 4 PORTCULLIS-repair witnesses =
94; 38 − 11 reclassified + 2 in-profile replacements + 2 PORTCULLIS
companions = 31.)

**Canonical five-file run: CLEAN, exit 0, coverage byte-for-byte
unchanged** (10/6 · 0/16 · 4/0 · 0/0 · 0/0) under both declared versions —
and the five governed files were verified ALREADY INSIDE the proposed
language before the profile was frozen (no NFC drift, no forbidden
characters, no entities, no raw HTML): the profile constrains future
drafting; it required no change to the constitution.

**Census:** `OCCURRENCE-ADJUDICATION-R0.18.md` — R0.1–R0.17 scope;
independent enumeration actually obtained: **138 rows · 112
HISTORICAL/PROVENANCE · 26 FROZEN-ARTIFACT NAME · 0 LIVE**. One fewer than
R0.17, wholly explained by the charter head's commission-language change
(six R0.16 tokens out, five R0.17 tokens in), verified by line-independent
multiset comparison; the generator reproduced the closed R0.17 table
byte-exact before being trusted; no classification reopened.

**Dates:** current-revision metadata coherent at the actual seal date
(2026-08-12, verified UTC); frozen historical dates untouched.

## Not reopened

The constitutional text and languagehood holdings · SOL-R04-01 and every
adopted jurisdiction/authority boundary · W-02…W-14 · gate architecture,
triaged owner forks, and campaign designs · substantive evidence
adjudication · every occurrence classification through R0.17 · all
eighteen frozen strata. The Sol R0.16 readback's §8 next-movement
expectation (a fresh full-archive readback before docket) is superseded by
the owner's filed disposition, which this stratum implements.

*— Concordance R0.18, the chair (Claude Fable 5), 2026-08-12. Candidate;
adopts nothing; the docket is presented by the owner's own commission.*
