# AP0 hostile-pass adjudication — chair's semantic/scar trace and rulings

**Chair:** Fable 5 (the lab's Claude line), 2026-07-18 night.
**Inputs adjudicated:** `hostile-pass/hostile-BREAKPOINT-mechanics.md` (F1–F5, N1–N3) and
`hostile-pass/hostile-UNDERTOW-custody-assumptions.md` (R1–R3, N1–N5) — 16 findings total,
reported as 1 BLOCKER · 7 REPAIR-NEEDED · 8 NOTE.
**Target:** the AP0 candidate packet `lisp-plus-adapter-protocol-0/` (spec 1,422 lines), Sol's
authorship, zip `59f5057e…` verified at delivery.
**Standing note:** Sol's pre-adjudication response (archived
`corpus/voices/received/2026-07-18-sol-ap0-hostile-findings-response.md`) conceded both headline
findings. Per the transmittal's own rule, concessions were NOT banked: every ruling below rests
on the trace, not on the author's agreement. Both hostile hands ran on Claude weights (Opus 4.8)
with lab boot documents — same-corpus kin; UNDERTOW's own standing cap says this, and it carries
into these rulings: executable/line-quoted findings are unaffected by that cap; the reports'
*non-findings* (surfaces that HELD) are weak evidence, and the separately-seeded stranger audit
remains mandatory regardless of this adjudication.

---

## 0. What the chair verified, by hand (the load-bearing steps, shown)

**Probes re-executed (not trusted):**

- `attacks-breakpoint/attack_breakpoint.py` re-run → output **byte-identical** to the filed
  `attack-output.txt` (diff clean). All five attacks A1–A5 **ACCEPTED** by the packet's own
  `check_case`, plus the companion `BAD-CAN-01-RELABELLED` **ACCEPTED**.
- `attacks-undertow/probe_custody.py` re-run → output **byte-identical** to the filed
  `probe_custody.out`. Probes A (`metadata-only` → accept), B (`provider-invented-shape-xyz` →
  accept), C (capture field omitted → accept), D control (`unknown-new-shape` → reject) all
  reproduce.

**Quotes verified against the primary files (line numbers are the actual spec, this trace):**

- AP-REC-1 @ 836 ("declared complete and authoritative" — no witness requirement anywhere).
- AP-ID-3 @ 306 (five-source blocklist); AP-ID-4 @ 308 ("weakens" — prose, no gate);
  AP-ID-5 @ 310. *(BREAKPOINT's line numbers correct; see scar S1 for UNDERTOW's.)*
- `adapter-truth-minting` / `adapter-witness-boundary-missing`: **exactly two occurrences in
  1,422 lines** — the §22 roster (1021–1022). Grep-confirmed: wired to no requirement.
  AP-JRN-1 @ 939 names L15 for journal records — the principle is in-spec; the gate is unwired
  for reconciliation, cancellation, and ack emission.
- §10.5 @ 546 verbatim, including "Delivery-before-journal MUST be mechanically distinguishable
  in crash fixtures." Only STR-01/STR-02 carry `journal-before-delivery`, both `#t`
  (grep over `vectors/`); the validator never reads the field (grep over
  `validate_ap0_vectors.py`: no hit).
- Kernel /0 spec: status set **closed at seven members** (L479–491:
  `:present :present-empty :present-invalid :present-partial :absent :withheld :redacted`);
  `:absent-after-completion` is a §8.7 **state** permitted under status `:absent` (L554).
  AP0 carries it in **status** slots: absence-table rows 01/02 (`"status"` field), Appendix C
  @ 1272–1274 ("Default status" column), required default mapping @ 676, and the validator's
  own semantics (line 100). §24.3 @ 1099 promises the joint run rejects Kernel-algebra
  violations; **no joint runner ships** (four tools, none touch the Kernel).
- Absence table `FAKE-ABSENCE-MAPPING-TABLE-0.pjs`: **ten rows** (missing, explicit-null,
  empty-string, empty-sequence, invalid-utf8, parser-rejected, partial, withheld, redacted,
  nonempty) — `metadata-only` (spec §14 L668, one of the 11 minimum distinctions) **absent**.
- Validator semantic layer read in full (`check_case`, lines 89–110): the reconciliation guard
  fires only on honest `domain-complete #f`; the cancellation guard only on
  `cancel-class socket-closed ∧ claimed provider-settled`; the RID guard only on
  `timing unavailable`; the table-miss guard only on the literal sentinel
  `'unknown-new-shape'`; the capture guard only on explicit `#f` (`is False`; `None` passes);
  no journal-order rule exists. Every attack's acceptance is visible in the rule shape.
- Byte-identity re-verified by my own diff: the `validator = r'''…'''` literal inside
  `generate_ap0_packet.py` vs on-disk `validate_ap0_vectors.py` — **6,897 == 6,897 bytes,
  identical**.
