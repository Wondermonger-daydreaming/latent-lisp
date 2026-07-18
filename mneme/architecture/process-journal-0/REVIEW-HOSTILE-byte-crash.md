# REVIEW-HOSTILE-byte-crash — Process Journal /0

**Seat:** MALLET, the separately-charged hostile implementation reviewer (byte arithmetic, digest preimages, crash consistency, the vector tool). Not the semantic reviewer; no deference to Sol.
**Subject:** `experiments/latent-lisp/mneme/architecture/process-journal-0/`
**Method:** every claim below was run, not read. Scratch + reproducing artifacts under `/tmp/mallet/`.

---

## Verdict

**SURVIVED at the byte level** (attacks 1–4, 0 wrong-byte defects) — **DEFECTS-FOUND at the methodological level (2):** the vector tool is a verbatim copy of the generator (shared brain), and the spec never mandates binary / no-newline-translation I/O. Neither is a wrong byte immortalized in a fixture; both are blind spots in what the packet *can* catch.

| Attack family | Result |
|---|---|
| 1. Byte arithmetic / truncation count | **SURVIVED** (0) |
| 2. Digest preimage / concat collision | **SURVIVED** (0) |
| 3. Validator vs. authored mutants | **SURVIVED** (0 structural slips; 1 documented semantic-boundary non-catch) |
| 4. Crash consistency (SIGKILL) | **SURVIVED** (0 anomalies / 56 trials) |
| 5. Tool self-trust (shared brain) | **DEFECT — 1 structural** (worst finding) |
| 6. Cross-platform honesty | **DEFECT — 1 spec gap** (fails-closed, but unstated) |

---

## Attack 1 — Byte arithmetic (truncation count)

Golden journal `fixtures/positive/synced-demo/EVENTS.pj0` = **7919 bytes**, 7 frames. Final frame starts at **S = 6684**, length **N = 1235** (6684 + 1235 = 7919, verified). Truncation family ships **1235 files**, names `truncate-final-0000 … truncate-final-1234`, offsets contiguous `0..1234` (verified), and `SHA256SUMS.txt` carries exactly 1235 `truncate-final-` entries.

- Proper prefixes of an N-byte frame have lengths `0 … N-1` = **N = 1235** prefixes. Offset **0** = the empty prefix of the final frame = the prior valid journal (verified `valid`, 6 records, 6684 valid bytes). Offsets **1..1234** = torn-tail (spot-checked 1, 617, 1234 → all `torn-tail`, 6 valid records). The full length N=1235 is **excluded** (it is `positive-synced-demo`, the separate untruncated control).
- **The claim "1,235 = every proper byte offset" is exactly right.** No off-by-one: offset 0 is included and documented as valid-end; full-length is correctly excluded. PJ-TRN-3 holds — first 6684 bytes byte-identical across sampled family members (verified).
- **Framing arithmetic (§7.2) is unambiguous:** `PAYLOAD-LENGTH` counts payload octets only; the frame-separator LF is *not* counted and *not* in the payload digest. Reader consumes exactly `plen` octets then requires one LF. No ambiguity about where the LF belongs.

## Attack 2 — Digest preimage / concatenation collision

Frame-digest preimage (§8.3):
`"PJ0-FRAME-0" ‖ NUL ‖ STORE-ID ‖ NUL ‖ ORDINAL ‖ NUL ‖ PAYLOAD-LENGTH ‖ NUL ‖ RAW(payload_sha)[32] ‖ RAW(prev_sha)[32]`

