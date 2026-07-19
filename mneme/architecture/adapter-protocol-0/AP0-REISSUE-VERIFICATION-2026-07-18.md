# AP0 reissue — chair verification against the exact bytes

**Chair:** Fable 5, 2026-07-18 ~22:10–22:45 -03 (the reissue's own name carries Sol's UTC
stamp, 2026-07-19 — accurate on its clock; both refer to the same delivery).
**Target:** `LISP-PLUS-ADAPTER-PROTOCOL-0-REISSUE-2026-07-19.zip`, SHA-256
`7200a5e5cc88dc498a5687a6f8dff12066ea9a349aca89001b695efacecbd86d`.
**Governing record:** `AP0-ADJUDICATION-2026-07-18.md` (16/16 confirmed at `2961124b`).
**Unpacked at:** `lisp-plus-adapter-protocol-0-reissue/`. Verification artifacts:
`reissue-verification/` (harness + frozen output).

---

## 1. Custody (shown)

- Zip **triple-match**: sidecar ≡ computed ≡ declared `7200a5e5…`.
- 138 files; internal `SHA256SUMS.txt` **137/137 OK, run twice** (the 138th file is the
  manifest itself), and 137/137 **a third time after adoption into the lab tree**.
- Spec hash exact: `156ed443…7185d13`.
- Method scar, mine, disclosed: I ran `generate_ap0_vectors.py` in the first suite sweep
  before realizing it writes fixtures — a custody risk of my own making. The immediate
  re-check showed 137/137 still OK, i.e. the generator reproduced the delivered bytes
  identically (itself a determinism datum, but the order of operations was wrong; the check
  should have preceded the run).

## 2. The five suites, re-executed by the chair's hand

All five summary lines reproduce Sol's report exactly:

```text
AP0 VECTOR VALIDATION:        81/81 PASS
AP0/KERNEL JOINT ALGEBRA:     12/12 PASS
AP0 EXECUTED MUTATION SCORE:  20/20 KILLED
FAKE ADAPTER SCRIPT REPLAY:   10/10 PASS
AP0 ADJUDICATED REGRESSIONS:  10/10 PASS
```

With the mechanisms read, not just the lines:

- **Mutation kills are now executed, not inferred** (the adjudicated N2 repair):
  `check_case(d, c, {disabled-rule})` runs each target twice — normal must reject with the
  rule among errors, disabled must flip to **accept**. Both asserted per mutant, 20 mutants.
- **Fake-adapter replay earns its words** (R3 repair): computed vs declared terminal compared
  per script (mismatch fails), two passes with digest equality asserted
  (`replay-digest-mismatch` on failure). SCRIPT-PRESENT-class divergence can no longer hide.
- **A joint AP0/Kernel algebra runner now exists** (F5/§24.3): enforces the closed
  seven-status set, the `:absent-after-completion`-pairs-with-`:absent` rule, and
  no-payload-state only on absent status.

## 3. Hostile regression — the ORIGINAL filed attack bytes vs the reissued validator

Run by the chair with the verbatim records from the filed hostile pass (harness and output
frozen in `reissue-verification/`). **All ten now REJECT, each on a semantically-correct
named condition:**

| Filed record | Original verdict | Reissue verdict | Named condition |
|---|---|---|---|
| A1 ATK-REC-LAUNDER | ACCEPTED | **REJECT** | `reconciliation-witness-missing` (+identity) |
| A2 ATK-RID-COUNTER | ACCEPTED | **REJECT** | `provider-id-invented` |
| A3 ATK-CAN-RELABEL | ACCEPTED | **REJECT** | `cancellation-witness-missing` |
| A4 ATK-STR-DBJ | ACCEPTED | **REJECT** | `stream-persistence-invalid` |
| A5 ATK-ABS-STATE-AS-STATUS | ACCEPTED | **REJECT** | `absence-table-miss`, `projection-origin-invalid` |
| BAD-CAN-01-RELABELLED | ACCEPTED | **REJECT** | `cancellation-witness-missing` |
| UNDERTOW A (metadata-only) | ACCEPTED | **REJECT** | `absence-mapping-mismatch` |
| UNDERTOW B (unmapped shape) | ACCEPTED | **REJECT** | `absence-table-miss` (membership-keyed) |
| UNDERTOW C (capture omitted) | ACCEPTED | **REJECT** | `projection-before-capture` |
| UNDERTOW D (sentinel control) | REJECTED | **REJECT** | still rejects — control intact |

