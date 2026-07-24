;;;; CHAIR-REPRO.lisp — chair's INDEPENDENT reproduction of Kimi B1/B2,
;;;; plus the mutable-leaf DOMAIN probe the relay requires before any
;;;; string-only repair is authorized.  Written from the API, not copied
;;;; from the auditor's battery.  Read-only w.r.t. the repository.

(handler-bind ((style-warning (lambda (w) (muffle-warning w))))
  (load (merge-pathnames "slice1.lisp" *load-truename*)))

(defpackage #:chair-repro (:use #:cl))
(in-package #:chair-repro)

(import '(lisp-plus-slice1:proposition
          lisp-plus-slice1:proposition-pattern
          lisp-plus-slice1:proposition-pattern-normal-form
          lisp-plus-slice1:judgment-schema
          lisp-plus-slice1:register-schema
          lisp-plus-slice1:resolve-schema
          lisp-plus-slice1:clear-schema-registry
          lisp-plus-slice1:judgment-schema-premises
          lisp-plus-slice1:judgment-schema-locals
          lisp-plus-slice1:judgment-schema-unique-locals
          lisp-plus-slice1:derive
          lisp-plus-slice1:derivation-refused
          lisp-plus-slice1:derivation-receipt-decision
          lisp-plus-slice1:derivation-receipt-conclusion
          lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
          lisp-plus-slice1:normal-form-p))

(defun sw (form &key (kind :observation) (source :signer))
  (lisp-plus-slice0:witness :for (proposition form) :mode :direct
                            :kind kind :source source))
(defun ctx-of (id &rest witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))

(defvar *n* 0)
(defun report (label observed expected)
  (incf *n*)
  (format t "~&[~2,'0D] ~A~%     observed=~S expected=~S ~A~%"
          *n* label observed expected
          (if (eq observed expected) "<<MATCH>>" "<<DIVERGENCE>>")))

(format t "~%======== CHAIR INDEPENDENT REPRODUCTION ========~%")

;;; ==================================================================
;;; B1 — mutable leaf detachment.  Direction 1: CALLER INPUT.
;;; ==================================================================
(format t "~%-- B1 direction 1: caller input string --~%")
(let* ((s (copy-seq "alpha"))
       (p (proposition (list :predicate :p (list :r s)))))
  (setf (char s 0) #\Z)
  (report "B1.1 stored proposition rewritten via caller-held string"
          (equal p '(:predicate :p (:r "Zlpha"))) t))

;;; Direction 1b: caller input reaches a GRANTED receipt.
(clear-schema-registry)
(register-schema
 (judgment-schema :name :repro :version 1
   :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
   :premises (list (proposition-pattern '(:predicate :ev (:x (:var :x)))))))
(let* ((s (copy-seq "V1"))
       (w (sw (list :predicate :ev (list :x (copy-seq "V1"))))))
  (multiple-value-bind (claim receipt)
      (derive :schema-name :repro :schema-version 1
              :conclusion (proposition (list :predicate :ok (list :x s)))
              :supports (list w) :receiver (ctx-of :ctx w))
    (declare (ignore claim))
    (setf (char s 0) #\Z)
    (report "B1.2 granted receipt conclusion rewritten after the fact"
            (equal (derivation-receipt-conclusion receipt)
                   '(:predicate :ok (:x "Z1")))
            t)))

;;; Direction 2: PUBLIC READER RESULT writes back into storage.
(let ((w (sw '(:predicate :ev (:x "V1")))))
  (multiple-value-bind (claim receipt)
      (derive :schema-name :repro :schema-version 1
              :conclusion (proposition '(:predicate :ok (:x "V1")))
              :supports (list w) :receiver (ctx-of :ctx w))
    (declare (ignore claim))
    (let* ((returned (derivation-receipt-conclusion receipt))
           (leaf (second (assoc :x (cddr returned)))))
      (setf (char leaf 0) #\Q)
      (report "B1.3 storage rewritten THROUGH the defensive-copy reader"
              (equal (derivation-receipt-conclusion receipt)
                     '(:predicate :ok (:x "Q1")))
              t))))

;;; ==================================================================
;;; B1-DOMAIN — is the mutable-leaf domain STRINGS ONLY?
;;; %validate-value admits: keywords, integers, non-empty strings, proper
;;; lists thereof, (:var KW) in patterns, and (:quoted-datum FORM) whose
;;; "payload is never walked or interpreted".  That last clause is a second
;;; ingress: ANY Lisp object may ride inside it.
;;; ==================================================================
(format t "~%-- B1 DOMAIN probe: beyond strings --~%")

;; D1: a string inside a quoted-datum payload.
;; NOTE (chair, self-corrected): this check first compared against a
;; mis-typed literal ("Zinner" for a mutation of "inner", which yields
;; "Znner") and therefore reported a spurious NIL.  Identity is the robust
;; formulation: ask whether storage IS the caller's object, not whether it
;; equals a literal the chair typed by hand.
(let* ((s (copy-seq "inner"))
       (p (proposition (list :predicate :p (list :r (list :quoted-datum s)))))
       (stored-payload (second (second (assoc :r (cddr p))))))
  (setf (char s 0) #\Z)
  (report "B1.D1 quoted-datum STRING payload is EQ to the caller's string"
          (eq stored-payload s) t)
  (report "B1.D1b ... and the stored normal form now reads the mutation"
          (equal p '(:predicate :p (:r (:quoted-datum "Znner")))) t))

;; D2: a VECTOR inside a quoted-datum payload (copy-tree never copies it).
(let* ((v (vector 1 2 3))
       (p (proposition (list :predicate :p (list :r (list :quoted-datum v)))))
       (stored (second (assoc :r (cddr p)))))
  (setf (aref v 0) 99)
  (report "B1.D2 quoted-datum VECTOR payload is shared with storage"
          (eql (aref (second stored) 0) 99) t)
  (report "B1.D2b constructed with a vector payload at all"
          (normal-form-p p) t))

;; D3: a HASH-TABLE inside a quoted-datum payload.
(let* ((h (make-hash-table))
       (p (proposition (list :predicate :p (list :r (list :quoted-datum h)))))
       (stored (second (assoc :r (cddr p)))))
  (setf (gethash :k h) :injected)
  (report "B1.D3 quoted-datum HASH-TABLE payload is shared with storage"
          (eq (gethash :k (second stored)) :injected) t))

;; D4: an ADJUSTABLE string at an ORDINARY leaf position — mutable length.
(let* ((a (make-array 3 :element-type 'character :adjustable t
                        :fill-pointer 3 :initial-contents '(#\a #\b #\c)))
       (p (proposition (list :predicate :p (list :r a)))))
  (setf (fill-pointer a) 1)
  (report "B1.D4 adjustable string at ordinary leaf: stored value shortened"
          (equal p '(:predicate :p (:r "a"))) t))

;;; ==================================================================
;;; B2 — schema constructor input ownership, EACH SLOT SEPARATELY.
;;; ==================================================================
(format t "~%-- B2: constructor slot ownership, per slot --~%")

;; B2.1 :unique-locals spine
(clear-schema-registry)
(let* ((ul (list :tag))
       (schema (judgment-schema :name :b2u :version 1
                 :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
                 :premises (list (proposition-pattern
                                  '(:predicate :ev (:x (:var :x)) (:tag (:var :tag)))))
                 :locals '(:tag) :unique-locals ul)))
  (register-schema schema)
  (setf (car ul) :wiped)
  (report "B2.1 :unique-locals declaration rewritten post-registration"
          (equal (judgment-schema-unique-locals (resolve-schema :b2u 1)) '(:wiped))
          t)
  ;; and the behavioural consequence: declared uniqueness silently erased
  (let ((e1 (sw '(:predicate :ev (:x "X1") (:tag "T1"))))
        (e2 (sw '(:predicate :ev (:x "X1") (:tag "T2")))))
    (handler-case
        (multiple-value-bind (claim r)
            (derive :schema-name :b2u :schema-version 1
                    :conclusion (proposition '(:predicate :ok (:x "X1")))
                    :supports (list e1 e2) :receiver (ctx-of :ctx e1 e2))
          (declare (ignore claim))
          (report "B2.1b ambiguity became a GRANT after vandalism"
                  (and (eq (derivation-receipt-decision r) :granted)
                       (null (derivation-receipt-uniqueness-conflicts r)))
                  t))
      (derivation-refused (c) (declare (ignore c))
        (report "B2.1b ambiguity became a GRANT after vandalism" nil t)))))

;; B2.2 :premises spine
(clear-schema-registry)
(let* ((pat-a (proposition-pattern '(:predicate :ev-a (:x (:var :x)))))
       (pat-b (proposition-pattern '(:predicate :ev-b (:x (:var :x)))))
       (pl (list pat-a)))
  (register-schema
   (judgment-schema :name :b2p :version 1
     :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
     :premises pl))
  (setf (car pl) pat-b)
  (report "B2.2 :premises spine rewritten post-registration"
          (eq (second (proposition-pattern-normal-form
                       (first (judgment-schema-premises (resolve-schema :b2p 1)))))
              :ev-b)
          t))

;; B2.3 :locals spine
(clear-schema-registry)
(let* ((lo (list :tag))
       (schema (judgment-schema :name :b2l :version 1
                 :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
                 :premises (list (proposition-pattern
                                  '(:predicate :ev (:x (:var :x)) (:tag (:var :tag)))))
                 :locals lo)))
  (register-schema schema)
  (setf (car lo) :wiped)
  (report "B2.3 :locals declaration rewritten post-registration"
          (equal (judgment-schema-locals (resolve-schema :b2l 1)) '(:wiped))
          t))

;;; ==================================================================
;;; B2-SUFFICIENCY — would a shallow COPY-LIST at construction suffice?
;;; :locals / :unique-locals are validated as lists of KEYWORDS (immutable
;;; elements) => spine copy is total.  :premises elements are read-only
;;; proposition-pattern structs whose normal-form may carry MUTABLE STRING
;;; leaves => spine copy leaves a residual path that belongs to B1, not B2.
;;; ==================================================================
(format t "~%-- B2 sufficiency: residual element-level path --~%")
(clear-schema-registry)
(let* ((s (copy-seq "lit"))
       (pat (proposition-pattern (list :predicate :ev (list :x (list :var :x))
                                       (list :lit s))))
       (pl (list pat)))
  (register-schema
   (judgment-schema :name :b2r :version 1
     :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
     :premises pl))
  (setf (char s 0) #\Z)
  (report "B2.R premise PATTERN literal rewritten via shared string (survives any spine copy)"
          (equal (proposition-pattern-normal-form
                  (first (judgment-schema-premises (resolve-schema :b2r 1))))
                 '(:predicate :ev (:lit "Zit") (:x (:var :x))))
          t))

(format t "~%======== CHAIR REPRODUCTION DONE (~D checks) ========~%" *n*)