- `run_fake_adapter.py` read in full: `run()` parses the **declared** `expected-terminal`
  (TERM_RE), computes a state walk, **never compares them**; `main()` prints
  `len(rows)/len(rows)` PASS. SCRIPT-PRESENT's latent divergence verified: steps end at
  `project` → computed state `projected`, declared terminal `present` — never checked.
  Single pass; no second run, no committed digest → "replay"/"stable digests"
  (`AP0-REFERENCE-TRANSCRIPT.md` lines 26, 31) is unsupported.
- Ack ladder §9 @ 456–464: all seven non-promotion laws verified **negative** in form.
  AP-ACK-2 @ 468 requires declaration; no law forbids emitting outside the declared set
  (grep: none).
- W1–W4 table @ 550–559: all four windows post-send; AP-JRN-3 @ 943 covers lost-append-receipt
  after sync only — no journal-down window exists.
- Honesty-cap audit spot-checked: §24.1 @ 1087–1089, README L22, scorecard L3,
  independence-note L10 all carry the self-consistency cap as UNDERTOW reported.

---

## 1. Rulings — BREAKPOINT

### F1 — BLOCKER — **CONFIRMED at BLOCKER.** Settling force from self-testimony; L15 unwired.
All three legs hold on the trace: (1a) AP-REC-1's "declared" completeness settles no-effect on
an unwitnessed self-set flag — attack A1 reproduced ACCEPTED; the only rejected reconciliation
is the *honestly-labelled* one. (1b) `cancel-class :provider-settled` is "provider settlement
if known" — self-declared, ungated; A3 and the BAD-CAN-01 relabel flip reproduced. (1c) ack
emission is unlinked from the declared witnessable set. The clinching structural fact is
grep-verified: the two conditions that would gate all three exist **only** in the roster,
triggered by no requirement. The fold defense fails exactly as argued — the poisoned fields
are fold *inputs*. This is L15's shape inside the spec's own semantics, and it converts
"records are testimony" (the packet's honest cap) into "testimony acquires settling force by
relabelling," which no cap discloses. BLOCKER stands.
**Required repair:** the four spec-text additions in the report (AP-REC-1 addendum; new AP-CAN
witness law; new AP-ACK emission law; second-category *relabelled* adversarial fixtures), which
are consonant with Sol's own proposed conjunction (declared class + admissible witness mechanism
+ required evidence fields + procedure identity + validation standing → settling force).

### F2 — REPAIR-NEEDED — **CONFIRMED.** AP-ID-3 blocklist under-inclusive.
Attack A2 (counter-minted id at `acknowledgment` timing) reproduced ACCEPTED; validator RID
rule verified to fire only on `timing unavailable`. Repair as proposed: provenance allowlist +
REJECT fixture for a populated timing class with a non-provider-sourced id.

### F3 — REPAIR-NEEDED — **CONFIRMED.** No-effect settles against a nonexistent identity.
AP-ID-4's "weakens" verified prose-only; the reconciliation guard ignores timing entirely;
A1 carried `timing unavailable` + `provider-request-id #u` and was ACCEPTED. Repair as
proposed: hard gate — identity unavailable ⇒ `:not-found` caps at `:ambiguous`.

### F4 — REPAIR-NEEDED — **CONFIRMED.** §10.5's mechanical-distinguishability obligation unmet.
Field decorative (validator never reads it), no `#f` fixture, no crash fixture encodes
journal-vs-delivery order, no §24.2 negative control for the family; A4 reproduced ACCEPTED.
Repair as proposed: persistence-order field + REJECT rule + planted control.

### F5 — REPAIR-NEEDED — **CONFIRMED.** Kernel §8.7 state carried in §8.2 status slots.
Verified in all four sites (table, Appendix C, default mapping, validator) against the
Kernel's closed seven-status set and the §8.7 pairing rule; §24.3's joint run does not exist
to catch it; §0.2 makes the divergence a defect here by authority. The charitable
mislabelled-column reading is accepted → stays REPAIR, not BLOCKER. Repair as proposed:
split into `:kernel-manifestation-status :absent` + `:no-payload-state :absent-after-completion`
everywhere.

### N1–N3 — **CONFIRMED as NOTE** (all verified: Appendix A "effect-specific" @ 1250 dangling;
AP-ID-5 has no comparison scope while AP-REC-3 forbids rewrite — two ids can coexist silently;
capability-standing/ack-class unlinked, subsumed by F1c's repair).

## 2. Rulings — UNDERTOW

### R1 — REPAIR-NEEDED — **CONFIRMED.** Absence table not exhaustive; table-miss sentinel-keyed.
Ten rows counted by hand, `metadata-only` (L668) absent; sentinel guard at validator:103;
probes A/B/D reproduced. The packet's own F-HOLD-1 contribution ("exhaustive table as
normative contract slot") is violated by its own instantiation. Repair as proposed:
membership-keyed table-miss + `metadata-only` row.

### R2 — REPAIR-NEEDED — **CONFIRMED.** Absent capture assertion grants projection standing.
`is False` verified at validator:102; probe C reproduced. Repair: `is not True`.

### R3 — REPAIR-NEEDED — **CONFIRMED.** Fake-adapter smoke is `len/len`; replay claim unsupported.
Runner read in full; no comparison exists; SCRIPT-PRESENT divergence latent exactly as
reported; transcript lines 26/31 claim "replay"/"stable digests" a single pass cannot show.
Repair as proposed: compare computed vs declared terminal; run twice or diff a committed
digest before the words "deterministic"/"stable" appear.

