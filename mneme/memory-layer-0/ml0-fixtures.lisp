;;;; ml0-fixtures.lisp — Memory Layer /0: the declared constants, the closed
;;;; vocabularies, the fixed store nonce, and the environment pre-flight lists.
;;;;
;;;; Every value here is DECLARED.  Nothing is generated, read from a file,
;;;; derived from a name, or taken from the clock, the PID, or the filesystem.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(in-package #:lisp-plus-memory-layer0)

;;; ===========================================================================
;;; The lane's declared constants.
;;; ===========================================================================

;;; The domain-separation string for Memory Layer /0, version 0.  It enters the
;;; account-identity preimage as a TYPED CD/0 STRING VALUE, never as a prefix
;;; concatenated onto other octets.
(defparameter +ml0-id-domain+ "lisp-plus/memory-layer-0/account-id/v0")

;;; The lane stem.  Separator-free.
(defparameter +ml0-lane-stem+ "memorylayer0")

;;; ONE runtime process name for the in-process suites.  DECLARED, never
;;; derived.  The SPECIMEN declares its own per-process names because it has
;;; more than one process life.
(defparameter +ml0-runtime-process-name+ "tabularius")

;;; The account rendering version.  A later lane that changes any rule of the
;;; account body rendering changes this number, so an account digest can never
;;; silently mean two things.
(defparameter +ml0-rendering-version+ 1)

;;; ===========================================================================
;;; The fixed store nonce.
;;; ===========================================================================
;;;
;;; ⚠ THE RIDER, PRINTED AT THE FIXTURE AND NOT IN A FOOTNOTE:
;;;
;;;   PJ-META-1 UNPREDICTABILITY IS INTENTIONALLY NOT MET BY THIS STORE, AND
;;;   THIS STORE IS TEST INFRASTRUCTURE ONLY.  A fixed nonce is a predictable
;;;   store-id, and predictability is exactly the property PJ-META-1 exists to
;;;   provide.  The lane trades it away deliberately to buy byte-identical twin
;;;   runs, and claims NOTHING about this store's unpredictability, cross-host
;;;   uniqueness, or fitness outside this suite.
;;;
;;; Precedent, cited rather than re-argued: One Act /1 (act1-fixtures.lisp:
;;; 44-61), capability /2's de-effectu-incerto, and One Act /0 all declared
;;; exactly this deviation.
(defparameter +ml0-store-nonce+
  (make-array 16 :element-type '(unsigned-byte 8)
                 :initial-contents
                 '(#x6D #x65 #x6D #x6F #x72 #x79 #x30 #x2D     ; "memory0-"
                   #x66 #x69 #x78 #x65 #x64 #x2D #x6E #x31))   ; "fixed-n1"
  "Exactly sixteen octets, written out literally, never generated.")

;;; ===========================================================================
;;; THE CLOSED SOURCE-SPECIES SET, and what each species may warrant.
;;;
;;; Grounded in L15 (witness separation) and its operational ancestors
;;; AP-JRN-1 / AP-REC-1 / AP-CAN-6, which are cited as governing precedent
;;; whose reasoning transfers — see MEMORY-LAYER-0-SPEC.md §3 for the exact
;;; clause carried across in each case.
;;;
;;; ⚑ THE SET IS CLOSED AND THE MEMBERSHIP TEST IS A `MEMBER`, NOT A DEFAULT.
;;; A species this lane does not know is REFUSED, never silently demoted to
;;; corroboration: an unknown species is an unknown warrant.
;;; ===========================================================================

(defparameter +ml0-source-species+
  '(:kernel-mediated-journal        ; cap2 frames, origin/observed, read via the
                                    ; public fold over the VALIDATED PREFIX
    :world-bytes                    ; the world's own files: ledger row, cell
                                    ; value, whole-fixture digests
    :reconciliation-conjunction     ; act1-reconciliation-closes-seat-p — a joint
                                    ; reading of world AND journal
    :lane-self-report               ; ANY origin/self-reported narrative,
                                    ; INCLUDING this lane's own accounts
    :core0-issuance-testimony       ; a Core /0 evidence account, its digest, its
                                    ; receipt, or a report describing it
    :scoped-negative-observation    ; a look across a DECLARED universe that
                                    ; found the subject absent
    :account-reconstruction)        ; successful validation of durable account
                                    ; bytes
  "THE CLOSED SET.  Nine questions of provenance, seven species.")

(defparameter +ml0-occurrence-species+
  '(:kernel-mediated-journal :world-bytes :reconciliation-conjunction)
  "THE ONLY SPECIES THAT MAY WARRANT OCCURRENCE, and the reason they may is one
sentence long: each of them inspects facts that WOULD NOT BECOME TRUE MERELY
BECAUSE AN EVIDENCE OBJECT WAS MINTED.  `%make-core0-evidence` writes a struct
in the image and `%issue-core0-evidence` writes a hash table; neither touches a
journal frame or a world byte.  That dissociation is not argued here — it is
MEASURED, in a preserved artifact of the consumed lane
(language-act-1/RED-PROOF-HOST-FAULT-BEFORE.txt: EVIDENCE-ISSUED T with
JOURNAL-FRAMES-MOVED NIL and WORLD-BYTE-UNCHANGED T).

⚠ :LANE-SELF-REPORT IS DELIBERATELY ABSENT, and its absence is the point.  One
Act /0's own frames are `origin/self-reported` and its own gate table forbids
copying capability /2's stronger provenance (act0-gates.lisp:114-119).  A
self-written narrative — including EVERY account this lane writes — remains
asserted testimony (AP-JRN-1's clause, carried across).  It may corroborate; it
may never be the sole occurrence basis.

⚠ :CORE0-ISSUANCE-TESTIMONY IS DELIBERATELY ABSENT, and that absence is the
whole commission.  A public reader must never answer `occurred` by finding only
an issued evidence object, its digest, its receipt, or a report describing it.")

(defparameter +ml0-nonoccurrence-species+
  '(:scoped-negative-observation)
  "The only species that may warrant a NEGATIVE reading, and only with the
four-part warrant of AP-REC-1's clause carried across: domain completeness +
authority over the identity + a distinct inspectable witness + a record binding
witness-mechanism / evidence-identity / procedure-identity / origin /
validation-standing.")

(defparameter +ml0-attestations+
  '(:frontier-crossed-for-this-identity
    :no-record-for-this-identity
    :inconclusive)
  "WHAT THE SOURCE ACTUALLY FOUND, in a CLOSED MACHINE-READABLE vocabulary.

⚑ WHY THIS FIELD EXISTS, and it was found by building the contradiction row and
watching the rule get it wrong.  A source's species says WHAT KIND OF THING WAS
READ; its `frontier-relation` says IN PROSE what the reading means.  Neither says
WHETHER THE READING WAS POSITIVE — so a `:world-bytes` source built from a
lookup that found NO ROW satisfied every leg of the promotion rule and warranted
`:occurred`.  An admitted species reading admitted bytes and finding NOTHING is
the sharpest possible false positive, because every provenance field is honest.

So the rule now reads this field too: `:occurred` requires an occurrence species
that attests :FRONTIER-CROSSED-FOR-THIS-IDENTITY, and `:nonoccurred` requires a
scoped negative that attests :NO-RECORD-FOR-THIS-IDENTITY.  :INCONCLUSIVE
warrants neither and is the honest value for a reading that settles nothing —
including every issuance testimony, since a mint says nothing about a frontier.")

(defparameter +ml0-source-validations+
  '(:validated-by-door :asserted-testimony :stored-assertion
    :inherited-from-validated-record)
  "THE VALIDATION STANDING OF A SOURCE ROW — added 2026-08-20 in the repair round,
and it is the whole of BLOCK 1's cure.

⚠ R3, THE SECOND REPAIR ROUND: a FOURTH standing exists, and the reason it exists
is that the third one was doing two jobs.  `:STORED-ASSERTION` meant both `read
out of bytes` and `carrying a warrant somebody earned` — and since the decoder
that produces it is PUBLIC and reads the record's own validation field, a caller
could write the field and receive the warrant.  The two jobs are now two
standings: `:STORED-ASSERTION` is what ANY decode produces and warrants NOTHING;
`:INHERITED-FROM-VALIDATED-RECORD` is minted ONLY inside `ml0-retrieve`, after
`validate-journal` has verified the enclosing frame chain and the account body has
re-digested to the identity its own frame names.  The authority is the STORE'S
digest chain; the record's own field is never the ground of anything.

⚑ WHAT THE BLOCKED BUILD GOT WRONG.  `make-ml0-source` was public and validated
SHAPE ONLY: it checked that fields were present, non-empty and drawn from closed
vocabularies, and never read a journal frame or a world byte.  The promotion rule
then inspected those caller-supplied fields syntactically.  So an ordinary public
caller could take an act that lawfully REFUSED before the frontier, hand over a
`:world-bytes` row with the real act identity, a `:looked` scope, a positive
attestation, an arbitrary coordinate and an arbitrary 64-hex digest, and receive a
durable account reading `:OCCURRED` — for an act whose derived effect standing was
`:ABSENT` and whose external-request key had zero rows in the world.  That is
truth-minting through the lane's own front door: the exact disease this lane
exists to refuse, one remove further out than where it was being refused.
(Reproduced against the blocked build: `RED-BLOCK-BEFORE.txt`, exit 1.)

THE THREE STANDINGS, and who may mint each:

  :VALIDATED-BY-DOOR   Only a PRODUCTION OBSERVATION DOOR of this lane may stamp
                       this, and a door stamps it only on a row whose every field
                       IT derived from the substrate IT read.  The row constructor
                       that carries this stamp is INTERNAL; no caller can reach it.
  :ASSERTED-TESTIMONY  What the public `make-ml0-source` produces.  Anyone may say
                       anything; it is durable, it is carried, it is retrievable,
                       and it CAN NEVER WARRANT OCCURRENCE.  Testimony is not a
                       weaker observation — it is a different kind of thing.
  :STORED-ASSERTION    What DECODING produces, ALWAYS — including the public
                       `ml0-source-from-record` and the public
                       `ml0-account-from-event`.  A row read out of durable bytes
                       is testimony about a validation someone else made; it is
                       never a fresh look.  IT WARRANTS NOTHING, whatever its bytes
                       record, and it re-serializes as `asserted-testimony`.
  :INHERITED-FROM-VALIDATED-RECORD
                       Minted ONLY by `ml0-retrieve`, and only for a row whose
                       durable bytes recorded a door's validation, and only after
                       `validate-journal` verified the enclosing PJ0 frame chain
                       and the body re-digested to its frame's own account
                       identity.  The constructor is INTERNAL.  This is the only
                       way a warrant crosses a process boundary, and what
                       authenticates it is the STORE'S digest chain — never the
                       source record's self-description.

⚠ THE CEILING ON THE FOURTH STANDING, said once and meant: the frame chain
authenticates that these bytes are the bytes THIS STORE recorded, in this order,
unmodified.  It does not authenticate the store.  A caller who owns a store owns
its contents; this lane remains capability-DISCIPLINED, never capability-SECURE,
and inheriting a warrant across a validated retrieve does not change that.")

(defparameter +ml0-observation-doors+
  '(:journal-door :world-door :reconciliation-door :absence-door :issuance-door)
  "THE FIVE PRODUCTION OBSERVATION DOORS, each of which ACTUALLY READS the
substrate that owns the fact it reports, through that lane's own public readers.
They live in the LANE and are loaded by `load.lisp` — the blocked build's real
substrate-reading builders lived in `ml0-suite-ground.lisp`, which the canonical
loader deliberately excludes, so a consumer got the forgeable door and not the
honest one.")

(defparameter +ml0-acquisition-routes+
  '(:live-query :reconstructed)
  "THE ORIGIN RATCHET's closed set, taken verbatim from capability /0
(receipts.lisp:25-33).  :OBSERVED IS NOT A MEMBER ON PURPOSE: a reader's
fold-derived answer can never be an observation (laws L10, L15).  Passing it is
a caller error, refused here in code — not documented and hoped for.")

(defparameter +ml0-occurrence-standings+
  '(:occurred :nonoccurred :unresolved :contradicted)
  ":UNRESOLVED IS THE LAWFUL DEFAULT AND IS NEVER A DEFECT.  Absence of an
occurrence warrant is not proof of nonoccurrence.  :CONTRADICTED may be emitted
by consolidation only, and preserves BOTH warrants.")

(defparameter +ml0-issuance-standings+
  '(:issued-in-writing-image :unresolved)
  "THE ISSUANCE AXIS IS EXACTLY TWO, AND ITS SHORTNESS IS THE POINT.

Core /0's issuance registry is a per-image hash table with NO durable footprint
(core0.lisp:830-836).  `core0-evidence-current-image-issued-p` therefore answers
FALSE FOR EVERY POSSIBLE INPUT in any image but the issuing one — and a predicate
that is false universally is not an absence warrant.  Reading its false as `not
issued` is the lab's own underpowered-null defect class.

⚠ AND A SCOPE DOES NOT REPAIR THAT (Sol's correction, work order AMENDMENT 1.1;
this supersedes an earlier `:not-issued-in-scope` member of this set, which THIS
LANE SHIPPED FOR PART OF ITS OWN BUILD and then struck).  The account store never
observes Core /0's registry at all, so no declaration of the store's boundaries
can confer observational competence over a thing outside it.  Scope narrows a
claim a looker was competent to make; it cannot manufacture the competence.  A
struck member is worth more here than a footnote: the tempting move was to keep
the word `not-issued` and make it safe with an adjective, and the adjective could
not do it.

`:issued-in-writing-image` is provenanced testimony by the writing process, from
the live predicate, in the image that minted — and it is named for its own
boundary so that no later reader can quote it flat.  Everything else is
`:unresolved`.  Whether THIS STORE happens to hold an issuance record is a
different question, on a different field: see +ML0-RECORD-COVERAGES+.")

(defparameter +ml0-record-coverages+
  '(:issuance-record-present-in-account-store
    :no-issuance-record-in-account-store
    :not-examined)
  "RECORD COVERAGE — a SEPARATE observation about THIS LANE'S OWN STORE, and never
a member of the issuance axis.

`:no-issuance-record-in-account-store` is a true, checkable, competent statement:
the account store IS the universe of this look, and this lane IS authoritative
over it.  What it is not, and may never be read as, is a statement about Core /0's
registry — which is exactly why it lives on its own field with its own vocabulary
rather than as a shy spelling of `not-issued`.")

(defparameter +ml0-occurred-proposition+
  "the governed protected effect associated with canonical act identity A crossed/applied and is present in the declared journal/world universe under its derived external-request identity"
  "THE PROPOSITION `:OCCURRED` WARRANTS, PINNED VERBATIM (work order AMENDMENT 1.3).

⚠ IT IS NOT `perform WAS INVOKED`.  A lawful refusal is itself an execution event
— something genuinely happened in the language — whose PROTECTED DEED did not
occur.  Reading `:occurred` as `an act was attempted` would make every refusal an
occurrence and would quietly turn this lane into a duplicate of the execution
axis.

Occurrence-standing is the LATER READER'S EPISTEMIC STANDING toward this precisely
named proposition.  It is not a fifth outcome axis: the four adopted axes describe
an outcome held by a live actor, and this describes what a reader who was not
there is entitled to say afterwards.")

(defparameter +ml0-effect-determinacies+
  '(:determinate :bounded :indeterminate)
  "Architecture 0.1 §6.8's per-axis determinacy, VERBATIM.  Reused, not
re-spelled: this lane carries a SCOPED OBSERVATION OF the external-effect axis,
never the axis's standing itself.")

(defparameter +ml0-derivations+
  '(:direct-write :consolidation)
  "How an account came to be.  A consolidation output is a DERIVED account whose
own provenance names its inputs; it is never a retroactive rewrite of what those
inputs were (Architecture 0.1 D4).")

(defparameter +ml0-scope-statuses+
  '(:looked :could-not-look)
  "⚠ :COULD-NOT-LOOK IS A DISTINCT VALUE FROM AN ABSENT BYTE.  One Act /1's
world-scope instrument is the tree's only executable form of this discipline
(act1.lisp:974-1006) and this lane inherits the discriminant WITH ITS CANDIDATE
STANDING TRAVELLING.  Looked-and-absent and could-not-look are different
answers, and no comparison in this lane conflates them.")

;;; ===========================================================================
;;; W-ENV — the environment pre-flight for the SINGLE-PROCESS suites.
;;; ===========================================================================
;;;
;;; The suites (ml0-selftest, ml0-controls, ml0-mutants, ml0-red-proof,
;;; ml0-host-fault-proof) declare ONE PROCESS LIFE.  That declaration is a claim
;;; about the run, and the run must CHECK it.  Any one set VOIDS the suite — it
;;; does not proceed, does not create an account store, and does not report a
;;; pass.  A VOID IS NOT A FAILURE.
;;;
;;; ⚠ THE SPECIMEN IS EXEMPT BY CONSTRUCTION AND SAYS SO: de-actu-memorato SETS
;;; CAP2_WORLD_DIE_IN_WINDOW for its dying stage on purpose.  The specimen
;;; stages therefore never call this pre-flight; the orchestrator passes the
;;; switch explicitly, per child.

(defparameter +ml0-env-class-i+
  '("CAP2_WORLD_DIE_IN_WINDOW")
  "CLASS I — in a LOADED LIBRARY of this lane's stack (capability2/world.lisp:
239-244).  Set to \"1\", %world-apply-request calls (sb-ext:exit :code 7 :abort t)
AFTER the write is applied and ledgered and BEFORE the acknowledgment returns.
The only environment-controlled process death in a file this lane loads.")

(defparameter +ml0-env-class-ii+
  '("ML0_SELFTEST_PLANT_FAULT"        ; ml0-selftest.lisp
    "ML0_CONTROLS_PLANT_FAULT"        ; ml0-controls.lisp
    "ML0_READER_DIE"                  ; de-actu-memorato/stage-reader.lisp
    "ACT1_SELFTEST_PLANT_FAULT"       ; act1-selftest.lisp
    "ACT1_CONTROLS_PLANT_FAULT"       ; act1-controls.lisp
    "ACT1_RESTART_DIE"                ; act1/de-actu-resurgente/stage-restart.lisp
    "CAP2_SELFTEST_PLANT_FAULT"       ; capability2/capability2-selftest.lisp:645
    "CAP2_CONTROLS_PLANT_FAULT"       ; capability2/capability2-controls.lisp:554
    "CAP2_CONTROLS_DIE"               ; capability2/capability2-controls.lisp:558
    "DE_EFFECTU_DIE")                 ; capability2/de-effectu-incerto/stage-restart.lisp:116
  "CLASS II — this lane's own three switches, One Act /1's three, and the four
capability /2 switches reachable in this stack.  TEN, counted, not estimated.
⚑ THE ACT1 ENTRIES ARE HERE BECAUSE THIS LANE LOADS THAT TREE.  One Act /1's own
Class III note says a successor that loads another tree must EXTEND the Class II
list rather than re-derive it; this is that extension, made by reading the lists
on disk.")

(defparameter +ml0-env-class-iii-declared-out-of-stack+
  '("SURFACE2_*" "ADAPTER0_*" "VERTICAL0_*" "SA0_*" "LCI0_*"
    "DE_TESTE_OCCISO_DIE" "TITHE_FORCE_INDEX" "FORM2_FORCE_RED"
    "SURFACE1_SUBJECT_LABEL")
  "CLASS III — DECLARED OUT OF THIS LANE'S STACK and NOT asserted unset: this
lane loads One Act /1 (and through it capability2 + core0) and nothing else, so
none of these files is loaded here.  Named, never asserted — the boundary drawn
by reading rather than by silence.")
