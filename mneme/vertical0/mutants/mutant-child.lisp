;;;; mutant-child.lisp — THE campaign child, with zero or more planted
;;;; defects installed.
;;;;
;;;; Run exactly like the real child (one argument, one execution
;;;; directory); the defect list rides an environment variable so the
;;;; child's ARGV is identical to the real child's:
;;;;
;;;;   VERTICAL0_DEFECTS=budget-ignored \
;;;;     sbcl --script mneme/vertical0/mutants/mutant-child.lisp <exec-dir>
;;;;
;;;; With VERTICAL0_DEFECTS unset or empty this IS the real child: the same
;;;; source forms of program/campaign.lisp, evaluated in the same order in
;;;; the same package with the same *LOAD-TRUENAME*, with nothing installed
;;;; over them.  The mutation gate proves that claim rather than asserting
;;;; it (loader-fidelity check: one mini campaign through campaign.lisp and
;;;; one through this file must produce byte-identical journals).
;;;;
;;;; The only behavioral addition is the outer report: campaign.lisp's own
;;;; trailing HANDLER-CASE is the one form the forms-loader skips, so a
;;;; condition that escapes the route runners reaches THIS handler, which
;;;; prints the condition's exact TYPE-OF before exiting 2.  That line —
;;;;
;;;;   CHILD-CONDITION <TYPE-NAME>
;;;;
;;;; — is what lets a gate assert "killed by the exact named predicate"
;;;; instead of "the child crashed".  Only the type name is printed: it is
;;;; deterministic, where a condition report may carry paths or digests.
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(let* ((here (make-pathname :name nil :type nil :defaults *load-truename*))
       (vertical0 (merge-pathnames "../" here)))
  (load (merge-pathnames "support/forms-loader.lisp" vertical0))
  (load (merge-pathnames "program/load.lisp" vertical0))
  ;; The real program's definitions, minus its trailing entry form.
  (cl-user::load-definitions (merge-pathnames "program/campaign.lisp"
                                              vertical0)
                             :package (find-package '#:lisp-plus-vertical0))
  ;; The planted-defect registry loads AFTER, so every replacement closes
  ;; over the real original.
  (load (merge-pathnames "program/defects.lisp" vertical0)))

(in-package #:lisp-plus-vertical0)

(let ((names (parse-defect-names
              (sb-ext:posix-getenv "VERTICAL0_DEFECTS"))))
  (when names
    (install-defects names)
    (format t "MUTANT-DEFECTS ~{~a~^,~}~%"
            (mapcar (lambda (name) (string-downcase (symbol-name name)))
                    names))
    (finish-output)))

(handler-case
    (let ((arguments (rest sb-ext:*posix-argv*)))
      (unless (= 1 (length arguments))
        (vfail "usage: mutant-child.lisp <exec-dir>"))
      (campaign-main (first arguments)))
  (error (condition)
    (format t "CHILD-CONDITION ~a~%" (type-of condition))
    (finish-output)
    (vfail "unhandled: ~a" condition)))
