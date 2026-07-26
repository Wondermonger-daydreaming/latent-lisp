;;;; surface0-selftest.lisp — teeth for Language Surface /0.
;;;;
;;;; Governed by LANGUAGE-SURFACE-0-WORK-ORDER.md §§8–9.
;;;;
;;;; THE CENTRAL CLAIM UNDER TEST is not "the macros work".  It is:
;;;;
;;;;     the surface path and the direct-constructor path produce the SAME
;;;;     PUBLIC SEMANTIC OBSERVATIONS
;;;;
;;;; so every declarative macro here has a DIRECT-API TWIN built beside it, and
;;;; the two are compared through public readers only — never by EQ where the
;;;; public contract does not promise it, and never by comparing success
;;;; banners or printed text.
;;;;
;;;; ALL greens are SELF-CONSISTENCY CERTIFICATION.  Surface /0 claims NO
;;;; semantic delta below itself; nothing here claims durability, cross-image
;;;; standing, serialization authenticity or any cryptographic property, and no
;;;; account below is evidence that any external deed occurred.
;;;;
;;;; Run: sbcl --non-interactive --load surface0-selftest.lisp  (exit 0 on all-pass)

(unless (find-package :lisp-plus-surface0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "surface0.lisp" *load-truename*))))

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-core-0/fake-courier.lisp" *load-truename*))))

(defpackage #:surface0-selftest
  (:use #:cl #:lisp-plus-surface0))
(in-package #:surface0-selftest)

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defmacro fires (name expected-type &body body)
  "Show a gate FIRE, and assert WHICH gate.  `did it fail?` is not a result."
  (let ((c (gensym)))
    `(handler-case (progn ,@body (ok ,name nil "nothing fired (expected a refusal)"))
       (,expected-type (,c) (ok ,name t (format nil "bit: ~A" (type-of ,c))))
       (error (,c) (ok ,name nil (format nil "WRONG condition: ~A" (type-of ,c)))))))

(defmacro fires-surface (name reason &body body)
  "A surface-grammar refusal, asserted down to its REASON KEYWORD."
  (let ((c (gensym)))
    `(handler-case (progn ,@body (ok ,name nil "nothing fired"))
       (surface-syntax-refused (,c)
         (ok ,name (eq (surface-syntax-refused-reason ,c) ,reason)
             (format nil "reason=~S offending=~S"
                     (surface-syntax-refused-reason ,c)
                     (surface-syntax-refused-offending ,c))))
       (error (,c) (ok ,name nil (format nil "WRONG condition: ~A" (type-of ,c)))))))

;;; ------------------------------------------------------------------
;;; Fixtures.  A dispatch desk, deliberately the same shape the Slice /2 teeth
;;; use, so a reader comparing the two files is comparing surface vs direct and
;;; not two different worlds.

(defun np (f) (lisp-plus-slice1:proposition f))
(defun pp (f) (lisp-plus-slice1:proposition-pattern f))

(defparameter +req+ '(:predicate :deliver (:payload "surface-0 -> reader")))

(defun key-for ()
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates '(:deliver))))

(defun genuine-account (&key (script :clean-commit) (label "surf/dispatch"))
  (multiple-value-bind (adapter world)
      (lisp-plus-fake-courier:make-fake-courier :script script)
    (declare (ignore world))
    (handler-case
        (nth-value 1 (lisp-plus-core0:perform
                      :adapter adapter :request +req+ :authority (key-for)
                      :process (lisp-plus-core0:process-context :label label)))
      (lisp-plus-core0:core0-interrupted (c)
        (lisp-plus-core0:core0-condition-evidence c)))))

(defun ctx (&rest supports)
  (lisp-plus-slice0:receiver-context
   :context-id :surface-desk
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice2:source-basis-p s)
                    (list (lisp-plus-slice2:source-basis-identity s)))
                   ((lisp-plus-slice2:derivation-basis-p s)
                    (list (lisp-plus-slice2:derivation-basis-identity s)))
                   ((lisp-plus-slice0:witness-p s)
                    (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)
                    (list (lisp-plus-slice0:claim-id s)))))
           supports)))

(lisp-plus-slice1:clear-schema-registry)

(format t "~%== Language Surface /0 teeth (self-consistency certification) ==~%")

;;; ==================================================================
;;; SD — DIFFERENTIAL SEMANTICS.  Surface twin vs direct twin, compared only
;;; through public readers.

(format t "~%-- SD: the surface path and the direct path, compared --~%")

