STRANGER-AUDIT RETURN — Language Form /0, Candidate /0
Seat: independent auditor (no prior lab corpus). Authored figures only.
Overall verdict: FINDINGS — CANDIDATE REMAINS CONTINUABLE

================================================================================
1. EXACT TARGET COMMIT AND TREE
================================================================================

Declared (packet / FORM0-AUDIT-TARGET-IDENTITY.txt; not network-reconfirmed):

  public commit   5ed23c7d5f768d8e8f13c83842f572cf563270d3
  root tree       e0950634a7b0791ea58db2463928f6a4e68a6521
  subject tree    a0941e749cf0fb23de74de811ca69e1447d397c1
                  (mneme/language-form-0/ at 5ed23c7 — interested-party note)

Audit subject path: repository/mneme/language-form-0/
  (16 entries: package.lisp, form0.lisp, form0-selftest.lisp,
   PUBLIC-SURFACE-AUDIT.lisp, EXPORT-CENSUS.md, MUTATION-LEDGER.{md,sh},
   LANGUAGE-FORM-0-{CLOSURE,RETURN,RULINGS,WORK-ORDER}.md,
   CHAIR-REVIEW-RESPONSE-1.md, RETURN-CHAIR-REVIEW-{1,2}.md,
   SUMMARY-AND-OPEN-QUESTION.md, de-forma-dormiente/)

Runtime: SBCL 2.4.6 (confirmed via `sbcl --version`).

Workspace harness: target/ read-only; writable experiments under scratch/;
scratch/repository is a full writable copy of the published tree.

================================================================================
2. TRANSPORT VERIFICATION
================================================================================

Confirmed locally:
  - `sha256sum -c` on target/SHA256SUMS.txt → exit 0 for all listed members
    (3875 OK lines; header comment words are not file entries).
  - Packet body and repository tree checksums match the shipped SUMS file.
  - No writes possible under target/ (PUBLIC-SURFACE-AUDIT failed Permission
    denied on EXPORT-CENSUS.md when run RO — expected; regen used scratch/).

Not confirmed (out of reach in this seat):
  - Fresh network clone of github.com/Wondermonger-daydreaming/latent-lisp
    at 5ed23c7 and tree-hash e0950634… (offline / no clone capability here).
  - therefore lab↔public content equivalence in identity file §§2–3 remains
    ATTACHED CLAIM BY AN INTERESTED PARTY, not stranger-verified.
  - No repository/.git in the packet; local rev-parse impossible.

PREFLIGHT-TRANSCRIPT.txt was kept unread until own tallies were complete;
its figures were not used as authority.

================================================================================
3. INSTRUMENT-PREFLIGHT FINDINGS (PASS A) — A1–A10
================================================================================

A1. Floor runners execute the floors they claim
  STATUS: HOLD (form floor complete; language/all complete by source + run).

  verify-form-floor.sh: ROOT=dirname(script); three check_floor invocations only
    → language-form-0/form0-selftest.lisp
    → language-form-0/de-forma-dormiente/APPLICATION.lisp
    → language-form-0/PUBLIC-SURFACE-AUDIT.lisp
  Hardcoded VERDICTS path matches exactly those three loads.
  Independent direct loads of those three from scratch matched runner PASS lines.

  verify-language-floor.sh: 11 check_floor calls (source-read); each entry file
  exists and was independently loaded (see A2).
  verify-all.sh: 6 suites as scripted; each independently loaded.

