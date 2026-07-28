;;;; probe-pln.lisp — CHAIR probe D: package-local nicknames make Door 2's
;;;; reconstruction depend on the caller's ambient *PACKAGE*, and reach
;;;; ROUND-TRIP-MISMATCH with ZERO package-state mutation.
;;;;
;;;; Scenario: package AUDIT-DELTA (canonical "AUDIT-DELTA") owns X.  Door 1
;;;; encodes AUDIT-DELTA::X.  A bystander package AUDIT-CALLER carries a
;;;; package-local nickname "AUDIT-DELTA" -> AUDIT-ELSEWHERE (which owns its own
;;;; X).  Door 2 is performed with *PACKAGE* bound to AUDIT-CALLER.  Nothing in
;;;; the image was mutated: no unintern, no rename, no deletion.

(load (merge-pathnames "../../extract/target/tree/mneme/language-surface-1/surface1.lisp"
                       *load-truename*))

(defpackage #:chair-pln (:use #:cl #:lisp-plus-surface1))
(in-package #:chair-pln)

(defun say (fmt &rest args) (format t "~&~?~%" fmt args) (finish-output))
(defun tag (n) (lisp-plus-cd0:make-identifier-datum '("chair-audit") (list n)))

(defpackage #:audit-delta (:use))
(defpackage #:audit-elsewhere (:use))
(defpackage #:audit-caller (:use))

(let* ((x-delta (intern "X" (find-package "AUDIT-DELTA")))
       (x-else  (intern "X" (find-package "AUDIT-ELSEWHERE")))
       (req (request-expansion (list x-delta) :macroexpand-1 (tag "D"))))
  (declare (ignorable x-else))
  ;; the bystander's local nickname — a lexical convenience of ONE package,
  ;; not a mutation of AUDIT-DELTA, AUDIT-ELSEWHERE, or any symbol
  (sb-ext:add-package-local-nickname "AUDIT-DELTA" "AUDIT-ELSEWHERE"
                                     (find-package "AUDIT-CALLER"))
  ;; Door 2 performed from inside the bystander package
  (let ((*package* (find-package "AUDIT-CALLER")))
    (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
      (declare (ignore receipt expanded))
      (say "D1: refusal code=~s upstream=~s"
           (and refusal (expansion-refusal-code refusal))
           (and refusal (expansion-refusal-upstream-code refusal)))
      (say "D1 verdict: ~a"
           (cond ((null refusal)
                  "NO REFUSAL — expansion crossed; check which symbol was bound!")
                 ((and (eq (expansion-refusal-code refusal) :source-not-reconstructible)
                       (equal (expansion-refusal-upstream-code refusal) "ROUND-TRIP-MISMATCH"))
                  "ROUND-TRIP-MISMATCH reached via ambient *PACKAGE* alone — zero mutation")
                 (t (format nil "other refusal: ~s / ~s"
                            (expansion-refusal-code refusal)
                            (expansion-refusal-upstream-code refusal)))))))
  ;; control: same request, performed from a package with no local nickname
  (let ((*package* (find-package "CHAIR-PLN")))
    (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
      (declare (ignore receipt expanded))
      (say "D2 control: code=~s (expect :NOT-A-KNOWN-SURFACE-CONSTRUCT — gate passes)"
           (and refusal (expansion-refusal-code refusal)))))
  ;; and the decode-term view, both contexts
  (let ((*package* (find-package "AUDIT-CALLER")))
    (handler-case
        (let ((form (decode-term (expansion-request-source-form-datum req))))
          (say "D3: decode under PLN context resolved head to home package ~a"
               (package-name (symbol-package (car form)))))
      (error (c) (say "D3: decode under PLN context signalled: ~a" (type-of c))))))

(sb-ext:exit :code 0)
