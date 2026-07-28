;;;; PRE-REPAIR-REPRODUCTION.lisp — Errata 0.3, pre-repair custody.
;;;;
;;;; Reproduces the stranger audit's D1, D2, D3, D7 against the UNMODIFIED
;;;; Errata 0.2 candidate, before a single line of production code is changed.
;;;; D5's two witnesses run as separate subprocesses (one of them kills its
;;;; image on purpose); D4 and D6 are harness defects reproduced by teeth.sh.
;;;;
;;;; Provenance: every witness here is a re-expression of an immutable audit
;;;; probe under audits/2026-07-28-stranger-audit/probes/ — named per case.
;;;; The audit's own probes are never edited.
;;;;
;;;; Run: sbcl --non-interactive --load PRE-REPAIR-REPRODUCTION.lisp

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../../surface1.lisp" *here*))
  (load (merge-pathnames "../../../language-surface-0/surface0.lisp" *here*)))

(defpackage #:errata-0.3-pre (:use #:cl))
(in-package #:errata-0.3-pre)

(defparameter *here* cl-user::*here*)

;;; ERRATA 0.3 (D8 / F-16): an instrument may not reach the layer through
;;; INTERN.  This resolves through FIND-SYMBOL and REFUSES at macroexpansion
;;; time unless the symbol already exists and is EXTERNAL — so this file
;;; cannot silently depend on a private name.
(defmacro s1 (name &rest args)
  (let ((p (find-package '#:lisp-plus-surface1)))
    (multiple-value-bind (sym status) (find-symbol (string name) p)
      (unless (eq status :external)
        (error "instrument reached a non-external symbol ~A (status ~S)" name status))
      `(,sym ,@args))))

(defparameter *verdicts* 0)
(defparameter *confirmed* 0)
(defun verdict (id label confirmed detail)
  (incf *verdicts*)
  (when confirmed (incf *confirmed*))
  (format t "~&  ~A  ~A~%      ~A~%      ~A~%"
          (if confirmed "CONFIRMED" "refuted  ") id label detail)
  (finish-output))

(defun tag (n) (lisp-plus-cd0:make-identifier-datum '("errata-0.3-pre") (list n)))

(format t "~%LANGUAGE SURFACE /1 — ERRATA 0.3 PRE-REPAIR REPRODUCTION~%")
(format t "  subject     ~A~%" (or (second sb-ext:*posix-argv*) "<unlabelled>"))
(format t "  directory   ~A~%"
        (truename (merge-pathnames "../../"
                                   (make-pathname :name nil :type nil
                                                  :defaults *here*))))
(format t "  SBCL ~A · grammar v~D · procedure v~D · policy v~D~%~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version) (s1 expansion-procedure-version)
        (s1 expansion-policy-version))

;;; ==================================================================
;;; D1 — :EXPANDED-NODES-EXCEEDED, advertised unreachable, reached publicly.
;;; Audit witness: probes/TABULARIUS/probe-C.lisp · probes/FOSSOR/P2d-minimal-N.lisp
;;; ==================================================================

(defun judgment-schema-with-premises (n)
  `(lisp-plus-surface0:define-judgment-schema cl-user::*e03-j*
     :name :e03 :version 0 :conclusion 0
     :premises ,(make-list n :initial-element 0)
     :locals () :unique-locals ()))

(let* ((form (judgment-schema-with-premises 2493))
       (code nil) (door1 :refused))
  (handler-case
      (let ((req (s1 request-expansion form :macroexpand-1 (tag "d1"))))
        (setf door1 :accepted)
        (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
          (declare (ignore r e))
          (setf code (and refusal (s1 expansion-refusal-code refusal)))))
    (error (c) (setf code (type-of c))))
  (let ((entry (assoc :expanded-nodes-exceeded (s1 expansion-refusal-code-catalog))))
    (verdict "D1" "a public source form reaches :EXPANDED-NODES-EXCEEDED, catalogued :UNREACHABLE-UNDER-THIS-POLICY"
             (and (eq door1 :accepted) (eq code :expanded-nodes-exceeded))
             (format nil "Door 1 ~A · Door 2 code ~S · catalogue reachability ~S"
                     door1 code (s1 refusal-catalog-entry-reachability entry)))))

;;; ==================================================================
;;; D2 — compound TYPE-OF crashes the refusal-describing helper.
;;; Audit witness: probes/PERSCRUTATOR/CRASH.lisp · probes/CHAIR/probe-crash-verify.lisp
;;; ==================================================================

(dolist (spec (list (list "D2a" "a complex number"        (complex 1 2))
                    (list "D2b" "a simple vector"         (vector 1 2 3))
                    (list "D2c" "a multidimensional array" (make-array '(2 2)))))
  (destructuring-bind (id label object) spec
    (let ((outcome nil))
      (handler-case
          (multiple-value-bind (req refusal)
              (s1 try-request-expansion (list 'f object) :macroexpand-1 (tag id))
            (declare (ignore req))
            (setf outcome (list :designed-refusal
                                (and refusal (s1 expansion-refusal-code refusal)))))
        (type-error (c) (setf outcome (list :uncaught-host-type-error (type-of c))))
        (error (c) (setf outcome (list :other-host-error (type-of c)))))
      (verdict id (format nil "~A escapes TRY-REQUEST-EXPANSION as an uncaught host TYPE-ERROR instead of the designed refusal" label)
               (eq (first outcome) :uncaught-host-type-error)
               (format nil "outcome ~S" outcome)))))

;;; ==================================================================
;;; D3 — ROUND-TRIP-MISMATCH reached by public input; %SEG truncation.
;;; Audit witnesses: probes/CHAIR/probe-door-semantics.lisp (B1),
;;;                  probes/CHAIR/probe-pln.lisp (D1),
;;;                  probes/TABULARIUS/probe-E.lisp (CASE 2)
;;; ==================================================================

(defpackage #:e03-rho (:use))
(let* ((x (intern "X" (find-package "E03-RHO")))
       (req (s1 request-expansion (list x) :macroexpand-1 (tag "d3a"))))
  (rename-package (find-package "E03-RHO") "E03-RHO-PRIME" '("E03-RHO"))
  (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
    (declare (ignore r e))
    (verdict "D3a" "RENAME-PACKAGE keeping the old name as a nickname reaches ROUND-TRIP-MISMATCH from public input"
             (and refusal
                  (eq (s1 expansion-refusal-code refusal) :source-not-reconstructible)
                  (equal (s1 expansion-refusal-upstream-code refusal) "ROUND-TRIP-MISMATCH"))
             (format nil "code ~S · upstream ~S"
                     (and refusal (s1 expansion-refusal-code refusal))
                     (and refusal (s1 expansion-refusal-upstream-code refusal)))))
  (rename-package (find-package "E03-RHO-PRIME") "E03-RHO"))

(defpackage #:e03-delta (:use))
(defpackage #:e03-elsewhere (:use))
(defpackage #:e03-caller (:use))
(let* ((x (intern "X" (find-package "E03-DELTA"))))
  (intern "X" (find-package "E03-ELSEWHERE"))
  (let ((req (s1 request-expansion (list x) :macroexpand-1 (tag "d3b"))))
    (sb-ext:add-package-local-nickname "E03-DELTA" "E03-ELSEWHERE"
                                       (find-package "E03-CALLER"))
    (let ((*package* (find-package "E03-CALLER")))
      (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
        (declare (ignore r e))
        (verdict "D3b" "a package-local nickname in the caller's ambient *PACKAGE* reaches ROUND-TRIP-MISMATCH with ZERO global mutation"
                 (and refusal
                      (eq (s1 expansion-refusal-code refusal) :source-not-reconstructible)
                      (equal (s1 expansion-refusal-upstream-code refusal) "ROUND-TRIP-MISMATCH"))
                 (format nil "code ~S · upstream ~S"
                         (and refusal (s1 expansion-refusal-code refusal))
                         (and refusal (s1 expansion-refusal-upstream-code refusal))))))))

(defpackage #:e03-seg (:use))
(let* ((sym (intern "W" (find-package "E03-SEG")))
       (mk-term (lambda (ns path)
                  (lisp-plus-cd0:make-record-datum
                   (list (lisp-plus-cd0:make-record-entry
                          (lisp-plus-cd0:make-identifier-datum '("TERM") '("KIND"))
                          (lisp-plus-cd0:make-identifier-datum '("TERMKIND") '("SYMBOL")))
                         (lisp-plus-cd0:make-record-entry
                          (lisp-plus-cd0:make-identifier-datum '("TERM") '("VALUE"))
                          (lisp-plus-cd0:make-identifier-datum ns path))))))
       (a (funcall mk-term '("E03-SEG") '("W")))
       (b (funcall mk-term '("E03-SEG" "SURPLUS") '("W" "SURPLUS")))
       (da (s1 decode-term a))
       (db (handler-case (s1 decode-term b) (error (c) (list :refused (type-of c))))))
  (verdict "D3c" "two DISTINCT admissible datums decode to ONE symbol — %SEG discards surplus identifier segments beneath an injectivity claim"
           (and (eq da sym) (eq db sym)
                (not (lisp-plus-cd0:equal-datum a b)))
           (format nil "equal-datum(a,b) ~S · decode(a) EQ decode(b) ~S · both EQ E03-SEG::W ~S"
                   (lisp-plus-cd0:equal-datum a b) (eq da db) (and (eq da sym) (eq db sym)))))

;;; ==================================================================
;;; D7 — receipt accessors answer the live package; the alarm is vacuous.
;;; Audit witness: probes/FOSSOR/P5-temporal.lisp
;;; ==================================================================

(defparameter *good-source*
  '(lisp-plus-surface0:define-judgment-schema cl-user::*e03-good*
    :name :e03g :version 0
    :conclusion (:predicate :z (:v (:var :v)))
    :premises () :locals () :unique-locals ()))

(let* ((req (s1 request-expansion *good-source* :macroexpand-1 (tag "d7")))
       (receipt (s1 perform-expansion req))
       (minted-version (s1 expansion-receipt-procedure-version receipt))
       ;; NB: CD/0 octets are a CLOS %OCTET-STRING, so EQUALP on two of them is
       ;; object identity, not byte equality.  Compare the rendered VALUE (a
       ;; string) — an instrument that compared the objects would be testing
       ;; nothing, which is the very defect class D8 repairs.
       (identity-before (s1 render-identity-hex (s1 expansion-receipt-identity receipt))))
  (handler-bind ((warning #'muffle-warning))
    (eval '(defun lisp-plus-surface1::expansion-procedure-version () 4)))
  (let ((after (s1 expansion-receipt-procedure-version receipt))
        (identity-after (s1 render-identity-hex (s1 expansion-receipt-identity receipt))))
    (verdict "D7" "an OLD receipt's reported procedure version MOVES when the live package version changes; the receipt stores none"
             (and (= minted-version 3) (= after 4)
                  (string= identity-before identity-after))
             (format nil "minted at ~D · after live bump the same receipt reports ~D · identity bytes unchanged ~S"
                     minted-version after (string= identity-before identity-after))))
  ;; restore, so nothing downstream inherits a bumped image
  (handler-bind ((warning #'muffle-warning))
    (eval '(defun lisp-plus-surface1::expansion-procedure-version () 3))))

(format t "~%PRE-REPAIR-RESULT verdicts=~D expected=8 confirmed=~D~%" *verdicts* *confirmed*)
(sb-ext:exit :code (if (and (= *verdicts* 8) (= *confirmed* 8)) 0 1))