A2. Recompute counts from raw verdicts
  STATUS: HOLD. Aggregates re-derived by summing parts.

  Form floor (raw counters calibrated per format):
    form0-selftest     152 × `^  ok   `          banner 152; rc=0
    de-forma-dormiente  24 × `^  ok   ` / checks  banner 24;  rc=0
    public-surface      23 × `^  ok   `          banner 23;  rc=0
    sum                 199 = runner “FORM FLOOR GREEN — 3 floors, 199 checks”

  Language floor (direct suite loads under scratch/repository/mneme):
    core0-substrate     29 × `^  ok   `     banner 29
    core0-issuance      73 × `^  ok   `     banner 73
    slice1-selftest    123 × `^  ok   `     banner 123
    slice1-smoke         9 × `  [N] PASS`   banner 9/9
    de-bibliotheca     123 × `^  ok   `     banner 123
    de-codice          101 × `^  ok   `     banner 101
    de-cursore-aereo    23 × `^  ok   `     banner 23
    de-ponte-usto       17 × `^  ok   `     banner 17
    slice2-selftest    108 × `^  ok   `     banner 108
    slice2-smoke        10 × `  [ N] PASS`  banner 10/10
    surface0-selftest   38 × `^  ok   `     banner 38
    arithmetic sum     654 = runner “LANGUAGE FLOOR GREEN — 11 floors, 654 checks”
    (NOTE: language-floor total is sum of EXPECT_* table constants on green path;
     independent raw counts match every EXPECT cell.)

  verify-all suites (independent):
    conformance-walk         7 × `✓`                 rc=0
    adversarial-conformance  banner “=== 18 passed, 0 failed ===”  rc=0
    counterexample-closure   banner “=== 10 passed, 0 failed ===”  rc=0
    boundary                 banner “=== 9 passed, 0 failed ===”   rc=0
    atelier                  4 matching pass-banners               rc=0
    language-a-fixtures     14 × `PASS ` + 1 × `SUITE PASSED`     rc=0
  Runner reported 6/6 green — matches.

A3. Displayed identity abbreviations vs complete identities
  STATUS: HOLD with documented caveat (not a silent collapse in the shipped
  inhabited display).

  Observed on a live phase chain (public API; scratch probe logs/a3 via pass-b):
    - bare head-16 of hex identities: 3 collapse groups among distinct full IDs
    - bare tail-16: 1 collapse group
    - dormiente short() = head-24 + "(len)": distinct(full)=distinct(short)=10
      on the same sample (discriminates)

  de-forma-dormiente/APPLICATION.lisp implements `short` with length suffix and
  `check-abbreviations-discriminate` on the phase ledger. Comments there explicitly
  name the head/tail-16 collapse hazard.

  Finding class: declared limitation / documentation of a known display hazard.
  No evidence the climax layer *compares* abbreviated displays for lawfulness;
  phases compare full strings / CD0 equality.

A4. Regenerate export census
  STATUS: HOLD.
  PUBLIC-SURFACE-AUDIT.lisp under scratch/repository/mneme/language-form-0:
    rc=0; 23 ok; 99 external symbols; delivered EXPORT-CENSUS.md
    diff vs pre-regen committed copy: EMPTY (byte-identical).

A5. Every export external; every disposition real
  STATUS: HOLD (both directions).
  Independent live `do-external-symbols` on :LISP-PLUS-FORM0 after loading
  package.lisp+form0.lisp: 99 names.
  Parsed EXPORT-CENSUS.md name column: 99.
  set-difference both ways: empty.
  Disposition histogram from census cells: reader 67, predicate 10,
  protocol-constant 1, condition 1, grammar-constructor 7, transition 4,
  constructor 3, package-owned-operator 2, transition-try 4 (sum 99).
  Bound-status walk: 0 external symbols neither fbound nor bound.
  No refuge for reverse mismatches found.

A6. Regenerate mutation ledger
  STATUS: HOLD.
  bash MUTATION-LEDGER.sh from scratch copy: rc=0; killed=10 survived=0.
  Regenerated MUTATION-LEDGER.md byte-identical to committed copy.

A7. Each mutant actually changed intended source
  STATUS: HOLD for apply.
  Applied-check is `diff form0.lisp` OR `diff package.lisp` (script lines 31–36).
  Every mutant in this battery edits form0.lisp (incl. restore-arbitrary-handler
  append). Manual re-run: all 10 showed non-empty form0.lisp diff vs source
  (diffstat line counts 11–12); zero “MUTATION DID NOT APPLY”.
  Sufficiency note: applied-check would miss a mutant that only edited
  form0-selftest.lisp or PUBLIC-SURFACE-AUDIT.lisp; current battery does not
  plant such mutants. The historical /tmp invalid battery failure mode is
  addressed (mutants live at mneme/_mut-<name>/ so ../../canonical-datum resolves).

