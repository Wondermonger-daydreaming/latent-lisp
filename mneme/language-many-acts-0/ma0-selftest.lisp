;;;; ma0-selftest.lisp — MANY ACTS /0: the lane's runner.
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-selftest.lisp
;;;;
;;;; Sentinel, printed ONLY on a fully green run:
;;;;
;;;;   ma0-selftest: <N> checks, 0 failures
;;;;
;;;; CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; DISCIPLINE
;;;; ---------------------------------------------------------------------------
;;;;
;;;; * FRESH IMAGE, SBCL 2.4.6 only — fails closed on any other version.
;;;; * The lane is entered THROUGH ASDF (`lisp-plus/many-acts-0'), exactly as an
;;;;   outside hand would enter it.
;;;; * EVERY SCENARIO RUNS IN ITS OWN IMAGE, spawned by the suite: one program
;;;;   per image is the contract's runner law, not a preference.
;;;; * Scratch and run roots are created OUTSIDE the subject tree and removed on
;;;;   success AND on failure.
;;;; * THE COUNT IS OBSERVED, NOT AUTHORIZED — see ma0-selftest-suite.lisp's
;;;;   header for why this suite may not carry a frozen count yet.
;;;; * THE TOOTH: MA0_SELFTEST_PLANT_FAULT=1 infects one check, through the
;;;;   suite's OWN `ma0-check', so the plant is counted by the instrument that
;;;;   counts every real check.
;;;;
;;;; — FABER (Claude Opus 5, subagent), 2026-08-09

(require :asdf)
(require :sb-posix)

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: this runner is authorized for SBCL 2.4.6 only.~%~
             Observed ~a.  No portability is claimed and none may be inferred.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*ma0-selftest-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*ma0-selftest-tree*
  (truename (merge-pathnames "../../" cl-user::*ma0-selftest-here*))
  "experiments/latent-lisp — the subject tree root.")

(format *error-output* "~&== ma0-selftest — SBCL ~a ==~%   subject tree: ~a~%"
        (lisp-implementation-version) cl-user::*ma0-selftest-tree*)
(finish-output *error-output*)

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*ma0-selftest-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/many-acts-0"))

(let ((suite-error nil) (total 0) (failed 0))
  (handler-case
      (multiple-value-setq (total failed)
        (funcall (uiop:find-symbol* '#:ma0-selftest '#:lisp-plus-many-acts0)))
    (error (c)
      (setf suite-error c)
      (format t "~&~%!! THE SUITE SIGNALLED: ~a~%" (type-of c))
      (format *error-output* "~&!! suite error: ~a~%" c)))
  (format t "~&~%== TALLY: ~d passed, ~d failed ==~%" (- total failed) failed)
  (let ((green (and (null suite-error) (zerop failed) (plusp total))))
    (if green
        ;; THE SENTINEL.  Printed on this path and on no other.
        (format t "~&ma0-selftest: ~d checks, ~d failures~%" total failed)
        (format t "~&ma0-selftest: RUN REFUSED — observed ~d check(s) and ~d ~
failure(s).~@[~%   the suite signalled: ~a~]~%The success sentinel is ~
WITHHELD.~%"
                total failed (and suite-error (type-of suite-error))))
    (finish-output)
    (sb-ext:exit :code (if green 0 1))))
