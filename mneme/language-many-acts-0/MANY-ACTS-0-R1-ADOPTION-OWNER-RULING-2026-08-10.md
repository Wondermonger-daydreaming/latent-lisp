# MANY ACTS /0 R1 — ADOPTION OWNER RULING (2026-08-10, filed verbatim)

**Filed verbatim by the chair (Claude Fable 5) from the owner's direct message,
2026-08-10, per the ruling's own execution step 1. Append-only; the owner's words
below are unedited.**

---

Fable—

Round 0 is complete.

# Owner disposition — Many Acts /0 R1

## ADOPTED WITH RIDERS

The Many Acts /0 R1 membrane repair, as returned in parcel:

> `many-acts-0-r1-return-parcel-2026-08-10.tar.gz`

with SHA-256:

> `54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`

is **OWNER-ADOPTED** as the governing repaired Many Acts /0 base, subject to the claim ceilings and riders below.

This adoption covers:

* R1 predecessor `76952ea4f278d269f98f158555e412a095a3da6f`;
* transport patch SHA-256 `913a1c9bd1158c855cca6f68f065af9228130cc9fa3c2bb374fb1fc364f20998`;
* the four ruled membrane repairs D1–D4;
* the D5 generation-seam repair and printer closure;
* product freeze lane subtree `e94870bd9091e67f68e9cf238a6c5d0dcf302a05`;
* P4 holdout commit `ef98ede12021889753babb6d368b218689cf311d`;
* R1 return commit `e170e1d680b273e7906d1edd2b352cfb7aede458`;
* return lane subtree `dd2a7a0aa36d6ddabfb6b66c569260bbc73edab7`;
* the seven registered R1 findings, including the findings that constrain rather than flatter the result.

The product freeze and the evidence additions retain different roles:

* `e94870bd…` is the frozen repaired product surface against which P4 was opened;
* P4 and the R1 return are post-freeze evidence/provenance additions;
* their presence does not retroactively move the product freeze.

## Audit record

The owner-side audit established:

1. The tarball’s SHA-256 exactly matches the declared `54aa7783…` identity.
2. The external sidecar agrees.
3. The internal `MANIFEST.sha256` authenticates `MANIFEST.md`.
4. Every one of the manifest’s 85 listed files passed its recorded digest.
5. The 37-file patch is internally reversible and re-applicable:

   * reverse check: green;
   * reverse application: green;
   * forward check: green;
   * forward application: green;
   * final supplied lane versus round-tripped lane: byte-identical;
   * mechanical patch size: +3,837/−91.
6. D1–D5’s preserved red transcripts and post-repair green transcripts match their reported transitions:

   * D1: `0 owned / 6 defects` → `6 owned / 0 defects`;
   * D2: `2 closed / 2 defects` → `4 closed / 0 defects`;
   * D3: watchdog exit 124 → `6 closed / 0 defects`;
   * D4: `0 closed / 4 defects` → `4 closed / 0 defects`;
   * D5: `40 closed / 3 defects` → `43 closed / 0 defects`.
7. The two selftest output bodies—not their timestamped transcript wrappers—are byte-identical:

   * 23,372 bytes each;
   * SHA-256 `6f03877ef080c50d973bc2a164025131b4cb105dc836da3f4f8713ba4cf6d7d0`;
   * 200 checks / 0 failures.
8. Static examination corroborated:

   * 53 `ma0-check` sites with loop expansion to the declared 200;
   * 15 teeth sections;
   * seven arms;
   * eighteen facets per arm;
   * 126 concordance comparisons;
   * five named diseases exercised through six disease invocations.
9. P4’s first-run transcript is preserved honestly:

   * it ends with `ma0-p4-holdout: 11 checks, 0 failures`;
   * it does not record the process exit code;
   * the source’s next and final operation is `uiop:quit`, parameterized by the displayed failure count;
   * the separate rerun records exit 0.

This audit did **not** rederive the Git object graph from repository objects and did not rerun the SBCL witnesses. The parcel intentionally contains no repository bundle or predecessor stack, and the audit environment carries no SBCL installation. Git identities beyond the supplied artifact remain chair-reported until rederived during adoption execution.

Nothing here may be called independently verified, independently validated, stranger-audited, or independently reproduced.

## Rider 1 — Exact R1 claim

The adopted claim is:

> A same-author, post-R1-freeze holdout program was expressible through the repaired Many Acts /0 candidate authoring surface without evaluator modification.

P4 additionally supplied a first-execution transcript with 11 checks and 0 failures.

The following are not licensed:

* “P4’s first-run exit code was captured as 0”;
* stranger inhabitation;
* independent inhabitation;
* guide-only semantic transmission;
* independent implementation;
* open-ended authoring;
* unrestricted domain generality;
* multi-environment orchestration;
* transactionality or crash resumability.

P4 remains evaluator-genericity/post-freeze-extension evidence. It is not an IH0 specimen.

## Rider 2 — D5 construction-failure scope

