;;;; ml0-mutant-overlay.lisp — THE PLANTED DEFECTS, RELOCATED OUT OF PRODUCTION.
;;;;
;;;; ⚠ THIS FILE IS NOT ONE OF THE LANE'S FOUR SOURCES and is deliberately not in
;;;; `+ml0-lane-sources+`.  `load.lisp` does not load it, has no reference to it,
;;;; and cannot reach it.  A consumer that loads the lane the canonical way gets
;;;; production and NONE of this — which is the entire point of the file.
;;;;
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;; WHY IT EXISTS (R4, 2026-08-20, the Codex adversarial audit's finding F1)
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;;
;;;; Until 2026-08-20 the six planted defects were driven by a `&key defect`
;;;; parameter compiled into TEN EXPORTED PRODUCTION FUNCTIONS —
;;;; `ml0-species-may-warrant-occurrence-p`, `ml0-occurrence-conjuncts`,
;;;; `ml0-print-conjuncts`, `ml0-occurrence-warranted-p`,
;;;; `ml0-nonoccurrence-warranted-p`, `ml0-derive-occurrence-standing`,
;;;; `ml0-account-from-event`, `ml0-retrieve`, `ml0-write`, `ml0-consolidate`.
;;;; Every one of them was reachable through the front door with one keyword, and
;;;; the guarantee that they were `production NIL, controls only` was A DOCSTRING.
;;;; A cross-family (GPT/Codex) reader flipped the crown predicate in a fresh
;;;; image loaded through the canonical `load.lisp`:
;;;;
;;;;     SPECIES-NORMAL=NIL       (ml0-species-may-warrant-occurrence-p
;;;;                                 :core0-issuance-testimony)
;;;;     SPECIES-DEFECT=T         (…                :defect :issuance-implies-occurrence)
;;;;
;;;; §I-f, verbatim: PROMPTS GUIDE; CODE ENFORCES.  A guarantee written as a
;;;; docstring is the weakest form of that guarantee.  So the seam is not
;;;; narrowed, not asserted-NIL, not stripped at a gate — it is REMOVED from the
;;;; production arglists entirely, and the mutants moved here.
;;;;
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;; THE ARCHITECTURE, AND WHY THIS SHAPE AND NOT ANOTHER
;;;; ═══════════════════════════════════════════════════════════════════════════
;;;;
;;;; Three shapes were available.  Disclosed as a fork, with the reason:
;;;;
;;;;   (a) A `#+ml0-mutants` READ-TIME CONDITIONAL in `ml0.lisp`.  Rejected: the
;;;;       mutant text would still live in the production source, and a feature
;;;;       pushed by any consumer's own build would compile it back in.  It moves
;;;;       the guarantee from a docstring to a `*features*` entry, which is a
;;;;       global a caller can also set.
;;;;
;;;;   (b) AN INTERNAL SPECIAL that production reads (`(when (eq *%ml0-defect*
;;;;       :drop-scope) …)`).  Rejected, and this is the interesting one: it
;;;;       satisfies the letter of `no defect parameter on any external symbol`
;;;;       while leaving THE MUTANT BRANCHES COMPILED INTO THE PRODUCTION IMAGE,
;;;;       reachable by anyone who writes `lisp-plus-memory-layer0::*%ml0-defect*`.
;;;;       It would have been a cheaper repair that passed its own probe.  That is
;;;;       exactly the shape of defect this lane has now migrated three times.
;;;;
;;;;   (c) TAKEN: the mutants live OUTSIDE the lane and install themselves by
;;;;       REDEFINING production functions, each wrapper DELEGATING to the
;;;;       production definition it saved.  The production image, loaded through
;;;;       `load.lisp`, contains no mutant branch of any kind — nothing to reach,
;;;;       internal or external.
;;;;
;;;; ⚑ WRAPPERS, NEVER COPIES.  Every wrapper below calls the saved production
;;;; function for everything except the ONE forbidden collapse it exists to make.
;;;; A mutant that reimplemented the logic would prove that the reimplementation
;;;; is killable, which is not a fact about this lane — `ml0-mutants.lisp` has
;;;; said so since R1 and it is still the law.  Nothing here duplicates a
;;;; production body.
;;;;
;;;; ⚑ AND THE MUTANT IS DYNAMIC, not global.  `*ml0-mutant*` is NIL by default
;;;; and every wrapper delegates untouched when it is NIL, so a CURED thunk and a
;;;; DISEASED thunk still run in the same image — which is what makes a kill a
;;;; DISCRIMINATION rather than two separate runs compared by eye.
;;;;
;;;; ⚠ WHAT THIS FILE COSTS, STATED PLAINLY.  Three of the six mutants are now
;;;; expressed one remove further out than they were:
;;;;   * `:drop-scope` used to make the RULE ignore the scope status; it now
;;;;     falsifies the scope BEFORE the production rule sees it.
;;;;   * `:origin-upgrade-on-readback` used to rewrite routes INSIDE the decoder;
;;;;     it now rewrites the account the production decoder returned.
;;;;   * `:retain-live-evidence` used to branch inside `ml0-write`; it now
;;;;     re-wraps write's own result.
;;;; In each case the CURED arm still exercises the production check itself (it
;;;; must answer T against the untouched lane, or the mutant is reported a
;;;; SURVIVOR), and the DISEASED arm still shows the check is load-bearing.  This
;;;; is the lane's own sanctioned `mutant CALLER over the shipped code` form —
;;;; mutant 2 has always been driven that way — and it is disclosed rather than
;;;; smoothed over.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — OBTURATOR (Claude Opus 5, subagent), 2026-08-20

(in-package #:lisp-plus-memory-layer0)

(defvar *ml0-mutant* nil
  "THE INSTALLED DEFECT, or NIL.  Bound only by `with-ml0-mutant`, and only ever
inside a suite process that has loaded this file.  Production code never reads
it: no function in `ml0.lisp` mentions this symbol, and `load.lisp` never loads
the file that defines it.")

(defvar *ml0-mutant-payload* nil
  "The live Core /0 evidence object the `:retain-live-evidence` mutant keeps.")

(defmacro with-ml0-mutant ((defect &key payload) &body body)
  "Install DEFECT for the dynamic extent of BODY.  Everything outside is cured."
  `(let ((*ml0-mutant* ,defect)
         (*ml0-mutant-payload* ,payload))
     ,@body))

;;; ---------------------------------------------------------------------------
;;; The saved production definitions.  Captured BEFORE any redefinition below, so
;;; every wrapper delegates to the lane as it actually ships.

(defvar *ml0-production*
  (list :species-may-warrant #'ml0-species-may-warrant-occurrence-p
        :occurrence-warranted #'ml0-occurrence-warranted-p
        :nonoccurrence-warranted #'ml0-nonoccurrence-warranted-p
        :retrieve #'ml0-retrieve
        :write #'ml0-write
        :consolidate #'ml0-consolidate
        ;; R5 control seams (NOT counted as mutants; `ml0-mutants.lisp` still reports six)
        :account-body #'ml0-account-body
        :mint-identity #'ml0-mint-account-identity
        :dry-decode #'%ml0-dry-decode))

(defun %ml0-prod (key) (getf *ml0-production* key))

;;; ---------------------------------------------------------------------------
;;; Copy helpers.  These build the SHAPES the mutants need; they compute no
;;; standing and answer no question.

(defun %ml0-mutant-force-looked (source)
  "A copy of SOURCE whose observation scope claims `:LOOKED` whatever it was.
This is the `:drop-scope` disease in its honest form: somebody says a look
happened that did not."
  (if (eq :looked (ml0-scope-status (ml0-source-observation-scope source)))
      source
      (%make-ml0-source
       :species (ml0-source-species source)
       :acquisition-route (ml0-source-acquisition-route source)
       :producer-principal (ml0-source-producer-principal source)
       :recorder-principal (ml0-source-recorder-principal source)
       :coordinate (ml0-source-coordinate source)
       :observation-scope
       (make-ml0-scope
        :universe (ml0-scope-universe (ml0-source-observation-scope source))
        :status :looked
        :detail (ml0-scope-detail (ml0-source-observation-scope source)))
       :origin-as-read (ml0-source-origin-as-read source)
       :subject-act-id (ml0-source-subject-act-id source)
       :payload-digest (ml0-source-payload-digest source)
       :frontier-relation (ml0-source-frontier-relation source)
       :attests (ml0-source-attests source)
       :observation-interval (ml0-source-observation-interval source)
       :validation-standing (ml0-source-validation-standing source)
       :door (ml0-source-door source)
       :recorded-validation (ml0-source-recorded-validation source))))

(defun %ml0-mutant-live-query (source)
  "A copy of SOURCE whose acquisition route claims `:LIVE-QUERY` — the origin
ratchet defeated."
  (%make-ml0-source
   :species (ml0-source-species source)
   :acquisition-route :live-query
   :producer-principal (ml0-source-producer-principal source)
   :recorder-principal (ml0-source-recorder-principal source)
   :coordinate (ml0-source-coordinate source)
   :observation-scope (ml0-source-observation-scope source)
   :origin-as-read (ml0-source-origin-as-read source)
   :subject-act-id (ml0-source-subject-act-id source)
   :payload-digest (ml0-source-payload-digest source)
   :frontier-relation (ml0-source-frontier-relation source)
   :attests (ml0-source-attests source)
   :observation-interval (ml0-source-observation-interval source)
   :validation-standing (ml0-source-validation-standing source)
   :door (ml0-source-door source)
   :recorded-validation (ml0-source-recorded-validation source)))

(defun %ml0-mutant-recopy-account (account &key (sources nil sources-supplied)
                                                (retrieval-origin nil origin-supplied))
  "A copy of ACCOUNT with at most two fields replaced.  Every other field is
carried through unread, so a mutant changes exactly what it says it changes."
  (%make-ml0-account
   :id (ml0-account-id account) :id-hex (ml0-account-id-hex account)
   :act-id (ml0-account-act-id account)
   :act-id-hex (ml0-account-act-id-hex account)
   :subject-seat (ml0-account-subject-seat account)
   :subject-attempt (ml0-account-subject-attempt account)
   :occurrence-standing (ml0-account-occurrence-standing account)
   :occurrence-scope (ml0-account-occurrence-scope account)
   :issuance-standing (ml0-account-issuance-standing account)
   :issuance-scope (ml0-account-issuance-scope account)
   :record-coverage (ml0-account-record-coverage account)
   :record-coverage-scope (ml0-account-record-coverage-scope account)
   :effect-observation (ml0-account-effect-observation account)
   :sources (if sources-supplied sources (ml0-account-sources account))
   :derivation (ml0-account-derivation account)
   :predecessors (ml0-account-predecessors account)
   :recorder-principal (ml0-account-recorder-principal account)
   :subject-principal (ml0-account-subject-principal account)
   :retrieval-origin (if origin-supplied
                         retrieval-origin
                         (ml0-account-retrieval-origin account))
   :standing-authority (ml0-account-standing-authority account)
   :carried-standings (ml0-account-carried-standings account)
   :body-record (ml0-account-body-record account)))

;;; ---------------------------------------------------------------------------
;;; THE SIX DEFECTS.  Each redefinition below is inert unless `*ml0-mutant*` names
;;; it.  Redefinition style-warnings are muffled ONLY for the redefinition class
;;; and ONLY here: a suite transcript full of `redefining X in DEFUN` is a gate
;;; nobody reads, and every other warning class still reaches the transcript.

(handler-bind ((warning (lambda (condition)
                          (when (typep condition 'sb-kernel:redefinition-warning)
                            (muffle-warning condition)))))

  ;; ---- 1 (part a) — ISSUANCE-IMPLIES-OCCURRENCE, at the SPECIES depth.
  (defun ml0-species-may-warrant-occurrence-p (species)
    (if (eq *ml0-mutant* :issuance-implies-occurrence)
        (or (eq species :core0-issuance-testimony)
            (funcall (%ml0-prod :species-may-warrant) species))
        (funcall (%ml0-prod :species-may-warrant) species)))

  ;; ---- 1 (part b) — the same admission at the SUFFICIENCY depth.  It still
  ;; ---- respects leg 0 and the subject identity, so the RED row stays
  ;; ---- attributable to `Core evidence ⇒ occurrence basis` and to nothing else.
  (defun ml0-occurrence-warranted-p (act-id sources)
    (when (eq *ml0-mutant* :issuance-implies-occurrence)
      (dolist (source sources)
        (when (and (eq :core0-issuance-testimony (ml0-source-species source))
                   (ml0-source-warranting-validation-p source)
                   (same-datum-p (ml0-source-subject-act-id source) act-id))
          (return-from ml0-occurrence-warranted-p
            (values t source "MUTANT: an issued evidence account was present"
                    (ml0-occurrence-conjuncts act-id source))))))
    (funcall (%ml0-prod :occurrence-warranted) act-id sources))

  ;; ---- 5 — PROVENANCE/SCOPE-DROPPED.  `:could-not-look` masquerades as
  ;; ---- looked-and-absent.
  (defun ml0-nonoccurrence-warranted-p (act-id sources)
    (funcall (%ml0-prod :nonoccurrence-warranted) act-id
             (if (eq *ml0-mutant* :drop-scope)
                 (mapcar #'%ml0-mutant-force-looked sources)
                 sources)))

  ;; ---- 6 — ORIGIN-UPGRADE-ON-SUCCESSFUL-READBACK.
  ;;
  ;; ⚠ AND ONE CONTROL SEAM THAT IS NOT ONE OF THE SIX DEFECTS, named as such:
  ;; `:READBACK-REFUSES-AFTER-APPEND`.  It exists for `ml0-controls` CONTROL 11,
  ;; which measures F4 — what `ml0-write` actually leaves behind when a refusal
  ;; happens AFTER `append-event`.  ⚑ THE TRIGGER IS SYNTHESISED AND THAT IS
  ;; DISCLOSED: no reachable input produces one, because PJ0's `append-event`
  ;; verifies the frame chain ITSELF and refuses a damaged store BEFORE writing —
  ;; which is why the audit called the trigger narrow, and why an honest control
  ;; cannot wait for one.  What the control MEASURES is production's, untouched:
  ;; `ml0-write`'s structure, its append, and the absence of any rollback.  Only
  ;; the readback's ANSWER is forced.  It is not counted as a mutant and it kills
  ;; nothing; `ml0-mutants.lisp` still reports six.
  ;; ---- R5 CONTROL SEAMS for §5.A as amended (disposition B).  Three seams, none
  ;; ---- a mutant: they PLANT a frame fault or an identity fault, and optionally
  ;; ---- SKIP the dry decode (payload :skip-dry-decode) so the same fault can be
  ;; ---- measured reaching the append — the disease half of CONTROLs 12 and 13.
  (defun ml0-account-body (&rest arguments)
    (let ((body (apply (%ml0-prod :account-body) arguments)))
      (if (eq *ml0-mutant* :frame-rendering-mismatch)
          ;; the exact body, with a rendering version this lane's decoder does not know
          (lisp-plus-cd0:make-record-datum
           (loop for index below (lisp-plus-cd0:record-datum-size body)
                 for key = (lisp-plus-cd0:record-datum-key-at body index)
                 collect (if (string= "account:rendering" (identifier-segment-string key))
                             (entry '("account" "rendering")
                                    (i-datum (1+ +ml0-rendering-version+)))
                             (lisp-plus-cd0:make-record-entry
                              key (lisp-plus-cd0:record-datum-value-at body index)))))
          body)))
  (defvar *ml0-identity-seam-armed* nil
    "ONE-SHOT arming for :identity-mismatch.  The decoder re-digests the body through
the SAME function, so a seam that always lied would lie to both sides and they
would agree.  The control arms it before ONE write; the write's own mint consumes
the arming and returns a wrong hex; every later call (the dry decode's re-digest,
the readback's) is honest.")
  (defun ml0-mint-account-identity (body)
    (multiple-value-bind (id hex) (funcall (%ml0-prod :mint-identity) body)
      (if (and (eq *ml0-mutant* :identity-mismatch) *ml0-identity-seam-armed*)
          ;; a minted identity that is NOT the content digest of the body — once
          (let ((wrong (copy-seq hex)))
            (setf *ml0-identity-seam-armed* nil)
            (setf (char wrong 63) (if (char= (char wrong 63) #\0) #\1 #\0))
            (values id wrong))
          (values id hex))))
  (defun %ml0-dry-decode (envelope account-hex)
    (if (eq *ml0-mutant-payload* :skip-dry-decode)
        t                                 ; DISEASE: the pre-append check is skipped
        (funcall (%ml0-prod :dry-decode) envelope account-hex)))

  (defun ml0-retrieve (store &key account-hex)
    (when (eq *ml0-mutant* :readback-refuses-after-append)
      (ml0-refuse 'ml0-account-readback-refused "ML0-RB-1"
                  "CONTROL SEAM: the readback is forced to refuse, so what the ~
write leaves behind can be measured rather than narrated"))
    (let ((account (funcall (%ml0-prod :retrieve) store :account-hex account-hex)))
      (if (eq *ml0-mutant* :origin-upgrade-on-readback)
          (%ml0-mutant-recopy-account
           account
           :sources (mapcar #'%ml0-mutant-live-query (ml0-account-sources account))
           :retrieval-origin :live-query)
          account)))

  ;; ---- 3 — RETRIEVE-MINTS-OR-PROMOTES-TO-CURRENT-IMAGE-EVIDENCE.  The account
  ;; ---- keeps a LIVE object the caller handed it instead of keeping only what
  ;; ---- it wrote down.
  (defun ml0-write (store bundle &rest arguments)
    (let ((account (apply (%ml0-prod :write) store bundle arguments)))
      (if (eq *ml0-mutant* :retain-live-evidence)
          (%ml0-mutant-recopy-account
           account
           :sources (cons *ml0-mutant-payload* (ml0-account-sources account)))
          account)))

  ;; ---- 4 — CONSOLIDATION-INHERITS-A-STANDING (last-write-wins).  The occurrence
  ;; ---- standing is taken from the LAST ordered input's keyword instead of being
  ;; ---- re-derived from the warrants that survived; every other returned value
  ;; ---- is production's own.
  (defun ml0-consolidate (accounts)
    ;; R4.1: the production function returns a typed carrier; the disease
    ;; re-copies it with the LAST ordered input's keyword in place of the
    ;; re-derived standing.  The carrier's internal constructor is reachable here
    ;; only because the overlay lives INSIDE the lane package, outside the
    ;; canonical load.
    (let ((c (funcall (%ml0-prod :consolidate) accounts)))
      (if (eq *ml0-mutant* :last-write-wins)
          (let ((last (car (last (ml0-consolidation-inputs c)))))
            (%make-ml0-consolidation
             :act-id (ml0-consolidation-act-id c)
             :act-id-hex (ml0-consolidation-act-id-hex c)
             :subject-seat (ml0-consolidation-subject-seat c)
             :subject-attempt (ml0-consolidation-subject-attempt c)
             :subject-principal (ml0-consolidation-subject-principal c)
             :occurrence-standing (ml0-account-occurrence-standing last)
             :occurrence-scope (ml0-account-occurrence-scope last)
             :issuance-standing (ml0-consolidation-issuance-standing c)
             :issuance-scope (ml0-consolidation-issuance-scope c)
             :record-coverage (ml0-consolidation-record-coverage c)
             :record-coverage-scope (ml0-consolidation-record-coverage-scope c)
             :sources (ml0-consolidation-sources c)
             :predecessors (ml0-consolidation-predecessors c)
             :inputs (ml0-consolidation-inputs c)
             :clash (ml0-consolidation-clash c)))
          c))))

(format t "~&ml0-mutant-overlay: six defects installed OUTSIDE the lane; ~
*ml0-mutant* is ~s (production behaviour) until a `with-ml0-mutant` binds it.~%"
        *ml0-mutant*)
(finish-output)
