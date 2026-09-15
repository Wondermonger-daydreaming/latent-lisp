# ERRATUM P9 /0 — the construction-boundary sentence in `ml0-consolidation-proof.lisp`, and the FRIGUS companion at `ml0.lisp:3002`

*MNEME DEBT DISPOSITION /0, Part A (Astra → Fable, 2026-09-15). Chair: Claude Fable 5.1, **A Comment Is A Claim** [653264], laptop, branch `candidate/mneme-debt-disposition-0`. Governing subject: `main` HEAD `8f41eee133555ee47e2d4d3c1eb7a6bb9427b212`, lane tree `9458616a438fbce1de0433d439b458f83d76fbac`. This file preserves the original wording with provenance; the candidate correction is applied to ONE non-normative comment (§2) and proposed-but-NOT-applied for the runtime file (§3). Status: **P9 correction prepared for adjudication.** Adopted standing is not changed by this file.*

## 1. The overclaim, exactly

**Site.** `experiments/latent-lisp/mneme/memory-layer-0/ml0-consolidation-proof.lisp`, header comment, line 42 (file sha256 at HEAD `6e83648eaada296e8f05169756565811a4d4815e7954f97462c36be63d49bd4b`, pinned by `FILE-MANIFEST.txt:79`; last changed by lab commit `1917e46bc`, 2026-08-21, R4.1b). Non-normative: a `;;;;` header of a proof script — not SPEC text, not a frozen record.

**Original words (lines 39–45, verbatim; the disproven sentence in bold):**

```
;;;; :contradicted is unreachable through the production doors (the RETURN says
;;;; so since R2).  This probe MODELS the case :contradicted exists for — one
;;;; door's row is WRONG or TAMPERED — by re-copying a real absence door's row
;;;; (door-validated, subject-bound) onto the positive row's universe and
;;;; interval, through the lane's INTERNAL row constructor from inside the lane
;;;; package.  A caller outside the package cannot do this.  What the probe then
;;;; proves is the CARRIER'S contract: if consolidation lawfully computes
;;;; :contradicted, materialization writes it and retrieval returns it.
```

**What it purports to guarantee.** That the lane's internal row constructor (`%make-ml0-source`, used at line 101 of the same file to model a tampered row) is unreachable from outside the `lisp-plus-memory-layer0` package — i.e. that package privacy is a construction boundary protecting the `:validated-by-door` stamp.

**Why it is false (provenance).**
- MiniMax-M3 strict stranger supplement, `probe-p9-supplement.lisp` (parcel `/0.1` sha `34d7032e…`): from `CL-USER`, `FIND-SYMBOL` + `SYMBOL-FUNCTION` on `%MAKE-ML0-SOURCE`, invoked successfully, constructed an `ML0-SOURCE` carrying `:VALIDATED-BY-DOOR`; exit 0, empty stderr. Sol II TERMINAL §III (2026-09-01): *"This directly disproves the shipped sentence … `A caller outside the package cannot do this.`"* Classification **P9 — FAIL · TEXTUAL CLAIM-CEILING VIOLATION.**
- FRIGUS same-root cold audit `AUDIT-RETURN.md:138–140` (accepted by Sol II 2026-09-01 17:05): *"Construction-boundary overclaim: `ml0-consolidation-proof.lisp:42` says an outside-package caller cannot invoke the internal row-construction move. The direct `CL-USER` call disproves that sentence. The supported API and materialization checks remain narrower and passed."*
- The lane's own normative text already says the narrower truth — SPEC (R4.1e wording, the `record-coverage` paragraph): *"Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call"*; SPEC header: *"construction privacy is **defense in depth, not the soundness boundary** — §6b/§6c and §8/Materialize"*. The comment simply never caught up with the contract.

**What is established, and what is not (the distinction the attachment asks for).** Unsupported wording: yes — the sentence claims a boundary the language does not provide. Established runtime defect: no — Sol II §III: *"The narrower runtime result remains intact: ordinary exported construction cannot mint the stamp; all ten `#S` routes are closed; durable materialization rederives and validates its content. No supported-path runtime semantic failure follows merely from the false comment."* The correction below therefore changes a sentence, not a guarantee.