The generation-seam result earns **property 2 under the /0 public-API threat model**:

> Generation installation occurs only after every specified or project-level fallible construction step exercised by the public API has succeeded.

The D5 instrument tested six public construction-failure modes and found exactly one capable of crossing the old seam. The repair moves ownership and other specified fallible operations above the commit point.

The prose sentence:

> “Nothing below this line can signal”

is too absolute if read as a claim about arbitrary host-resource exhaustion, asynchronous process termination, or failure of memory allocation itself. `%make-ma0-environment` still allocates a structure below the declared commit line.

Therefore the adopted interpretation is:

> No specified Lisp+ refusal or ordinary project-level failure path remains below the commit point under the /0 public-API threat model. Host exhaustion, process death, asynchronous interruption, and failures outside that threat model are not covered.

This is a claim-ceiling correction, not a demand to reopen the frozen implementation. Parcel A must replace or qualify the absolute prose wherever it appears prospectively. Historical transcripts and evidence remain byte-unaltered.

A later hardening round may choose to allocate the environment object before committing the generation and five specials, but R1 does not require that additional host-failure guarantee.

## Rider 3 — D2 and the sealed binding law

R1-F3 is adopted exactly:

* sibling alternatives receive independent visibility tables;
* the cumulative defined-name table spans the entire program;
* the same identifier may not be defined independently in two alternatives;
* such reuse is refused by V-BIND;
* there is no post-branch binding position because every alternative terminates and V-TERM refuses subsequent steps.

Any future proposal to allow same-name definitions in distinct alternatives is grammar growth. It is not a correction to R1.

## Rider 4 — D3 source-tree law

The R1/D3 repair adopts the rule:

> A lawful Many Acts /0 source is a tree.

Both cycles and acyclic shared cons structure are refused with V-SHAPE. This is not merely an implementation shortcut: it preserves the relationship between the declared source-node bound and the ownership copier’s actual allocation.

This rule governs already-read host forms as well as textual source after reading.

## Rider 5 — Store identifiers

R1-F5 remains binding:

> A store-id is a content-derived label, not an installation identity and not a discriminator between distinct store instances.

Two distinct stores may lawfully share the same store-id. Environment currency is determined only by the private image-local generation.

No later document may infer instance identity from store-id equality or inequality.

## Rider 6 — Evidence language

The five pre-repair transcripts remain preserved even though the initial brief expected four. D5’s later red is part of the actual repair history.

The D5 witness header describes the defect class in the same language in both red and green captures. Its green tally governs the post-repair result; the repeated “PROVES … reachable” header must not be quoted as though the repaired version still exhibits the defect. Parcel A may revise the prospective fixture commentary from “PROVES” to “TESTS WHETHER,” but historical transcripts remain untouched.

The disease inventory must continue distinguishing:

* five named diseases;
* six disease invocations/pairs.

Neither count should be silently substituted for the other.

## Adoption execution

Prepare and execute a bounded R1 adoption path that excludes every later PortJ/0 candidate artifact.

Do not merge the current candidate-branch head wholesale. The branch now contains later court-construction material that this ruling does not adopt.

The adoption execution must:

1. File this ruling verbatim.
2. Re-derive all full Git coordinates locally:

   * predecessor;
   * freeze commit and lane subtree;
   * P4 commit;
   * return commit and lane subtree;
   * ancestry between them.
3. Fail closed if any rederived coordinate differs from this ruling or the authenticated parcel.
4. Re-run the mandatory adoption gates serially from the exact R1 return state:

   * selftest twice;
   * byte-identity of output bodies;
   * full teeth;
   * P3;
   * P4;
   * One Act 173;
   * applicable release/readback floor;
   * V-F digest.
5. Preserve the missing P4 first-run exit code as missing.
6. Create the R1 adoption record and receipt.
7. Integrate only the bounded R1 range and its adoption record into main through the established non-destructive merge protocol.
8. Exclude PortJ/0 candidate commits and artifacts from the R1 semantic adoption.
9. Push only after the ancestry, tree, and gate checks pass.
10. Record private-origin and mirror publication/readback separately. An unreached mirror is not publication and must remain reported as unreached.

Suggested record name:

> `MANY-ACTS-0-R1-ADOPTION-RECORD-2026-08-10.md`

Return the adoption commit, merge commit, main tree, published lane subtree, complete gate results, and readback receipt.

## Consequences for the PortJ/0 schedule

Once the R1 adoption receipt is sealed:

* Round 0 is complete;
* Round A may open;
* F-GUIDE-2 enters Parcel A because its governing continuation rule has acquired adopted standing through R1;
* Round B remains after Parcel A;
* Rounds P and OA continue independently as already authorized;
* hidden-bank authoring and J2 issuance remain closed until S-freeze.

R1 repairs the membrane. It does not complete the public statute book. The twenty-eight-place semantic-extractability finding remains standing and now becomes the agenda for the documentary and constitutional rounds rather than an ambiguity about which base they govern.
