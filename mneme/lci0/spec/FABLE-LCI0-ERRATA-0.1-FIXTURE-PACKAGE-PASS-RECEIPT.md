# FABLE PASS RECEIPT — LCI/0 Errata 0.1 + Normative Fixture Package

**Document:** `FABLE-LCI0-ERRATA-0.1-FIXTURE-PACKAGE-PASS-RECEIPT.md`
**Date issued:** 2026-07-14 (UTC)
**Issuer:** Claude Fable 5 (independent reviewer of record for LCI/0; chair of the 2026-07-13
constitutional audit that returned NARROW-ERRATA-REQUIRED)
**Verdict:** **PASS**
**Effect (per `LCI0-POST-REVIEW-RULING.md` §10–§12):** this receipt renders implementation
authorization **effective** for independently seeded Common Lisp and Python LCI/0 implementations,
within the §12 scope only.

---

## 1. Exact identities this receipt binds to

### 1.1 The seven primary package artifacts (package root)

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `LCI0-POST-REVIEW-RULING.md` | 19,714 | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` |
| `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | 113,990 | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | 274,969 | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| `LCI0-FIXTURE-REGISTRY.json` | 158,009,634 | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `LCI0-FIXTURE-VECTORS.jsonl` | 26,665,609 | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| `LCI0-FIXTURE-PACKAGE-MANIFEST.md` | 6,384 | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` |
| `LCI0-FIXTURE-SHA256SUMS.txt` | 2,388 | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |

### 1.2 Delivery archives

| Archive | Bytes | SHA-256 |
| --- | --- | --- |
| `lci0-errata-0.1-fixture-package-2026-07-14.zip` | 4,857,158 | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| `lci0-errata-0.1-fixture-package-2026-07-14.tar.gz` | 4,840,040 | `ddc03ba184e835fdbd3c51e9a0f8d3edf4a93deb4d6b980544d82a5c47a83934` |

### 1.3 Upstream anchors (all verified in-session against the delivered bytes)

| Anchor | SHA-256 / id |
| --- | --- |
| Candidate spec `LOCATED-CLAIM-IDENTITY-SPEC.md` | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` |
| Frozen CD/0 reference packet | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |
| Consultation packet | `e2740dc037837a539e3b1b7d6e07675c139263e2b6f41ee579d85e5efcdbaaf2` |
| Frozen repository commit | `56f0ce55253ef8dd4caaf80b03e49835c4087406` (tree `e73d50772b22651df4f9620cd971baaf4de74739`) |
| Fable review artifacts embedded in package | byte-identical to the lab tree copies of commit `ffaf56fd` (3/3 hashes match) |

---

## 2. Method

Verification ran 2026-07-14 (UTC) on the lab host, under the chair (Fable 5) with eight named
verification agents, each owning specific ruling-§10 items, each returning evidence-bearing
reports (saved under `_staging/lci0-errata-verify/scratch/`): BOOKKEEPER (archive integrity),
LAPIDARY (errata constitutional review), RECKONER (registry/vector mechanical completeness),
CLOSURE-WARDEN (fixture closure), SMITH (frozen-codec differential incl. the SBCL gate),
VECTOR-MARSHAL (typed-vector execution), RELIQUARY (out-of-count document sweep), CODA
(supplementary codec leg). Total agent spend ≈ 1.62M tokens. Independent two-leg cross-checks
were built into the design: the ten E1 values were extracted twice independently (LAPIDARY from
the errata text, SMITH for recomputation) and reconciled by the chair (10/10 byte-identical);
the 1,105-document enumeration was performed independently by RECKONER and SMITH (both exactly
1,105, identical per-source breakdown); ZIP/TAR.GZ member sets were compared by the chair
first-hand.

The frozen worktree at `56f0ce55` was verified `git status`-clean before and after every
codec leg; no tracked file was modified.

---

## 3. Ruling §10 checklist — item-by-item confirmation

**Item 1 — E1–E9 and all five I12 clarifications present without reopening ClaimId or
WarrantTarget: CONFIRMED (LAPIDARY).** Each erratum discharges its mapped issue register
obligation within the ruling's adjudicated narrowing (E3 four-owner tie-break; E6 option-one
deterministic field order + depth-first recursion; E7 fourteen schemes namespaced under
`Id(["lisp-plus","lci","0","fixture"], …)`; E8 unconditional; E9 total 7→5 reconciliation with
every migration vector category restored). All five I12 clarifications present and faithful. No
ClaimId field-set or projection change, no WarrantTarget field-set change, no CD/0 touch. The
nearest-the-line item — I12(b) `inner-target-relation`/`testimony-mode` — was verified to be
content of an already-existing evidence-kind boundary (candidate §4.7/§9.14), authorized by
ruling §3.9(2), not a field-set change.

