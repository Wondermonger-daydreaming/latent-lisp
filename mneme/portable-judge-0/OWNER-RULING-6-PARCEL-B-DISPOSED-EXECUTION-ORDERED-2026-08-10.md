# OWNER RULING 6 — PARCEL B DISPOSED; EXECUTION ORDERED (2026-08-10, filed verbatim)

**Filed verbatim by the chair (Claude Fable 5) from the owner's direct message,
2026-08-10. Append-only; the owner's words below are unedited. (This is the
Parcel-B-law Ruling 6 for which the name was reserved by Ruling 5A.)**

---

Outcome: **Parcel B’s return is accepted; B2 is accepted as repaired; all eight handoff items are disposed.** The submitted Git tip is conditionally mergeable after repository-local bundle verification. Two separate execution returns remain required, so S-freeze is not yet reached.

# OWNER RULING 6 — PARCEL B DISPOSED; EXECUTION ORDERED

## 1. Parcel authentication

Verified:

* Outer SHA-256: `ae605081380f5aa5725fba1ee9bba1e4bcb694c913f45dba592539c7ee411b4c`
* Size: `215,209` bytes
* Manifest: **24/24 payload hashes green**, with the manifest itself properly excluded
* Patch inventory: exactly **19 paths**

  * 2 existing files modified
  * 17 Parcel-B artifacts added
  * no deletion, rename, binary patch, path escape, or mode change
* Applying `parcel-b.patch` to the accepted A-R1 versions reconstructs all nineteen loose artifacts byte-for-byte.
* Old blobs match:

  * failure matrix: `31ed6ece…`
  * diseases script: `2ad79de0…`
* New blobs match:

  * failure matrix: `5c6706d1…`
  * diseases script: `8c316e97…`
  * all seventeen added artifact blobs likewise match their patch identities.
* `ma0-diseases.sh` remains executable: Git `100755`, loose artifact `0755`.
* B2’s RED and GREEN captures differ in exactly one line:

  * before: `5 diseases detected, 5 controls clean`
  * after: `5 diseases detected, 6 controls clean`

The supplied transcripts report the expected same-author reruns: selftest `200/0`, teeth `15/15`, P3 `11/0`, P4 `11/0` as a rerun only, and One Act `173/0`. They were inspected but not independently rerun here because the complete repository is absent.

### Thin-bundle condition

`parcel-b.bundle` honestly declares prerequisite `b5f3dc29…`. An empty repository therefore cannot verify or fetch it. Unlike P2-R1, no empty-repository transport was ordered for this parcel, so this is not a parcel defect—but it means commit `7643d7aa…` has not been authenticated here beyond the bundle header, audited patch, and exact blob reconstruction.

Before integration, the project checkout must establish:

1. base `b5f3dc298da5a4aa4c53dbec161bc62d9f76282b` exists exactly;
2. the bundle verifies there;
3. fetched tip is exactly `7643d7aac0cce49a1d6630be856adbb462b4cabc`;
4. `git diff b5f3dc29..7643d7aa` is byte-identical to `parcel-b.patch`;
5. the changed-path set is exactly the audited nineteen paths.

A mismatch stops integration. A match requires no further owner disposition.

## 2. Jurisdiction — PASS

The previously sealed Parcel A source confirms that B1–B8 are exactly its eight handoff items. No ninth item was opened.

The broader reader grammar, refusal table, numerical bounds, identity rules, normalization rules, environment signatures, result shapes, and remaining semantic-extractability deficits are **not** discharged by this parcel. They remain part of the 28-deficit/S-freeze agenda.

## 3. Item dispositions

### B1 — standing banners: AMENDED STRATIFICATION ADOPTED

Options A, B, and C are rejected as drafted.

Their common defect is that they allow standing to attach to a pathname or broad artifact class. Git adoption cannot work that way: a file at an adopted path may later acquire candidate bytes. Parcel A already made comment-only successor changes, and B2 now changes `ma0-diseases.sh`; calling every current byte at those paths “adopted base” would immediately print another false banner.

The governing rule is:

> **Standing attaches to immutable object identities and explicit dispositions, never merely to filenames, directories, or descent from an adopted commit.**
>
> The Many Acts /0 R1 base consists of the exact coordinates named by the R1 adoption ruling. A current blob identical to an adopted blob may say that it reproduces an adopted-base byte-state. A modified descendant at the same path is a **candidate successor to an adopted base** until separately accepted or adopted.
>
> Owner rulings derive force from issuance. Historical returns, evidence, records, and candidate design documents retain the standing assigned by their own dispositions; they do not become adopted merely because they occupy the same lane.

The guide’s language clause receives this scoped replacement:

> Programs written against this guide target the owner-adopted Many Acts /0 R1 implementation base. No consolidated, frozen, and published Many Acts /0 statute or portable-conformance standard has yet been adopted. Individual owner rulings settle the questions they expressly decide; they do not silently complete that statute.

This avoids denying the broader languagehood already established for Lisp+ while refusing the separate inflation from “adopted evaluator” to “completed portable statute.”

### B2 — disease sentinel: ACCEPTED, WITH TERMINOLOGICAL CORRECTION

The implemented change from `$DISEASE_COUNT` to `$CONTROLS` is accepted.

The proposal’s phrase “repair rather than a change of behaviour” is not ratified literally: the script’s observable diagnostic output does change. The governing construction is:

> B2 is a diagnostic-output repair that changes the shell tool’s printed output while changing no witness, disease, control arm, evaluator semantics, program result, or language law.

Historical transcripts remain untouched. Five disease families and six invocations/control arms remain distinct.

### B3 — `PROVES` label: OPTION 1 ADOPTED, MODIFIED

The live tool shall print:

```text
TESTS WHETHER:
```