;; ---- schema: surface ----
(define-judgment-schema *surf-account-schema*
  :name :surf-account-standing :version 1
  :conclusion (:predicate :account-acknowledged (:volume (:var :volume)))
  :premises ((:predicate :core0-account-reports-acknowledgment
              (:attempt (:var :attempt)) (:request (:var :request))
              (:acknowledgment :acknowledged)))
  :locals (:attempt :request)
  :unique-locals ())

;; ---- schema: direct twin, same anatomy under a different key ----
(defparameter *direct-account-schema*
  (lisp-plus-slice1:judgment-schema
   :name :direct-account-standing :version 1
   :conclusion (pp '(:predicate :account-acknowledged (:volume (:var :volume))))
   :premises (list (pp '(:predicate :core0-account-reports-acknowledgment
                         (:attempt (:var :attempt)) (:request (:var :request))
                         (:acknowledgment :acknowledged))))
   :locals '(:attempt :request)
   :unique-locals '()))
(lisp-plus-slice1:register-schema *direct-account-schema*)

;; NOTE ON THE COMPARISON, because getting it wrong is the obvious mistake and
;; this test made it first: a PROPOSITION-PATTERN is a DEFSTRUCT, and CL's EQUAL
;; on structures is EQ.  Two separately-constructed patterns that are
;; structurally identical are NOT EQUAL.  The work order says it outright — do
;; not require EQ where the public contract does not promise it — so the
;; comparison goes through the public normal-form reader instead.
(defun pattern-nf (p) (lisp-plus-slice1:proposition-pattern-normal-form p))

(ok "SD1 the surface schema and its direct twin agree on every public reader but the name"
    (and (eql 1 (lisp-plus-slice1:judgment-schema-version *surf-account-schema*))
         (equal (pattern-nf (lisp-plus-slice1:judgment-schema-conclusion *surf-account-schema*))
                (pattern-nf (lisp-plus-slice1:judgment-schema-conclusion *direct-account-schema*)))
         (equal (mapcar #'pattern-nf (lisp-plus-slice1:judgment-schema-premises *surf-account-schema*))
                (mapcar #'pattern-nf (lisp-plus-slice1:judgment-schema-premises *direct-account-schema*)))
         (equal (lisp-plus-slice1:judgment-schema-locals *surf-account-schema*)
                (lisp-plus-slice1:judgment-schema-locals *direct-account-schema*))
         (equal (lisp-plus-slice1:judgment-schema-unique-locals *surf-account-schema*)
                (lisp-plus-slice1:judgment-schema-unique-locals *direct-account-schema*))
         (eq :surf-account-standing
             (lisp-plus-slice1:judgment-schema-name *surf-account-schema*)))
    "premise order, conclusion pattern, locals and uniqueness declaration all identical")

(ok "SD2 the surface schema is REGISTERED, and by the public operation"
    (eq *surf-account-schema*
        (lisp-plus-slice1:resolve-schema :surf-account-standing 1)))

;; ---- contracts ----
(define-admission-contract *surf-source-bound*
  :contract-id :surf-source-bound :contract-version 0
  :accepted-clauses ((:source-basis :relations (:core0-account-reports-acknowledgment)))
  :proposition-relation :exact-normalized-equality
  :receiver-accessibility :required
  :retain (:contract-snapshot :support-identity :support-basis :source-basis))

(defparameter *direct-source-bound*
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :surf-source-bound :contract-version 0
   :accepted-clauses '((:source-basis
                        :relations (:core0-account-reports-acknowledgment)))
   :proposition-relation :exact-normalized-equality
   :receiver-accessibility :required
   :retain '(:contract-snapshot :support-identity :support-basis :source-basis)))

(ok "SD3 the surface contract and its direct twin agree on EVERY public reader"
    (and (equal (lisp-plus-slice2:support-admission-contract-contract-id *surf-source-bound*)
                (lisp-plus-slice2:support-admission-contract-contract-id *direct-source-bound*))
         (eql (lisp-plus-slice2:support-admission-contract-contract-version *surf-source-bound*)
              (lisp-plus-slice2:support-admission-contract-contract-version *direct-source-bound*))
         (equal (lisp-plus-slice2:support-admission-contract-accepted-clauses *surf-source-bound*)
                (lisp-plus-slice2:support-admission-contract-accepted-clauses *direct-source-bound*))
         (eq (lisp-plus-slice2:support-admission-contract-proposition-relation *surf-source-bound*)
             (lisp-plus-slice2:support-admission-contract-proposition-relation *direct-source-bound*))
         (eq (lisp-plus-slice2:support-admission-contract-receiver-accessibility *surf-source-bound*)
             (lisp-plus-slice2:support-admission-contract-receiver-accessibility *direct-source-bound*))
         (equal (lisp-plus-slice2:support-admission-contract-retain *surf-source-bound*)
                (lisp-plus-slice2:support-admission-contract-retain *direct-source-bound*))
         (equal (lisp-plus-slice2:support-admission-contract-truth-ceilings *surf-source-bound*)
                (lisp-plus-slice2:support-admission-contract-truth-ceilings *direct-source-bound*)))
    "identity, version, clauses, relation, accessibility, retention AND ceilings")

;; ---- slice /2 schemas ----
(define-slice2-schema *surf-s2*
  :schema-id :surf-account/2 :schema-version 0
  :base-schema *surf-account-schema*
  :premise-contracts ((0 *surf-source-bound*)))

(defparameter *direct-s2*
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :direct-account/2 :schema-version 0
   :base-schema *direct-account-schema*
   :premise-contracts (list (list 0 *direct-source-bound*))))

(ok "SD4 the surface Slice /2 schema attaches by INDEX, exactly as the direct twin does"
    (and (eq *surf-account-schema* (lisp-plus-slice2:slice2-schema-base-schema *surf-s2*))
         (eq :surf-source-bound
             (lisp-plus-slice2:support-admission-contract-contract-id
              (lisp-plus-slice2:slice2-schema-contract-for-premise *surf-s2* 0)))
         (eq :surf-source-bound
             (lisp-plus-slice2:support-admission-contract-contract-id
              (lisp-plus-slice2:slice2-schema-contract-for-premise *direct-s2* 0)))))

;;; ---- the six scenarios, both paths ----

(defparameter *ev* (genuine-account))
(defparameter *basis*
  (lisp-plus-slice2:establish-core0-source-basis
   :evidence *ev* :request +req+
   :relation :core0-account-reports-acknowledgment
   :expected-outcome :acknowledged))

(defun account-conclusion (&optional (v "codex-9"))
  (np `(:predicate :account-acknowledged (:volume ,v))))

(defun observe (receipt)
  "The public observations a differential comparison is allowed to use."
  (let ((a (first (lisp-plus-slice2:slice2-receipt-admissions receipt))))
    (list :decision (lisp-plus-slice2:slice2-receipt-decision receipt)
          :disposition (lisp-plus-slice2:premise-admission-disposition a)
          :base-disposition (lisp-plus-slice2:premise-admission-base-disposition a)
          :ceilings (lisp-plus-slice2:premise-admission-truth-ceilings a)
          :n-source-bases (length (lisp-plus-slice2:slice2-receipt-source-bases-used receipt))
          :n-derivation-bases (length (lisp-plus-slice2:slice2-receipt-derivation-bases-used receipt))
          :residue (lisp-plus-slice2:slice2-receipt-unsupported-supports receipt))))

;; SCENARIO 2 — a Slice /2 source-basis derivation, both paths.
(defparameter *surf-claim* nil)
(defparameter *surf-receipt* nil)
(defparameter *surf-dbasis* nil)

(derive/2-case (claim receipt dbasis)
    (lisp-plus-slice2:derive/2 :schema *surf-s2* :conclusion (account-conclusion)
                               :supports (list *basis*) :receiver (ctx *basis*))
  (:granted (setf *surf-claim* claim *surf-receipt* receipt *surf-dbasis* dbasis))
  (:refused (c) (declare (ignore c)) (setf *surf-receipt* receipt)))

(multiple-value-bind (dclaim dreceipt ddbasis)
    (lisp-plus-slice2:derive/2 :schema *direct-s2* :conclusion (account-conclusion)
                               :supports (list *basis*) :receiver (ctx *basis*))
  (ok "SD5 scenario 2 — a source-basis derivation observes IDENTICALLY on both paths"
      (equal (observe *surf-receipt*) (observe dreceipt))
      (format nil "~S" (observe *surf-receipt*)))
  (ok "SD6 both paths grant, and both third values are established derivation bases"
      (and *surf-claim* dclaim
           (lisp-plus-slice2:derivation-basis-established-in-current-image-p *surf-dbasis*)
           (lisp-plus-slice2:derivation-basis-established-in-current-image-p ddbasis))
      "DERIVE/2-CASE binds the EXACT third value; it never constructs one"))

;; SCENARIO 1 — an ordinary Slice /1 derivation through DERIVE-CASE.
(define-judgment-schema *surf-plain*
  :name :surf-plain :version 1
  :conclusion (:predicate :plain-ok (:volume (:var :volume)))
  :premises ((:predicate :plain-premise (:volume (:var :volume))))
  :locals () :unique-locals ())

(defparameter *plain-witness*
  (lisp-plus-slice0:witness :for (np '(:predicate :plain-premise (:volume "codex-9")))
                            :mode :direct :kind :desk-note :source :desk))

(defparameter *plain-surface-claim* nil)
(derive-case (claim receipt)
    (lisp-plus-slice1:derive :schema-name :surf-plain :schema-version 1
                             :conclusion (np '(:predicate :plain-ok (:volume "codex-9")))
                             :supports (list *plain-witness*)
                             :receiver (ctx *plain-witness*) :by :desk)
  (:granted (declare (ignore receipt)) (setf *plain-surface-claim* claim))
  (:refused (c) (declare (ignore c)) nil))

(multiple-value-bind (dclaim dreceipt)
    (lisp-plus-slice1:derive :schema-name :surf-plain :schema-version 1
                             :conclusion (np '(:predicate :plain-ok (:volume "codex-9")))
                             :supports (list *plain-witness*)
                             :receiver (ctx *plain-witness*) :by :desk)
  (declare (ignore dreceipt))
  (ok "SD7 scenario 1 — an ordinary Slice /1 derivation grants identically through DERIVE-CASE"
      ;; CLAIM-JUDGMENT returns a JUDGMENT-RECORD, not a keyword — the keyword
       ;; lives behind JUDGMENT-RECORD-JUDGMENT.  This test asserted the keyword
       ;; directly at first and failed against a perfectly correct grant.
       (and *plain-surface-claim* dclaim
           (equal (lisp-plus-slice0:claim-proposition *plain-surface-claim*)
                  (lisp-plus-slice0:claim-proposition dclaim))
           (eq :verified (lisp-plus-slice0:judgment-record-judgment
                          (lisp-plus-slice0:claim-judgment *plain-surface-claim*)))
           (eq :verified (lisp-plus-slice0:judgment-record-judgment
                          (lisp-plus-slice0:claim-judgment dclaim))))))

;; SCENARIO 3 — a downstream derivation-basis-only premise.
(define-judgment-schema *surf-composed*
  :name :surf-composed :version 1
  :conclusion (:predicate :composed-ok (:volume (:var :volume)))
  :premises ((:predicate :account-acknowledged (:volume (:var :volume))))
  :locals () :unique-locals ())

(define-admission-contract *surf-dbasis-only*
  :contract-id :surf-derivation-bound :contract-version 1
  :accepted-clauses ((:derivation-basis))
  :proposition-relation :exact-normalized-equality
  :receiver-accessibility :required
  :retain (:contract-snapshot :support-identity :support-basis :source-basis))

(define-slice2-schema *surf-composed/2*
  :schema-id :surf-composed/2 :schema-version 0
  :base-schema *surf-composed*
  :premise-contracts ((0 *surf-dbasis-only*)))

(defun composed-conclusion (&optional (v "codex-9"))
  (np `(:predicate :composed-ok (:volume ,v))))

(defun run-composed (supports &key (receiver :auto))
  (let ((rcv (if (eq receiver :auto) (apply #'ctx supports) receiver)))
    (handler-case
        (multiple-value-bind (c r b)
            (lisp-plus-slice2:derive/2 :schema *surf-composed/2*
                                       :conclusion (composed-conclusion)
                                       :supports supports :receiver rcv)
          (values r c :granted b))
      (lisp-plus-slice2:slice2-derivation-refused (e)
        (values (lisp-plus-slice2:slice2-condition-receipt e) nil :refused nil)))))

(multiple-value-bind (r c decision b) (run-composed (list *surf-dbasis*))
  (declare (ignore c))
  (ok "SD8 scenario 3 — the derivation basis discharges a derivation-basis-only premise"
      (and (eq decision :granted)
           (lisp-plus-slice2:derivation-basis-p b)
           (= 1 (length (lisp-plus-slice2:slice2-receipt-derivation-bases-used r)))))
  (ok "SD9 and the prior Slice /2 receipt is reachable BY OBJECT from the new one"
      (eq *surf-receipt*
          (lisp-plus-slice2:derivation-basis-receipt
           (first (lisp-plus-slice2:slice2-receipt-derivation-bases-used r))))))

;; SCENARIO 4 — refusal caused by a naked claim.
(multiple-value-bind (r c decision b) (run-composed (list *surf-claim*))
  (declare (ignore c b))
  (ok "SD10 scenario 4 — the NAKED claim is refused there, with slice /1 satisfied"
      (and (eq decision :refused)
           (eq :not-admitted
               (lisp-plus-slice2:premise-admission-disposition
                (first (lisp-plus-slice2:slice2-receipt-admissions r))))
           (eq :satisfied
               (lisp-plus-slice2:premise-admission-base-disposition
                (first (lisp-plus-slice2:slice2-receipt-admissions r)))))
      "surface syntax did not soften Candidate /1's answer"))

;; SCENARIO 5 — refusal caused by inaccessibility.
(multiple-value-bind (r c decision b)
    (run-composed (list *surf-dbasis*)
                  :receiver (lisp-plus-slice0:receiver-context
                             :context-id :surface-desk :accessible-supports '()))
  (declare (ignore c b))
  (ok "SD11 scenario 5 — inaccessibility is NOT repaired by surface syntax"
      (and (eq decision :refused)
           (not (eq :satisfied
                    (lisp-plus-slice2:premise-admission-disposition
                     (first (lisp-plus-slice2:slice2-receipt-admissions r))))))))

;; SCENARIO 6 — a refuted premise.
(multiple-value-bind (r c decision b)
    (run-composed (list *surf-dbasis*
                        (lisp-plus-slice0:witness
                         :for (account-conclusion) :mode :direct :kind :desk-note
                         :source :desk :polarity :refutes)))
  (declare (ignore c b))
  (ok "SD12 scenario 6 — refutation retains precedence over an admitted basis"
      (and (eq decision :refused)
           (eq :refuted (lisp-plus-slice2:premise-admission-disposition
                         (first (lisp-plus-slice2:slice2-receipt-admissions r)))))))

;;; ==================================================================
;;; SC — SURFACE CONTROLS.

(format t "~%-- SC: surface grammar, transparency and evaluation discipline --~%")

(fires-surface "SC1 a MISSING required field refuses, naming the field" :missing-field
  (macroexpand-1 '(define-admission-contract *x*
                   :contract-id :a :contract-version 0
                   :accepted-clauses ((:verified-judged-claim))
                   :proposition-relation :exact-normalized-equality
                   :receiver-accessibility :required)))

(fires-surface "SC2 a DUPLICATE field refuses" :duplicate-field
  (macroexpand-1 '(define-admission-contract *x*
                   :contract-id :a :contract-id :b :contract-version 0
                   :accepted-clauses ((:verified-judged-claim))
                   :proposition-relation :exact-normalized-equality
                   :receiver-accessibility :required :retain ())))

(fires-surface "SC3 an UNKNOWN surface field refuses" :unknown-field
  (macroexpand-1 '(define-admission-contract *x*
                   :contract-id :a :contract-version 0 :vibes :good
                   :accepted-clauses ((:verified-judged-claim))
                   :proposition-relation :exact-normalized-equality
                   :receiver-accessibility :required :retain ())))

(fires-surface "SC4 a MALFORMED premise attachment refuses" :malformed-clause
  (macroexpand-1 '(define-slice2-schema *x*
                   :schema-id :a :schema-version 0 :base-schema *surf-composed*
                   :premise-contracts ((*surf-dbasis-only*)))))

(fires-surface "SC5 DERIVE-CASE wrapping the WRONG operation refuses" :wrong-operation
  (macroexpand-1 '(derive-case (c r) (lisp-plus-slice2:derive/2 :schema nil)
                   (:granted nil) (:refused (e) nil))))

(fires-surface "SC6 DERIVE/2-CASE wrapping the WRONG operation refuses" :wrong-operation
  (macroexpand-1 '(derive/2-case (c r b) (lisp-plus-slice1:derive :schema-name :x)
                   (:granted nil) (:refused (e) nil))))

(fires-surface "SC7 an OMITTED contract version refuses at the surface" :missing-field
  (macroexpand-1 '(define-admission-contract *x*
                   :contract-id :a
                   :accepted-clauses ((:verified-judged-claim))
                   :proposition-relation :exact-normalized-equality
                   :receiver-accessibility :required :retain ())))

;;; --- semantic refusals must reach the layer that OWNS them ---

(fires "SC8 a semantically UNKNOWN contract version reaches SLICE /2's refusal, not the surface's"
       lisp-plus-slice2:admission-contract-error
  (eval (macroexpand-1 '(define-admission-contract *x*
                         :contract-id :a :contract-version 7
                         :accepted-clauses ((:verified-judged-claim))
                         :proposition-relation :exact-normalized-equality
                         :receiver-accessibility :required :retain ()))))

(fires "SC9 an UNKNOWN support clause reaches SLICE /2's refusal, not the surface's"
       lisp-plus-slice2:unknown-admission-clause
  (eval (macroexpand-1 '(define-admission-contract *x*
                         :contract-id :a :contract-version 1
                         :accepted-clauses ((:vibe-basis))
                         :proposition-relation :exact-normalized-equality
                         :receiver-accessibility :required :retain ()))))

