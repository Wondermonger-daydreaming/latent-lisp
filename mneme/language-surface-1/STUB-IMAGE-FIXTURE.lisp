;;;; STUB-IMAGE-FIXTURE.lisp — the one refusal that needs its own process.
;;;;
;;;; `:CONSTRUCT-NOT-A-MACRO` is reachable only in an image where the construct
;;;; package EXISTS but its macros are NOT defined.  Manufacturing that state
;;;; inside the selftest's image would mean unbinding one of Surface /0's macro
;;;; functions — that is ALTERING SURFACE /0, which is forbidden, and it would
;;;; also be the observer manufacturing the world it then reports on.
;;;;
;;;; So this fixture runs in its own SBCL, WITHOUT ever loading surface0.lisp.
;;;; It defines the package and interns the symbol — nothing more.  No macro
;;;; function is created, none is destroyed, and Surface /0's file is never read.
;;;;
;;;; A gate that has never fired is untested, not passing.
;;;;
;;;; ERRATA 0.3 / D4.  This fixture used to report to its wrapper with nothing but
;;;; an exit code, and it exited 0 while running almost nothing: the stranger audit
;;;; truncated it at a clean top-level form boundary, leaving ZERO checks and no
;;;; summary at all, and the runner reported peace (`FOSSOR.md` §4, case T8b).  A
;;;; check that never ran never fails.  It now ends with ONE canonical
;;;; machine-readable line emitted from the LIVE counter, compared against a count
;;;; DECLARED at the top of this file, and it exits nonzero if they disagree.

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *here*)))
(load (merge-pathnames "errata-0.3/EVIDENCE.lisp" *here*))

;;; THE DECLARED COUNT.  Written here, at the top, so that a file truncated
;;; anywhere below cannot satisfy it: the live counter would fall short and the
;;; canonical line would not match.  Move it only with the checks it counts.
(defparameter *expected-checks* 8)

;;; The stub: the NAME exists, the MACRO does not.  surface0.lisp is not loaded
;;; and is not on any load path taken by this file.
(defpackage #:lisp-plus-surface0 (:use #:cl) (:export #:define-admission-contract))

(defpackage #:stub-fixture (:use #:cl))
(in-package #:stub-fixture)
;;; ERRATA 0.3 / D8 F-16.  Errata 0.1 repaired exactly one instrument's helper and
;;; the sentence "`s1` now resolves through FIND-SYMBOL" was written unqualified;
;;; the audit measured it and found the repair had reached the selftest and no other
;;; file (`FOSSOR.md` §6, F7).  Bare INTERN cannot tell a private name from a public
;;; one — and it CREATES the symbol it fails to find, so a typo becomes a fresh
;;; internal symbol and the error surfaces far from its cause.  Both helpers now
;;; resolve through FIND-SYMBOL and REFUSE AT MACROEXPANSION TIME unless the symbol
;;; both exists and is :EXTERNAL.
(defmacro s1 (name &rest args)
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-surface1)
    (unless (eq status :external)
      (error "S1: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-SURFACE1, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))
(defmacro cd0 (name &rest args)
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-cd0)
    (unless (eq status :external)
      (error "CD0: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-CD0, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))

(defparameter *checks* 0) (defparameter *failed* 0)
(defun ok (label c) (incf *checks*)
  (if c (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*) (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(format t "~&SURFACE /1 — STUB-IMAGE FIXTURE~%")
(format t "SBCL ~A~%" (lisp-implementation-version))
(surface1-evidence:print-evidence-header cl-user::*here*)

(defparameter *head* (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0))

(ok "the stub package exists and exports the construct's NAME" (and *head* t))
(ok "and the name has NO macro function — surface0.lisp was never loaded"
    (null (macro-function *head*)))

(defparameter *form* (list *head* 'cl-user::*x* :contract-id :a))
(defparameter *req*
  (s1 request-expansion *form* :macroexpand-1
      (cd0 make-identifier-datum '("stub-fixture") '("one"))))

(ok "DOOR 1 accepts it — the head IS in the closed construct table"
    (and (s1 expansion-request-p *req*)
         (s1 expansion-request-construct-identity *req*)))

(multiple-value-bind (receipt expanded refusal) (s1 try-perform-expansion *req*)
  (declare (ignore expanded))
  (ok "DOOR 2 refuses with :CONSTRUCT-NOT-A-MACRO"
      (and refusal (eq :construct-not-a-macro (s1 expansion-refusal-code refusal))))
  (ok "the refusal's phase is :PERFORM, not :REQUEST"
      (and refusal (eq :perform (s1 expansion-refusal-phase refusal))))
  (ok "NO receipt is minted — the object does not come into existence"
      (null receipt))
  (ok "the refusal carries its own identity, a bytes datum"
      (and refusal (cd0 bytes-datum-p (s1 expansion-refusal-identity refusal)))))

(ok "a head OUTSIDE the table still refuses with the OTHER code, so the two
      facts about the world stay two facts"
    (multiple-value-bind (rc ex rf)
        (s1 try-perform-expansion
            (s1 request-expansion '(cl:list 1) :macroexpand-1
                (cd0 make-identifier-datum '("stub-fixture") '("two"))))
      (declare (ignore rc ex))
      (eq :not-a-known-surface-construct (s1 expansion-refusal-code rf))))

(format t "~%== stub-image-fixture: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

;;; ONE CANONICAL, MACHINE-READABLE RESULT LINE — from the LIVE counter, after every
;;; intended check has executed, carrying the CONTENT-DERIVED subject digest.  The
;;; wrapper requires this exact shape with checks == expected and failed = 0, so a
;;; truncation at a clean form boundary, a gutted run, a crash, a renamed label and a
;;; trailing space all fail closed.  Counting zero of a string is not evidence that
;;; the string was ever going to be printed.
(format t "~%STUB-RESULT checks=~D expected=~D failed=~D subject=~A~%"
        *checks* cl-user::*expected-checks* *failed*
        (surface1-evidence:subject-short cl-user::*here*))
(when (or (plusp *failed*) (/= *checks* cl-user::*expected-checks*))
  (sb-ext:exit :code 1))
