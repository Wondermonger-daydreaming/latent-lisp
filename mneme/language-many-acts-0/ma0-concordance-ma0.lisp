;;;; ma0-concordance-ma0.lisp — THE MA0 SIDE of the concordance teeth
;;;; (FAILURE MATRIX §3, contract §4).
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-concordance-ma0.lisp <arm>
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS IMAGE IS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; ONE arm, ONE image, ONE store: the environment is built through MANY ACTS
;;;; /0's own door, the adopted `run-act' runs L0..L17, and the completion is
;;;; THIS LANE'S `ma0-complete-act' — the re-composition whose agreement with
;;;; the canonical composer is the question (contract §4).  Driving the
;;;; exported composition directly is what contract §6 exports it for.
;;;;
;;;; ⚠ THE FACTS ARE READ OUT OF THE STORE, not out of the return value, and
;;;; the reading code is the SAME SHAPE as the canonical side's, so a facet
;;;; that agrees agrees about the RECORD a cold reader would find.
;;;;
;;;; ⚠ NO DIGEST IS EMITTED.  Journal /0's per-event digest is prefix-chained,
;;;; so the same frame bytes in two stores digest differently; comparing them
;;;; across stores would manufacture a divergence that means nothing.  The
;;;; act-identity digest IS emitted, because it is derived from the seat and
;;;; the canonical request and from no store state — if THAT diverges, the
;;;; divergence is real.
;;;;
;;;; ⚠ B-R CARRIES A DECLARED REVOCATION.  One Act /0's opening authority
;;;; journals a revocation for arm B-R specifically (act0.lisp:1233-1237); this
;;;; environment declares the same one, so the arm meets the same condition.
;;;; Without it the two sides would be running different arms and calling the
;;;; difference a divergence.
;;;;
;;;; STDOUT is the harvest: lines of the form
;;;;   DENS-MA0 <arm> <facet>=<value>
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

(defparameter cl-user::*dens-arm*
  (or (second sb-ext:*posix-argv*)
      (progn (format *error-output* "~&!! no arm named~%") (sb-ext:exit :code 1))))

