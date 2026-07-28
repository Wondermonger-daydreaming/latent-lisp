(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(format t "~&FOSSOR — REFUSAL REACHABILITY BATTERY · SBCL ~A · grammar v~D procedure v~D policy v~D~%"
        (lisp-implementation-version) (s1 expansion-grammar-version)
        (s1 expansion-procedure-version) (s1 expansion-policy-version))
(line "subject dir ~A" (namestring (truename cl-user::*s1dir*)))

(defun nest (d) (let ((f 0)) (dotimes (i d) (setf f (list f))) f))
(defun djs (&key (premises nil) (conclusion 0))
  (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
        (intern "*FOSSOR-J*" '#:cl-user)
        :name :fossor :version 1 :conclusion conclusion
        :premises premises :locals nil :unique-locals nil))
(defun perform-of (src &optional (op :macroexpand-1))
  (lambda () (s1 perform-expansion (s1 request-expansion src op (tag "w")))))

(banner "A. REQUEST-PHASE :PUBLIC-API CODES")
(fires ":SOURCE-FORM-NOT-A-CALL — source form 42, an atom"
       :source-form-not-a-call
       (lambda () (s1 request-expansion 42 :macroexpand-1 (tag "a1"))))
(fires ":SOURCE-FORM-HEAD-NOT-A-SYMBOL — head is a cons"
       :source-form-head-not-a-symbol
       (lambda () (s1 request-expansion (list (list 1) 2) :macroexpand-1 (tag "a2"))))
(fires ":OPERATION-NOT-DECLARED — :MACROEXPAND-ALL is not declared"
       :operation-not-declared
       (lambda () (s1 request-expansion (list 'cl:quote 1) :macroexpand-all (tag "a3"))))
(fires ":OCCURRENCE-TAG-NOT-IDENTIFIER — tag NIL, and there is no default"
       :occurrence-tag-not-identifier
       (lambda () (s1 request-expansion (list 'cl:quote 1) :macroexpand-1 nil)))
(fires ":SOURCE-TERM-UNREPRESENTABLE — a CHARACTER leaf"
       :source-term-unrepresentable
       (lambda () (s1 request-expansion (list 'cl:quote #\a) :macroexpand-1 (tag "a5")))
       :expect-upstream "NO-TERM-KIND")
(fires ":SOURCE-TERM-SHARED-STRUCTURE — one subtree reachable by two paths"
       :source-term-shared-structure
       (let ((sub (list 1))) (lambda () (s1 request-expansion (list 'cl:quote sub sub)
                                            :macroexpand-1 (tag "a6"))))
       :expect-upstream "SHARED-OR-CIRCULAR-STRUCTURE")
(fires ":SOURCE-DEPTH-EXCEEDED — 60 host levels, ceiling 48"
       :source-depth-exceeded
       (lambda () (s1 request-expansion (list 'cl:quote (nest 60)) :macroexpand-1 (tag "a7"))))
(fires ":SOURCE-NODES-EXCEEDED — 20001 elements, depth 3"
       :source-nodes-exceeded
       (lambda () (s1 request-expansion
                      (list 'cl:quote (make-list 20001 :initial-element 0))
                      :macroexpand-1 (tag "a8"))))
(fires ":SOURCE-TERM-OCTETS-EXCEEDED — one 262145-char string leaf"
       :source-term-octets-exceeded
       (lambda () (s1 request-expansion
                      (list 'cl:quote (make-string 262145 :initial-element #\a))
                      :macroexpand-1 (tag "a9"))))

(banner "B. PERFORM-PHASE :PUBLIC-API CODES")
(fires ":NOT-A-KNOWN-SURFACE-CONSTRUCT — head is CL-USER::FROBNICATE"
       :not-a-known-surface-construct
       (perform-of (list (intern "FROBNICATE" '#:cl-user) 1)))
(fires ":EXPANDED-TERM-UNREPRESENTABLE — a gensym-bearing expansion with no sharing"
       :expanded-term-unrepresentable
       (perform-of '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                     (lisp-plus-slice1:derive :schema-name :x)
                     (:granted cl-user::c) (:refused (nil) 1)))
       :expect-upstream "UNINTERNED-SYMBOL")
(fires ":EXPANDED-TERM-SHARED-STRUCTURE — full expansion of DERIVE-CASE"
       :expanded-term-shared-structure
       (perform-of '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                     (lisp-plus-slice1:derive :schema-name :x)
                     (:granted cl-user::c) (:refused (cl-user::e) cl-user::e))
                   :macroexpand)
       :expect-upstream "SHARED-OR-CIRCULAR-STRUCTURE")
(fires ":EXPANDED-DEPTH-EXCEEDED — source depth 46, expansion depth 50, ceiling 48"
       :expanded-depth-exceeded
       (perform-of (djs :conclusion (nest 45))))
(fires ":EXPANDED-TERM-OCTETS-EXCEEDED — 2000 integer premises"
       :expanded-term-octets-exceeded
       (perform-of (djs :premises (make-list 2000 :initial-element 0))))
(line "  (source depth ~D / expanded depth ~D for the depth witness)"
      (s1i %host-depth (djs :conclusion (nest 45)))
      (s1i %host-depth (macroexpand-1 (djs :conclusion (nest 45)) nil)))

(banner "B2. :SOURCE-NOT-RECONSTRUCTIBLE — its FOUR public upstream reasons")
;; SYMBOL-ABSENT-IN-IMAGE
(let* ((p (eval '(defpackage #:fossor-r1 (:use))))
       (x (intern "X" p))
       (req (s1 request-expansion (list x 1) :macroexpand-1 (tag "b2a"))))
  (unintern x p)
  (fires ":SOURCE-NOT-RECONSTRUCTIBLE / SYMBOL-ABSENT-IN-IMAGE"
         :source-not-reconstructible (lambda () (s1 perform-expansion req))
         :expect-upstream "SYMBOL-ABSENT-IN-IMAGE"))
;; PACKAGE-ABSENT-IN-IMAGE
(let* ((p (eval '(defpackage #:fossor-r2 (:use))))
       (x (intern "X" p))
       (req (s1 request-expansion (list x 1) :macroexpand-1 (tag "b2b"))))
  (delete-package p)
  (fires ":SOURCE-NOT-RECONSTRUCTIBLE / PACKAGE-ABSENT-IN-IMAGE"
         :source-not-reconstructible (lambda () (s1 perform-expansion req))
         :expect-upstream "PACKAGE-ABSENT-IN-IMAGE"))
;; SYMBOL-NOT-HOME-IN-NAMESPACE  (errata 0.2's own defect, re-fired by my hand)
(let* ((q (eval '(defpackage #:fossor-q (:use) (:export #:x))))
       (p (eval '(defpackage #:fossor-p (:use #:fossor-q) (:shadow #:x))))
       (px (find-symbol "X" p))
       (req (s1 request-expansion (list px 1) :macroexpand-1 (tag "b2c"))))
  (declare (ignorable q))
  (line "before unintern: (find-symbol \"X\" P) home ~A status ~S"
        (package-name (symbol-package (find-symbol "X" p)))
        (nth-value 1 (find-symbol "X" p)))
  (unintern px p)
  (line "after  unintern: (find-symbol \"X\" P) home ~A status ~S"
        (package-name (symbol-package (find-symbol "X" p)))
        (nth-value 1 (find-symbol "X" p)))
  (fires ":SOURCE-NOT-RECONSTRUCTIBLE / SYMBOL-NOT-HOME-IN-NAMESPACE"
         :source-not-reconstructible (lambda () (s1 perform-expansion req))
         :expect-upstream "SYMBOL-NOT-HOME-IN-NAMESPACE"))

(banner "C. :INTERNAL-PLANTED-FAULT-ONLY — the three integrity alarms + the round-trip gate")
(defparameter *good* (djs))
(defparameter *goodreq* (s1 request-expansion *good* :macroexpand-1 (tag "c0")))
(line "control: the same source WITHOUT any fault -> receipt? ~A"
      (s1 expansion-receipt-p (s1 perform-expansion *goodreq*)))
(let ((sym (find-symbol "*%FAULT-SOURCE-IDENTITY*" '#:lisp-plus-surface1)))
  (progv (list sym) (list (cd0 make-bytes-datum (cd0 canonical-octets (tag "lie"))))
    (fires ":SOURCE-IDENTITY-PROJECTION-MISMATCH via *%FAULT-SOURCE-IDENTITY*"
           :source-identity-projection-mismatch
           (lambda () (s1 perform-expansion *goodreq*)))))
(let ((sym (find-symbol "*%FAULT-EXPANDED-IDENTITY*" '#:lisp-plus-surface1)))
  (progv (list sym) (list (cd0 make-bytes-datum (cd0 canonical-octets (tag "lie"))))
    (fires ":EXPANDED-IDENTITY-PROJECTION-MISMATCH via *%FAULT-EXPANDED-IDENTITY*"
           :expanded-identity-projection-mismatch
           (lambda () (s1 perform-expansion *goodreq*)))))
(let ((sym (find-symbol "*%FAULT-PROCEDURE-VERSION*" '#:lisp-plus-surface1)))
  (progv (list sym) (list 99)
    (fires ":PROCEDURE-VERSION-MISMATCH via *%FAULT-PROCEDURE-VERSION*"
           :procedure-version-mismatch
           (lambda () (s1 perform-expansion *goodreq*)))))
(let ((sym (find-symbol "*%FAULT-DECODE-SUBSTITUTION*" '#:lisp-plus-surface1)))
  ;; substitute a DIFFERENT but perfectly encodable form: the round-trip gate,
  ;; not the encodability branch.
  (progv (list sym) (list (lambda (form) (declare (ignore form)) (list 'cl:quote 7)))
    (fires ":SOURCE-NOT-RECONSTRUCTIBLE / ROUND-TRIP-MISMATCH via *%FAULT-DECODE-SUBSTITUTION*"
           :source-not-reconstructible (lambda () (s1 perform-expansion *goodreq*))
           :expect-upstream "ROUND-TRIP-MISMATCH"))
  ;; and the sibling branch: a substitution that will not re-encode AT ALL
  (progv (list sym) (list (lambda (form) (declare (ignore form)) (list 'cl:quote #\a)))
    (fires ":SOURCE-NOT-RECONSTRUCTIBLE / ROUND-TRIP-NOT-ENCODABLE via the same hook"
           :source-not-reconstructible (lambda () (s1 perform-expansion *goodreq*))
           :expect-upstream "ROUND-TRIP-NOT-ENCODABLE")))

(banner "D. THE CODE CLASSIFIED :UNREACHABLE-UNDER-THIS-POLICY")
(fires ":EXPANDED-NODES-EXCEEDED — 2500 integer premises, PUBLIC API ONLY"
       :expanded-nodes-exceeded
       (perform-of (djs :premises (make-list 2500 :initial-element 0))))

(format t "~%  CATALOGUE MISMATCHES: ~D of ~D witnesses~%" *bad* *n*)
