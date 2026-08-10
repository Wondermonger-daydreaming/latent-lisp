;;;; ma0-footprint-witness.lisp — W-V-FOOTPRINT, AT THE PROGRAM LEVEL.
;;;; (FAILURE MATRIX §1 W-V-FOOTPRINT, and the red condition disease
;;;; D-SKIP-VALIDATE is supposed to produce: "an invalid program reaches the
;;;; store".)
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-footprint-witness.lisp
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHY THIS FILE EXISTS — a gap in the lane's own suite, named
;;;; ---------------------------------------------------------------------------
;;;;
;;;; `ma0-selftest-suite.lisp''s W-V-FOOTPRINT witness watches a SCRATCH
;;;; DIRECTORY after a column of refused VALIDATIONS: it shows that refusing a
;;;; source creates no store.  It never runs a program, so it cannot see the
;;;; state D-SKIP-VALIDATE produces — an invalid program that reaches a LIVE
;;;; store and appends to it.  Under that disease the suite's own W-V-FOOTPRINT
;;;; check stays GREEN while the W-V-* family goes red, which would leave the
;;;; matrix's D-SKIP-VALIDATE row naming a witness that does not fire.
;;;;
;;;; So this witness stands a LIVE ENVIRONMENT up first, counts the store's
;;;; validated prefix, offers the evaluator a source the validator must refuse
;;;; (two acts on ONE arm — V-ARM, refused statically), and then counts again.
;;;;
;;;; ⚠ AND IT PROVES THE STORE WAS ALIVE.  A prefix that did not grow proves
;;;; nothing if nothing could have grown it, so phase 2 runs a LAWFUL program
;;;; against the same environment and requires the prefix to grow there.  Two
;;;; programs in one image is the contract's one-program-per-image law set aside
;;;; deliberately and only here, on two DIFFERENT arms so no seat is consumed
;;;; twice; without phase 2 phase 1 would be a witness that cannot fail.
;;;;
;;;; Sentinel, printed on the green path and no other:
;;;;   ma0-footprint-witness: <N> checks, 0 failures
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
                            "/ma0-footprint.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*dens-tree*))
      (root (namestring cl-user::*dens-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output* "~&!! FAIL CLOSED: run root ~a is INSIDE ~a~%" root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "~&== ma0-footprint-witness — SBCL ~a ==~%   run root: ~a~%"
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

(defun dens-prefix-frames ()
  (lisp-plus-journal0:prefix-report-frame-count
   (lisp-plus-journal0:validate-journal lisp-plus-language-act0:*store*)))

(defun dens-write (basename text)
  (let ((path (merge-pathnames basename cl-user::*dens-root*)))
    (with-open-file (out path :direction :output :if-exists :supersede
                              :external-format :utf-8)
      (write-string text out))
    path))

;;; ---- the source the validator must refuse: ONE arm, TWICE (V-ARM).
(defparameter *invalid-source* "
(ma0-program
 (:name \"twice-on-one-arm\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (act first-time (:arm \"C-i\") (:authority-slot g))
  (act second-time (:arm \"C-i\") (:authority-slot g))
  (result :should-never-be-reached)))
")

;;; ---- the lawful source, on a DIFFERENT arm, proving the store is alive.
(defparameter *lawful-source* "
(ma0-program
 (:name \"one-lawful-act\")
 (:input ())
 (:authority-slots (g))
 (:steps
  (act only (:arm \"A\") (:authority-slot g))
  (result :one-act-ran)))
")

(defun dens-run ()
  (format t "~&== W-V-FOOTPRINT (program level) — an invalid program against a LIVE store ==~%")
  (let ((environment (lisp-plus-many-acts0:make-ma0-environment
                      :root cl-user::*dens-root*
                      :arms '("A" "C-i")
                      :grants '((:slot "g" :arm "A") (:slot "g" :arm "C-i"))
                      :revocations '()
                      :seat-map '()
                      :inputs '())))
    (let ((before (dens-prefix-frames))
          (refused nil) (code nil) (kind nil))
      (format t "~&    prefix frames with the environment standing: ~d~%" before)

      ;; ---- PHASE 1: the invalid program.
      ;; ⚠ THE BROAD HANDLER IS DELIBERATE.  A condition that is NOT this lane's
      ;; typed refusal must not abort the witness before the footprint is read:
      ;; the whole question is what the STORE holds afterwards, and a witness
      ;; that stops at the first surprise cannot answer it.  What kind of
      ;; condition it was is recorded and checked separately.
      (handler-case
          (let ((r (lisp-plus-many-acts0:ma0-run-program
                    (lisp-plus-many-acts0:ma0-validate
                     (dens-write "invalid.lisp" *invalid-source*))
                    environment)))
            (format t "~&    !! THE INVALID PROGRAM RAN — disposition ~s~%"
                    (lisp-plus-many-acts0:ma0-result-disposition r)))
        (lisp-plus-many-acts0:ma0-refusal (c)
          (setf refused t
                kind (type-of c)
                code (lisp-plus-many-acts0:ma0-refusal-code c)))
        (error (c)
          (setf kind (type-of c))
          (format t "~&    !! a NON-MA0 condition escaped the invalid program: ~s~%"
                  (type-of c))))

      (dens-check "W-V-ARM two acts on one arm are refused"
                  refused "type=~s code=~s" kind code)
      (dens-check "W-V-ARM the refusal is typed V-ARM"
                  (equal "V-ARM" code) "code=~s" code)
      (dens-check "W-V-FOOTPRINT the invalid program appended NOTHING to the live store"
                  (eql before (dens-prefix-frames))
                  "before=~d after=~d" before (dens-prefix-frames))

      ;; ---- PHASE 2: the store was alive all along.
      (let ((result (lisp-plus-many-acts0:ma0-run-program
                     (lisp-plus-many-acts0:ma0-validate
                      (dens-write "lawful.lisp" *lawful-source*))
                     environment)))
        (dens-check "NON-VACUITY a lawful program on another arm DOES complete"
                    (eq :completed
                        (lisp-plus-many-acts0:ma0-result-disposition result))
                    "disposition=~s"
                    (lisp-plus-many-acts0:ma0-result-disposition result))
        (dens-check "NON-VACUITY and it DOES grow the prefix — the store was never dead"
                    (> (dens-prefix-frames) before)
                    "before=~d after=~d" before (dens-prefix-frames))))))

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
        (format t "~&ma0-footprint-witness: ~d checks, 0 failures~%" total)
        (format t "~&ma0-footprint-witness: RUN REFUSED — ~d check(s), ~d failure(s).~
~@[  the witness signalled: ~a~]  The success sentinel is WITHHELD.~%"
                total *failed* (and suite-error (type-of suite-error))))
    (finish-output)
    (sb-ext:exit :code (if green 0 1))))