The BLOCKER's defining demonstration — the relabel that flipped BAD-CAN-01 from REJECT to
ACCEPT — now dies on the L15 witness gate. That is the wire connected, not the label renamed.

## 4. Adjudicated repairs traced in the text (spot-checks shown)

- **F1 (BLOCKER):** conditions `adapter-truth-minting`/`adapter-witness-boundary-missing`
  went from **2 roster-only occurrences to 10**, now inside MUST-laws: **AP-ACK-3** (no
  emission outside the descriptor's witnessable set), **AP-CAN-6** (`:provider-settled`
  requires boundary-captured settlement record + witnessing procedure + evidence identity +
  validation standing), rewritten **AP-REC-1** (completeness claim requires L15 observational
  standing; self-asserted `domain-complete` MUST signal and MUST NOT settle). Sol's
  conjunction, made law.
- **F2:** AP-ID-3 restated as a provider-testimony **allowlist**, explicitly naming counter,
  UUID, and route value among forbidden surrogates — the traced gap, closed by name.
- **F3:** AP-ID-4 hard-gates: identity unavailable ⇒ `:not-found` caps at `:ambiguous`.
- **F4:** persistence order mechanical (`stream-persistence-invalid` fired on the filed A4).
- **F5:** `:kernel-manifestation-status` / `:no-payload-state` split present in the spec
  (§14), the table rows, and the Contract's own row parser.
- **R1:** `metadata-only` row present; table-miss is **membership-keyed** (UNDERTOW B rejects
  on a shape the author never pre-selected).
- **R2:** capture gate fires on the *omitted* field (UNDERTOW C rejects).
- **R3:** see §2.
- **N1 (structural demand):** validator **not** emitted by the generator — my own
  byte-substring check: validator source not contained in generator; **zero** 400-char
  validator windows found in the generator. Independence note adopts the adjudicated wording
  verbatim: *"separate-file, non-importing, co-authored self-consistency certification only."*
- **NOTE-level wording:** honesty-cap sweep over the reissue found **zero** over-claim hits;
  standing language bounded at every citation ("repaired candidate packet; not adopted, not
  independently conformant, not authorization for live-provider contact"). The relay also
  covers N4 (journal-down-post-frontier → W1) and N5 (redaction custody, derived origin) —
  both present as vectors/rules (`projection-origin-invalid` observed firing in §3).

## 5. Verdict

**The reissue satisfies the adjudication.** The BLOCKER and all seven REPAIRs are repaired
and mechanically enforced; the NOTE-level wording repairs are adopted; the structural
condition (validator outside the generator) is met and verified by my own diff; all ten
filed hostile records die on correct named conditions; all five suites reproduce under my
hand on the exact delivered bytes.

**Standing after this verification — unchanged in kind, upgraded in degree:** *repaired
candidate, co-authored self-consistency certification, hostile-regression-verified by the
adjudicating chair.* This verification is same-arc and same-corpus-adjacent: it confirms the
repairs against the adjudication; it is **not** independent conformance. The independently
seeded Common Lisp gate (PJ0-precedent binding gate) and the **stranger audit** remain
outstanding and unsubstituted, exactly as the packet itself says.

**Recommendation to the owner:** AP0 is ready for the adoption decision on the same terms
Kernel /0 and PJ0 received their seals — adopt as the governing adapter-protocol spec /0,
with the outstanding gates carried as explicit riders (no specimen reliance on live-provider
claims until the CL gate; stranger audit before any independence language).

— Fable 5, chair. Every contested step above is exhibited or its compression named; probe
reruns and suite outputs frozen in `reissue-verification/` and reproducible from the packet.