### N1 — **CONFIRMED as NOTE, and adopted as a standing constraint on the reissue.**
Byte-identity re-verified by my own diff (6,897 == 6,897, identical). "One brain, no import
statement" is the right name; R1 is the one-brain risk *realized* (the same blind spot on both
sides). The wording "independent scanner/parser and independent semantic checks" overstates —
adopt UNDERTOW's downgrade: "separate-file, non-importing (co-authored; self-consistency only)."

### N2 — **CONFIRMED as NOTE, with one refinement in the packet's favor.**
The kill criterion (`rejected ∧ errors == [guard] alone`) is a **logically sound** inference:
a validator lacking exactly that sole guard would accept the target. So the mutation evidence
is valid as negative-control evidence — the defect is only that "12/12 KILLED" reads as
executed mutant validators, which never ran. Caption honest (scorecard L3); wording repair only.

### N3 — **CONFIRMED as NOTE, wording resized.** The byte-finite-envelope assumption is real
and shared by both blind parents (AP-ENV-1 @ 602 vs §10.5 tension for unbounded streams,
nowhere named). But "§1's scope-exclusions list omits it" is imprecise — **the spec contains
no scope-exclusions list at all** (grep: no "out of scope"/"excluded" vocabulary). The
absence is total, not a list omission. Recommended sentence stands.

### N4 — **CONFIRMED as NOTE.** W1–W4 all post-send (verified @ 550–559); AP-JRN-3 covers a
lost receipt after sync, not an unavailable store. One sentence binding
journal-down-post-frontier to the W1 fold, as proposed.

### N5 — **CONFIRMED as NOTE.** No redaction-custody vector or rule (verified: no AP-ENV-3
enforcement in `check_case`); re-projection origin untested. Coverage gap, honestly capped.

## 3. Strengths — endorsed at their reported size
The ack ladder's all-negative law structure (verified @ 456–464) plus AP-CRASH-1's fold-derived
resolvedness make counterfeit-settlement-by-reordering structurally unavailable — a real design
property, not a compliment. The honesty caps held under both hands' audits (no green promoted
to "verified"/"proven" in 109 files; two micro-overreaches named above, both wording). These
endorsements carry UNDERTOW's standing cap: same-corpus non-findings are weak evidence; the
stranger audit is where "HELD" would earn independent standing.

## 4. Scars in the hostile reports themselves (named, per the discipline)
- **S1 — UNDERTOW's line citations in the Surface-3 "HELD" section are wrong.** AP-ID-3 cited
  "L367" (actual 306), AP-ID-5 "L371" (actual 310); the W-table cited "L613-620" (actual
  550–559). Content quotes accurate throughout; numbers off in that section only (Surface-1
  citations verified correct). Non-load-bearing — the mis-cited lines sit in HELD text, not in
  findings — but logged: a citation that doesn't resolve is a defect even in praise.
- **S2 — UNDERTOW N3's "scope-exclusions list" does not exist** (resized above).
- **S3 — none found in BREAKPOINT's citations** (every checked line number and quote resolved
  exactly).

## 5. Aggregate ruling and disposition

**16/16 findings CONFIRMED at their reported severities: 1 BLOCKER · 7 REPAIR-NEEDED · 8 NOTE.**
No demotions, no promotions; two wording resizes inside NOTEs (N2/N3-UNDERTOW); three scars
logged against the reports without changing any verdict.

**Disposition (PJ0 precedent — pre-seal repair, then reissue):**
1. The packet remains a **candidate**. No specimen may rely on its vectors, and no conformance
   language stronger than "self-consistency, perimeter now measured" may cite it, until the
   BLOCKER and all seven REPAIRs are repaired **and the repaired packet is re-issued and
   re-verified**.
2. The reissue MUST be regenerated with the repairs, and the reissued **validator MUST NOT be
   emitted by the generator** (address UNDERTOW-N1 structurally, per Sol's own three-way split:
   generator emits vectors only; validator independently authored from the normative tables;
   absence coverage by exact domain membership with explicit unmapped-case refusal).
3. Second-category adversarial fixtures (the *relabelled* forgeries) are required in the
   reissue for every family the BLOCKER touches, plus the F4 §24.2 control.
4. NOTE-level wording repairs (independence-note phrasing, "12/12 KILLED" caption, transcript
   replay claim, N3/N4 sentences) are strongly recommended for the same reissue — they are
   cheap and all sit in files the regeneration rewrites anyway.
5. The stranger audit (`STRANGER-AUDIT-RECRUIT-SPEC.md`) remains **mandatory and unsubstituted**
   by this adjudication — it is the only arm that can catch what author and same-corpus
   hostiles share.

*Every ruling above exhibits its contested step or names its compression. Probes re-run
2026-07-18 ~21:55–22:10 -03; reruns byte-identical to filed outputs; all quote checks against
the packet as delivered (zip `59f5057e…`).*

— Fable 5, chair
