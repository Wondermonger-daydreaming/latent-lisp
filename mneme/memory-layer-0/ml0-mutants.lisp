;;;; ml0-mutants.lisp — Memory Layer /0: SIX PLANTED DEFECTS, EACH KILLED.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-mutants.lisp
;;;;
;;;; Sentinel: ml0-mutants: 6 defects, 6 killed, 0 survivors
;;;;
;;;; ⚑ EACH DEFECT MAKES EXACTLY ONE FORBIDDEN COLLAPSE, and each is DRIVEN OVER
;;;; THE SHIPPED CODE — never in a copy of the logic.  A mutant that lived in a
;;;; test-only reimplementation would prove that the reimplementation is killable,
;;;; which is not a fact about this lane.  Every wrapper in
;;;; `ml0-mutant-overlay.lisp` delegates to the production function it saved and
;;;; changes exactly the one thing it names.
;;;;
;;;; ⚠ R4: THE `:defect` SEAM IS GONE FROM PRODUCTION and this file no longer
;;;; passes one.  It was a public `&key` on ten exported functions, defended by a
;;;; docstring saying `production NIL, controls only` — which a cross-family
;;;; adversarial reader flipped through the front door in a canonically-loaded
;;;; image.  The defects moved OUT; the kills did not change.
;;;;
;;;; A DEFECT COUNTS AS KILLED when its kill predicate is TRUE against the lane
;;;; as it ships AND FALSE against the defect.  A predicate false under both is a
;;;; predicate that proves nothing, and it is reported as a SURVIVOR here rather
;;;; than quietly counted as a kill.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
;; ⚑ THE DEFECTS LIVE HERE NOW (R4).  Until 2026-08-20 they rode a `&key defect`
;; on ten EXPORTED production functions and this file only had to pass a keyword.
;; The seam is gone from the lane; the overlay installs the same six collapses by
;; redefining production functions with delegating wrappers, and `load.lisp` — the
;; canonical door every consumer uses — cannot reach this file.
(load (merge-pathnames "ml0-mutant-overlay.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *defects* 0)
(defvar *killed* 0)
(defvar *survivors* 0)

(defun mutant (name collapse cured-thunk diseased-thunk)
  "CURED-THUNK must answer T (the law holds); DISEASED-THUNK must answer NIL (the
law is broken).  Anything else is a SURVIVOR."
  (incf *defects*)
  (let* ((cured (handler-case (funcall cured-thunk) (error () :error)))
         (diseased (handler-case (funcall diseased-thunk) (error () :error)))
         (killed (and (eq t cured) (null diseased))))
    (if killed (incf *killed*) (incf *survivors*))
    (format t "~&[~d] ~a  ~a~%    forbidden collapse: ~a~%    cured => ~s · diseased => ~s~%"
            *defects* (if killed "KILLED  " "SURVIVED") (format nil name)
            (format nil collapse) cured diseased)
    (finish-output)
    killed))

(format t "~&Memory Layer /0 — MUTANTS.  CANDIDATE; nothing here is adopted, and ~
nothing here is independent verification.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-mutants: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(defvar *root* (ml0-fresh-run-root "ml0-mutants" *subject-root*))

;;; ⚠ THE RUN'S VARIABLES ARE DECLARED AT TOP LEVEL AND ASSIGNED BELOW.
;;; `defparameter` INSIDE the unwind-protect would be one top-level form,
;;; so every later reference in that form compiles against an undefined
;;; variable and SBCL warns — and a gate whose own transcript is full of
;;; compiler noise is a gate nobody reads.
(defvar *settled* nil)
(defvar *refused* nil)
(defvar *settled-result* nil)
(defvar *refused-result* nil)
(defvar *settled-id* nil)
(defvar *refused-id* nil)
(defvar *world-src* nil)
(defvar *issuance-src* nil)
(defvar *blind-negative* nil)
(defvar *base-account* nil)
(defvar *clash-positive* nil)
(defvar *negative-account* nil)

(unwind-protect
     (progn
       (ml0-ground *root*)
       (setf *settled* (ml0-settled-row))
       (setf *refused* (ml0-refused-row))
       (setf lisp-plus-language-act1:*act1-fixture-table* (list *settled* *refused*))
       (ml0-open-authority (list *settled* *refused*))
       (setf *settled-result*
         (lisp-plus-language-act1:run-act1 *settled* :verbose nil))
       (setf *refused-result*
         (lisp-plus-language-act1:run-act1 *refused* :verbose nil))
       (setf *settled-id* (nth-value 0 (ml0-rederive-act-identity *settled*)))
       (setf *refused-id* (nth-value 0 (ml0-rederive-act-identity *refused*)))
       (setf *world-src* (ml0-world-source *settled-id* "a-prima"))
       (setf *issuance-src*
         (ml0-issuance-source *refused-id*
                              (lisp-plus-language-act1:act1-result-evidence
                               *refused-result*)))
       ;; ⚑ THE SYNTHESISED ADVERSARIAL ROW (see ml0-controls TOOTH 5): the exact
       ;; shape the mutant would admit and no door would produce — door-stamped,
       ;; :COULD-NOT-LOOK, and attesting a finding anyway.  The honest blind row
       ;; from the absence door now attests :INCONCLUSIVE and is stopped twice, so
       ;; it can no longer make this mutant bleed.
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
       (setf *base-account*
         (ml0-write *ml0-account-store*
                    (make-ml0-bundle :fixture-row *settled*
                                     :claimed-act-id *settled-id*
                                     :subject-principal *suite-actor*
                                     :sources (list *world-src*)
                                     :issuance-observation (ml0-issuance-observation-for *settled-id* *settled-result*))))
       ;; ⚑ REBUILT IN THE REPAIR ROUND.  A COMMENSURABLE clash between two
       ;; WARRANTING rows is no longer reachable — two correct doors reading one
       ;; universe over one interval agree — so this defect is now exercised on
       ;; what it actually corrupts: consolidation INHERITING an input's standing
       ;; instead of RE-DERIVING from the surviving warrants.  The ordering is
       ;; constructed so the two answers must differ; without that the mutant and
       ;; the cure would coincide and the kill would prove nothing.
       (setf *clash-positive*
             (ml0-write *ml0-account-store*
                        (make-ml0-bundle :fixture-row *settled*
                                         :claimed-act-id *settled-id*
                                         :subject-principal *suite-actor*
                                         :observations
                                         (list (ml0-world-observation *settled-id*
                                                                     "a-prima")))))
       (setf *negative-account*
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

       ;; ---- 1 -------------------------------------------------------------
       (mutant "ISSUANCE-IMPLIES-OCCURRENCE (the crown)"
               "an issued Core /0 evidence account is treated as sufficient ~
warrant that the act occurred"
               (lambda ()
                 (not (ml0-occurrence-warranted-p *refused-id* (list *issuance-src*))))
               (lambda ()
                 (with-ml0-mutant (:issuance-implies-occurrence)
                   (not (ml0-occurrence-warranted-p *refused-id*
                                                    (list *issuance-src*))))))

       ;; ---- 2 -------------------------------------------------------------
       (mutant "RETRIEVE-REPERFORMS"
               "reading an account makes a journal or world transition"
               (lambda ()
                 (let ((frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                       (world (lisp-plus-language-act1:take-world-scope
                               (ml0-world) (ml0-world-directory))))
                   (ml0-retrieve *ml0-account-store*
                                 :account-hex (ml0-account-id-hex *base-account*))
                   (and (eql frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                        (lisp-plus-language-act1:world-scope-unchanged-p
                         world (lisp-plus-language-act1:take-world-scope
                                (ml0-world) (ml0-world-directory)))
                        t)))
               (lambda ()
                 ;; the mutant CALLER: retrieve, then act.  Same instrument.
                 (let ((frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                       (world (lisp-plus-language-act1:take-world-scope
                               (ml0-world) (ml0-world-directory)))
                       (row (ml0-settled-row :attempt "a-prima-9"
                                             :text "Actus iteratus a lectore."
                                             :symbol 'ml0-mutants/reperform)))
                   (ml0-retrieve *ml0-account-store*
                                 :account-hex (ml0-account-id-hex *base-account*))
                   (lisp-plus-language-act1:act1-opening-authority
                    *ml0-act-store* (list row))
                   (lisp-plus-language-act1:run-act1 row :verbose nil)
                   (and (eql frames (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                        (lisp-plus-language-act1:world-scope-unchanged-p
                         world (lisp-plus-language-act1:take-world-scope
                                (ml0-world) (ml0-world-directory)))
                        t))))

       ;; ---- 3 -------------------------------------------------------------
       (mutant "RETRIEVE-MINTS-OR-PROMOTES-TO-CURRENT-IMAGE-EVIDENCE"
               "an account carries, or is treated as, a current-image Core /0 ~
evidence account"
               (lambda ()
                 (and (ml0-account-carries-no-current-image-evidence-p *base-account*)
                      (ml0-account-carries-no-current-image-evidence-p
                       (ml0-retrieve *ml0-account-store*
                                     :account-hex (ml0-account-id-hex *base-account*)))
                      t))
               (lambda ()
                 (with-ml0-mutant (:retain-live-evidence
                                   :payload (lisp-plus-language-act1:act1-result-evidence
                                             *settled-result*))
                   (ml0-account-carries-no-current-image-evidence-p
                    (ml0-write *ml0-account-store*
                               (make-ml0-bundle
                                :fixture-row *settled*
                                :claimed-act-id *settled-id*
                                :subject-principal *suite-actor*
                                :sources (list *world-src*
                                               (ml0-self-report-source
                                                *settled-id* "mutant 3"))))))))

       ;; ---- 4 -------------------------------------------------------------
       (mutant "CONSOLIDATION-INHERITS-A-STANDING (last-write-wins)"
               "a consolidated standing is taken from an input's KEYWORD instead ~
of being re-derived from the warrants that survived"
               (lambda ()
                 ;; RE-DERIVED: a warranting positive survives the union, so the
                 ;; answer is :OCCURRED even though the LAST ordered input says
                 ;; :NONOCCURRED.
                 (and (string< (ml0-account-id-hex *clash-positive*)
                               (ml0-account-id-hex *negative-account*))
                      (eq :nonoccurred (ml0-account-occurrence-standing
                                        *negative-account*))
                      ;; R4.1: consolidation returns a typed carrier — the
                      ;; standing under test is read off it, not compared to it.
                      (eq :occurred
                          (ml0-consolidation-occurrence-standing
                           (ml0-consolidate (list *clash-positive*
                                                  *negative-account*))))))
               (lambda ()
                 (with-ml0-mutant (:last-write-wins)
                   (eq :occurred
                       (ml0-consolidation-occurrence-standing
                        (ml0-consolidate (list *clash-positive*
                                               *negative-account*)))))))

       ;; ---- 5 -------------------------------------------------------------
       (mutant "PROVENANCE/SCOPE-DROPPED"
               ":could-not-look masquerades as looked-across-the-universe-and-absent"
               (lambda ()
                 (and (not (ml0-nonoccurrence-warranted-p *refused-id*
                                                          (list *blind-negative*)))
                      (eq :unresolved
                          (ml0-derive-occurrence-standing *refused-id*
                                                          (list *blind-negative*)))
                      t))
               (lambda ()
                 (with-ml0-mutant (:drop-scope)
                   (and (not (ml0-nonoccurrence-warranted-p *refused-id*
                                                            (list *blind-negative*)))
                        (eq :unresolved
                            (ml0-derive-occurrence-standing *refused-id*
                                                            (list *blind-negative*)))
                        t))))

       ;; ---- 6 -------------------------------------------------------------
       (mutant "ORIGIN-UPGRADE-ON-SUCCESSFUL-READBACK"
               "successful validation of a reconstructed account upgrades its ~
source to a live observation"
               (lambda ()
                 (let ((r (ml0-retrieve *ml0-account-store*
                                        :account-hex (ml0-account-id-hex
                                                      *base-account*))))
                   (and (eq :reconstructed (ml0-account-retrieval-origin r))
                        (notany (lambda (s) (eq :live-query
                                                (ml0-source-acquisition-route s)))
                                (remove-if-not
                                 (lambda (s) (eq :reconstructed
                                                 (ml0-source-acquisition-route s)))
                                 (ml0-account-sources r)))
                        (equal (mapcar #'ml0-source-acquisition-route
                                       (ml0-account-sources r))
                               (mapcar #'ml0-source-acquisition-route
                                       (ml0-account-sources *base-account*)))
                        t)))
               (lambda ()
                 (with-ml0-mutant (:origin-upgrade-on-readback)
                   (let ((r (ml0-retrieve *ml0-account-store*
                                          :account-hex (ml0-account-id-hex
                                                        *base-account*))))
                     (and (eq :reconstructed (ml0-account-retrieval-origin r)) t)))))

       (format t "~&~%"))
  (when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t)))

(format t "~&ml0-mutants: ~d defects, ~d killed, ~d survivors~%"
        *defects* *killed* *survivors*)
(finish-output)
(sb-ext:exit :code (if (zerop *survivors*) 0 1))