(fires "SC10 a MISSING premise contract retains SLICE /2's typed refusal"
       lisp-plus-slice2:premise-contract-missing
  (eval (macroexpand-1 '(define-slice2-schema *x*
                         :schema-id :a :schema-version 0
                         :base-schema *surf-composed*
                         :premise-contracts ()))))

(fires "SC11 a DUPLICATE premise contract retains SLICE /2's typed refusal"
       lisp-plus-slice2:premise-contract-duplicate
  (eval (macroexpand-1 '(define-slice2-schema *x*
                         :schema-id :a :schema-version 0
                         :base-schema *surf-composed*
                         :premise-contracts ((0 *surf-dbasis-only*)
                                             (0 *surf-dbasis-only*))))))

(fires "SC12 an OUT-OF-RANGE premise index retains SLICE /2's typed refusal"
       lisp-plus-slice2:premise-contract-unknown-premise
  (eval (macroexpand-1 '(define-slice2-schema *x*
                         :schema-id :a :schema-version 0
                         :base-schema *surf-composed*
                         :premise-contracts ((0 *surf-dbasis-only*)
                                             (9 *surf-dbasis-only*))))))

;;; --- Candidate /1 semantics are untouched by the surface ---

(multiple-value-bind (r c decision b)
    (run-composed (list (lisp-plus-slice0:raise
                         (lisp-plus-slice0:claim :proposition (account-conclusion)
                                                 :by :desk)
                         :to :verified
                         :per (lisp-plus-slice0:promotion-procedure
                               :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                                            :procedure-id (lisp-plus-kernel0:make-identity
                                                           :procedure "surf/read")
                                            :version 1 :judgment-class :semantic
                                            :result-vocabulary '(:verified :refuted))
                               :admits '((:direct :desk-note)))
                         :considering (list (lisp-plus-slice0:witness
                                             :for (account-conclusion) :mode :direct
                                             :kind :desk-note :source :desk))
                         :receiver :surface-desk)))
  (declare (ignore c b))
  (ok "SC13/14 an ORDINARILY RAISED matching claim is still refused at a derivation-bound premise"
      (and (eq decision :refused)
           (eq :not-admitted (lisp-plus-slice2:premise-admission-disposition
                              (first (lisp-plus-slice2:slice2-receipt-admissions r)))))))

(multiple-value-bind (r c decision b) (run-composed (list *basis*))
  (declare (ignore c b))
  (ok "SC15 a SOURCE basis is not accepted as a DERIVATION basis"
      (and (eq decision :refused)
           (not (eq :satisfied (lisp-plus-slice2:premise-admission-disposition
                                (first (lisp-plus-slice2:slice2-receipt-admissions r))))))))

(let ((r (handler-case
             (nth-value 1 (lisp-plus-slice2:derive/2
                           :schema *surf-s2* :conclusion (account-conclusion)
                           :supports (list *surf-dbasis*)
                           :receiver (ctx *surf-dbasis*)))
           (lisp-plus-slice2:slice2-derivation-refused (e)
             (lisp-plus-slice2:slice2-condition-receipt e)))))
  (ok "SC16 a DERIVATION basis is not accepted as a SOURCE basis"
      (not (eq :satisfied (lisp-plus-slice2:premise-admission-disposition
                           (first (lisp-plus-slice2:slice2-receipt-admissions r)))))
      "the two ceilings stay distinct because the two clauses do"))

;;; --- evaluation discipline ---

(let ((n 0))
  (flet ((count-once () (incf n) (list *surf-dbasis*)))
    (derive/2-case (c r b)
        (lisp-plus-slice2:derive/2 :schema *surf-composed/2*
                                   :conclusion (composed-conclusion)
                                   :supports (count-once)
                                   :receiver (ctx *surf-dbasis*))
      (:granted (declare (ignore c r b)) nil)
      (:refused (e) (declare (ignore e)) nil)))
  (ok "SC19 caller expressions are evaluated EXACTLY ONCE" (= n 1)
      (format nil "operand evaluated ~D time(s)" n)))

(let ((order '()))
  (flet ((mark (tag v) (push tag order) v))
    (derive/2-case (c r b)
        (lisp-plus-slice2:derive/2 :schema (mark :a *surf-composed/2*)
                                   :conclusion (mark :b (composed-conclusion))
                                   :supports (mark :c (list *surf-dbasis*))
                                   :receiver (mark :d (ctx *surf-dbasis*)))
      (:granted (declare (ignore c r b)) nil)
      (:refused (e) (declare (ignore e)) nil)))
  (ok "SC20 and in SOURCE ORDER" (equal (reverse order) '(:a :b :c :d))
      (format nil "~S" (reverse order))))

(fires "SC21 an UNEXPECTED host error ESCAPES rather than being caught as a refusal"
       simple-error
  (derive/2-case (c r b)
      (lisp-plus-slice2:derive/2 :schema *surf-composed/2*
                                 :conclusion (composed-conclusion)
                                 :supports (error "a real bug, not a refusal")
                                 :receiver nil)
    (:granted (declare (ignore c r b)) nil)
    (:refused (e) (declare (ignore e)) :swallowed)))

;;; --- transparency of the expansion ---

(let ((x (macroexpand-1 '(define-judgment-schema *z*
                          :name :z :version 1
                          :conclusion (:predicate :z (:v (:var :v)))
                          :premises ((:predicate :y (:v (:var :v))))
                          :locals () :unique-locals ()))))
  (labels ((symbols (f) (cond ((symbolp f) (list f))
                              ((consp f) (append (symbols (car f)) (symbols (cdr f))))
                              (t nil))))
    (let* ((syms (remove-if-not #'symbolp (symbols x)))
           (internal (remove-if-not
                      (lambda (s)
                        (let ((p (symbol-package s)))
                          (and p
                               (member (package-name p)
                                       '("LISP-PLUS-SLICE0" "LISP-PLUS-SLICE1"
                                         "LISP-PLUS-SLICE2" "LISP-PLUS-CORE0"
                                         "LISP-PLUS-KERNEL0")
                                       :test #'string=)
                               (not (eq :external
                                        (nth-value 1 (find-symbol (symbol-name s) p)))))))
                      syms)))
      (ok "SC23 MACROEXPAND-1 contains NO internal lower-layer symbols"
          (null internal) (format nil "~S" internal))
      (ok "SC24 and no hidden registry clearing"
          (not (member 'lisp-plus-slice1:clear-schema-registry syms))
          "reloading hits Slice /1's duplicate behaviour, unchanged")
      (ok "SC-extra the expansion visibly names the PUBLIC constructor and the PUBLIC registry op"
          (and (member 'lisp-plus-slice1:judgment-schema syms)
               (member 'lisp-plus-slice1:register-schema syms)
               (member 'lisp-plus-slice1:proposition-pattern syms))))))

;;; --- the third value, and the refusal that mints nothing ---

(ok "SC25 a successful DERIVE/2-CASE binds the EXACT third return value"
    (and (lisp-plus-slice2:derivation-basis-p *surf-dbasis*)
         (lisp-plus-slice2:derivation-basis-established-in-current-image-p *surf-dbasis*)
         (eq *surf-claim* (lisp-plus-slice2:derivation-basis-claim *surf-dbasis*))
         (eq *surf-receipt* (lisp-plus-slice2:derivation-basis-receipt *surf-dbasis*))))

(let ((before (hash-table-count
               (symbol-value (find-symbol "*ESTABLISHED-DERIVATION-BASES*"
                                          :lisp-plus-slice2))))
      (bound :untouched))
  (derive/2-case (c r b)
      (lisp-plus-slice2:derive/2 :schema *surf-composed/2*
                                 :conclusion (composed-conclusion)
                                 :supports (list *surf-claim*)
                                 :receiver (ctx *surf-claim*))
    (:granted (declare (ignore c r b)) (setf bound :granted))
    (:refused (e) (declare (ignore e)) (setf bound :refused)))
  (ok "SC26 a REFUSED DERIVE/2-CASE mints no basis and registers nothing"
      (and (eq bound :refused)
           (= before (hash-table-count
                      (symbol-value (find-symbol "*ESTABLISHED-DERIVATION-BASES*"
                                                 :lisp-plus-slice2)))))
      "and the claim and basis variables are not even in scope in that arm"))

;;; --- accessibility and refutation THROUGH the control form ---
;;;
;;; SD11/SD12 exercise these through a direct DERIVE/2 call.  These two run the
;;; same questions THROUGH DERIVE/2-CASE, which is where a control form that
;;; "helpfully" supplied a permissive receiver would show up.  Without these,
;;; planted fault B below would have nothing to trip.

(let ((outcome nil) (disposition nil))
  (derive/2-case (c r b)
      (lisp-plus-slice2:derive/2 :schema *surf-composed/2*
                                 :conclusion (composed-conclusion)
                                 :supports (list *surf-dbasis*)
                                 :receiver (lisp-plus-slice0:receiver-context
                                            :context-id :surface-desk
                                            :accessible-supports '()))
    (:granted (declare (ignore c b)) (setf outcome :granted)
              (setf disposition (lisp-plus-slice2:premise-admission-disposition
                                 (first (lisp-plus-slice2:slice2-receipt-admissions r)))))
    (:refused (e) (declare (ignore e))
              (setf outcome :refused
                    disposition (lisp-plus-slice2:premise-admission-disposition
                                 (first (lisp-plus-slice2:slice2-receipt-admissions r))))))
  (ok "SC17 receiver INACCESSIBILITY is not repaired by DERIVE/2-CASE"
      (and (eq outcome :refused) (not (eq disposition :satisfied)))
      (format nil "outcome=~S disposition=~S — the control form supplies no receiver of its own"
              outcome disposition)))

(defparameter *refuter*
  (lisp-plus-slice0:witness :for (account-conclusion) :mode :direct :kind :desk-note
                            :source :desk :polarity :refutes)
  "A refuting witness that the receiver can actually REACH.  The first draft of
SC18 gave the receiver only the basis, so the refuter was INACCESSIBLE and the
premise granted — a green that would have proved nothing about refutation.
Naming the refuter separately keeps the receiver honest.")

(let ((outcome nil) (disposition nil))
  (derive/2-case (c r b)
      (lisp-plus-slice2:derive/2
       :schema *surf-composed/2* :conclusion (composed-conclusion)
       :supports (list *surf-dbasis* *refuter*)
       :receiver (ctx *surf-dbasis* *refuter*))
    (:granted (declare (ignore c b)) (setf outcome :granted))
    (:refused (e) (declare (ignore e))
              (setf outcome :refused
                    disposition (lisp-plus-slice2:premise-admission-disposition
                                 (first (lisp-plus-slice2:slice2-receipt-admissions r))))))
  (ok "SC18 REFUTATION retains precedence through DERIVE/2-CASE"
      (and (eq outcome :refused) (eq disposition :refuted))
      (format nil "outcome=~S disposition=~S" outcome disposition)))

;;; --- COMPILE-FILE then LOAD, not only interactive EVAL ---
;;;
;;; A macro layer that only works under the evaluator is a demo, not a compiler
;;; front end.  This writes a small surface-native file, COMPILE-FILEs it, LOADs
;;; the fasl, and compares the resulting objects through public readers.

(let* ((src (merge-pathnames "surface0-compile-probe.lisp"
                             (or *load-truename* *default-pathname-defaults*)))
       (fasl nil))
  (with-open-file (out src :direction :output :if-exists :supersede)
    (format out ";;;; generated by surface0-selftest.lisp — compile-file probe~%")
    (format out "(in-package #:surface0-selftest)~%")
    (format out "(define-judgment-schema *compiled-schema*~%")
    (format out "  :name :compiled-standing :version 1~%")
    (format out "  :conclusion (:predicate :compiled-ok (:volume (:var :volume)))~%")
    (format out "  :premises ((:predicate :compiled-premise (:volume (:var :volume))))~%")
    (format out "  :locals () :unique-locals ())~%")
    (format out "(define-admission-contract *compiled-contract*~%")
    (format out "  :contract-id :compiled-c :contract-version 1~%")
    (format out "  :accepted-clauses ((:derivation-basis))~%")
    (format out "  :proposition-relation :exact-normalized-equality~%")
    (format out "  :receiver-accessibility :required~%")
    (format out "  :retain (:contract-snapshot))~%")
    (format out "(define-slice2-schema *compiled-s2*~%")
    (format out "  :schema-id :compiled/2 :schema-version 0~%")
    (format out "  :base-schema *compiled-schema*~%")
    (format out "  :premise-contracts ((0 *compiled-contract*)))~%"))
  (handler-bind ((warning #'muffle-warning))
    (setf fasl (compile-file src :verbose nil :print nil))
    (load fasl))
  (ok "SC22 COMPILE-FILE then LOAD produces the same public observations as a direct load"
      (and (lisp-plus-slice1:judgment-schema-p (symbol-value '*compiled-schema*))
           (eq (symbol-value '*compiled-schema*)
               (lisp-plus-slice1:resolve-schema :compiled-standing 1))
           (eq :compiled-c (lisp-plus-slice2:support-admission-contract-contract-id
                            (symbol-value '*compiled-contract*)))
           (eql 1 (lisp-plus-slice2:support-admission-contract-contract-version
                   (symbol-value '*compiled-contract*)))
           (equal '((:derivation-basis))
                  (lisp-plus-slice2:support-admission-contract-accepted-clauses
                   (symbol-value '*compiled-contract*)))
           (eq (symbol-value '*compiled-schema*)
               (lisp-plus-slice2:slice2-schema-base-schema
                (symbol-value '*compiled-s2*))))
      "the macros are a compiler front end, not an evaluator trick")
  (ignore-errors (delete-file src))
  (when fasl (ignore-errors (delete-file fasl))))

;;; ==================================================================
;;; Tally + exit.

(format t "~%== Language Surface /0 teeth: ~D passed / ~D failed ==~%" *pass* *fail*)
(format t "(self-consistency certification — Surface /0 claims NO semantic delta ~
below itself; every account above is a labelled scripted fake adapter and none ~
is evidence that an external deed occurred)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
