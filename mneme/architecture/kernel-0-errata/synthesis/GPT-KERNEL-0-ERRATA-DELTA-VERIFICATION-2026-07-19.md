# GPT-KERNEL-0-ERRATA DELTA VERIFICATION — 2026-07-19

**Status:** chair verification record; not an adoption act and not governing  
**Verifier:** GPT-5.6 Thinking  
**Purpose:** verify Fable's M-1..M-3 and N-1..N-3 delta against the frozen GPT synthesis,
then emit the exact folded normative body for the 0.2 issuance step.

## 1. Custody and hash verification

- Seal-round relay ZIP:
  `FABLE-KERNEL-0-ERRATA-SEAL-ROUND-RELAY-2026-07-19.zip`
- Owner-supplied expected SHA-256:
  `35a560358af911e78f97e9d73fe0c18bc9825ceafe25f2a9bde5d3fa938fe68e`
- Computed SHA-256:
  `35a560358af911e78f97e9d73fe0c18bc9825ceafe25f2a9bde5d3fa938fe68e`
- Result: **PASS**

The ZIP contained five files. Its `SEAL-ROUND-SUMS.txt` listed four payload artifacts.
All four listed payloads were recomputed and matched exactly:

- `FABLE-KERNEL-0-ERRATA-RECONCILIATION.md` — `678eb02b0492af25eba58db00a28218bd0b5186cfb999f6fb72acb9bbc1ad3ba` — 14973 bytes — **PASS**
- `KERNEL-0-ERRATA-CONCORDANCE-F-vs-G.md` — `0ed96b870a698a5981169e80819499f24356d5efc7c283ef55dbc357c37af0db` — 15371 bytes — **PASS**
- `FABLE-DELTA-TO-GPT-SYNTHESIS.md` — `ef9bef24b6e19e98093141bde67e5c5c2ccf40cd70ec00c5945ff08a4d503188` — 6869 bytes — **PASS**
- `KERNEL-0-ERRATA-FORK-DISPOSITION-RECORD-2026-07-19.md` — `516558211e1d57a84c375f6c1a480c0818ca524b16ff02421db8526a769e1715` — 2152 bytes — **PASS**

The checksum ledger itself has SHA-256
`a2767d5fc3e1f3fa0ebadfb316c8d79d98fc2b79eafe4d0800e40bacc21f3542` and is not self-listed, as expected.

## 2. Frozen base verification

- Frozen base:
  `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-SYNTHESIS-CANDIDATE.md`
- Expected SHA-256:
  `85b17863402264874bd456c6430b3cb0cde7d4c9b9a74f36cb4660839e751627`
- Computed SHA-256:
  `85b17863402264874bd456c6430b3cb0cde7d4c9b9a74f36cb4660839e751627`
- Result: **PASS**

## 3. Mechanical delta verification

Each OLD block or insertion anchor named by
`FABLE-DELTA-TO-GPT-SYNTHESIS.md` occurred **exactly once** in the frozen base.

| Edit | Unique target | Applied | Post-application marker |
|---|---:|---:|---:|
| M-1 — K0E-5a §23 stay | 1 | PASS | 1 |
| M-2 — explicit §7.4 replacement | 1 | PASS | 1 |
| M-3 — widen K0E-7 to row class | 1 | PASS | 1 |
| N-1 — authorizing basis grants nothing | 1 | PASS | 1 |
| N-2 — inspection traversal | 1 | PASS | 1 |
| N-3 — append receipts by reference | 1 | PASS | 1 |

The emitted unified patch contains only those six logical edits. No other normative body
text was changed.

## 4. Substantive chair verdict

**ACCEPT.** M-1, M-2, and M-3 repair genuine internal consequences of the unanimously
recommended fork dispositions:

- M-1 prevents §23 from retaining an impossible MUST for the stayed call-296 row;
- M-2 makes the revised three-way determinacy boundary explicit rather than silently
  changing §7.4 through implication;
- M-3 correctly records that the missing manifestation alternative is a row-class
  vocabulary problem, not merely a call-296 anomaly.

N-1..N-3 are compatible boundary clarifications:

- a visibility record's authorizing reference grants no authority;
- reference-based stream lineage remains lawful only when the standard inspection surface
  can traverse it;
- PJ0 receipts enter the Kernel evidence bundle by identity rather than duplicated bytes.

No repair reopens the seven owner-disposed forks. No change crosses into Canonical Datum
octets, PJ-S/0 framing, AP0 vector bytes, provider semantics, Language-A factual standing,
or capability minting law.

## 5. Folded result

- Artifact:
  `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-SYNTHESIS-PLUS-FABLE-DELTA.md`
- SHA-256:
  `ce5d739a47b91d86e357dfb2002df19c3dcffa3083a4170c002d4a93e129a760`
- Bytes:
  24184
- Lines:
  652

This artifact is the frozen GPT synthesis with exactly the verified Fable delta folded
into its normative body. It is **not yet the governing 0.2 erratum**. The remaining
issuance act may change document identity/status metadata and must bind this body hash,
both blind-parent hashes, both synthesis records, the fork-disposition record, and the
final owner seal.

## 6. Patch identity

- Patch:
  `GPT-KERNEL-0-ERRATA-FABLE-DELTA-VERIFIED.patch`
- SHA-256:
  `181d655d916d06e82cd45456b8a4e1d51b9c37cc98ff4236ada83906825a0433`

## 7. Chair disposition

```text
FABLE M/N DELTA: VERIFIED
FOLDED BODY: READY FOR 0.2 ISSUANCE
OWNER FORK DOCKET: DISPOSED
ERRATUM GOVERNING STATUS: NOT YET — FINAL OWNER SEAL REQUIRED
```
