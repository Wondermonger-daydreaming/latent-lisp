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

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *here*)))

;;; The stub: the NAME exists, the MACRO does not.  surface0.lisp is not loaded
;;; and is not on any load path taken by this file.
(defpackage #:lisp-plus-surface0 (:use #:cl) (:export #:define-admission-contract))

(defpackage #:stub-fixture (:use #:cl))
(in-package #:stub-fixture)
(defmacro s1 (name &rest args) `(,(intern (string name) '#:lisp-plus-surface1) ,@args))
(defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))

(defparameter *checks* 0) (defparameter *failed* 0)
(defun ok (label c) (incf *checks*)
  (if c (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*) (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(format t "~&SURFACE /1 — STUB-IMAGE FIXTURE~%")
(format t "SBCL ~A~%" (lisp-implementation-version))

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
(when (plusp *failed*) (sb-ext:exit :code 1))