A8. Four-way classification per mutant (do not collapse to exit code)
  STATUS: DISTRIBUTED — 10/10 nonzero exit, but teeth not uniformly demonstrated.

  | mutant                    | applied | exit | classification                          | marker |
  |---------------------------|---------|------|-----------------------------------------|--------|
  | no-species-check          | yes     | ≠0   | intended tooth reached                  | FAIL T-WRONG-SPECIES (no refusal) |
  | two-pass-substitute       | yes     | ≠0   | intended tooth reached                  | FAIL T-ONE-PASS (×3) then later CD0 abort |
  | no-env-identity-gate      | yes     | ≠0   | intended tooth reached (with caveat*)   | FAIL T-SAME-LOOKING-DIFFERENT-ENVIRONMENT but expected :ENVIRONMENT-IDENTITY-DRIFT, got :ENVIRONMENT-CONTENT-DRIFT |
  | no-content-digest-gate    | yes     | ≠0   | intended tooth reached                  | FAIL T-ENVIRONMENT-CONTENT-DRIFT (no refusal) |
  | boundary-accepts-host     | yes     | ≠0   | killed elsewhere (at tooth site)        | Unhandled CD0-FAILURE during T-HOST-SYMBOL-REFUSED path; no `FAIL` line |
  | unfilled-hole-allowed     | yes     | ≠0   | killed elsewhere (at tooth site)        | Unhandled CD0-FAILURE inside T-UNFILLED-HOLE try-instantiate; no `FAIL` line |
  | no-arity-gate             | yes     | ≠0   | intended tooth reached                  | FAIL T-OPERATOR-ARITY (no refusal) |
  | literal-descends          | yes     | ≠0   | killed earlier — tooth UNDERSPECIFIED   | CD0-FAILURE before any T-ONE-PASS marker; tooth_mentioned=no |
  | no-snapshot               | yes     | ≠0   | intended tooth reached                  | FAIL T-SNAPSHOT-IS-INDEPENDENT |
  | restore-arbitrary-handler | yes     | ≠0   | intended tooth reached (surface suite)  | FAIL “5. MAKE-OPERATOR-DESCRIPTOR does not exist” |

  *Caveat no-env-identity-gate: disabling the environment-identity `unless`
  still kills at the *named* tooth because the content-digest gate fires first
  with a different code. The tooth line fails (expected identity-drift, observed
  content-drift). That is evidence the env-identity gate is *redundant with*
  content drift on this particular planted scenario, not pure single-gate bite.

  Headline “10 planted, 10 killed” is true and weak. Evidential distribution:
    intended tooth with named FAIL:     7 (of which 1 wrong residual code)
    killed at-/near-tooth but abort:    2 (boundary-accepts-host, unfilled-hole)
    died earlier / undemonstrated tooth: 1 (literal-descends)
    invalid/no-op:                      0
    survived:                           0

  Classification: instrument/reporting limit of the battery (what it establishes),
  not a semantic defect of Form /0. Teeth for host-boundary, unfilled-hole, and
  the literal-descends variant of one-pass remain only partially /
  not demonstrated *by those mutants*.

A9. Packet/target vs declared public commit
  STATUS: PARTIAL — local checksum OK; public half out of reach.
  SHA256SUMS for repository/ holds. No network clone; no .git. Treat identity
  §§2–3 as attestation. Subject tree hash a0941e74… not independently hashed
  via `git rev-parse` here.

A10. Publication hooks
  STATUS: DECLARED LIMITATION — out of reach.
  Hooks live lab-side; absent from public tree per design. Content-message of
  auto-sync ≠ content equivalence. No claim of verified or broken topology.

PASS A GATE: instruments are trustworthy enough to support Pass B.
  Caveats carried forward (battery distribution; network identity; A3 bare prefixes)
  do not launder semantics.

================================================================================
4. SEMANTIC FINDINGS (PASS B) — B1–B14
================================================================================

Method: concrete public-API programs in scratch (logs/pass-b.out), 59 local
probes, 0 FAIL. Attacks attempted; where stopped, stop site recorded.
No paraphrase of CLOSURE substituted for a program.

B1 Phase separation / immutability after derive
  Disposition: UPHELD (for exercised cases).
  Distinct proposed / instantiated / validated / realization-receipt objects
  and distinct phase content identities. Mutating the caller’s binding cons
  cells after instantiate-form did not change stored subject identity
  (snapshots at fill). No public MAKE-VALIDATED-FORM.
  Not exhausted: every possible setter on every slot (structs use :copier nil
  and read-only slots; not re-proved exhaustively beyond public surface).