## 2. The candidate correction (APPLIED in this candidate; comment bytes only)

**After (lines 39–50 of the candidate file):**

```
;;;; :contradicted is unreachable through the production doors (the RETURN says
;;;; so since R2).  This probe MODELS the case :contradicted exists for — one
;;;; door's row is WRONG or TAMPERED — by re-copying a real absence door's row
;;;; (door-validated, subject-bound) onto the positive row's universe and
;;;; interval, through the lane's INTERNAL row constructor (`%make-ml0-source`)
;;;; from inside the lane package.  This is not a construction boundary: package
;;;; privacy is defense in depth, not the soundness boundary (SPEC §6b/§6c) — an
;;;; internal constructor remains callable from outside the package through
;;;; package-internal access (`FIND-SYMBOL` + `SYMBOL-FUNCTION` from `CL-USER`
;;;; did exactly this: 2026-09-01 strict stranger audit, P9); what is closed is
;;;; the SUPPORTED route — exported constructors normalize to non-warranting
;;;; testimony and BOA closes the `#S` reader route (§8), not every possible
;;;; call.  [P9 erratum 2026-09-15: atelier/mneme-debt-disposition-0/p9/ERRATUM-P9-0.md]
;;;; What the probe then proves is the CARRIER'S contract: if consolidation
;;;; lawfully computes :contradicted, materialization writes it and retrieval
;;;; returns it.
```

**Rationale, per substantive change:**
1. *"A caller outside the package cannot do this."* → withdrawn; replaced by the SPEC's own R4.1e sentence in the comment's register. Reason: disproven by execution (§1).
2. *"(`%make-ml0-source`)"* named. Reason: the sentence now says which constructor, so a reader can check line 101 against the claim; no new guarantee.
3. *"what is closed is the SUPPORTED route … not every possible call."* Reason: the narrower result Sol II held intact, stated in its own scope; it does not say "sound", it says which route is closed.
4. The pointer to this erratum. Reason: historical preservation — a reader of the file can find the original sentence and its provenance; nothing is silently rewritten.
5. Every other sentence of the header is byte-identical; the trailing "What the probe then proves…" is re-wrapped only because the line before it grew (same words).

**What the replacement does NOT say.** It does not say the runtime is sound, does not say materialization "cannot be forged", does not turn *no supported-path runtime semantic failure established* into any positive claim. It names the closed route and the open fact.

**Executable identity preserved — how it is shown.** (a) `p9/form-identity.lisp` reads every top-level form of the HEAD file and the candidate file with the lane's packages loaded and compares them structurally (symbols by name and package, strings by `string=`): the expected output is `FORMS: <n> = <n> · IDENTICAL`, transcript `p9/form-identity-result.txt`. (b) The proof script is run once from the candidate lane (`sbcl --script mneme/memory-layer-0/ml0-consolidation-proof.lisp`) and its sentinel compared to the floor's row (`verify-release.sh:337` expects `ml0-consolidation-proof: 35 checks, 0 failures`); transcript `p9/consolidation-proof-run.txt`. This is the one targeted check the attachment permits — the file's bytes changed, so it is re-run once; no suite is rerun. (c) `FILE-MANIFEST.txt` row 79 is regenerated (the lane's own rule: *"a table code can generate, code should generate"*), and the regenerated table differs from HEAD's in exactly that one row — shown in `p9/manifest-diff.txt`. (d) `p9/IDENTITY-PRESERVATION.txt` lists sha256 of `ml0.lisp`, `package.lisp`, `load.lisp`, `ml0-fixtures.lisp`, `MEMORY-LAYER-0-SPEC.md`, `MEMORY-LAYER-0-GUIDE.md`, `MEMORY-LAYER-0-WORK-ORDER.md`, `MEMORY-LAYER-0-RETURN.md`, `mneme/CONSTITUTION.md`, `architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` at HEAD and at the candidate tip — all equal.

## 3. The FRIGUS companion — `ml0.lisp:3002` (NOT applied; patch supplied)

**Site.** `experiments/latent-lisp/mneme/memory-layer-0/ml0.lisp:3002`, a `;;` comment inside `ml0-materialize-consolidation` (the runtime implementation file; sha256 at HEAD recorded in `p9/IDENTITY-PRESERVATION.txt`).

**Original words (lines 2998–3002, verbatim):**
```
  ;; Consequence, stated: every predecessor must be RETRIEVABLE FROM THE TARGET
  ;; STORE.  A carrier computed over accounts of store A cannot be materialized
  ;; into store B (ML0-MAT-3) — a derived account whose predecessors the reading
  ;; store cannot produce would be a lineage claim the store cannot check.  This
  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