The classic unkeyed-concat attack needs two adjacent **variable** fields with a movable boundary. Here every variable field (`STORE-ID` = `pj0-store:` + 64 lowercase hex; `ORDINAL`, `PAYLOAD-LENGTH` = decimal ASCII) is **NUL-delimited**, and NUL is **excluded from all three alphabets** (the reader validates `ord_s.isdigit()` / `len_s.isdigit()`; store-id is a fixed-format hash string). The trailing two fields are **fixed 32 bytes each**, so the tail parses as exactly 32‖32. **No colliding field-tuple is constructible** — this is delimiter-safe-by-alphabet-exclusion, functionally as strong as length-prefixing. I attempted no collision because the structure forbids one; the single latent fragility (if any field's alphabet ever admitted NUL) does not exist today. **Blocked.**

Independent recomputation (no tool import): genesis `sha256("PJ0-GENESIS-0")` matches; store-id recomputed from a textually-stripped basis matches `12b099a4…`; **all 7 payload digests and all 7 frame digests reproduce from public fields.** F-02/F-03/F-04 satisfied.

## Attack 3 — Validator vs. authored mutants

Baseline first: all 3 positives → `valid`; all 16 adversarial fixtures → `corruption` with the registry-expected error. Then **12 new mutants** the shipped 6 planted-mutants do not cover (files + sha256 under `/tmp/mallet/mutants/`):

| Mutant | Result | Caught |
|---|---|---|
| m01 dup final frame verbatim | corruption (ordinal-gap) | ✅ |
| m02 reordered events, chain fixed up | **valid** | ⚠ semantic boundary |
| m03 ordinal gap w/ valid chain | corruption (ordinal-gap) | ✅ |
| m04 valid-UTF8 noncanonical datum (`007`) | corruption (payload-canonicality) | ✅ |
| m05 trailing whitespace in header | corruption (header-field-count) | ✅ |
| m06 uppercase PREV digest field | corruption (digest-syntax) | ✅ |
| m07 empty journal file | valid-end | ✅ (correct per E-01) |
| m08 META/journal store mismatch | corruption (frame-hash) | ✅ |
| m09 leading space in header | corruption (header-field-count) | ✅ |
| m10 raw NUL in string payload | corruption (raw control in string) | ✅ |
| m11 CRLF header (`\r\n`) | corruption (digest-syntax) | ✅ |
| m12 payload-length longer than actual | corruption (bad-frame-separator) | ✅ |

**Tally: 12 authored / 10 corruption-caught / 1 correct valid-end (empty) / 1 structural pass (m02). Structural slip-throughs: 0.**

**m02 is not a structural slip — it is a scope boundary worth flagging.** The shipped CLI implements only structural steps 1–15 of §12; **step 16 (Kernel semantic fold) is absent from the executable — there is no `--semantic` flag**, despite §22's `(validate-journal … &key semantic)`. Consequence: a semantically-invalid-but-structurally-valid journal (events reordered, chain re-hashed) validates. The spec *is* honest that ordering is Kernel jurisdiction (§12.16, §17.2, PJ-VAL-3), and the semantic `.sexp` fixtures ship as bare data checked only for `valid-datum` — but the packet advertises a 16-step reader and ships 15. A faithful implementer who wires "the validator" as the conformance gate inherits a reader that **cannot** reject a reordered fold.

## Attack 4 — Crash consistency (SIGKILL)

Reproduced the harness, then ran **56 trials across 7 seeds** (296, 1, 7, 42, 101, 2026, 17), prefix = first 6 frames, candidate = final frame, killed at seeded byte offsets.

**Classification tally: `{torn-tail: 54, valid: 2}`. Zero runs classified as corruption. Zero anomalies** (every result inside the crash-window admissible set: 0 bytes or full frame → valid; any proper partial → torn-tail). The seeded classification is honest; nothing was flattered into success or damned as corruption.

## Attack 5 — Tool self-trust (THE WORST FINDING)

`build_tools()` (line 1933) constructs the shipped `tools/pj0_vector_tool.py` as `Path(__file__).read_text().rsplit(marker)[0] + <cli>` — i.e. **the "validator" is a verbatim copy of the generator's own source.** `validate_bytes`, `render`, `esc_string`, `frame_digest`, `parse_canonical` are the *same functions* that wrote every fixture. **Every green checkmark in this packet proves internal self-consistency, not conformance to the spec's prose.** A defect in `render()` or the digest preimage would be invisible: generator and validator would agree on the wrong bytes, and the mutation scorecard would still read 6/6. This is exactly Sol's own named "two executables wearing one brain" anti-pattern, and no independent implementation ships (only two Python tools; no Common Lisp verifier). The spec self-discloses this (§33: "One implementation invoking the other is not independent verification") and defers the real check to a future CL+Python phase — **but until that phase exists, the packet's self-certification is structurally incapable of catching a byte-level spec error.** An independent implementation would need: a from-scratch PJ-S/0 codec, an independent `frame_digest` preimage assembler, and agreement on decoded datum / canonical bytes / digests / prefix boundary / classification for every fixture — the §33 list. That is the load-bearing work the green transcript does **not** discharge.

## Attack 6 — Cross-platform honesty (SPEC GAP, fails-closed)

Byte-exact framing plus the tool's explicit `encoding='utf-8'` + binary reads make CRLF, case-insensitive, and non-UTF-8-locale hazards **fail closed** — m11 (CRLF header) → corruption, m10 (raw NUL) → corruption, all I/O locale-independent. **But the spec never normatively mandates binary / no-newline-translation I/O.** A faithful implementer who opens `EVENTS.pj0` in Windows/WSL text mode would have `\n`↔`\r\n` translation silently shift every byte offset; the journal would then fail *its own* validation (safe) — but the spec should **scope this out explicitly** (a `MUST open primary files in binary with no newline translation` clause) rather than leave it to luck that the digest chain catches it. §10.4 handles durability honesty on WSL; it does not handle byte-transport honesty.

---

## Reproduction

- Baseline + truncation arithmetic: rerun the battery in this review against the fixtures (all commands are self-contained).
- Mutants: `/tmp/mallet/mutants/m01…m12` (sha256 recorded inline above); validate with `python3 tools/pj0_vector_tool.py /tmp/mallet/META.pjs <mutant>` (m08 uses `/tmp/mallet/METAB.pjs`).
- Crash: `/tmp/mallet/kill9-<seed>/REPORT.json` for all 7 seeds; prefix `/tmp/mallet/prefix.pj0`, frame `/tmp/mallet/final.frame`.

— MALLET (Claude Opus 4.8, 1M context), the separately-charged seat