**Item 2 — every registry definition and vector input/expected output valid and complete:
CONFIRMED (RECKONER).** 675 definitions exact; 1,105 embedded CD/0 documents enumerated
(675 registry + 215 vector-inputs + 215 vector-expected); for all 1,105: lowercase valid hex,
byte count = octet length, `sha256_checksum_of_canonical_octets` recomputed exactly, decoded
abstract value present, `4c50434400` magic+version prefix. **0 failures.** Checksum algorithm
confirmed from fixture spec §13.1; `checksum_is_semantic_identity` uniformly `false`.

**Item 3 — the ten E1 values independently recomputed and byte-identical: CONFIRMED
(SMITH + LAPIDARY + chair).** Ten values (five Mneme base references + five neutral
expressions — precisely the I01 gap) extracted twice independently, reconciled 10/10, then
recomputed from abstract values through **both** frozen codecs: errata text = frozen Python =
frozen Common Lisp, byte-identical for all ten; each present in the registry with identical
octets; byte counts and review checksums match.

**Item 4 — fourteen StableRef domains closed: CONFIRMED (CLOSURE-WARDEN).** Mechanical 1:1:1
mapping (14 domain-ids ↔ 14 scheme-ids ↔ 14 scheme-definitions, exactly one scheme per domain);
every scheme carries `mutable-aliases-forbidden=true`, a version rule, and a represented-loss
rule; per-domain `E7-ALIAS-*`/`E7-SCHEME-*` witnesses; the sole bridge is explicit, total over
`['alpha-file']`, non-retroactive.

**Item 5 — grammar, placement, calculi, target schemas, policies, migration tables, budgets,
occurrence schema, loss accounts closed and executable: CONFIRMED (CLOSURE-WARDEN).**
Proposition grammar with subject-vs-locator occurrence marking and a structural
proposition/location consistency predicate (discharging I05); all four calculi; 11 closed
target schemas; Policy-A and Policy-B both `hard-reject-every-f-valued-target-result=true`;
inert zero-live-warrant migration with total 7→5 reconciliation; 13 exact budgets; occurrence
schema; 7 loss-account schemas. The implementer-choice hunt found **zero real forks**; the
human spec index and machine registry agree on all 99 item-class counts (675 = 675);
Appendix B is bijective with the 215-vector file.

**Item 6 — all P001–P030, N001–N032, and every errata/fixture vector present, unique, and
producing the exact typed result or failure: CONFIRMED (VECTOR-MARSHAL).** 215/215 vectors,
all IDs unique, 62/62 core IDs present, census reproduces fixture-spec §14 line-for-line.
Execution: 215/215 clean on full integrity + CD/0 self-consistency; typed decisions re-derived
from the closed normative tables — 79 fully re-derived (scope set-semantics 7/7, temporal
interval algebra 9/9, migration map 7/7, budgets 13+1, target-NEG first-fault 11/11, E2×4,
E5×2, E6×2, collisions, restoration refusals, E9 adversaries), 136 verified by
consistency-plus-closed-rule-existence. **0 mismatches, 0 underdetermined.** All six witness
requirements satisfied (11 target kinds POS+NEG; both policies hard-reject every F; E5's two
failures distinct and non-collapsing; E6 multi-fault first-fault precedence; complete I11/E9
adversarial migration set incl. the three legacy-fingerprint collision dimensions and
`PrivilegedRestorationAttempt`; zero live warrants anywhere). Failure namespace clean: 54 codes
in 10 disjoint LCI categories, no CD/0 category-name reuse (the shared spelling
`PrivilegedRestorationAttempt` is a CD/0 *category* but an LCI *code*, exactly as I12(c)
discloses).

**Item 7 — frozen Python CD/0 at `56f0ce55` reproduces every document: CONFIRMED (SMITH).**
Frozen Python suite green (167 tests). Differential over all 1,105 documents: 1105/1105
encode-agree, 1105/1105 decode-agree, 1105/1105 byte-count, 1105/1105 checksum, 0 mismatches.

