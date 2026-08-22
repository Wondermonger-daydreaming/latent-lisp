;;;; ml0-controls.lisp — Memory Layer /0: the TEETH, each with a CURED control
;;;; AND a DISEASE control.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-controls.lisp
;;;;
;;;; Sentinel: ml0-controls: N controls, N caught, 0 missed
;;;;
;;;; ⚠ A TEST THAT MERELY FAILS UNDER BOTH IMPLEMENTATIONS PROVES NOTHING, and a
;;;; gate that has never been seen to fire is untested rather than passing.  So
;;;; every tooth below is exercised TWICE: once against the lane as it ships
;;;; (the CURED half, which must hold) and once against a deliberately diseased
;;;; caller or a planted defect seam (the DISEASE half, which the instrument must
;;;; CATCH).  A control counts as CAUGHT only when BOTH halves come out right.
;;;;
;;;; ⚠ NO BLANKET REFUSAL MAY PASS HERE EITHER.  Where a tooth is a refusal,
;;;; there is a same-shape control that must SUCCEED — otherwise "refuse
;;;; everything" would score full marks.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
;; ⚑ R4: the DISEASE half of every tooth below used to ride a `&key defect` on
;; ten EXPORTED production functions.  The seam is gone from the lane; the six
;; collapses now live in an overlay `load.lisp` never loads.
(load (merge-pathnames "ml0-mutant-overlay.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *host-fault-probe* "not a list"
  "⚠ THE PROBE LIVES IN A GLOBAL ON PURPOSE.  SBCL derives the type of a literal
— and of `(format nil ...)` — precisely enough to turn `(car x)` into a
COMPILE-TIME WARNING instead of a RUN-TIME FAULT, and a warning is not a host
fault: it would leave this gate testing nothing while looking green.  A special
variable's value is opaque to the compiler, so the slip happens where it must.
(The lab has been bitten by the mirror of this rule before — SBCL elides a
DISCARDED special-var read — so note that this value is USED, as CAR's argument,
and cannot be optimized away.)")

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *controls* 0)
(defvar *caught* 0)
(defvar *missed* 0)

(defun control (label cured-ok disease-caught &optional (note ""))
  "ONE control = the cured half AND the disease half.  Both are printed, so a
reader can see WHICH half failed rather than being told the pair did."
  (incf *controls*)
  (let ((ok (and cured-ok disease-caught)))
    (if ok (incf *caught*) (incf *missed*))
    (format t "~&[~3,'0d] ~a ~a~%        cured: ~a · disease: ~a~@[~%        ~a~]~%"
            *controls* (if ok "CAUGHT " "MISSED ") (format nil label)
            (if cured-ok "holds" "BROKEN")
            (if disease-caught "caught" "WALKED PAST")
            (and (plusp (length note)) (format nil note)))
    (finish-output)
    ok))

(defun refused-with (requirement thunk)
  "T when THUNK signals an ml0-condition carrying REQUIREMENT.  Refusals are
named by TYPE + REQUIREMENT-ID, never by message text."
  (handler-case (progn (funcall thunk) nil)
    (ml0-condition (c) (equal requirement (ml0-condition-requirement-id c)))))

(defun succeeded-p (thunk)
  (handler-case (progn (funcall thunk) t) (error () nil)))

(defun copy-store-directory (from to)
  (when (probe-file to) (sb-ext:delete-directory to :recursive t))
  (ensure-directories-exist to)
  (dolist (source (directory (merge-pathnames "*.*" from)))
    (with-open-file (in source :element-type '(unsigned-byte 8))
      (let ((octets (make-array (file-length in) :element-type '(unsigned-byte 8))))
        (read-sequence octets in)
        (with-open-file (out (merge-pathnames (file-namestring source) to)
                             :direction :output :element-type '(unsigned-byte 8)
                             :if-exists :supersede :if-does-not-exist :create)
          (write-sequence octets out)))))
  to)

(defun damage-file (pathname mode)
  "MODE :truncate drops the last third of the file; :flip corrupts one interior
byte; :forge-standing rewrites an account's OCCURRENCE STANDING in place, from
\"unresolved\" to \"occurred  \", WITHOUT changing any length.  All three are
damage to THIS LANE'S OWN record and to nothing else.

⚑ :FORGE-STANDING IS THE INTERESTING ONE.  It is the edit an adversary would
actually want: not noise, but a semantically meaningful lie, byte-for-byte the
same size so no length or offset changes.  Readback does NOT re-derive the
standing from the sources, so the question is whether anything else catches it —
and the answer, checked here rather than asserted in prose, is that it is caught
twice over: this lane's account identity is a digest of the WHOLE body and the
frame's event-id carries it (ML0-RB-11), and beneath that PJ0's own frame-digest
chain rejects the prefix outright.  Adversarial tampering remains OUTSIDE every
claim this lane makes; what this row establishes is only that the naive edit does
not survive."
  (let (octets)
    (with-open-file (in pathname :element-type '(unsigned-byte 8))
      (setf octets (make-array (file-length in) :element-type '(unsigned-byte 8)))
      (read-sequence octets in))
    (let ((damaged (ecase mode
                     (:truncate (subseq octets 0 (floor (* 2 (length octets)) 3)))
                     (:flip (let ((copy (copy-seq octets))
                                  (at (floor (length octets) 2)))
                              (setf (aref copy at) (logxor 255 (aref copy at)))
                              copy))
                     (:forge-standing
                      (let* ((copy (copy-seq octets))
                             (text (map 'string #'code-char octets))
                             (at (search "unresolved" text)))
                        ;; ⚠ A CONTROL THAT CANNOT FIND ITS TARGET MUST NOT PASS
                        ;; QUIETLY.  If no :unresolved standing is in the store,
                        ;; this row would be editing nothing and refusing nothing.
                        (unless at
                          (error "the forge-standing control found no ~s standing ~
in the store: it would have tested nothing" "unresolved"))
                        (loop for i from 0 below 10
                              for c across "occurred  "
                              do (setf (aref copy (+ at i)) (char-code c)))
                        copy)))))
      (with-open-file (out pathname :direction :output
                                    :element-type '(unsigned-byte 8)
                                    :if-exists :supersede)
        (write-sequence damaged out)))))

(format t "~&Memory Layer /0 — CONTROLS.  Every tooth twice: cured and diseased.  ~
CANDIDATE; nothing here is adopted, and nothing here is independent ~
verification.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-controls: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(defvar *root* (ml0-fresh-run-root "ml0-controls" *subject-root*))

;;; ⚠ THE RUN'S VARIABLES ARE DECLARED AT TOP LEVEL AND ASSIGNED BELOW.
;;; `defparameter` INSIDE the unwind-protect would be one top-level form,
;;; so every later reference in that form compiles against an undefined
;;; variable and SBCL warns — and a gate whose own transcript is full of
;;; compiler noise is a gate nobody reads.
(defvar *settled* nil)
(defvar *refused* nil)
(defvar *other* nil)
(defvar *settled-result* nil)
(defvar *other-result* nil)
(defvar *refused-result* nil)
(defvar *settled-id* nil)
(defvar *other-id* nil)
(defvar *refused-id* nil)
(defvar *settled-world-src* nil)
(defvar *other-world-src* nil)
(defvar *issuance-src* nil)
(defvar *retrieve-target* nil)
(defvar *positive-account* nil)
(defvar *incommensurable-negative* nil)
(defvar *clash-positive* nil)
(defvar *clash-negative* nil)
(defvar *clash-commensurable-p* nil)
(defvar *negative-account* nil)
(defvar *blind-negative* nil)
(defvar *honest-blind* nil)
(defvar *seeing-negative* nil)
(defvar *damaged-root* nil)
(defvar *flipped-root* nil)
(defvar *forged-root* nil)

(unwind-protect
     (progn
       (ml0-ground *root*)

       (setf *settled* (ml0-settled-row))
       (setf *refused* (ml0-refused-row))
       (setf *other* (ml0-settled-row :seat "tertia" :attempt "a-tertia"
                                              :cell '("cella" "revocata")
                                              :cell-name "cella:revocata"
                                              :text "Actus tertius."
                                              :symbol 'ml0-controls/other))
       (setf lisp-plus-language-act1:*act1-fixture-table*
             (list *settled* *refused* *other*))
       (ml0-open-authority (list *settled* *refused* *other*))

       (setf *settled-result*
         (lisp-plus-language-act1:run-act1 *settled* :verbose nil))
       (setf *other-result*
         (lisp-plus-language-act1:run-act1 *other* :verbose nil))
       (setf *refused-result*
         (lisp-plus-language-act1:run-act1 *refused* :verbose nil))

       (setf *settled-id* (nth-value 0 (ml0-rederive-act-identity *settled*)))
       (setf *other-id* (nth-value 0 (ml0-rederive-act-identity *other*)))
       (setf *refused-id* (nth-value 0 (ml0-rederive-act-identity *refused*)))

       (setf *settled-world-src* (ml0-world-source *settled-id* "a-prima"))
       (setf *other-world-src* (ml0-world-source *other-id* "a-tertia"))
       (setf *issuance-src*
         (ml0-issuance-source *refused-id*
                              (lisp-plus-language-act1:act1-result-evidence
                               *refused-result*)))

       ;;; ================================================================
       ;;; CONTROL 1 — THE CROWN: issuance-implies-occurrence.
       ;;; ================================================================
       (control
        "TOOTH 1 · ISSUANCE-IMPLIES-OCCURRENCE.  A GENUINELY ISSUED Core /0 ~
evidence account for an act that did not occur, presented as an occurrence ~
warrant, with the SAME act identity on both sides"
        ;; CURED: the shipped rule refuses it, and the stored account says
        ;; :unresolved.
        (and (not (ml0-occurrence-warranted-p *refused-id* (list *issuance-src*)))
             (let ((account (ml0-write *ml0-account-store*
                                       (make-ml0-bundle
                                        :fixture-row *refused*
                                        :claimed-act-id *refused-id*
                                        :subject-principal *suite-actor*
                                        :sources (list *issuance-src*)
                                        :issuance-observation (ml0-issuance-observation-for *refused-id* *refused-result*)))))
               (and (not (ml0-account-occurred-p account))
                    (ml0-account-issuance-only-p account))))
        ;; DISEASE: the planted seam, at BOTH depths, promotes the same sources.
        (with-ml0-mutant (:issuance-implies-occurrence)
         (and (ml0-occurrence-warranted-p *refused-id* (list *issuance-src*))
             (ml0-species-may-warrant-occurrence-p :core0-issuance-testimony)
             (let ((account (ml0-write *ml0-account-store*
                                       (make-ml0-bundle
                                        :fixture-row *refused*
                                        :claimed-act-id *refused-id*
                                        :subject-principal *suite-actor*
                                        :sources (list *issuance-src*
                                                       (ml0-self-report-source
                                                        *refused-id* "disease arm"))
                                        :issuance-observation (ml0-issuance-observation-for *refused-id* *refused-result*)))))
               (ml0-account-occurred-p account))))
        "the disease arm's account durably reads :OCCURRED for an act whose ~
journal frames never moved and whose world is byte-unchanged — which is the ~
whole reason this lane exists")

       ;;; ================================================================
       ;;; CONTROL 2 — RETRIEVE RE-PERFORMS.
       ;;; ================================================================
       (setf *retrieve-target*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle :fixture-row *settled*
                                     :claimed-act-id *settled-id*
                                     :subject-principal *suite-actor*
                                     :sources (list *settled-world-src*))))
       (control
        "TOOTH 2 · RETRIEVE RE-PERFORMS.  The instrument is the pair (journal ~
frame count, world scope) taken across a retrieval"
        ;; CURED: the shipped retrieval moves neither.
        (let ((frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
              (world (lisp-plus-language-act1:take-world-scope
                      (ml0-world) (ml0-world-directory))))
          (ml0-retrieve *ml0-account-store*
                        :account-hex (ml0-account-id-hex *retrieve-target*))
          (and (eql frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
               (lisp-plus-language-act1:world-scope-unchanged-p
                world (lisp-plus-language-act1:take-world-scope
                       (ml0-world) (ml0-world-directory)))))
        ;; DISEASE: a MUTANT CALLER that retrieves and then re-performs the act
        ;; through One Act /1's public seam.  The instrument must SEE it.
        (let* ((frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
               (world (lisp-plus-language-act1:take-world-scope
                       (ml0-world) (ml0-world-directory)))
               (reperforming-row
                 (ml0-settled-row :seat "prima" :attempt "a-prima-9"
                                  :text "Actus iteratus."
                                  :symbol 'ml0-controls/reperform)))
          (ml0-retrieve *ml0-account-store*
                        :account-hex (ml0-account-id-hex *retrieve-target*))
          ;; the disease: the "retrieval" goes on to act
          (lisp-plus-language-act1:act1-opening-authority
           *ml0-act-store* (list reperforming-row))
          (lisp-plus-language-act1:run-act1 reperforming-row :verbose nil)
          (and (not (eql frames (nth-value 1 (act1-journal-kinds *ml0-act-store*))))
               (not (lisp-plus-language-act1:world-scope-unchanged-p
                     world (lisp-plus-language-act1:take-world-scope
                            (ml0-world) (ml0-world-directory))))))
        "the disease half really did re-perform: BOTH instruments moved, so the ~
cured half's stillness is a measurement and not an assumption")

       ;;; ================================================================
       ;;; CONTROL 3 — RETRIEVE MINTS / PROMOTES TO CURRENT-IMAGE EVIDENCE.
       ;;; ================================================================
       (control
        "TOOTH 3 · AN ACCOUNT CARRIES CURRENT-IMAGE EVIDENCE.  The instrument ~
walks every value reachable from the account's public surface"
        ;; CURED: a written and a retrieved account both carry none — AND the
        ;; instrument's own budget is not a LENGTH LIMIT.  A 61-source account
        ;; still answers T, which a cdr-recursion budget could not do; found by
        ;; adversarial re-reading after every gate was already green, and kept
        ;; here so it cannot regress.
        (and (ml0-account-carries-no-current-image-evidence-p *retrieve-target*)
             (ml0-account-carries-no-current-image-evidence-p
              (ml0-retrieve *ml0-account-store*
                            :account-hex (ml0-account-id-hex *retrieve-target*)))
             (null (ml0-account-may-continue-p *retrieve-target*))
             (let ((many (cons *settled-world-src*
                               (loop for i below 60
                                     collect (ml0-self-report-source
                                              *settled-id*
                                              (format nil "long-list probe ~d" i))))))
               (and (= 61 (length many))
                    (ml0-account-carries-no-current-image-evidence-p
                     (ml0-write *ml0-account-store*
                                (make-ml0-bundle
                                 :fixture-row *settled*
                                 :claimed-act-id *settled-id*
                                 :subject-principal *suite-actor*
                                 :sources many)))
                    ;; and it STILL SEES the evidence in a list that long
                    (with-ml0-mutant
                        (:retain-live-evidence
                         :payload (lisp-plus-language-act1:act1-result-evidence
                                   *settled-result*))
                      (not (ml0-account-carries-no-current-image-evidence-p
                            (ml0-write *ml0-account-store*
                                       (make-ml0-bundle
                                        :fixture-row *settled*
                                        :claimed-act-id *settled-id*
                                        :subject-principal *suite-actor*
                                        :sources many))))))))
        ;; DISEASE: the planted seam retains the live evidence object.
        (with-ml0-mutant (:retain-live-evidence
                          :payload (lisp-plus-language-act1:act1-result-evidence
                                    *settled-result*))
          (let ((diseased (ml0-write *ml0-account-store*
                                     (make-ml0-bundle
                                      :fixture-row *settled*
                                      :claimed-act-id *settled-id*
                                      :subject-principal *suite-actor*
                                      :sources (list *settled-world-src*
                                                     (ml0-self-report-source
                                                      *settled-id* "tooth 3 disease"))))))
            (not (ml0-account-carries-no-current-image-evidence-p diseased))))
        "and the evidence the disease arm retained is a REAL, current-image-issued ~
Core /0 account — the instrument is not catching a decoy")

       ;;; ================================================================
       ;;; CONTROL 4 — CONSOLIDATION ERASES A CONTRADICTION.
       ;;; ================================================================
       (setf *positive-account*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle :fixture-row *settled*
                                     :claimed-act-id *settled-id*
                                     :subject-principal *suite-actor*
                                     :sources (list *settled-world-src*)
                                     :issuance-observation (ml0-issuance-observation-for *settled-id* *settled-result*))))
       ;; ⚑ AN HONESTLY-PRODUCED CONTRADICTION.  The negative look is made across
       ;; a DIFFERENT world — capability /2's :ambiguous fixture, whose ledger is
       ;; genuinely empty — and its scope SAYS SO.  Both readings are real; they
       ;; disagree because they looked at different universes, and the preserved
       ;; scopes are what let a later reader see why.
       ;; the INCOMMENSURABLE pair: an honest negative look at a DIFFERENT world.
       (setf *incommensurable-negative*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle :fixture-row *settled*
                                     :claimed-act-id *settled-id*
                                     :subject-principal *suite-actor*
                                     :sources (list (ml0-negative-source
                                                     *settled-id* "a-prima"
                                                     :world (getf *ml0-worlds*
                                                                  :ambiguous))))))
       ;; ⚑ THE POSITIVE IS NOW A DOOR-VALIDATED READING, not a modelled row: only
       ;; a warranting account can make the re-derivation test mean anything.
       (setf *clash-positive*
             (ml0-write *ml0-account-store*
                        (make-ml0-bundle :fixture-row *settled*
                                         :claimed-act-id *settled-id*
                                         :subject-principal *suite-actor*
                                         :observations
                                         (list (ml0-world-observation *settled-id*
                                                                     "a-prima")))))
       (multiple-value-bind (positive negative)
           (ml0-commensurable-clash-pair *settled-id* "a-prima")
         (setf *clash-commensurable-p*
               (ml0-warrants-commensurable-p positive negative)))
       ;; ⚑ THE ORDERING IS CONSTRUCTED, DELIBERATELY AND VISIBLY.  Consolidation
       ;; orders by CONTENT-DERIVED identity, so which input is `last` is a fact
       ;; about digests, not about the caller.  The `:last-write-wins` defect reads
       ;; the LAST ordered input's standing — so unless that input's standing
       ;; DIFFERS from the re-derived answer, the two paths coincide and the tooth
       ;; proves nothing.  This loop searches for a negative account that sorts
       ;; after the positive one, by varying only a self-report note.  Without it
       ;; the control would have passed while testing nothing, which is the failure
       ;; mode this whole lane is about.
       (setf *clash-negative*
             (loop for index below 32
                   for candidate = (ml0-write
                                    *ml0-account-store*
                                    (make-ml0-bundle
                                     :fixture-row *settled*
                                     :claimed-act-id *settled-id*
                                     :subject-principal *suite-actor*
                                     :observations
                                     (list (ml0-negative-observation
                                            *settled-id* "a-prima"
                                            :world (getf *ml0-worlds* :ambiguous)))
                                     :sources (list (ml0-self-report-source
                                                     *settled-id*
                                                     (format nil "ordering probe ~d"
                                                             index)))))
                   when (string< (ml0-account-id-hex *clash-positive*)
                                 (ml0-account-id-hex candidate))
                     return candidate
                   finally (return candidate)))
       (setf *negative-account* *clash-negative*)
       (control
        "TOOTH 4 · CONSOLIDATION ERASES A CONTRADICTION (last-write-wins).  Two ~
qualified observations of ONE act that disagree"
        ;; CURED: consolidation RE-DERIVES from the surviving warrants and never
        ;; adopts an input's keyword.  The two inputs disagree — one :OCCURRED
        ;; from a world door, one :NONOCCURRED from an absence door over a
        ;; different world — and they are INCOMMENSURABLE (different declared
        ;; universes), so the honest answer is not a contradiction: it is whatever
        ;; the union of warrants supports, with both preserved and neither picked.
        (and (eq :occurred (ml0-account-occurrence-standing *clash-positive*))
             (eq :nonoccurred (ml0-account-occurrence-standing *clash-negative*))
             ;; the two inputs sort in the order this control constructed
             (string< (ml0-account-id-hex *clash-positive*)
                      (ml0-account-id-hex *clash-negative*))
             ;; R4.1: consolidation returns ONE typed carrier; occurrence and the
             ;; source union are read off it.  The predicate is unchanged.
             (let* ((c (ml0-consolidate (list *clash-positive* *clash-negative*)))
                    (occurrence (ml0-consolidation-occurrence-standing c))
                    (sources (ml0-consolidation-sources c)))
               (and
                ;; RE-DERIVED from the union: a warranting positive survives, so
                ;; the answer is :OCCURRED — and NOT the last input's keyword.
                (eq :occurred occurrence)
                (not (eq :contradicted occurrence))
                ;; both warrants survive
                (some (lambda (s) (eq :world-bytes (ml0-source-species s))) sources)
                (some (lambda (s) (eq :scoped-negative-observation
                                      (ml0-source-species s)))
                      sources))))
        ;; DISEASE: the planted seam takes the LAST ordered input's standing
        ;; instead of re-deriving.  With the ordering constructed above, that is
        ;; :NONOCCURRED — a different answer, from a keyword instead of a warrant.
        (with-ml0-mutant (:last-write-wins)
          (let ((diseased (ml0-consolidation-occurrence-standing
                           (ml0-consolidate (list *clash-positive*
                                                  *clash-negative*)))))
            (and (eq :nonoccurred diseased)
                 (eq diseased (ml0-account-occurrence-standing *clash-negative*)))))
        "⚠ AND A DOWNGRADE, RECORDED RATHER THAN HIDDEN.  Before the repair round ~
this tooth exercised a COMMENSURABLE clash reaching :CONTRADICTED.  It cannot any ~
more: after the repair a row warrants only if a DOOR validated it, and two correct ~
doors reading one universe over one interval AGREE — so a commensurable clash ~
between warranting rows is unreachable, and :CONTRADICTED with it.  What this ~
tooth now proves is the other half of the same law, which is the half the chair ~
blocked on: consolidation RE-DERIVES and never inherits an input's keyword")

       ;;; ================================================================
       ;;; CONTROL 5 — PROVENANCE / SCOPE DROPPED (:could-not-look masquerades).
       ;;; ================================================================
       ;; ⚑ THE BLIND ROW IS NOW DOOR-VALIDATED, and it had to become so.  A
       ;; testimony row fails leg 0 and would make this tooth pass for the wrong
       ;; reason — the scope check would never be reached.  The absence door is
       ;; given the world's declared directory and the ledger file is removed from
       ;; a COPY, so the door itself reports :COULD-NOT-LOOK: a row that cleared
       ;; validation and still must warrant nothing.
       ;; ⚑ TWO BLIND ROWS, BECAUSE THE REPAIR ADDED A SECOND GUARD.
       ;;
       ;; (i) THE HONEST ONE, from the absence door pointed at a world whose
       ;;     request ledger has been removed from a COPY.  The door reports
       ;;     :COULD-NOT-LOOK **and** attests :INCONCLUSIVE — it refuses to call a
       ;;     failed look an absence.  So the masquerade is now blocked TWICE, and
       ;;     the `:drop-scope` mutant, which bypasses only the scope guard, can no
       ;;     longer get through it.  That is defence in depth and it is good; it
       ;;     also means this row alone can no longer make the tooth bite.
       ;;
       ;; (ii) THE SYNTHESISED ADVERSARIAL ONE, built through the lane's INTERNAL
       ;;      row constructor — the exact shape the mutant would admit and no door
       ;;      would ever produce: door-stamped, :COULD-NOT-LOOK, and attesting a
       ;;      finding anyway.  A tooth that cannot be shown to bite is untested,
       ;;      so the control constructs the adversary rather than losing the tooth.
       (setf *honest-blind*
             (let ((copy (merge-pathnames "blind-world/" *root*)))
               (copy-store-directory (ml0-world-directory) copy)
               (delete-file (merge-pathnames "REQUEST-LEDGER.txt" copy))
               (ml0-negative-observation-source *refused-id* "a-secunda"
                                                :world (ml0-world)
                                                :directory copy)))
       (setf *blind-negative*
             (%ml0-build-source
              :species :scoped-negative-observation
              :acquisition-route :live-query
              :producer-principal "principal:cap2-world-adapter"
              :recorder-principal "principal:memorylayer0"
              :coordinate (rec (entry '("coordinate" "kind")
                                      (s-datum "SYNTHESISED-ADVERSARIAL-ROW")))
              :observation-scope
              (make-ml0-scope :universe "the whole request ledger"
                              :status :could-not-look
                              :detail "the ledger could not be opened")
              :origin-as-read "observed"
              :subject-act-id *refused-id*
              :payload-digest (make-string 64 :initial-element #\d)
              :frontier-relation "claims absence across a universe it could not read"
              :observation-interval "synthesised"
              :attests :no-record-for-this-identity
              :validation-standing :validated-by-door
              :door :absence-door))
       (setf *seeing-negative*
             (ml0-observation-source
              (ml0-observe-absence (ml0-subject-for *refused-id* "a-secunda")
                                   (ml0-world)
                                   :directory (ml0-world-directory))))
       (control
        "TOOTH 5 · :COULD-NOT-LOOK MASQUERADES AS LOOKED-AND-ABSENT"
        ;; CURED: the blind look warrants nothing; the seeing look warrants
        ;; :nonoccurred — so this is not a blanket refusal of negatives.
        (and (not (ml0-nonoccurrence-warranted-p *refused-id* (list *blind-negative*)))
             (eq :unresolved (ml0-derive-occurrence-standing *refused-id*
                                                             (list *blind-negative*)))
             (ml0-nonoccurrence-warranted-p *refused-id* (list *seeing-negative*))
             (eq :nonoccurred (ml0-derive-occurrence-standing *refused-id*
                                                              (list *seeing-negative*))))
        ;; DISEASE: the planted seam admits the failed look.
        (with-ml0-mutant (:drop-scope)
          (and (ml0-nonoccurrence-warranted-p *refused-id* (list *blind-negative*))
               (eq :nonoccurred
                   (ml0-derive-occurrence-standing *refused-id*
                                                   (list *blind-negative*)))))
        "⚠ AND A SECOND GUARD NOW STANDS BESIDE THE FIRST: the honest blind row ~
from the absence door attests :INCONCLUSIVE, so a failed look cannot claim an ~
absence even if the scope guard were removed.  The synthesised adversarial row ~
exists precisely because that redundancy would otherwise have retired the tooth ~
— and a tooth that cannot be shown to bite is untested, not passing")

       ;;; ================================================================
       ;;; CONTROL 6 — ORIGIN UPGRADE ON SUCCESSFUL READBACK.
       ;;; ================================================================
       (control
        "TOOTH 6 · ORIGIN UPGRADE ON READBACK.  Validation success is treated as ~
an upgrade of the source's epistemic origin"
        ;; CURED: retrieval is :reconstructed and every route is untouched.
        (let ((retrieved (ml0-retrieve *ml0-account-store*
                                       :account-hex (ml0-account-id-hex
                                                     *retrieve-target*))))
          (and (eq :reconstructed (ml0-account-retrieval-origin retrieved))
               (equal (mapcar #'ml0-source-acquisition-route
                              (ml0-account-sources retrieved))
                      (mapcar #'ml0-source-acquisition-route
                              (ml0-account-sources *retrieve-target*)))))
        ;; DISEASE: the planted seam raises both.
        (with-ml0-mutant (:origin-upgrade-on-readback)
          (let ((diseased (ml0-retrieve *ml0-account-store*
                                        :account-hex (ml0-account-id-hex
                                                      *retrieve-target*))))
            (and (eq :live-query (ml0-account-retrieval-origin diseased))
                 (every (lambda (s) (eq :live-query (ml0-source-acquisition-route s)))
                        (ml0-account-sources diseased)))))
        "the ratchet is load-bearing: without it a reconstructed account would ~
present itself as a live observation to every later reader")

       ;;; ================================================================
       ;;; CONTROL 7 — FAILED WRITES OBSERVABLY NON-MUTATING.
       ;;; ================================================================
       (control
        "TOOTH 7 · A FAILED WRITE LEAVES SOMETHING BEHIND.  The instrument is the ~
WHOLE declared account-store directory: its file set and every file's sha256"
        ;; CURED: four different refusal paths, each byte-neutral.
        (let ((before (ml0-take-store-scope *ml0-account-root*))
              (paths 0))
          ;; (a) identity mismatch on the claim
          (when (refused-with "ML0-WR-3"
                              (lambda ()
                                (ml0-write *ml0-account-store*
                                           (make-ml0-bundle
                                            :fixture-row *settled*
                                            :claimed-act-id *other-id*
                                            :subject-principal *suite-actor*
                                            :sources (list *settled-world-src*)))))
            (incf paths))
          ;; (b) a source about another act
          (when (refused-with "ML0-WR-4"
                              (lambda ()
                                (ml0-write *ml0-account-store*
                                           (make-ml0-bundle
                                            :fixture-row *settled*
                                            :claimed-act-id *settled-id*
                                            :subject-principal *suite-actor*
                                            :sources (list *other-world-src*)))))
            (incf paths))
          ;; (c) a bundle with no sources at all
          (when (refused-with "ML0-BND-2"
                              (lambda ()
                                (ml0-write *ml0-account-store*
                                           (make-ml0-bundle
                                            :fixture-row *settled*
                                            :claimed-act-id *settled-id*
                                            :subject-principal *suite-actor*
                                            :sources '()))))
            (incf paths))
          ;; (d) a bare, unscoped `not-issued`
          ;; (d) an issuance standing SUPPLIED AT ALL — refused since the repair
          ;;     round, whatever word the caller picked.  The blocked build asked
          ;;     whether the word was in the vocabulary; the question was never
          ;;     which word, it was who chooses.
          (when (refused-with "ML0-BND-6"
                              (lambda ()
                                (ml0-write *ml0-account-store*
                                           (make-ml0-bundle
                                            :fixture-row *settled*
                                            :claimed-act-id *settled-id*
                                            :subject-principal *suite-actor*
                                            :sources (list *settled-world-src*)
                                            :issuance-standing :issued-in-writing-image))))
            (incf paths))
          (and (= 4 paths)
               (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        ;; DISEASE (the competence half): a LAWFUL write between two snapshots
        ;; must make the very same instrument say CHANGED.
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (ml0-write *ml0-account-store*
                     (make-ml0-bundle :fixture-row *settled*
                                      :claimed-act-id *settled-id*
                                      :subject-principal *suite-actor*
                                      :sources (list (ml0-self-report-source
                                                      *settled-id*
                                                      "tooth 7 competence probe"))))
          (not (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        "four refusal paths, one instrument, and the instrument shown able to see ~
a change before its stillness is trusted")

       ;;; ================================================================
       ;;; CONTROL 8 — CROSS-IDENTITY PROVENANCE (D5 / D2 arm b).
       ;;; ================================================================
       (control
        "TOOTH 8 · EVIDENCE CROSSED FROM ANOTHER ACT.  An occurrence basis and an ~
issuance artifact genuinely belonging to act B, presented in act A's bundle"
        ;; CURED: refused PRE-mutation, on identity, for BOTH species.
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (refused-with "ML0-WR-4"
                             (lambda ()
                               (ml0-write *ml0-account-store*
                                          (make-ml0-bundle
                                           :fixture-row *settled*
                                           :claimed-act-id *settled-id*
                                           :subject-principal *suite-actor*
                                           :sources (list *other-world-src*)))))
               (refused-with "ML0-WR-4"
                             (lambda ()
                               (ml0-write *ml0-account-store*
                                          (make-ml0-bundle
                                           :fixture-row *settled*
                                           :claimed-act-id *settled-id*
                                           :subject-principal *suite-actor*
                                           :sources (list *issuance-src*)))))
               (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        ;; DISEASE (the anti-blanket half): the SAME SHAPE with all identities
        ;; matching must SUCCEED — otherwise "refuse everything" would score here.
        (and (succeeded-p (lambda ()
                            (ml0-write *ml0-account-store*
                                       (make-ml0-bundle
                                        :fixture-row *other*
                                        :claimed-act-id *other-id*
                                        :subject-principal *suite-actor*
                                        :sources (list *other-world-src*)))))
             (ml0-account-occurred-p
              (ml0-write *ml0-account-store*
                         (make-ml0-bundle
                          :fixture-row *other*
                          :claimed-act-id *other-id*
                          :subject-principal *suite-actor*
                          ;; ⚑ R3: the warrant-bearing row travels through
                          ;; `:observations`, now the only channel that carries one.
                          :observations (list (ml0-world-observation
                                               *other-id* "a-tertia"))
                          :sources (list (ml0-self-report-source
                                          *other-id* "matching-identity control"))))))
        "the same-shape matching control SUCCEEDS and reads :OCCURRED, so a ~
blanket refusal cannot pass this tooth")

       ;;; ================================================================
       ;;; CONTROL 9 — THE HOST-FAULT DISCIPLINE, TWO-HALVED.
       ;;; ================================================================
       (control
        "TOOTH 9 · AN UNADMITTED HOST FAULT WEARING A SEMANTIC REFUSAL'S CLOTHES"
        ;; CURED half (a): an unadmitted condition becomes a typed bridge
        ;; violation with NO account, NO standing, NO discriminant.
        (and (refused-with "ML0-BRIDGE-2"
                           (lambda ()
                             (ml0-through "a deliberate host fault"
                                          (lambda () (car *host-fault-probe*)))))
             ;; and through the real door: a non-row handed to Write raises a
             ;; TYPE-ERROR inside One Act /1's re-derivation
             (refused-with "ML0-BRIDGE-2"
                           (lambda ()
                             (ml0-write *ml0-account-store*
                                        (make-ml0-bundle
                                         :fixture-row :not-a-fixture-row
                                         :claimed-act-id nil
                                         :subject-principal *suite-actor*
                                         :sources (list *settled-world-src*))))))
        ;; CURED half (b), THE OTHER HALF OF THE GATE: a LAWFUL refusal from an
        ;; ADMITTED family still arrives as ITSELF and is not reclassified.  A
        ;; gate that answered "bridge violation" to everything would pass half
        ;; (a) and fail here.
        (and (handler-case
                 (progn (ml0-through "an admitted lawful refusal"
                                     (lambda ()
                                       (lisp-plus-language-act1:make-act1-fixture-row
                                        :arm "BAD" :label "x" :runtime-seat "x"
                                        :attempt-name "wrong-shape"
                                        :cell-segments '("cella" "prima")
                                        :adapter-symbol 'ml0-controls/bad
                                        :form (lisp-plus-language-act1:act1-request-form
                                               "cella:prima" "t"))))
                        nil)
               (lisp-plus-language-act1:act1-condition (c)
                 (equal "ACT1-FX-3"
                        (lisp-plus-language-act1:act1-condition-requirement-id c)))
               (ml0-condition () nil))
             ;; and through the real door: a lexis-refused request row reaches
             ;; Write, and the ACT LANE'S OWN condition propagates unchanged.
             (handler-case
                 (progn (ml0-write *ml0-account-store*
                                   (make-ml0-bundle
                                    :fixture-row
                                    (ml0-settled-row
                                     :seat "quarta" :attempt "a-quarta"
                                     :text " leading space is refused pre-frontier"
                                     :symbol 'ml0-controls/lexis)
                                    :claimed-act-id nil
                                    :subject-principal *suite-actor*
                                    :sources (list *settled-world-src*)))
                        nil)
               (lisp-plus-language-act1:act1-request-lexis-refused () t)
               (ml0-condition () nil)))
        "both halves of the gate: the unadmitted fault is refused as a HOST FAULT, ~
and an admitted family's lawful refusal still arrives as itself — so `refuse ~
everything as a bridge violation` cannot pass")

       ;;; ================================================================
       ;;; CONTROL 10 — DAMAGED DURABLE BYTES FAIL CLOSED (D7).
       ;;; ================================================================
       (setf *damaged-root* (merge-pathnames "damaged-store/" *root*))
       (setf *flipped-root* (merge-pathnames "flipped-store/" *root*))
       (setf *forged-root* (merge-pathnames "forged-store/" *root*))
       (control
        "TOOTH 10 · DAMAGED DURABLE BYTES.  The lane's OWN account store, ~
truncated, bit-flipped, and — the edit an adversary would actually want — its ~
OCCURRENCE STANDING FORGED IN PLACE at the same length, all on COPIES"
        ;; CURED: the undamaged store still retrieves — so this is not a tooth
        ;; that bites everything.
        (ml0-account-p (ml0-retrieve *ml0-account-store*
                                     :account-hex (ml0-account-id-hex
                                                   *retrieve-target*)))
        ;; DISEASE: both damages produce a typed failure and NO ACCOUNT.
        (let ((truncated-caught nil) (flipped-caught nil) (forged-caught nil))
          (copy-store-directory *ml0-account-root* *damaged-root*)
          (damage-file (merge-pathnames "EVENTS.pj0" *damaged-root*) :truncate)
          (copy-store-directory *ml0-account-root* *flipped-root*)
          (damage-file (merge-pathnames "EVENTS.pj0" *flipped-root*) :flip)
          (copy-store-directory *ml0-account-root* *forged-root*)
          ;; the forge is length-preserving, so the file's size is UNCHANGED —
          ;; asserted, not assumed, because a length change would make the catch
          ;; uninteresting.
          (let ((before (with-open-file (s (merge-pathnames "EVENTS.pj0" *forged-root*)
                                           :element-type '(unsigned-byte 8))
                          (file-length s))))
            (damage-file (merge-pathnames "EVENTS.pj0" *forged-root*) :forge-standing)
            (let ((after (with-open-file (s (merge-pathnames "EVENTS.pj0" *forged-root*)
                                            :element-type '(unsigned-byte 8))
                           (file-length s))))
              (format t "        forge: ~d octets -> ~d octets (same length: ~a)~%"
                      before after (if (= before after) "yes" "NO"))
              (unless (= before after)
                (error "the forge-standing control changed the file length"))))
          (dolist (pair (list (cons *damaged-root* :truncate)
                              (cons *flipped-root* :flip)
                              (cons *forged-root* :forge-standing)))
            (let ((result
                    (handler-case
                        (let ((store (open-store (car pair))))
                          (list :account (ml0-retrieve store)))
                      (ml0-account-readback-refused (c)
                        (list :ml0 (ml0-condition-requirement-id c)))
                      (lisp-plus-journal0:pj0-condition (c)
                        (list :pj0 (lisp-plus-journal0:pj0-condition-requirement-id c)))
                      (error (c) (list :other (type-of c))))))
              (format t "        ~a -> ~s~%" (cdr pair) result)
              (when (member (first result) '(:ml0 :pj0))
                (case (cdr pair)
                  (:truncate (setf truncated-caught t))
                  (:flip (setf flipped-caught t))
                  (:forge-standing (setf forged-caught t))))))
          (and truncated-caught flipped-caught forged-caught))
        "three damages, three typed refusals, no account from any of them.  The ~
forged-standing row is the sharpest: a length-preserving, semantically meaningful ~
LIE is refused, and it is refused twice over (this lane's body-digest/identity ~
check, and beneath it PJ0's own frame-digest chain).  ⚠ THAT IS NOT A SECURITY ~
CLAIM: adversarial tampering stays outside every claim in this lane, and what the ~
row establishes is only that the naive edit does not survive.  The damage reaches ~
ONLY this lane's own record; power loss and filesystem behaviour remain outside ~
every claim here")

       ;;; ================================================================
       ;;; CONTROL 11 — WHAT A POST-APPEND REFUSAL LEAVES BEHIND (R4, F4).
       ;;;
       ;;; TOOTH 7 above measures the refusals that happen BEFORE the append and
       ;;; shows the store byte-unchanged across every one.  It does NOT measure
       ;;; the other kind, and until 2026-08-20 `ml0-write`'s docstring asserted
       ;;; there was no other kind: `a failed write is observably non-mutating
       ;;; over the WHOLE declared store`.  Two paths refute that — the readback
       ;;; (step 6) and the WR-5 identity check (step 7), both AFTER
       ;;; `append-event`, in an append-only store with no rollback.
       ;;;
       ;;; ⚠ THE TRIGGER IS SYNTHESISED AND THE SYNTHESIS IS THE FINDING.  No
       ;;; reachable input produces a post-append refusal: PJ0's `append-event`
       ;;; verifies the frame chain ITSELF and refuses a damaged store BEFORE
       ;;; writing (measured, not assumed — a mid-frame bit-flip yields
       ;;; PJ0-PAYLOAD-DIGEST-MISMATCH from the append, never from the readback).
       ;;; So the readback's ANSWER is forced by the overlay's control seam.
       ;;; EVERYTHING ELSE IS PRODUCTION'S: write's structure, its append, and the
       ;;; total absence of a compensating delete.  What this control measures is
       ;;; the CONSEQUENCE, and the consequence is real.
       ;;; ================================================================
       (control
        "TOOTH 11 · A POST-APPEND REFUSAL IS NOT NON-MUTATING.  The instrument is ~
the same one TOOTH 7 uses — the whole declared account-store directory and every ~
file's sha256 — read on both sides of ONE refused call"
        ;; CURED: a PRE-append refusal, through the same instrument, is byte-neutral.
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (refused-with "ML0-WR-3"
                             (lambda ()
                               (ml0-write *ml0-account-store*
                                          (make-ml0-bundle
                                           :fixture-row *settled*
                                           :claimed-act-id *other-id*
                                           :subject-principal *suite-actor*
                                           :sources (list *settled-world-src*)))))
               (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        ;; DISEASE: the refusal arrives from the READBACK, and the store HAS GROWN.
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (with-ml0-mutant (:readback-refuses-after-append)
                 (refused-with "ML0-RB-1"
                               (lambda ()
                                 (ml0-write *ml0-account-store*
                                            (make-ml0-bundle
                                             :fixture-row *settled*
                                             :claimed-act-id *settled-id*
                                             :subject-principal *suite-actor*
                                             :sources
                                             (list (ml0-self-report-source
                                                    *settled-id*
                                                    "the frame a refused write keeps")))))))
               ;; ⚑ AND THE INSTRUMENT SAYS SO: the store is NOT unchanged.
               (not (ml0-store-scope-unchanged-p
                     before (ml0-take-store-scope *ml0-account-root*)))
               ;; ⚑ AND THE RETAINED FRAME IS WELL-FORMED EVIDENCE, not a torn
               ;; tail: the store still validates and still yields accounts.
               (eq :valid (nth-value 2 (ml0-list-account-ids *ml0-account-store*)))))
        "⚑ R5 (§5.A as amended, Sol disposition B): THIS IS NOW THE GOVERNING ~
SEMANTICS, AND THE RESIDUE IS HOST FAULT ONLY.  The forced readback refusal here ~
MODELS a host fault between append and readback — the one thing the pre-append dry ~
decode (CONTROLs 12–13) cannot move before the append.  Once append-event succeeds, a ~
readback or identity refusal returns NO account and neither retracts nor rewrites ~
durable bytes; the surviving frame acquires no standing by surviving — it is judged ~
only through Journal /0 validation and Memory Layer /0 retrieval (the third conjunct ~
above measures that it still validates).  No rollback exists or is wanted")

       ;;; ================================================================
       ;;; R5 — §5.A AS AMENDED: the planted DRY-DECODE and IDENTITY failures
       ;;; refuse BEFORE the append (cured), and the SAME faults reach the append
       ;;; when the dry decode is skipped (disease) — so the gate is seen to fire.
       ;;; ================================================================
       (control
        "TOOTH 12 · A FRAME THE LANE'S OWN DECODER WOULD REFUSE IS REFUSED BEFORE ~
THE APPEND (ML0-WR-8), store byte-unchanged — and the same planted frame REACHES the ~
append when the dry decode is skipped"
        ;; CURED: planted rendering-version fault → dry decode refuses (WR-8) pre-append
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (with-ml0-mutant (:frame-rendering-mismatch)
                 (refused-with "ML0-WR-8"
                               (lambda ()
                                 (ml0-write *ml0-account-store*
                                            (make-ml0-bundle
                                             :fixture-row *settled*
                                             :claimed-act-id *settled-id*
                                             :subject-principal *suite-actor*
                                             :sources (list (ml0-self-report-source
                                                             *settled-id* "tooth 12 cured")))))))
               (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        ;; DISEASE: dry decode skipped → the fault is appended, the readback refuses
        ;; (RB-7) AFTER the append, and the store HAS GROWN.
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (with-ml0-mutant (:frame-rendering-mismatch :payload :skip-dry-decode)
                 (refused-with "ML0-RB-7"
                               (lambda ()
                                 (ml0-write *ml0-account-store*
                                            (make-ml0-bundle
                                             :fixture-row *settled*
                                             :claimed-act-id *settled-id*
                                             :subject-principal *suite-actor*
                                             :sources (list (ml0-self-report-source
                                                             *settled-id* "tooth 12 diseased")))))))
               (not (ml0-store-scope-unchanged-p
                     before (ml0-take-store-scope *ml0-account-root*)))))
        "The planted fault is a body whose rendering version this decoder does not ~
know (RB-7).  Cured: WR-8 before mutation, whole-store file set + sha256 unchanged.  ~
Diseased (:skip-dry-decode): the frame lands, RB-7 fires from the readback, the ~
store changed — the R4 behaviour, now unreachable except through this seam")

       (control
        "TOOTH 13 · AN IDENTITY THAT IS NOT THE BODY'S CONTENT DIGEST IS REFUSED ~
BEFORE THE APPEND (ML0-WR-8), store byte-unchanged — and reaches the append when the ~
dry decode is skipped"
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (with-ml0-mutant (:identity-mismatch)
                 (setf *ml0-identity-seam-armed* t)
                 (refused-with "ML0-WR-8"
                               (lambda ()
                                 (ml0-write *ml0-account-store*
                                            (make-ml0-bundle
                                             :fixture-row *settled*
                                             :claimed-act-id *settled-id*
                                             :subject-principal *suite-actor*
                                             :sources (list (ml0-self-report-source
                                                             *settled-id* "tooth 13 cured")))))))
               (ml0-store-scope-unchanged-p
                before (ml0-take-store-scope *ml0-account-root*))))
        (let ((before (ml0-take-store-scope *ml0-account-root*)))
          (and (with-ml0-mutant (:identity-mismatch :payload :skip-dry-decode)
                 (setf *ml0-identity-seam-armed* t)
                 (handler-case
                     (progn (ml0-write *ml0-account-store*
                                       (make-ml0-bundle
                                        :fixture-row *settled*
                                        :claimed-act-id *settled-id*
                                        :subject-principal *suite-actor*
                                        :sources (list (ml0-self-report-source
                                                        *settled-id* "tooth 13 diseased"))))
                            nil)
                   ;; any POST-APPEND refusal — the readback's identity check or the
                   ;; decoder's own — is the disease; which one is printed below
                   (ml0-condition (c)
                     (ml0-note "tooth 13 disease refused as ~a [~a]"
                               (type-of c) (ml0-condition-requirement-id c))
                     t)))
               (not (ml0-store-scope-unchanged-p
                     before (ml0-take-store-scope *ml0-account-root*)))))
        "The planted fault is a minted identity one hex digit off the body's digest.  ~
Cured: the dry decode compares the decoded identity to the minted one and refuses ~
WR-8 before mutation.  Diseased: the frame is appended under the wrong identity and ~
the refusal arrives only from the readback, with the store changed")

       (format t "~&~%"))
  (when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t)))

(format t "~&ml0-controls: ~d controls, ~d caught, ~d missed~%"
        *controls* *caught* *missed*)
(finish-output)
(sb-ext:exit :code (if (zerop *missed*) 0 1))