B2 Subject identity template→closed across chain
  Disposition: UPHELD.
  template subject = proposed subject retained as template-subject-identity;
  closed subject differs after instantiate; closed stable through validate and
  realization receipt subject field.

B3 Phase-object id ≠ subject id; context commitment
  Disposition: UPHELD.
  For proposed/instantiated/validated: phase-id ≠ subject-id.
  Predecessor links: inst→prop, val→inst, realization.validated→val all match.
  No found pair of phase objects with equal phase identities and unequal contexts
  in the exercised construction.

B4 Public API cannot mint validated form or receipt
  Disposition: UPHELD (export surface + constructor absence).
  External dump excludes MAKE-VALIDATED-FORM, MAKE-FORM-VALIDATION-RECEIPT,
  MAKE-FORM-REALIZATION-RECEIPT, %MAKE-* of those, MAKE-OPERATOR-DESCRIPTOR.
  Same-image internals via :: remain host power (threat model; B13).

B5 No arbitrary handler injection; MAKE-FORM-ENVIRONMENT package-owned only
  Disposition: UPHELD for public construction.
  Host function in :operators → form-refused / error, no env.
  Operator name "perform" at construction → refused.
  Symbol MAKE-OPERATOR-DESCRIPTOR not present in package.
  Mutant restore-arbitrary-handler is killed by PUBLIC-SURFACE-AUDIT tooth 5.

B6 Same built-ins cannot diverge publicly
  Disposition: UPHELD for identical public construction.
  Two make-form-environment+seal with same name/version/ops/holes:
  equal content digests; realize-form yields CD0-equal results.
  (Different names yield different env identity/digest — by design.)

B7 Five independent rechecks at realization
  Disposition: PARTIALLY ESTABLISHED (three independent public hits + two
  structural non-mutability arguments).

  Concrete try-realize-form attacks:
    different env name (same ops) → :ENVIRONMENT-IDENTITY-DRIFT   [hit]
    version 99 same name             → refusal at realize (member of
                                       version-drift / identity-drift /
                                       content-drift family)            [hit]
    fewer operators, same name/ver   → :ENVIRONMENT-CONTENT-DRIFT   [hit]
  Grammar identity: package constant via grammar-identity(); no public
    constructor installs a foreign grammar — cannot publicly fork it. [structural]
  Budget id: public constructor always "cd0-conformance-default"; no key to
    diverge it.                                                       [structural]
  Operator-identity re-resolution exists in realize-form source and is also
  covered when the operator set changes (content digest fires first).

  Gap (honest): five *independent* residual codes for all five dimensions are
  not each distinctively driven via public-only knobs, because grammar and
  budget are not publicly divergent. This is alignment with the design, not a
  counterexample, but it limits what a stranger can demonstrate without
  planted internal faults.

B8 Hole fillings are data, not code
  Disposition: UPHELD for nested/self-referential shape exercised.
  Filled :sequence hole with a hole-node tree; admitted; realized via
  sequence-length as integer 2 (head+name), not recursive hole expansion.

B9 Five binding refusals
  Disposition: UPHELD with one coding nuance.
  undeclared-hole, unfilled-hole, duplicate-binding, wrong-species: exact codes.
  “extra” binding (third name on a two-hole form): refused; residual code on
  this path was accepted as member of {:EXTRA-BINDING, :UNDECLARED-HOLE}.
  In the exercised order, undeclared/extra may share residual vocabulary —
  both refuse. Not double exertion of a silent allow path.

B10 PERFORM named but not installed
  Disposition: UPHELD (load-bearing demo).
  operator-node "perform" + literal → propose-form succeeds (structural admit);
  instantiate ok; try-validate-form → nil + :UNKNOWN-OPERATOR.
  No public path installs PERFORM.

B11 Refusals inspectable after later success; datum retained
  Disposition: UPHELD.
  try-propose-form of bare integer refused with offending datum + identity +
  detail; subsequent lawful propose-form succeeds; prior refusal fields unchanged
  and still hold the offending CD0 datum.

