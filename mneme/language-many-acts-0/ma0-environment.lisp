;;;; ma0-environment.lisp — the ONE door through which live state enters a run
;;;; (contract §7, GRAMMAR §6).
;;;;
;;;; CANDIDATE.  Nothing here is adopted (contract §0).
;;;;
;;;; ⚠ THE DOOR ACCEPTS DECLARATIONS, NEVER LIVE OBJECTS.  Every argument of
;;;; `make-ma0-environment' is DATA — strings, keywords, integers, and plans
;;;; expressed as plists.  The store, the worlds, the bootstrap authority, the
;;;; minting context and the journaled grants are constructed HERE, by this
;;;; lane, through public predecessor operations.  A caller cannot hand in a
;;;; live capability, because no parameter would receive one.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(in-package #:lisp-plus-many-acts0)

;;; ===========================================================================
;;; §1 — replicated declared VALUES from One Act /0's published source.
;;;
;;; ⚠ THESE ARE VALUES RE-DECLARED, NOT FUNCTIONS CALLED.  `grant-terms-for',
;;; `capability-id-for' and the fixture `world-key' reader are INTERNAL to
;;; #:lisp-plus-language-act0 and this lane may not reference them (contract
;;; §3).  What is public is their SOURCE, and a value read out of published
;;; source and re-declared here — with the line cited — is not a use of an
;;; internal symbol.  If One Act /0 ever changes one of these, this lane's
;;; concordance teeth are what must catch it; the re-declaration is the risk
;;; that makes those teeth necessary rather than decorative.
;;; ===========================================================================

(defparameter +ma0-act-subject+ '("subject" "scriba")
  "act0.lisp:1157 — +act-subject+.")
(defparameter +ma0-act-action+ '("action" "inscribere")
  "act0.lisp:1158 — +act-action+.")
(defparameter +ma0-act-scope+ '("scope" "semel")
  "act0.lisp:1159 — +act-scope+.")
(defparameter +ma0-act-issuer+ '("issuer" "oneact0")
  "act0.lisp:1160 — +act-issuer+.")

(defparameter +ma0-arm-world-key+
  '(("A" . :apply) ("B-L1" . :apply) ("B-L2" . :apply) ("B-R" . :apply)
    ("C-i" . :ambiguous) ("C-ii" . :apply) ("D" . :apply))
  "act0.lisp:155-207 — the fixture table's `world-key' column, arm by arm.  Only
arm C-i runs against the :ambiguous world, because its script is the one whose
acknowledgment carries no evidence (act0-fixtures.lisp:102-104).  Read as a
column of the closed ARM vocabulary, which is what W-GENERIC admits.")

(defun %ma0-idf (segments)
  (lisp-plus-journal0:identifier-from-segments segments))

(defun %ma0-fixture-for-arm (arm)
  (or (find arm lisp-plus-language-act0:*act-fixture-table*
            :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=)
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARM"
                  "no adopted fixture carries arm ~s" arm)))

(defun %ma0-grant-terms (fixture)
  "The four terms of the Capability /0 grant this act's Office R capability is
minted from (act0.lisp:1162-1169, re-declared).  The per-seat RESOURCE is the
seat's effect-cell identity — read here through the EXPORTED cell-segments
reader, so only the three constant terms are transcriptions."
  (list :subject (%ma0-idf +ma0-act-subject+)
        :action (%ma0-idf +ma0-act-action+)
        :resource (%ma0-idf (lisp-plus-language-act0:act-fixture-cell-segments
                             fixture))
        :scope (%ma0-idf +ma0-act-scope+)))

(defun %ma0-capability-id (fixture)
  "act0.lisp:1171-1172 — capability-id-for."
  (list "cap" (lisp-plus-language-act0:act-fixture-runtime-seat fixture)))