**Item 8 — frozen Common Lisp CD/0 rerun (the authoring environment's open FABLE GATE):
CONFIRMED — GATE CLOSED (SMITH).** `sbcl --noinform --disable-debugger --script
canonical-datum/common-lisp/run-tests.lisp` at the frozen commit: exit 0, 2,633 assertions,
0 failures (SBCL 2.4.6). Fixture-corpus adapter fed the frozen system **unmodified** via a
CL-`read`-able s-expression corpus (no hand-written JSON parser on the CL side): 1105/1105
encode-agree, 1105/1105 decode-agree, 0 errors.

**Item 9 — ZIP and TAR.GZ member sets identical, all members satisfy the checksum file:
CONFIRMED (chair, first-hand; BOOKKEEPER for the checksum legs).** 22 members in each archive,
member sets identical, full extraction `diff -r` byte-identical across all 22 files;
`sha256sum --check` 20/20 OK plus independent per-file recomputation 22/22; manifest and
checksum-file coverage rules hold exactly. (The TAR.GZ was delivered by the owner
mid-verification after the chair flagged its absence; both archive hashes are bound in §1.2.)

**Item 10 — no placeholder semantics, local semantic choice, silent version fallback,
production-crypto selection, or live-authority invention: CONFIRMED (LAPIDARY +
CLOSURE-WARDEN).** Keyword-and-read hunts over the errata and the fixture spec found zero real
violations: every hit is a prohibition, a bounded permission, a deferral marker, or a pinned
canonical value. All StableRef material is `FixtureStableMaterial/0` explicit records; all 675
registry checksums are marked non-semantic; unsupported nested versions fail closed recursively;
migration creates zero live warrants.

---

## 4. Verification beyond the ruling's literal scope (supplementary; all clean)

The full-package sweep found that the registry and vectors contain **1,593** embedded CD/0
documents, not only the 1,105 the manifest counts (spec §13.2's count is accurate for its
declared scope; the remainder had simply never been machine-verified by anyone):

- **458 relation-table documents** (`scope_relation_table_0` 169 + `temporal_relation_table_0`
  289): verified structurally (RELIQUARY: hex/byte-count/checksum/magic/decoded-value, 0
  failures; referential integrity to `definitions[]` — 0 dangling) **and** codec-verified
  (CODA, frozen Python: 458/458 encode-agree, 458/458 decode-agree, 0 mismatches; 0 overlap
  with the official 1,105's canonical bytes).
- **30 nested bytes-material documents** inside the ten `LCI0-E1-*` vectors (3 occurrences
  each): verified structurally (RELIQUARY, 0 failures; byte-identical across each triple), and
  identified by the chair as **exactly the ten E1 pinned values** (10/10 SHA-256 match) — i.e.
  the same octets already three-way codec-verified under item 3.
- Dual-method sweep (key-name scan and magic-prefix value scan) converged exactly (460 = 460 in
  the registry; 430 official in vectors), so no magic-prefixed document exists anywhere in the
  package outside the sets above.

---

## 5. Disclosed notes and compressions (none blocking)

1. **Adapter schema note (SMITH).** The package's `abstract_cd0` JSON uses a human-readable
   schema (plain-string identifiers, `rat` `num`/`den`, redundant `string.text`) that differs
   from the schema the frozen `from_fixture_ast`/`datum-from-fixture-ast` consume
   (`namespace_utf8_hex`/`utf8_hex`, `rat` `p`/`q`). The verification adapter is a pure, total,
   semantic-choice-free translation (plain→UTF-8-hex; key renames; the redundant `text` checked
   for consistency — 0 inconsistencies — then dropped), proven exhaustive by an empirical schema
   scan of all 1,105 documents. Implementers consuming the package JSON directly should be aware
   the two encodings coexist; the canonical octets, not either JSON schema, are authoritative.
2. **Vector-execution evidence tiers (VECTOR-MARSHAL; stated per the lab's show-the-compressed-
   step rule).** 79/215 typed decisions were independently re-derived end-to-end from the closed
   tables; the remaining 136 were verified by full octet/consistency checking plus confirmation
   that the governing closed rule exists and is cited — their *success payload projections*
   (abstract value → full ClaimId envelope content) were not re-derived byte-by-byte, because
   doing so requires exactly the LCI implementation stack whose construction this receipt
   authorizes. The two independently seeded implementations' differential tests are the designed
   discharge of that residue. 0 mismatches, 0 underdetermined either way.
3. **Documentation note (VECTOR-MARSHAL).** `LCI0-TEMPORAL-DISJOINT` and
   `LCI0-TEMPORAL-OVERLAP` deterministically emit the precise sub-relations `before`/`contains`
   (independently reproduced by re-derivation); the fixture spec's §3 *prose* witness-table
   labels those two rows with the coarser words `disjoint`/`overlap`. The vectors and normative
   tables are correct and fully derivable; only the illustrative prose label is looser. Worth a
   one-word prose touch-up in any future fixture-spec revision; no obligation is created.
4. **TAR.GZ delivery timing.** The TAR.GZ twin was not in the initial delivery; the chair
   flagged it and the owner supplied it mid-verification. Both archives are hash-bound in §1.2
   and verified byte-equivalent in content.
5. **Environment note.** The authoring pass recorded CPython 3.13.5; this verification ran the
   frozen Python implementation under the lab's CPython (3.11/3.13-compatible frozen source,
   suite green) and SBCL 2.4.6. No behavior difference was observed anywhere bytes were
   compared.

---

## 6. Receipt

```yaml
receipt: FABLE-LCI0-errata-0.1-fixture-package-verification
issued: 2026-07-14
issuer: Claude Fable 5 (independent reviewer of record, LCI/0)
verdict: PASS
binds_to:
  ruling_sha256: c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7
  errata_sha256: f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea
  fixture_spec_sha256: ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f
  registry_sha256: dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327
  vectors_sha256: 387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4
  manifest_sha256: 1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7
  sha256sums_sha256: d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050
  zip_sha256: 36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d
  targz_sha256: ddc03ba184e835fdbd3c51e9a0f8d3edf4a93deb4d6b980544d82a5c47a83934
  candidate_sha256: 6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba
  frozen_cd0_packet_sha256: bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81
  consultation_packet_sha256: e2740dc037837a539e3b1b7d6e07675c139263e2b6f41ee579d85e5efcdbaaf2
  repository_commit: 56f0ce55253ef8dd4caaf80b03e49835c4087406
ruling_s10_items:
  item_1_errata_present_no_reopening: CONFIRMED
  item_2_registry_vector_completeness: CONFIRMED   # 1105/1105, 0 failures
  item_3_ten_e1_values_recomputed: CONFIRMED       # 10/10 three-way byte-identical
  item_4_fourteen_stableref_domains: CONFIRMED
  item_5_closure_and_executability: CONFIRMED      # zero implementer forks
  item_6_vectors_execute_exactly: CONFIRMED        # 215/215, 0 mismatch, 0 underdetermined
  item_7_frozen_python_reproduces: CONFIRMED       # 1105/1105 encode+decode
  item_8_frozen_common_lisp_rerun: CONFIRMED       # SBCL gate closed; 1105/1105
  item_9_zip_targz_member_agreement: CONFIRMED
  item_10_no_placeholder_no_fallback: CONFIRMED
supplementary:
  extra_embedded_docs_verified: 488                # 458 relation-table + 30 nested E1
  total_embedded_docs_verified: 1593
blockers: none
implementation_status: AUTHORIZED (ruling §12 scope only)
```

---

## 7. Authorization statement

Per `LCI0-POST-REVIEW-RULING.md` §10 and §12, this PASS receipt — tied to the exact hashes in
§1 — **releases implementation authorization** for:

- independently seeded **Common Lisp** and **Python** LCI/0 implementations against this exact
  frozen fixture package;
- shared **differential ClaimId projection and target-matching tests**;
- **inert v1 migration fixtures**.

It does **not** authorize production warrant, standing, revocation, cryptography,
module/capability authority, live-migration work, or any modification to CD/0. The seeding and
phrasing laws of the CD/0 arc travel unchanged: the implementations are *independently seeded
under shared normative infrastructure* (never "clean-room" unqualified), and anything cited to
the implementer must travel in the relay message or land in its workspace.

Evidence of record: `_staging/lci0-errata-verify/` (chair notes, eight lane reports, scripts,
logs, machine summaries, `doc-index.csv` 1,105 rows, `extra-doc-index.csv` 488 rows,
`results.csv` 215 rows, `e1-values.json`/`e1-recompute.json`). A portable deliverables archive
accompanies this receipt to the author and implementer.

— **Claude Fable 5**, 2026-07-14
