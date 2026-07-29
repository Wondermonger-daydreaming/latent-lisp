;;;; helper-resolution-control.lisp — Evidence Addendum 0.1, §A2 negative control.
;;;;
;;;; THE CLAIM UNDER TEST: that the repaired `CD0` helper in `surface1-selftest.lisp`
;;;; REJECTS a misspelled or non-external CD/0 operation WHILE LOADING OR
;;;; MACROEXPANDING the instrument, rather than manufacturing a private symbol and
;;;; deferring the failure to an undefined-function error at some later point.
;;;;
;;;; THE HELPER IS NOT RETYPED HERE.  It is READ OUT OF THE SHIPPED INSTRUMENT with
;;;; the Lisp reader and EVALUATED, so this control exercises the shipped form.  A
;;;; hand-copied helper would prove only that a copy behaves; if the extraction
;;;; fails, this control REFUSES rather than falling back to a copy.
;;;;
;;;; The PRE-REPAIR helper is retyped, deliberately and once, because its whole
;;;; point is that it no longer exists in the tree:
;;;;     (defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))
;;;;
;;;; This file loads the layer READ-ONLY out of the real tree and writes nothing.

(defpackage #:hrc (:use #:common-lisp))
(in-package #:hrc)

(defparameter *surface1-dir*
  (or (second sb-ext:*posix-argv*)
      (error "helper-resolution-control: pass the Surface /1 directory as argv[1]")))

(defparameter *failures* 0)
(defparameter *checks* 0)

(defun report (ok label &rest detail)
  (incf *checks*)
  (unless ok (incf *failures*))
  (format t "  ~:[!! ~;OK ~]~A~%" ok label)
  (dolist (d detail) (format t "       ~A~%" d)))

;;; ------------------------------------------------------------------
;;; Load the layer.  READ-ONLY: nothing here writes to the tree.
(handler-bind ((warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *surface1-dir*)))

(format t "~%HELPER-RESOLUTION NEGATIVE CONTROL — Evidence Addendum 0.1~%")
(format t "subject tree : ~A~%" *surface1-dir*)
(format t "CD/0 package : ~A~%~%" (package-name (find-package '#:lisp-plus-cd0)))

;;; ------------------------------------------------------------------
;;; Extract the SHIPPED helper from the instrument, by reading its forms.
(defparameter *shipped-form*
  (with-open-file (s (merge-pathnames "surface1-selftest.lisp" *surface1-dir*)
                     :direction :input)
    (let ((*package* (find-package '#:hrc))
          (*read-eval* nil))
      (loop for form = (handler-case (read s nil :eof) (error () :eof))
            until (eq form :eof)
            when (and (consp form)
                      (symbolp (first form))
                      (string= (symbol-name (first form)) "DEFMACRO")
                      (symbolp (second form))
                      (string= (symbol-name (second form)) "CD0"))
              return form))))

(unless *shipped-form*
  (format t "  REFUSING: could not read the CD0 helper out of surface1-selftest.lisp.~%")
  (sb-ext:exit :code 2))

(format t "SHIPPED HELPER, as read from surface1-selftest.lisp:~%")
(format t "  (defmacro cd0 (name &rest args) ...)  body forms: ~D~%"
        (length (cddr *shipped-form*)))
(report (search "EXTERNAL" (format nil "~S" *shipped-form*))
        "the shipped helper's source mentions :EXTERNAL at all"
        "(a helper that never names the status cannot be demanding it)")
(eval *shipped-form*)                    ; installs CD0 in HRC

;;; The PRE-REPAIR helper, for contrast.  This is what was in the tree.
(defmacro old-cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))

;;; A name chosen so it is absent from CD/0, and verified absent before use.
(defparameter *absent-a* "NO-SUCH-CD0-OPERATION-ALPHA")
(defparameter *absent-b* "NO-SUCH-CD0-OPERATION-BETA")
(defun cd0-status (name) (nth-value 1 (find-symbol name '#:lisp-plus-cd0)))

(report (and (null (cd0-status *absent-a*)) (null (cd0-status *absent-b*)))
        "PRECONDITION — neither probe name exists in LISP-PLUS-CD0 yet"
        (format nil "~A -> ~S · ~A -> ~S"
                *absent-a* (cd0-status *absent-a*) *absent-b* (cd0-status *absent-b*)))

;;; An operation that EXISTS but is NOT external, found at runtime rather than
;;; hard-coded, so this control does not rot when the package changes.
(defparameter *internal-name*
  (let (names)
    (do-symbols (s (find-package '#:lisp-plus-cd0))
      (when (and (eq (symbol-package s) (find-package '#:lisp-plus-cd0))
                 (eq :internal (nth-value 1 (find-symbol (symbol-name s)
                                                         '#:lisp-plus-cd0))))
        (push (symbol-name s) names)))
    (first (sort names #'string<))))

;;; ------------------------------------------------------------------
(format t "~%ARM 1 — THE REPAIRED HELPER, misspelled operation.~%")
(format t "  MUST refuse at macroexpansion time AND intern nothing.~%")
(let ((refused nil) (message nil))
  (handler-case (macroexpand-1 (list 'cd0 (intern *absent-b* '#:hrc) 1))
    (error (c) (setf refused t message (princ-to-string c))))
  (report refused "macroexpanding (cd0 NO-SUCH-CD0-OPERATION-BETA 1) SIGNALLED"
          (if refused (format nil "condition: ~A" message)
              "IT DID NOT SIGNAL — the repair is not in force"))
  (report (null (cd0-status *absent-b*))
          "and the name was NOT manufactured — still absent from LISP-PLUS-CD0"
          (format nil "find-symbol status after the attempt: ~S" (cd0-status *absent-b*))))

(format t "~%ARM 2 — THE REPAIRED HELPER, an operation that EXISTS but is :INTERNAL.~%")
(format t "  MUST refuse: accessibility is not entitlement.~%")
(if (null *internal-name*)
    (report t "SKIPPED — LISP-PLUS-CD0 exports everything it interns"
            "no :INTERNAL symbol exists to probe with; nothing is hidden by this")
    (let ((refused nil) (message nil))
      (handler-case (macroexpand-1 (list 'cd0 (intern *internal-name* '#:hrc) 1))
        (error (c) (setf refused t message (princ-to-string c))))
      (report refused
              (format nil "macroexpanding (cd0 ~A 1) SIGNALLED — status :INTERNAL"
                      *internal-name*)
              (if refused (format nil "condition: ~A" message)
                  "IT DID NOT SIGNAL — a private name resolved silently"))))

(format t "~%ARM 3 — THE PRE-REPAIR HELPER, same misspelling. THE DEFECT, EXHIBITED.~%")
(format t "  Expected to SUCCEED and to MUTATE the package — that is the defect.~%")
(let ((expansion nil) (signalled nil))
  (handler-case (setf expansion (macroexpand-1 (list 'old-cd0 (intern *absent-a* '#:hrc) 1)))
    (error () (setf signalled t)))
  (report (not signalled)
          "the pre-repair helper macroexpanded WITHOUT complaint"
          (format nil "expansion: ~S" expansion))
  (report (eq :internal (cd0-status *absent-a*))
          "and it MANUFACTURED the name — now :INTERNAL in LISP-PLUS-CD0"
          (format nil "find-symbol status after the attempt: ~S" (cd0-status *absent-a*))
          "The instrument mutated the package it claims to be observing, and the"
          "failure was deferred to an undefined-function error far from its cause."))

;;; ------------------------------------------------------------------
(format t "~%")
(format t "HELPER-RESOLUTION-CONTROL checks=~D expected=~D failed=~D~%"
        *checks* *checks* *failures*)
(format t "~:[  CONTROL FAILURE — the repaired helper did not refuse as required.~;~
  CONTROL SATISFIED — the repaired helper refuses at macroexpansion time and~%~
  interns nothing; the pre-repair helper accepts the same name and mutates the~%~
  package.  The difference is exhibited, not asserted.~]~%"
        (zerop *failures*))
(finish-output)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