(defun %ma0-world-for-arm (environment arm)
  (let ((row (assoc arm +ma0-arm-world-key+ :test #'string=)))
    (unless row
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARM"
                  "arm ~s has no declared world key" arm))
    (getf (%env-worlds environment) (cdr row))))

;;; ===========================================================================
;;; §2 — plan checking.  Plans are DATA and are checked as data, before a byte
;;; of live state exists.
;;; ===========================================================================

(defun %ma0-check-plan-atom (value what)
  (unless (or (stringp value) (integerp value) (keywordp value))
    (ma0-refuse 'ma0-environment-refused "MA0-ENV-DATA"
                "~a must be a STRING, an INTEGER, or a KEYWORD; ~s is a ~a"
                what value (type-of value)))
  value)

(defun %ma0-check-arms (arms)
  (unless (and (listp arms) (plusp (length arms)))
    (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARMS"
                ":arms must declare at least one arm"))
  (dolist (arm arms arms)
    (unless (and (stringp arm) (member arm +ma0-arms+ :test #'string=))
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARMS"
                  "~s is not one of the seven sealed arms ~s" arm +ma0-arms+))
    (when (> (count arm arms :test #'equal) 1)
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-ARMS"
                  "arm ~s is declared twice" arm))))

(defun %ma0-check-grants (grants arms)
  "GRANTS is a list of plists (:slot STRING :arm STRING).  Returns the
occupancy alist (slot-name . list-of-arms)."
  (let ((occupancy '()))
    (dolist (plan grants)
      (unless (and (listp plan) (evenp (length plan))
                   (stringp (getf plan :slot)) (stringp (getf plan :arm)))
        (ma0-refuse 'ma0-environment-refused "MA0-ENV-GRANT"
                    "a grant plan is (:slot STRING :arm STRING); got ~s" plan))
      (let ((slot (%ma0-name-key (getf plan :slot))) (arm (getf plan :arm)))
        (unless (member arm arms :test #'string=)
          (ma0-refuse 'ma0-environment-refused "MA0-ENV-GRANT"
                      "grant plan names arm ~s, which is not in :arms ~s"
                      arm arms))
        (let ((row (assoc slot occupancy :test #'string=)))
          (when (and row (member arm (cdr row) :test #'string=))
            (ma0-refuse 'ma0-environment-refused "MA0-ENV-GRANT"
                        "slot ~s already carries a grant for arm ~s"
                        slot arm))
          (if row
              (setf (cdr row) (append (cdr row) (list arm)))
              (push (cons slot (list arm)) occupancy)))))
    (nreverse occupancy)))

(defun %ma0-check-revocations (revocations arms)
  (dolist (plan revocations revocations)
    (unless (and (listp plan) (evenp (length plan)) (stringp (getf plan :arm)))
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-REVOKE"
                  "a revocation plan is (:arm STRING); got ~s" plan))
    (unless (member (getf plan :arm) arms :test #'string=)
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-REVOKE"
                  "revocation plan names arm ~s, which is not in :arms ~s"
                  (getf plan :arm) arms))))

(defun %ma0-check-seat-map (seat-map)
  "SEAT-MAP is an alist (declared-name . runtime-seat).  Every runtime seat
must be a seat of the adopted fixture table — read through the EXPORTED
`act-fixture-runtime-seat', never guessed from a brief's placeholder."
  (let ((seats (mapcar #'lisp-plus-language-act0:act-fixture-runtime-seat
                       lisp-plus-language-act0:*act-fixture-table*)))
    (dolist (row seat-map seat-map)
      (unless (and (consp row) (stringp (car row)) (stringp (cdr row)))
        (ma0-refuse 'ma0-environment-refused "MA0-ENV-SEAT"
                    "a seat-map row is (NAME . RUNTIME-SEAT), both strings; ~
got ~s" row))
      (unless (member (cdr row) seats :test #'string=)
        (ma0-refuse 'ma0-environment-refused "MA0-ENV-SEAT"
                    "~s is not a runtime seat of the adopted fixture table ~s"
                    (cdr row) seats)))))

(defun %ma0-check-inputs (inputs)
  (dolist (row inputs inputs)
    (unless (and (consp row) (stringp (car row)))
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-INPUT"
                  "an input row is (NAME . VALUE) with a string NAME; got ~s"
                  row))
    (%ma0-check-plan-atom (cdr row) (format nil "input ~s" (car row)))))

(defun %ma0-key-alist (alist)
  "The alist with every KEY normalised through `%ma0-name-key'."
  (mapcar (lambda (row) (cons (%ma0-name-key (car row)) (cdr row))) alist))

;;; ===========================================================================
;;; §3 — the door.
;;; ===========================================================================

(defun make-ma0-environment (&key root arms grants revocations seat-map inputs)
  "Build the run's live state from DECLARATIONS.

ROOT         a directory pathname, OUTSIDE the subject tree, that the caller
             owns and removes.
ARMS         the arms this environment admits (a subset of the seven).
GRANTS       a list of (:slot STRING :arm STRING) plans.  Each journals ONE
             Capability /0 grant for that arm's seat and records the slot as
             occupied for that arm.
REVOCATIONS  a list of (:arm STRING) plans, journaled AFTER every grant.
SEAT-MAP     an alist (declared-seat-name . runtime-seat).
INPUTS       an alist (input-name . STRING|INTEGER|KEYWORD).

⚠ THE REVOCATION IS ENVIRONMENT-TIME, AND THE LIMIT IS STATED RATHER THAN
DRESSED.  P2's run β wants a revocation landing BETWEEN two acts; at /0 there
is no program construct that could trigger one, so this door journals declared
revocations during construction.  The pressure the run exercises — a later
act's authority is dead, its mint refuses by name, and the earlier acts' frames
are unchanged — is the real one; the TIMING is declared fixture, not a
demonstrated mid-run revocation.

⚠ IT SETS THE FIVE EXPORTED ONE ACT /0 RUN-STATE SPECIALS.  That is a whole-
image effect, and it is why the runner law is ONE PROGRAM PER IMAGE.

⚠ R1/D4 — THE SECOND ENVIRONMENT NO LONGER REDIRECTS THE FIRST ONE SILENTLY.
It still redirects it — the specials are one per image and this door still owns
them — but the redirection is now RECORDED: each successful construction takes
the next GENERATION, and an environment whose generation is not the installed
one is refused by `ma0-run-program' and `ma0-complete-act' BEFORE the first
consequential act, with zero footprint in either store.  What this does NOT do
is support two live environments: there is still exactly one, and the second one
wins.  The repair converts a silent wrong-store write into a typed refusal; it
does not make multi-environment orchestration lawful, and nothing here should be
read as an interleaving story.

Before the repair, running the FIRST environment after a SECOND was built left
the first store byte-identical and grew the second's `EVENTS.pj0' from 638 to
6753 bytes, wrote the second's world cells, and left the second environment
UNUSABLE — composition noticed only afterwards, reading a store where nothing
had landed (r1/pre-repair/D4-red.txt)."
  (unless root
    (ma0-refuse 'ma0-environment-refused "MA0-ENV-ROOT"
                ":root is required and has no default"))
  (let* ((arms (%ma0-check-arms arms))
         (occupancy (%ma0-check-grants grants arms))
         (revocations (%ma0-check-revocations revocations arms))
         (seat-map (%ma0-check-seat-map seat-map))
         (inputs (%ma0-check-inputs inputs)))
    ;; ---- W-ENV first, before the store exists.  A VOID is not a failure of
    ;; ---- the program and is never reported as one.
    (handler-case (lisp-plus-language-act0:w-env-preflight :signal t)
      (lisp-plus-language-act0:act0-condition (c)
        (ma0-refuse 'ma0-environment-refused "MA0-ENV-VOID"
                    "the One Act /0 environment pre-flight VOIDED the run: ~
~a — no journal store was created" c)))
    (let* ((worlds (lisp-plus-language-act0:build-fixture-worlds root))
           (store (lisp-plus-language-act0:build-store root))
           (store-id (lisp-plus-journal0:journal-store-store-id store))
           (bootstrap (lisp-plus-capability0:declare-bootstrap-authority
                       (%ma0-idf +ma0-act-issuer+) store-id))
           (minting (lisp-plus-capability1:make-minting-context
                     :label "manyacts0")))
      (lisp-plus-language-act0:validate-act-fixture-table)
      ;; ---- F-GRANT: one Capability /0 grant per declared plan, journaled
      ;; ---- BEFORE any F1 (the shape One Act /0 journals at act0.lisp:
      ;; ---- 1218-1237, restricted to the arms THIS environment declares).
      ;; ---- ⚠ THESE LOOPS RUN BEFORE THE COMMIT POINT AND USE THE LOCAL
      ;; ---- `store', never the special — which is what makes the R1/D5
      ;; ---- reordering possible at all.
      (dolist (plan grants)
        (let* ((arm (getf plan :arm))
               (fixture (%ma0-fixture-for-arm arm))
               (seat (lisp-plus-language-act0:act-fixture-runtime-seat fixture))
               (terms (%ma0-grant-terms fixture)))
          (lisp-plus-journal0:append-event
           store
           (lisp-plus-capability0:make-grant-event
            :event-id (list "cap0-event" (format nil "g-~a" seat))
            :capability-id (%ma0-capability-id fixture)
            :subject (getf terms :subject) :action (getf terms :action)
            :resource (getf terms :resource) :scope (getf terms :scope)
            :issuer (%ma0-idf +ma0-act-issuer+)))))
      ;; ---- F-REVOKE: after every grant, per declared plan.
      (dolist (plan revocations)
        (let* ((arm (getf plan :arm))
               (fixture (%ma0-fixture-for-arm arm))
               (seat (lisp-plus-language-act0:act-fixture-runtime-seat fixture)))
          (lisp-plus-journal0:append-event
           store
           (lisp-plus-capability0:make-revocation-event
            :event-id (list "cap0-event" (format nil "r-~a" seat))
            :capability-id (%ma0-capability-id fixture)
            :issuer (%ma0-idf +ma0-act-issuer+)))))
      ;; ⚠ R1/D1 — THE DOOR TAKES OWNERSHIP OF EVERY DECLARATION IT KEPT.
      ;; `copy-tree' left the environment holding the caller's own strings, so a
      ;; caller that mutated its input string AFTER this function returned
      ;; changed what the run then carried (r1/pre-repair/D1-red.txt, probe
      ;; D1-3).  The store-id is owned for the mirror reason: handed out raw, a
      ;; mutated readback vandalised the environment's own identifier (D1-5).
      ;; The live objects — store, worlds, bootstrap, minting context — are NOT
      ;; copied: they are live state, not data, and this door is the only thing
      ;; that ever made them.
      ;;
      ;; ⚠ R1/D5 — AND OWNERSHIP IS TAKEN *BEFORE* THE COMMIT POINT, BECAUSE IT
      ;; CAN REFUSE.  `%ma0-own' signals MA0-OWN-BOUND on an oversized
      ;; declaration, and an oversized declaration passes every plan check —
      ;; which is exactly how the pre-repair ordering let a construction fail
      ;; AFTER the counter had moved (r1/pre-repair/D5-red.txt).
      (let ((owned-store-id (%ma0-own store-id))
            (owned-arms (%ma0-own arms))
            (owned-occupancy (%ma0-own occupancy))
            (owned-seat-map (%ma0-own seat-map))
            (owned-inputs (%ma0-own (%ma0-key-alist inputs))))

        ;; ===================================================================
        ;; ⚠⚠ THE COMMIT POINT (R1/D5).  EVERY FALLIBLE STEP HAS SUCCEEDED.
        ;;
        ;; Nothing below this line can signal: an `incf' of a bound integer,
        ;; five assignments, and one structure allocation.  That is the whole
        ;; of the owner's PROPERTY 2 — "generation installation is committed
        ;; only after every fallible construction step succeeds" — and it is a
        ;; property of WHERE THESE FORMS SIT, not of a promise about them.
        ;;
        ;; The counter and the specials move TOGETHER and in that order, so
        ;; there is no instant at which the specials point at one environment
        ;; while the generation names another.  A failure anywhere above leaves
        ;; BOTH untouched, and the previously-installed environment stays
        ;; live — which is what a failed construction must not be able to take
        ;; away (D5-1: five failure modes left A current before the repair, and
        ;; the sixth, the one that reached this window, killed it).
        ;;
        ;; DO NOT MOVE A FALLIBLE FORM BELOW THIS LINE.  If a later hand needs
        ;; one, it belongs above the `let' — and r1/D5-generation-seam.lisp
        ;; will say so.
        ;; ===================================================================
        (incf *ma0-environment-generation*)
        (setf lisp-plus-language-act0:*run-root* root
              lisp-plus-language-act0:*worlds* worlds
              lisp-plus-language-act0:*store* store
              lisp-plus-language-act0:*bootstrap* bootstrap
              lisp-plus-language-act0:*minting-context* minting)
        (%make-ma0-environment
         :root root :store store :store-id owned-store-id :worlds worlds
         :bootstrap bootstrap :minting-context minting
         :generation *ma0-environment-generation*
         :arms owned-arms :occupancy owned-occupancy
         :seat-map owned-seat-map :inputs owned-inputs)))))

;;; ===========================================================================
;;; §4 — the explicit, per-step retrievals the evaluator makes.
;;; ===========================================================================

(defun %ma0-check-environment-current (environment where)
  "R1/D4.  Refuse a STALE environment — one built before a later
`make-ma0-environment' took over the run-state specials — BEFORE anything
consequential happens.

⚠ THE REFUSAL TELLS THE TRUE STORY AND NAMES ONLY WHAT IT KNOWS.  It names the
STALE environment's OWN store-id, because that is the store this object owns and
the only one it can honestly speak for.  It does NOT name the installed
environment's store or root: the stale object has no claim on those, and a
refusal that named them would be inventing an identifier for a store the caller
never asked about.

⚠ AND THE IDENTIFIER IT NAMES CANNOT BE USED TO TELL TWO STORES APART.  A
journal store's id is derived from its CONTENT, so two environments built from
the same declarations carry the same string.  It is here to say WHICH OBJECT was
refused, not to distinguish stores — a distinction the id cannot draw and this
message therefore does not claim."
  (unless (eql (%env-generation environment) *ma0-environment-generation*)
    (error 'ma0-environment-stale
           :code "MA0-ENV-STALE"
           :store-id (%ma0-own (%env-store-id environment))
           :detail (format nil
                           "~a was handed an environment of generation ~d while ~
generation ~d holds the One Act /0 run-state specials; a later ~
`make-ma0-environment' took them over, so an act run through this object would ~
journal into a store it does not own.  This environment's own store is ~a.  ~
Nothing was written, minted, or journaled in any store.  Many Acts /0 is ONE ~
PROGRAM PER IMAGE: it does not orchestrate two live environments, and this ~
refusal is not a step toward doing so."
                           where
                           (%env-generation environment)
                           *ma0-environment-generation*
                           (%env-store-id environment))))
  t)

(defun %ma0-slot-occupied-p (environment slot-name arm)
  "W-AUTH-EXPLICIT.  Occupancy is retrieved from the ENVIRONMENT, by slot NAME,
at each act step, explicitly.  There is no dynamic variable to fall back to and
no default branch that fills an empty slot: an unfilled slot returns NIL here
and the caller refuses before the act begins."
  (let ((row (assoc (%ma0-name-key slot-name) (%env-occupancy environment)
                    :test #'string=)))
    (and row (member arm (cdr row) :test #'string=) t)))

(defun %ma0-resolve-seat (environment declared-name)
  (let ((row (assoc declared-name (%env-seat-map environment) :test #'string=)))
    (unless row
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-SEAT"
                  "seat name ~s is not in the environment's declared seat map"
                  declared-name))
    (cdr row)))

(defun %ma0-input-value (environment name)
  (let ((row (assoc (%ma0-name-key name) (%env-inputs environment)
                    :test #'string=)))
    (unless row
      (ma0-refuse 'ma0-environment-refused "MA0-ENV-INPUT"
                  "the program declares input ~s and the environment supplies ~
no value for it" name))
    (cdr row)))
