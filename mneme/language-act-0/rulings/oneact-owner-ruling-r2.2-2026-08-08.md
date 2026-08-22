# ONE ACT /0 — OWNER RULING R2.2 (2026-08-08, direct)

*Received in-session 2026-08-08 ~00:4x −03, direct owner instrument, [R] tier.
Governing-instrument status confirmed by the owner by interview after an
ambiguous re-paste of R0.1 (chair asked; owner: "R2.2 governs — proceed").
Transcribed verbatim below; chair reception note follows.*

---

## Verbatim ruling

## Owner ruling — RETURN R2.2

```text
ONE ACT /0 RECOMMENDATION:
RETURN — ONE-ACT-0-ASDF-PACKAGE-EXISTENCE-CERTIFIES-INCOMPLETE-LANE
```

This is not a semantic rejection. One Act `/0` is substantially sound and its mechanism is now locked. Adoption, merge, and publication remain unauthorized pending one narrow loader-finality repair.

| Area                        | Ruling                |
| --------------------------- | --------------------- |
| Derived act identity        | **PASS — LOCKED**     |
| Seven-arm execution         | **PASS — LOCKED**     |
| B‑R R2.1 amendment          | **ACCEPTED — LOCKED** |
| 63 canonical vectors        | **PASS — LOCKED**     |
| V‑F1…V‑F5 freeze            | **PASS — LOCKED**     |
| Twin-run determinism        | **PASS — LOCKED**     |
| Surface Account non-contact | **PASS**              |
| ASDF load finality          | **RETURN**            |
| Adoption/publication        | **NOT AUTHORIZED**    |
| Surface `/3`                | **SHUT**              |

### Independent execution

Under exact SBCL 2.4.6:

* Two fresh full runs: **173/173 each**, byte-identical.
* Full-umbrella coexistence run: **173/173**.
* All seven derived identities and all **63 vectors** recomputed.
* The **23 frozen frames + 12 absence-by-law slots** matched the returned evidence exactly.
* All implementation sources compiled with zero warnings and zero failures.
* B‑R genuinely produces F1, then refuses at `CAP1-MINT-2`; F2–F5 are absent, the world is untouched, and cold readback classifies it `BINDING-DECLARED-UNPAIRED`.
* The ASDF delta over current public `main` (github.com/Wondermonger-daydreaming/latent-lisp) is exactly one 37-line stanza plus four new lane files.

### Blocking defect

The system loader uses:

```lisp
(unless (find-package '#:lisp-plus-language-act0)
  (load package)
  (load fixtures)
  (load implementation)
  (load gates))
```

I reproduced two false-success states:

```text
EMPTY NAMESAKE PACKAGE
ASDF exit 0
exports 0
RUN-ACT absent

PACKAGE.LISP LOADED ALONE
ASDF exit 0
exports 70
RUN-ACT :EXTERNAL but not FBOUNDP
```

Thus an empty package collision—or merely loading `package.lisp` for inspection—causes `asdf:load-system "lisp-plus/act0"` to report success while leaving the lane unusable.

This is the same species of defect Surface Account R4.3 permanently outlawed: package existence is not implementation readiness. The goblin has changed terminals but kept its passport.

### B‑R and the D1 docket

The R2.1 correction is sustained. The sealed B‑R story was impossible against `CAP1-MINT-2`; the implementation obeyed the predecessor rather than manufacturing a capability from a refusal.

Do **not** add or re-fixture a D1-refusal arm in `/0`. Under the adopted laws, exact terms are checked at binding, minted into Office R, and presented at D1 without an intervening append. Producing a lawful D1 refusal would require either deliberately breaking that binding or authorizing a new state transition between mint and D1. That costs new semantics, not merely two re-frozen vectors.

Disposition:

```text
ONE-ACT-0-D1-REFUSAL-ARM:
DEFERRED OUTSIDE /0.
NOT AN ADOPTION PREREQUISITE.
NO VECTOR RE-FREEZE AUTHORIZED.
```

### Confined R2.2 commission

1. Replace the package-existence guard with an explicit `act0-api-complete-p` predicate covering the declared external functions, variables/constants, types, and a final-source readiness carrier.

2. If the namesake package is incomplete, reapply `package.lisp`, load the remaining three files in order, and assert completeness afterward. Fail closed if the predicate remains false.

3. Add permanent witnesses for:

   * empty namesake package;
   * `package.lisp` only;
   * package + fixtures only;
   * package + fixtures + implementation, gates absent;
   * lawful fresh load;
   * forced/repeated load of a complete lane.

4. Add a disease comparator restoring the present `FIND-PACKAGE` guard. It must reproduce the false-success state and be detected.

5. Preserve byte-for-byte semantics: 173/173, twin-run identity, all 63 vectors, and the frozen V‑F table. Do not modify B‑R, identity derivation, D2, predecessors, or Surface `/3`.

6. Rerun the complete lab floor. My public reconstruction encountered the two known `431fee16` blocks, two host-sensitive Vertical durability failures that reproduce on pristine public `main`, and a missing Python `jsonschema` dependency; none is attributable to One Act.

7. Return a thin Git bundle or equivalent authenticated object closure containing the full 40-hex final candidate identity and prerequisite. The present parcel contains exact snapshots but no Git object capable of authenticating short tip `098d66cd`.

Custody of the implementation parcel is clean: SHA‑256 `822c6b16b30010fbfe575fad07b50ba73b7aaa6ef2d329c96a5a2a6b443e2145`; 19 regular files; manifest 17/17 plus sidecar exact.

```text
OWNER DISPOSITION:
R2.1 SEMANTICS ACCEPTED AND LOCKED.
R2.2 LOADER-FINALITY REPAIR AUTHORIZED.
D1-REFUSAL ARM DEFERRED OUTSIDE /0.
HOUSEKEEPING MOVEMENT AND DELETION UNAUTHORIZED.
ADOPTION, MERGE, AND PUBLICATION UNAUTHORIZED.
SURFACE /3 REMAINS SHUT.
```

We have the act. We do not yet have a loader consistently capable of admitting that the act exists—which is a hilariously Lisp-flavored final obstacle.

---

## Chair reception note (Claude Fable 5, 2026-08-08)

**Standing:** direct owner instrument; supersedes nothing semantic — it LOCKS
the R2/R2.1 semantics and returns exactly one defect (loader finality). The
owner's independent execution (173/173 twice, byte-identical; 63 recomputed;
frozen frames matched; compile clean) is the strongest corroboration this lane
has received.

**Dispositions recorded:**
1. **D1-refusal docket CLOSED for /0** — the R2.1 erratum's docket line is
   superseded by this ruling's disposition: DEFERRED OUTSIDE /0, not an
   adoption prerequisite, NO vector re-freeze. The owner's reasoning (a lawful
   D1 refusal would cost new semantics — an intervening state transition
   between mint and D1) is adopted into the docket record.
2. **The false-success reproduction is owner-verified** — both states (empty
   namesake package; package.lisp alone) reproduce; the defect class is
   Surface Account R4.3's outlawed species: package existence ≠ implementation
   readiness.
3. **Scope of R2.2:** the loader guard in the lisp-plus.asd stanza + new
   permanent witnesses + disease comparator; semantics byte-preserved
   (item 5's list); floor rerun; thin git bundle for authentication.
   Housekeeping, adoption, merge, publication, Surface /3: all unchanged.

**Round name: R2.2 (loader-finality repair).** Crew and records use the
`oneact-r22-*` staging prefix.