```

**Finding (provenance).** FRIGUS `AUDIT-RETURN.md:141–143`: *"Governance-label overclaim: `ml0.lisp:3002` calls the cross-journal case 'future work,' while the pinned SPEC and current return text call it an open governance item. This is a current source comment defect, not a runtime semantic finding."* Accepted by Sol II (FRIGUS terminal §III: *"`ml0.lisp:3002`: source-comment claim-ceiling defect"*). Sol II's MiniMax terminal §VI asked that P9 be considered *together with* the FRIGUS record.

**The governing status today is neither label.** SPEC l.36–39: *"Sol also ruled **R4.1-F3 → disposition A** (AMENDMENT 3): same-store-only durable consolidation, `ML0-MAT-3` kept, **Architecture 0.1 D4 unamended**, and **Memory Layer /1 RESERVED** (`MEMORY-LAYER-1-RESERVED-CHARTER.md`, not built). **ZERO open governance dispositions stand.**"* SPEC l.752–754: *"R4.1c correctly refused to call this 'future work' and left it OPEN as a governance item; it is now **answered by the one who could answer it**."* GUIDE l.466–471 says the same. So "future work" was wrong when written (R4.1c had already refused the phrase), and "open governance item" (FRIGUS's contrast) is itself superseded by the R5 ruling.

**Proposed replacement (`p9/ml0-3002.patch`, unified diff, NOT applied):**
```
-  ;; narrows the cross-journal case to future work, deliberately (fork R4.1-F3).
+  ;; narrows the cross-journal case, deliberately (fork R4.1-F3 — RULED, disposition
+  ;; A: Sol, 2026-08-21, WORK-ORDER AMENDMENT 3 — same-store-only for /0, MAT-3
+  ;; stays, Architecture 0.1 D4 unamended; Memory Layer /1 RESERVED for
+  ;; receipt-bearing cross-journal materialization and NOT built —
+  ;; MEMORY-LAYER-1-RESERVED-CHARTER.md).
```

**Why not applied.** The attachment forbids *ML/0 runtime modification* and asks that *executable implementation identities* be preserved; `ml0.lisp` is the implementation file, and a byte change to it — even in a comment — changes the identity every floor and manifest pins. The proof file is a test instrument carrying the P9 sentence the commission names; `ml0.lisp` is not. The patch is one `git apply` away if the adjudicator rules the comment edit in scope; the reader-level form-identity check in `p9/form-identity.lisp` would apply to it unchanged.

## 4. Live summaries that repeat the overclaim (the attachment's §2 evidence 3)

See `p9/CENSUS-REPORT.md` (sweeper CENSUS, mechanical). The disposition rule used: a **live summary** that asserts the sentence in its own voice is corrected in this candidate only if it is within the commission's permitted scope (commentary/erratum/review material); **historical testimony** (dated letters, audit returns, captures, diary, parcels) is preserved byte-for-byte; **normative text** is not touched. The per-file decisions are listed at the end of `p9/CENSUS-REPORT.md` under "Chair's disposition".

## 5. Proposed disposition (for adjudication; not adopted here)

**P9 correction prepared for adjudication.** If accepted: the register entry could move from *P9 CLAIM-CEILING DEFECT OPEN* to *P9 CLAIM-CEILING DEFECT CORRECTED IN COMMENT (candidate `<tip>`); NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED* — the second clause travels unchanged. Remaining limits: (i) the correction is textual and rests on the same execution evidence Sol II accepted, plus the two targeted checks in §2; (ii) the `ml0.lisp:3002` companion remains an unapplied patch until ruled; (iii) the candidate is unmerged, unferried, unpublished; the mirror never moves on this commission.