(defparameter cl-user::*dens-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string (string-right-trim "/" tmp)
                            "/ma0-concord-ma0.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*dens-tree*))
      (root (namestring cl-user::*dens-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output* "~&!! FAIL CLOSED: run root ~a is INSIDE ~a~%" root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "~&== ma0-concordance-ma0 — SBCL ~a — arm ~a ==~%   run root: ~a~%"
        (lisp-implementation-version) cl-user::*dens-arm* cl-user::*dens-root*)
(finish-output *error-output*)

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*dens-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/many-acts-0"))

(in-package #:cl-user)

(defun dens-emit (arm facet value)
  (format t "~&DENS-MA0 ~a ~a=~a~%" arm facet value)
  (force-output))

(defun dens-store () lisp-plus-language-act0:*store*)

(defun dens-fixture (arm)
  (or (find arm lisp-plus-language-act0:*act-fixture-table*
            :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=)
      (error "no adopted fixture carries arm ~s" arm)))

;;; --------------------------------------------------------------------------
;;; Reading the RECORD back.  Same shape as the canonical side's readers.
;;; --------------------------------------------------------------------------

(defun dens-frame-body (attempt frame)
  (multiple-value-bind (ordinal digest payload)
      (lisp-plus-journal0:find-event
       (dens-store) (lisp-plus-language-act0:frame-event-id frame attempt))
    (declare (ignore digest))
    (and ordinal
         (lisp-plus-journal0:record-field
          (lisp-plus-journal0:decode-pjs0 payload) "event" "body"))))

(defun dens-body-string (body field)
  (let ((datum (and body (lisp-plus-journal0:record-field body "act" field))))
    (if (and datum (lisp-plus-cd0:string-datum-p datum))
        (lisp-plus-cd0:string-datum-value datum)
        "none")))

(defun dens-frames-present (attempt)
  (loop for frame in '(:f1 :f2 :f3 :f4 :f5)
        when (lisp-plus-journal0:find-event
              (dens-store) (lisp-plus-language-act0:frame-event-id frame attempt))
          collect frame))

(defun dens-act-id-hex (attempt)
  (let* ((body (dens-frame-body attempt :f1))
         (id (and body (lisp-plus-journal0:record-field body "act" "act-id"))))
    (if (and id (lisp-plus-cd0:identifier-datum-p id))
        (car (last (lisp-plus-journal0:identifier-segments id)))
        "none")))

;;; --------------------------------------------------------------------------
;;; The environment, through MANY ACTS /0's own door — DECLARATIONS only.
;;; --------------------------------------------------------------------------

(defun dens-environment (arm)
  (lisp-plus-many-acts0:make-ma0-environment
   :root cl-user::*dens-root*
   :arms (list arm)
   :grants (list (list :slot "g" :arm arm))
   ;; act0.lisp:1233-1237 — the opening authority revokes arm B-R's capability
   ;; after granting it.  The declared revocation reproduces that condition.
   :revocations (if (string= arm "B-R") (list (list :arm arm)) '())
   :seat-map '()
   :inputs '()))

;;; --------------------------------------------------------------------------
;;; THE RUN.
;;; --------------------------------------------------------------------------

(defun dens-run (arm)
  (let* ((environment (dens-environment arm))
         (fixture (dens-fixture arm))
         (attempt (lisp-plus-language-act0:act-fixture-attempt-name fixture))
         (result (lisp-plus-language-act0:run-act fixture :verbose nil))
         (unpaired (eq :unpaired-f1 (getf result :class)))
         (done (unless unpaired
                 (lisp-plus-many-acts0:ma0-complete-act result environment))))
    (let* ((present (dens-frames-present attempt))
           (absent (set-difference '(:f1 :f2 :f3 :f4 :f5) present))
           (f2 (dens-frame-body attempt :f2))
           (f3 (dens-frame-body attempt :f3))
           (f4 (dens-frame-body attempt :f4))
           (f5 (dens-frame-body attempt :f5)))
      (dens-emit arm "frames-present" present)
      (dens-emit arm "frames-absent" (sort absent #'string< :key #'symbol-name))
      (dens-emit arm "classification"
                 (lisp-plus-language-act0:classify-act-frames present))
      (dens-emit arm "class" (if done (getf done :class) (getf result :class)))
      (dens-emit arm "act-id-hex" (dens-act-id-hex attempt))
      (dens-emit arm "f2-frontier" (dens-body-string f2 "frontier"))
      (dens-emit arm "f2-outcome-view" (dens-body-string f2 "outcome-view"))
      (dens-emit arm "f2-effect-axis-value"
                 (dens-body-string f2 "effect-axis-value"))
      (dens-emit arm "f2-effect-axis-determinacy"
                 (dens-body-string f2 "effect-axis-determinacy"))
      (dens-emit arm "f3-ledger-answer" (dens-body-string f3 "ledger-answer"))
      (dens-emit arm "f4-runtime-resolution"
                 (dens-body-string f4 "runtime-resolution"))
      (dens-emit arm "correspondence-row"
                 (dens-body-string f4 "correspondence-row"))
      (dens-emit arm "correspondence-verdict"
                 (dens-body-string f4 "correspondence-verdict"))
      (dens-emit arm "f5-execution-standing"
                 (dens-body-string f5 "execution-standing"))
      (dens-emit arm "f5-evidence-class" (dens-body-string f5 "evidence-class"))
      (dens-emit arm "agreement-row" (dens-body-string f5 "mapping-row"))
      (dens-emit arm "agreement-verdict"
                 (dens-body-string f5 "agreement-verdict"))
      (dens-emit arm "mint-refusal"
                 (if unpaired
                     (format nil "~a/~a" (getf result :refusal-type)
                             (getf result :refusal-requirement-id))
                     "none"))
      ;; The composition's OWN return, printed beside the record it wrote, so a
      ;; reader can see whether the two tell one story.
      (when done
        (dens-emit arm "returned-row" (getf done :row))
        (dens-emit arm "returned-verdict" (getf done :verdict))
        (dens-emit arm "returned-correspondence"
                   (or (getf done :correspondence) "none"))))))

(let ((propagated nil))
  (unwind-protect
       (handler-case (dens-run cl-user::*dens-arm*)
         (error (c)
           (setf propagated c)
           (format t "~&DENS-MA0 run PROPAGATED=~s~%" (type-of c))
           (format *error-output* "~&!! ~a~%" c)))
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (format *error-output* "   run root removed (exists: ~a)~%"
            (and (probe-file cl-user::*dens-root*) t))
    (finish-output *error-output*))
  (format t "~&DENS-MA0 run arm=~a~%" cl-user::*dens-arm*)
  (format t "~&DENS-MA0 run END=~a~%"
          (if propagated "propagated" "reached-end"))
  (finish-output)
  (sb-ext:exit :code (if propagated 1 0)))