B12 Form /0 mints nothing
  Disposition: UPHELD for export surface + realization return types exercised.
  No external MINT / MINT-CAPABILITY / ESTABLISH-SOURCE-BASIS / GRANT /
  MAKE-WARRANT / MAKE-AUTHORITY / MAKE-CLAIM.
  realize equal-datum → boolean CD0 datum + form-realization-receipt (data
  account). Not a warrant type.

B13 Threat model honesty
  Disposition: UPHELD on the documents read.
  LANGUAGE-FORM-0-WORK-ORDER.md §0:
    “Package-controlled operator installation is a PUBLIC-API ENFORCEMENT
     BOUNDARY. It is not process isolation and not a hostile-host sandbox.”
  LANGUAGE-FORM-0-CLOSURE.md header crosses to that threat model and denies
  isolation reading. SUMMARY-AND-OPEN-QUESTION.md certifies same.
  No sentence found that upgrades the boundary to process isolation.
  Classification if later found: documentation defect — none found this pass.

B14 Bounded recursion contingent, not structural
  Disposition: UPHELD as documentation honesty.
  WORK-ORDER § entrance gate for Form /1 explicitly: identities accepted “only
  because the phase chain has a statically bounded depth… Measured: 440 → …
  → 26020 characters.” GATE forbids unbounded phase history embedding full
  predecessor strings before Form /1. Not advertised as a general recursion bound.

================================================================================
5. EXACT COMMANDS AND OBSERVED COUNTS
================================================================================

Environment (each run_command is a fresh bash -c):
  export PATH="…/scratch/.local/bin:/home/gauss/.local/sbcl-2.4.6/bin:$PATH"
  sbcl → SBCL 2.4.6
  cwd bases: scratch/repository/mneme/… or scratch/

Form floor independent:
  (cd language-form-0 && sbcl --non-interactive --load form0-selftest.lisp)
    → 152 ok, banner 152, rc=0   log: scratch/logs/form0-selftest.raw
  (cd language-form-0/de-forma-dormiente && sbcl --non-interactive --load APPLICATION.lisp)
    → 24 ok, banner 24, rc=0     log: scratch/logs/dormiente.raw
  (cd scratch/.../language-form-0 && sbcl --non-interactive --load PUBLIC-SURFACE-AUDIT.lisp)
    → 23 ok, 99 externals, rc=0  log: scratch/logs/public-surface.raw
  bash mneme/verify-form-floor.sh → FORM FLOOR GREEN 199  (logs/verify-form-floor.out)

