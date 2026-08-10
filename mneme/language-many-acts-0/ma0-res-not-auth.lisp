;;;; ma0-res-not-auth.lisp — W-RES-NOT-AUTH, THE HOSTILE-DRIVER HALF.
;;;; (FAILURE MATRIX §2: "a result object substituted for authority is refused
;;;; statically (V-AUTH) AND, if forced via a hostile driver against
;;;; `ma0-complete-act', unrecognized upstream (Capability /1 law WITNESSED,
;;;; not claimed)".)
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-res-not-auth.lisp
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; THE TWO HALVES, AND WHOSE LAW EACH ONE IS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; A RESULT IS NOT AUTHORITY.  This lane hands a program two kinds of result
;;;; object — an act-SUMMARY (what `act' binds) and a derived seat-OUTCOME (what
;;;; `derive' binds) — and the interesting question is not whether the grammar
;;;; forbids putting one in the authority position.  It is what happens when a
;;;; driver puts one there anyway.
;;;;
;;;;   HALF 1 — WHERE MA0'S SURFACE CAN SEE IT, MA0 REFUSES, TYPED.
;;;;   Four substitutions, each through a door this lane actually owns: a
;;;;   literal in `:authority-slot'; an act-result identifier there; a derived
;;;;   outcome identifier there; and — the runtime door — a live result object
;;;;   handed to `make-ma0-environment' as a grant plan's slot and as an input
;;;;   value.  Every refusal is typed, carries a stable code, and happens
;;;;   BEFORE any live state exists.
;;;;
;;;;   HALF 2 — WHERE THE DRIVER GOES AROUND MA0, THE UPSTREAM LAW REFUSES.
;;;;   ⚠ THIS REFUSAL IS CAPABILITY /1'S, NOT MA0'S, AND EVERY CHECK NAME SAYS
;;;;   SO.  The driver takes the SAME live store, bootstrap and minting context
;;;;   the environment built — reached through One Act /0's own exported
;;;;   run-state specials, so nothing internal is touched — and presents each
;;;;   result object at Capability /1's recognition seam by calling the exported
;;;;   `present-live-capability' directly.  Recognition there is EQ membership
;;;;   in what the context minted (present.lisp §1), so an object carrying every
;;;;   public field in the world is still not a key.  MA0 could not have written
;;;;   this law and does not claim it; the condition type and requirement-id are
;;;;   captured VERBATIM from the signal.
;;;;
;;;; ⚠ THE CONTROL IS THE WHOLE POINT OF HALF 2.  A seam that refuses every
;;;; object refuses impostors for no reason worth reporting.  So the act's OWN
;;;; Office R capability — the genuine key, from the same mint, in the same
;;;; context — is presented FIRST, and the check is that it does NOT refuse at
;;;; the RECOGNITION step.  Whether it then passes or refuses further down (the
;;;; prefix advances as frames land, and exact prefix binding makes any advance
;;;; STALE — present.lisp's "honest subsumption") is recorded either way: what
;;;; must not happen is the genuine key being called unrecognized.
;;;;
;;;; ⚠ AND THE STORE MUST GAIN NOTHING.  The validated prefix is counted before
;;;; the hostile block and after it; a refusal that wrote something would be a
;;;; different failure wearing this one's name.
;;;;
;;;; Sentinel, printed on the green path and no other:
;;;;   ma0-res-not-auth: <N> checks, 0 failures
;;;;
;;;; — DENS (Claude Opus 5, subagent), 2026-08-09

(require :asdf)
(require :sb-posix)

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: authorized for SBCL 2.4.6 only.  Observed ~a.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*dens-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*dens-tree*
  (truename (merge-pathnames "../../" cl-user::*dens-here*)))

(defparameter cl-user::*dens-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string (string-right-trim "/" tmp)
                            "/ma0-res-not-auth.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*dens-tree*))
      (root (namestring cl-user::*dens-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output* "~&!! FAIL CLOSED: run root ~a is INSIDE ~a~%" root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "~&== ma0-res-not-auth — SBCL ~a ==~%   run root: ~a~%"
        (lisp-implementation-version) cl-user::*dens-root*)
(finish-output *error-output*)

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*dens-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/many-acts-0"))

(in-package #:cl-user)

(defvar *passed* 0)
(defvar *failed* 0)

(defun dens-check (name ok &optional (fmt "") &rest args)
  (if ok (incf *passed*) (incf *failed*))
  (format t "~&  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") name
          (let ((s (apply #'format nil fmt args))) (if (string= s "") nil s)))
  (force-output)
  (and ok t))

(defun dens-store () lisp-plus-language-act0:*store*)

(defun dens-prefix-frames ()
  (lisp-plus-journal0:prefix-report-frame-count
   (lisp-plus-journal0:validate-journal (dens-store))))

(defun dens-fixture (arm)
  (find arm lisp-plus-language-act0:*act-fixture-table*
        :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=))

(defun dens-write (basename text)
  (let ((path (merge-pathnames basename cl-user::*dens-root*)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string text out))
    path))

;;; --------------------------------------------------------------------------
;;; The four grant terms, RE-DECLARED from published source (act0.lisp:1156-1158
;;; and :1161-1168) — values read out of a public file, never internal symbols
;;; called.  The per-seat resource comes from the EXPORTED cell-segments reader.
;;; --------------------------------------------------------------------------

(defun dens-idf (segments)
  (lisp-plus-journal0:identifier-from-segments segments))

(defun dens-terms (fixture)
  (list :subject (dens-idf '("subject" "scriba"))
        :action (dens-idf '("action" "inscribere"))
        :resource (dens-idf (lisp-plus-language-act0:act-fixture-cell-segments
                             fixture))
        :scope (dens-idf '("scope" "semel"))))

;;; --------------------------------------------------------------------------
;;; The recognition seam, called directly.  ⚠ CAPABILITY /1'S DOOR, NOT MA0'S.
;;; Returns (values outcome condition-type requirement-id detail-plist condition).
;;; The CONDITION OBJECT is returned, not only its type name, so the "this is
;;; not an MA0 refusal" check can be a real TYPEP against the thing that was
;;; signalled rather than a sentence about it.
;;; --------------------------------------------------------------------------

(defun dens-present (object fixture label)
  (let ((terms (dens-terms fixture)))
    (handler-case
        (let ((receipt (lisp-plus-capability1:present-live-capability
                        (dens-store)
                        lisp-plus-language-act0:*bootstrap*
                        lisp-plus-language-act0:*minting-context*
                        object
                        :subject (getf terms :subject)
                        :action (getf terms :action)
                        :resource (getf terms :resource)
                        :scope (getf terms :scope)
                        :presentation-id (list "cap1-presentation" label))))
          (declare (ignore receipt))
          (values :receipt nil nil nil nil))
      (lisp-plus-capability1:cap1-unrecognized-object (c)
        (values :unrecognized (type-of c)
                (lisp-plus-capability1:cap1-condition-requirement-id c)
                (list :presented-type
                      (lisp-plus-capability1:cap1-unrecognized-object-presented-type c)
                      :presented-public-id
                      (lisp-plus-capability1:cap1-unrecognized-object-presented-public-id c)
                      :context-label
                      (lisp-plus-capability1:cap1-unrecognized-object-context-label c))
                c))
      (lisp-plus-capability1:cap1-condition (c)
        (values :other-cap1 (type-of c)
                (lisp-plus-capability1:cap1-condition-requirement-id c) nil c))
      (error (c)
        (values :other (type-of c) nil nil c)))))

;;; --------------------------------------------------------------------------
;;; Sources whose authority position carries something that is not a slot.
;;; --------------------------------------------------------------------------

(defparameter *literal-in-authority-position* "
(ma0-program
 (:name \"literal-in-authority-position\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (act only (:arm \"A\") (:authority-slot \"g\"))
  (result :should-never-be-reached)))
")

(defparameter *act-result-in-authority-position* "
(ma0-program
 (:name \"act-result-in-authority-position\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (act first-act (:arm \"A\") (:authority-slot g))
  (act second-act (:arm \"C-i\") (:authority-slot first-act))
  (result :should-never-be-reached)))
")

(defparameter *outcome-in-authority-position* "
(ma0-program
 (:name \"outcome-in-authority-position\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (derive standing (:seat \"s\"))
  (act only (:arm \"A\") (:authority-slot standing))
  (result :should-never-be-reached)))
")

(defparameter *one-lawful-act* "
(ma0-program
 (:name \"one-lawful-act\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (act only (:arm \"C-i\") (:authority-slot g))
  (result :one-act-ran)))
")

(defun dens-expect-source-refusal (name text code)
  (handler-case
      (progn (lisp-plus-many-acts0:ma0-validate
              (dens-write (format nil "~a.lisp" name) text))
             (dens-check name nil "the source was ACCEPTED; expected code ~s" code))
    (lisp-plus-many-acts0:ma0-refusal (c)
      (dens-check name (equal code (lisp-plus-many-acts0:ma0-refusal-code c))
                  "type=~s code=~s (expected ~s)" (type-of c)
                  (lisp-plus-many-acts0:ma0-refusal-code c) code))
    (error (c)
      (dens-check name nil "an UNTYPED condition escaped the validator: ~s"
                  (type-of c)))))

(defun dens-expect-environment-refusal (name code thunk)
  (handler-case
      (progn (funcall thunk)
             (dens-check name nil "the environment door ACCEPTED it; expected ~s"
                         code))
    (lisp-plus-many-acts0:ma0-refusal (c)
      (dens-check name (equal code (lisp-plus-many-acts0:ma0-refusal-code c))
                  "type=~s code=~s (expected ~s)" (type-of c)
                  (lisp-plus-many-acts0:ma0-refusal-code c) code))
    (error (c)
      (dens-check name nil "an UNTYPED condition escaped the door: ~s"
                  (type-of c)))))

;;; --------------------------------------------------------------------------
;;; THE RUN.
;;; --------------------------------------------------------------------------

(defun dens-run ()
  (format t "~&== W-RES-NOT-AUTH — a result object forced into authority position ==~%")
  (let* ((environment (lisp-plus-many-acts0:make-ma0-environment
                       :root cl-user::*dens-root*
                       :arms '("A" "C-i")
                       :grants '((:slot "g" :arm "A") (:slot "g" :arm "C-i"))
                       :revocations '()
                       :seat-map '(("s" . "prima"))
                       :inputs '()))
         (fixture-a (dens-fixture "A"))
         (seat-a (lisp-plus-language-act0:act-fixture-runtime-seat fixture-a)))

    ;; ---- the act, by hand, so the GENUINE Office R key is in reach.
    (let* ((result (lisp-plus-language-act0:run-act fixture-a :verbose nil))
           (office-r (getf result :office-r)))
      (dens-check "SETUP the act minted a live Office R capability"
                  (and office-r (lisp-plus-capability1:live-capability-p office-r))
                  "live-capability-p=~s" (and office-r
                                              (lisp-plus-capability1:live-capability-p
                                               office-r)))

      ;; ---- THE CONTROL, FIRST.  The genuine key must not be UNRECOGNIZED.
      (format t "~&~%-- CONTROL: the act's own key at Capability /1's seam --~%")
      (multiple-value-bind (outcome kind requirement detail)
          (dens-present office-r fixture-a "dens-control")
        (declare (ignore detail))
        (format t "~&    genuine key => ~s~@[ ~s~]~@[ requirement=~s~]~%"
                outcome kind requirement)
        (dens-check "CONTROL the GENUINE key is not refused as unrecognized"
                    (not (eq outcome :unrecognized))
                    "outcome=~s type=~s requirement=~s" outcome kind requirement)
        (dens-check "CONTROL and the seam gave it a decision it could only give a key it minted"
                    (member outcome '(:receipt :other-cap1))
                    "outcome=~s (a receipt, or a refusal from PAST recognition)"
                    outcome))

      ;; ---- finish the act through this lane's composition.
      (lisp-plus-many-acts0:ma0-complete-act result environment))

    ;; ---- a lawful program on the other arm, for a real act-SUMMARY object.
    (let* ((program-result
             (lisp-plus-many-acts0:ma0-run-program
              (lisp-plus-many-acts0:ma0-validate
               (dens-write "one-lawful-act.lisp" *one-lawful-act*))
              environment))
           (summary (first (lisp-plus-many-acts0:ma0-result-act-summaries
                            program-result)))
           (events (lisp-plus-surface2:validated-store-events (dens-store)))
           (outcome-object (lisp-plus-surface2:derive-seat-outcome
                            (dens-store) events seat-a))
           (frames-before (dens-prefix-frames)))
      (dens-check "SETUP the program bound a real act-summary"
                  (and summary (lisp-plus-many-acts0:ma0-act-summary-p summary))
                  "act-summary-p=~s"
                  (and summary (lisp-plus-many-acts0:ma0-act-summary-p summary)))
      (dens-check "SETUP a derived seat-outcome stands for the completed seat"
                  (and outcome-object
                       (lisp-plus-surface2:seat-outcome-p outcome-object))
                  "seat-outcome-p=~s"
                  (and outcome-object
                       (lisp-plus-surface2:seat-outcome-p outcome-object)))
      (format t "~&    prefix frames before the hostile block: ~d~%" frames-before)

      ;; ---- HALF 2: the upstream seam.  CAPABILITY /1'S LAW.
      (format t "~&~%-- HALF 2: the result objects at Capability /1's recognition seam --~%")
      (dolist (row (list (list "act-summary" summary "dens-summary")
                         (list "seat-outcome" outcome-object "dens-outcome")))
        (destructuring-bind (what object label) row
          (multiple-value-bind (outcome kind requirement detail condition)
              (dens-present object fixture-a label)
            (format t "~&DENS-RNA ~a condition-type=~a~%" what kind)
            (format t "~&DENS-RNA ~a requirement-id=~a~%" what requirement)
            (format t "~&DENS-RNA ~a presented-type=~a~%" what
                     (getf detail :presented-type))
            (format t "~&DENS-RNA ~a context-label=~a~%" what
                     (getf detail :context-label))
            (dens-check
             (format nil "W-RES-NOT-AUTH CAPABILITY /1 refuses the ~a as UNRECOGNIZED" what)
             (eq outcome :unrecognized)
             "outcome=~s type=~s" outcome kind)
            (dens-check
             (format nil "W-RES-NOT-AUTH the ~a refusal is Capability /1's own condition" what)
             (eq kind 'lisp-plus-capability1:cap1-unrecognized-object)
             "type=~s" kind)
            (dens-check
             (format nil "W-RES-NOT-AUTH the ~a refusal carries a requirement-id" what)
             (and requirement (stringp requirement) (plusp (length requirement)))
             "requirement-id=~s" requirement)
            (dens-check
             (format nil "W-RES-NOT-AUTH the ~a refusal is NOT an MA0 condition" what)
             (and condition
                  (not (typep condition 'lisp-plus-many-acts0:ma0-refusal)))
             "typep ma0-refusal => ~s — the law is Capability /1's"
             (and condition (typep condition 'lisp-plus-many-acts0:ma0-refusal)))
            (dens-check
             (format nil "W-RES-NOT-AUTH the ~a refusal names the presenting context" what)
             (equal "manyacts0" (getf detail :context-label))
             "context-label=~s" (getf detail :context-label)))))

      ;; ---- HALF 1: MA0's own surface.
      (format t "~&~%-- HALF 1: the same substitution where MA0's surface can see it --~%")
      (dens-expect-source-refusal "W-RES-NOT-AUTH a literal in authority position"
                                  *literal-in-authority-position* "V-RES-AUTH")
      (dens-expect-source-refusal "W-RES-NOT-AUTH an act-result in authority position"
                                  *act-result-in-authority-position* "V-AUTH")
      (dens-expect-source-refusal "W-RES-NOT-AUTH a derived outcome in authority position"
                                  *outcome-in-authority-position* "V-AUTH")
      (dens-expect-environment-refusal
       "W-RES-NOT-AUTH an act-summary handed to the environment as a grant slot"
       "MA0-ENV-GRANT"
       (lambda ()
         (lisp-plus-many-acts0:make-ma0-environment
          :root cl-user::*dens-root* :arms '("A")
          :grants (list (list :slot summary :arm "A"))
          :revocations '() :seat-map '() :inputs '())))
      (dens-expect-environment-refusal
       "W-RES-NOT-AUTH a seat-outcome handed to the environment as an input value"
       "MA0-ENV-DATA"
       (lambda ()
         (lisp-plus-many-acts0:make-ma0-environment
          :root cl-user::*dens-root* :arms '("A")
          :grants '((:slot "g" :arm "A"))
          :revocations '() :seat-map '()
          :inputs (list (cons "smuggled" outcome-object)))))

      ;; ---- the store gained nothing from any of it.
      (format t "~&~%-- the store --~%")
      (dens-check "W-RES-NOT-AUTH the hostile block appended NOTHING"
                  (eql frames-before (dens-prefix-frames))
                  "before=~d after=~d" frames-before (dens-prefix-frames))
      (dens-check "W-RES-NOT-AUTH the prefix still reads back whole"
                  (eq :valid (lisp-plus-journal0:prefix-report-status
                              (lisp-plus-journal0:validate-journal (dens-store))))
                  "status=~s" (lisp-plus-journal0:prefix-report-status
                               (lisp-plus-journal0:validate-journal (dens-store)))))))

(let ((suite-error nil))
  (unwind-protect
       (handler-case (dens-run)
         (error (c)
           (setf suite-error c)
           (format t "~&!! THE WITNESS SIGNALLED: ~a~%" (type-of c))
           (format *error-output* "~&!! ~a~%" c)))
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (format *error-output* "   run root removed (exists: ~a)~%"
            (and (probe-file cl-user::*dens-root*) t))
    (finish-output *error-output*))
  (let* ((total (+ *passed* *failed*))
         (green (and (null suite-error) (zerop *failed*) (plusp total))))
    (format t "~&~%== TALLY: ~d passed, ~d failed ==~%" *passed* *failed*)
    (if green
        (format t "~&ma0-res-not-auth: ~d checks, 0 failures~%" total)
        (format t "~&ma0-res-not-auth: RUN REFUSED — ~d check(s), ~d failure(s).~
~@[  the witness signalled: ~a~]  The success sentinel is WITHHELD.~%"
                total *failed* (and suite-error (type-of suite-error))))
    (finish-output)
    (sb-ext:exit :code (if green 0 1))))