The ten frozen captures retain `PROVES` byte-for-byte.

Option 3 is rejected because copying the current `capture.sh` would not preserve “the exact byte-state that produced the captures”: Parcel A has already changed its prospective commentary. A replica wearing the old script’s coat is not the old script.

The divergence must be recorded in the live script header, the Parcel-B execution return, and the supersession registry ordered under B4. Do not modify the ten captures or claim that an exact producing instrument was recovered.

### B4 — returned reports: OPTION 3 ADOPTED

Create `MANY-ACTS-0-SUPERSESSIONS.md`.

Returned reports and frozen observations remain byte-untouched. The registry shall be append-only: corrections to an existing registry entry are made by a new correcting entry, not by silently rewriting the old row.

Its initial entries must cover, at minimum:

* selftest `159 → 200`;
* teeth `9 → 15`;
* concordance `4 × 18 = 72 → 7 × 18 = 126`;
* historical disease sentinel `5 controls clean → 6 controls clean`;
* the B3 live-tool label divergence.

Each entry must name the exact historical artifact and locus, the statement as written, the governing instrument, and the current governing statement. Do not describe the modified live `ma0-diseases.sh` as though it still contains the old sentinel.

### B5 — `V-ATOMS`: OPTION 3 ADOPTED

`V-ATOMS` remains a non-observable umbrella, not a refusal code.

The grammar shall distinguish:

* **OBSERVABLE** names: emitted as `ma0-result-refusal-code`;
* **UMBRELLA** names: group several rules and are never emitted.

At /0, `V-ATOMS` is an umbrella over the relevant `V-DATA`, `V-PKG`, and `V-SHAPE` obligations. No code is minted, retired, or re-emitted.

One proposal-document statement is explicitly not ratified: B5 first reports `V-RES-AUTH` at one emission site and later calls it “3 emissions.” The execution return must use mechanically derived terminology—emission sites, code occurrences, and prose references must not impersonate one another. This correction changes no law.

### B6 — matcher concordance: OPTION 2 ADOPTED, SCOPED TO /0

No matcher-level comparator is required for the Many Acts /0 claim ceiling.

The unwitnessed phrase that MA0’s matcher “mirrors Surface /2’s” must be removed. The lane may state its own closed matching law and its own witnesses; it may say the design was informed by similar principles, but it may not claim comparative agreement or equivalence.

This does not prohibit a future comparator. Any future cross-lane equivalence, portability, or shared-matcher claim must reopen the question and earn its own bounded evidence.

### B7 — export census: AMENDED OPTION 1 ADOPTED; SEPARATE ROUND REQUIRED

A count-and-boundness gate is insufficient. Replacing one export with another preserves the number 38 and may leave every export bound.

The authorized gate must enforce the **exact export set**:

1. The expected set is the exact set of 38 external symbol names in `package.lisp` at the adopted R1 coordinate.
2. The set must be materialized as an independent, sorted expected-name table—not derived at runtime from the same package being tested.
3. The gate compares exact set equality and prints missing and unexpected names.
4. Every expected export must be bound in its explicitly designated sense: function, variable, condition class, structure type, or other declared public category.
5. Teeth must demonstrate detection of:

   * an unexpected export;
   * a missing or substituted export;
   * an unbound expected export.
6. `38` is the derived cardinality of the adopted exact set, not a substitute for checking identity.

This is new code and new same-author evidence. It must therefore be implemented as a separate **MA0 Export Census /0** return, not smuggled into the documentary execution packet and not bundled with PortJ work.

### B8 — Rider citation: CLOSED BY PRIOR RULING

Owner Ruling 3 already settled the matter:

* D5 is governed by Rider 2.
* “Rider 3” in Owner Ruling 2 §5 item 8 was clerical.
* Parcel A followed the intended rider correctly.

No earlier ruling is edited.

## 4. Integration authorization

Subject to the bundle condition in §1, integrate `7643d7aa…` into `many-acts-0-candidate`, preserving provenance.

That integration accepts:

* B2’s diagnostic repair;
* the Parcel-B proposal and return documents as historical candidate filings;
* the gate and RED/GREEN transcripts as same-author provenance.

It does **not** adopt the unchosen proposal language inside those filings. Owner Ruling 6 governs wherever a proposal differs from this disposition.

After integration, record a serial readback of the existing five gates. P4 remains a rerun; its missing first-run exit is not repaired by another green execution.

## 5. Required successor returns

Two returns must remain separate:

1. **Parcel B execution return**

   * implements B1, B3, B4, B5, and B6;
   * carries the B5 count/terminology correction;
   * proves every historical capture and filed ruling byte-untouched;
   * classifies current lane files by exact blob identity against the adopted coordinates;
   * runs the existing gates without changing their expectations merely to obtain green.

2. **MA0 Export Census /0**

   * implements B7’s exact-set and boundness gate;
   * includes planted-fault transcripts before the clean transcript;
   * states only the bounded branch-specific result;
   * earns no portability or independent-implementation claim.

They must not be bundled together.

## 6. Final disposition

* Parcel B return: **ACCEPTED**
* B2 repair: **ACCEPTED**
* Eight-item hearing: **CLOSED**
* Current tip: **CONDITIONALLY MERGEABLE**
* Parcel B execution: **OPEN**
* MA0 Export Census /0: **AUTHORIZED, UNBUILT**
* S-freeze: **NOT REACHED**
* Evidence earned by Parcel B: **ZERO**
* Hidden bank and J2: **CLOSED**
* PortJ-F/0: **CLOSED**
* PortJ/0 Round A: **still open under its existing jurisdiction**
* PortJ/0 Round B: **not opened by this ruling**

The parcel did its real job: it brought the undecided things to court without deciding them in the hallway. The bench has now answered—but the bailiffs still have two separate sets of furniture to move.