Language floor independent suite dir: scratch/logs/lang-raw/*.raw
  raw counts as A2 table; verify-language-floor.sh → 654 (logs/verify-language-floor.out)

verify-all independent: scratch/logs/all-raw/*
  7 / 18 / 10 / 9 / 4 banners / 14 PASS+SUITE
  verify-all.sh → 6/6 (logs/verify-all.out)

Census regen: PUBLIC-SURFACE-AUDIT on scratch tree; EXPORT-CENSUS.md diff empty.

Mutation:
  (cd scratch/.../language-form-0 && bash MUTATION-LEDGER.sh)
    → killed=10 survived=0; MUTATION-LEDGER.md byte-identical
    log: scratch/logs/mutation-ledger.run.out
  Manual four-way class logs: scratch/logs/mutants/<name>.out

Export walk: live 99 ↔ census 99 (logs/a5-export.out)

Pass B: logs/pass-b.out → “PASS-B totals: 59 ok / 0 fail”, rc=0

Transport: sha256sum -c target/SHA256SUMS.txt → OK.

================================================================================
6. REPRODUCIBLE WITNESSES FOR DEFECTS / LIMITS
================================================================================

No semantic or public-API defect counterexample succeeded. مؤ

Instrument / battery limits (witnessed):

W1. literal-descends mutant
  Witness: scratch/logs/mutants/literal-descends.out
  CD0-FAILURE before any T-ONE-PASS FAIL line; tooth_mentioned=no.
  Classifies as “killed earlier”; T-ONE-PASS not demonstrated by *this* mutant
  (two-pass-substitute does demonstrate T-ONE-PASS separately).

W2. boundary-accepts-host mutant
  Witness: scratch/logs/mutants/boundary-accepts-host.out
  Dies with Unhandled CD0-FAILURE on try-propose-form of host symbol PERFORM
  after the datum-p gate is neutered; suite never prints `FAIL T-HOST-…`.
  Kill is real; residual path is CD0, not the Form /0 refusal tooth text.

W3. unfilled-hole-allowed mutant
  Witness: scratch/logs/mutants/unfilled-hole-allowed.out
  CD0-FAILURE at TRY-INSTANTIATE for partially filled bindings after unfilled
  guard is neutered; no `FAIL T-UNFILLED-HOLE` line.
  Kill real; tooth text not the reporter.

W4. no-env-identity-gate residual switch
  Witness: scratch/logs/mutants/no-env-identity-gate.out
  Universe: FAIL T-SAME-LOOKING-DIFFERENT-ENVIRONMENT with
  expected :ENVIRONMENT-IDENTITY-DRIFT, got :ENVIRONMENT-CONTENT-DRIFT.
  Named tooth fails 고, but for the sibling gate. Shows dual-gate coupling.

W5. Naive abbreviation collapse (display hazard)
  Witness: logs/pass-b.out A3 section — head16-collapse-groups=3,
  tail16-collapse-groups=1; dormiente short discriminates full=10 short=10.
  Already documented in APPLICATION.lisp; still a live footgun if a future
  ledger compares bare prefixes.

W6. Public-network identity
  Witness: absence — no clone output; identity file §§2–3 adaptation only.

No witness for: must-not-fix phase law, must-not-inject handlers, must not mint
validated forms via public API, PERFORM-reaching-realize, selective binding allowence.

================================================================================
7. CLASSIFICATION FOR EVERY FINDING
================================================================================

F-transport-RO   instrument/environment note
  PUBLIC-SURFACE-AUDIT and MUTATION-LEDGER must run on a writable copy when
  target/ is read-only. Not an artifactamit defect.

F-battery-distribution   instrument/reporting defect (qua “N killed” headline)
  True “10/10 killed” understates that 1 tooth is undemonstrated by its mutant
  and 2 deaths are CD0 aborts rather than named Form0 FAIL lines. The ledger’s
  own `reached` column already discloses this when read; the oral headline must
  not stand alone.

F-abbreviation-naive   declared limitation (documented) when short() used;
  would be documentation defect if any shipped printer still used bare head/tail
  16 without length — dormiente does not.

F-A9-public-half   declared limitation / out of reach
F-A10-hooks        declared limitation / out of reach
F-B الند7-grammar-budget-not-publicly-forkable   declared limitation of what
  public-only recheck demos can show (not a counterexample).

Semantic defect:           none witnessed
Public-API defect:         none witnessed
Test defect:               none that falsifies a green claim of the product floor
                           (selftests that expect IDENTITY-DRIFT specifically are
                           slightly brittle to dual gates — note under F-battery)
Documentation defect:      none found on threat model / recursion gate wording

================================================================================
8. DISPOSITION FOR ADVERTISED CLAIMS B1–B14
================================================================================

  B1  phase separation / immutability ............... UPHELD
  B2  subject identity across chain ................ UPHELD
  B3  phase-id ≠ subject; context commit ........... UPHELD
  B4  public API cannot mint validated/receipt ..... UPHELD
  B5  no arbitrary handler injection ............... UPHELD
  B6  same built-ins, no public diverge ............ UPHELD
  B7  five rechecks at realization ................. PARTIALLY ESTABLISHED
       (3 public residual hits + 2 structural non-forks; not five independent
        public residual codes)
amb B8  hole fillings are data ....................... UPHELD
  B9  five binding refusals ........................ UPHELD
       (extra may share residual code with undeclared)
  B10 PERFORM structural admit, validation refuse .. UPHELD
  B11 refusals inspectable; datum retained ......... UPHELD
  B12 mints nothing .................... ........... UPHELD (surface + types)
  B13 threat model honesty ......................... UPHELD (docs read)
  B14 recursion bound contingent ................... UPHELD (docs explicit)

================================================================================
9. WHAT THIS AUDIT ESTABLISHES
================================================================================

- The shipped packet is checksum-consistent with its own SHA256SUMS and is
  executable on SBCL 2.4.6 via a writable copy.
- Form floor 199, language floor 654, and verify-all 6/6 are not banner-only:
  raw verdict formats were calibrated and re-counted; runner totals match.
- EXPORT-CENSUS.md and MUTATION-LEDGER.md regenerate byte-identically; they are‌
  present-state artifacts, not stale hand docs.
- Live package export set is exactly the census (99).
- Mutation battery applies every mutant; none survived; distribution of kill
  loci is as A8 (not a pure 10× intended-tooth story).
- Under public API attacks constructed by this seat, advertised phase, identity,
  minting-boundary, handler-boundary, binding-refusal, PERFORM, refusal-
  retention, and “mints nothing” claims held for the cases run.
- Threat-model and recursion-bound prose state their limits rather than
  over-claim isolation or general recursion safety.
- Dormiente abbreviation			
 printerales discriminate on the sample where
  bare 16-char slices collapse.

================================================================================
10. WHAT THIS AUDIT EXPLICITLY DOES NOT ESTABLISH
================================================================================

Be generous — these are the doors still open:

- Network-side identity of the public GitHub commit/tree. No stranger clone was
  possible; superin §§2–3 lab↔public equality are meantime interested-party
  claims.
- Publication hook topology (post-commit/post-merge/main-only / content verifier).
  Out of target by design (A10).
- Cryptographic strength of content digests or identity hex. Digests are
  canonical-octet hex, pedagogical as the layer itself disclaims elsewhere.
- Same-image host malice: any code with access to :: internals, SBCL debugger,
  or memory mutation can violate every “cannot” — the threat model already
  scopes to untrusted *Canonical Datum forms inside a trusted CL host*, not a
  hostile-host sandbox. This logout audit did not attempt #. / memory
  corruption / redefining internal functions via SLIME-class power.
- Completeness of the operator allowlist against every future consequential
  name. B10   
  shows PERFORM/eval/compile/load/establish-source-basis/mint-capability/derive
  are refused when named; it does not prove a closed taxonomy of all dangerous
  names for-all time.
- Five fully independent *public* residual meanings for B7’s five dimensions;
  grammar and budget are not forkable via the public constructor.
- That every selftest tooth is demonstrated by its mutation (A8: literal-descends
  undemonstrated by mutant; host-boundary and unfilled-hole die as CD0 aborts).
- Conformance of Form /0 to any external standard, prior law, or Slice/Core
  obligation beyond self-consistency. Language floor banners themselves disclaim
  “SELF-CONSISTENCY CERTIFICATION, never independent conformance.”
- Behavior under concurrent mutation, multi-threaded hosts, non-SBCL Lisps,
  or non-2.4.6 SBCL.
- Persistence, serialization round-trips, cross-image receipt carriage, or
  crash survival for form objects (not claimed).
- That inhabited applications (bibliotheca, codice, …) prove anything about
  external deeds — each suite labels adapters as scripted fakes; this audit
  did not re-open those claims.
- Adoption, freeze, or fitness for Form /1 / Slice Z3. Explicitly not granted.
- Whether DETERMING a future trusted-extension lane without reinventing a new
  entry point  is possible — SUMMARY flags this as an open reading hazard; not d
  smoke-tested.
- Full adversarial reading of every prose file outside WORK-ORDER/CLOSURE/
  SUMMARY/RULINGS for soft isolation over-claims; primary threat wording was
  checked; the long archive of prior-arc evidence was not line-audited.
- That «green» floors written by the same model family as the implementation
  constitute external corroboration. They  do not. This seat is that missing
  independent check, and still only covers Candidate /0 as exercised here.

================================================================================
OVERALL VERDICT
================================================================================

  FINDINGS — CANDIDATE REMAINS CONTINUABLE

Rationale: no reproducible semantic or public-API counterexample against
B1–B14’s core claims was obtained. Remaining findings are instrument/battery
distribution honesty, display-abbreviation footguns already mitigated in the
inhabited printer, and declared out-of-reach items (publish hooks, network
identity). Those justify "FINDINGS" rather than a clean "NO REPRODUCIBLE
FINDING" and do not rise sink to "REPAIR REQUIRED BEFORE FURTHER DEPENDENCE."

Auditor authority ends here. No patches proposed. No adoption/freeze/merge
advice. Prefer this over a polite false close.

— end stranger-audit return —
