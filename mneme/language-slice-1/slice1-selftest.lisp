;;;; slice1-selftest.lisp — substrate teeth for Lisp+ Slice /1.
;;;;
;;;; Δ6 teeth T1–T12 (CHARTER-DELTA-1.md) plus the constructor-refusal checks.
;;;; Every tooth that plants a defect SHOWS the catch fire (prints the refusing
;;;; condition type).  Output mirrors kernel0-selftest: a final tally line and a
;;;; nonzero exit on any failure.
;;;;
;;;; Run: sbcl --non-interactive --load slice1-selftest.lisp

(handler-bind ((style-warning (lambda (w) (muffle-warning w))))
  (load (merge-pathnames "slice1.lisp" *load-truename*)))

(in-package #:lisp-plus-slice1)

(defvar *pass* 0)
(defvar *fail* 0)

(defun ok (name bool &optional detail)
  (if bool
      (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defmacro fires (name expected-type &body body)
  "Assert BODY signals a condition of EXPECTED-TYPE; PRINT the fired type."
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (ok ,name nil "no condition fired (expected a refusal)"))
       (,expected-type (,c)
         (ok ,name t (format nil "caught ~A" (type-of ,c))))
       (error (,c)
         (ok ,name nil (format nil "wrong condition: ~A" (type-of ,c)))))))

;;; ------------------------------------------------------------------
;;; Fixtures.

(defun sw (form &key (kind :observation) (source :signer))
  "A GROUND support witness for a structured proposition FORM."
  (lisp-plus-slice0:witness :for (proposition form) :mode :direct
                            :kind kind :source source))

(defun ctx-of (id &rest witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))

(defun assessment-for (receipt predicate)
  (find predicate (derivation-receipt-assessments receipt)
        :key (lambda (a) (second (premise-assessment-premise-pattern a)))))

;; The founding S3 schema: artifact admissibility for a receiver + purpose.
(defun install-dp ()
  (clear-schema-registry)
  (register-schema
   (judgment-schema
    :name :de-praemissis :version 1
    :conclusion (proposition-pattern
                 '(:predicate :admissible (:artifact (:var :art))
                   (:purpose (:var :pur)) (:receiver (:var :rcv))))
    :premises (list
               (proposition-pattern '(:predicate :digest-matches (:artifact (:var :art))))
               (proposition-pattern '(:predicate :signature-valid (:artifact (:var :art))))
               (proposition-pattern '(:predicate :receiver-recognizes-signer
                                      (:artifact (:var :art)) (:receiver (:var :rcv))))
               (proposition-pattern '(:predicate :provenance-admissible
                                      (:artifact (:var :art)) (:purpose (:var :pur))
                                      (:receiver (:var :rcv))))))))

(defun full-supports (&key (art "artifact-1") (rcv :receiver-a) (pur :production))
  (list (sw `(:predicate :digest-matches (:artifact ,art)))
        (sw `(:predicate :signature-valid (:artifact ,art)))
        (sw `(:predicate :receiver-recognizes-signer (:artifact ,art) (:receiver ,rcv)))
        (sw `(:predicate :provenance-admissible (:artifact ,art) (:purpose ,pur)
              (:receiver ,rcv)))))

(defun dp-conclusion (&key (art "artifact-1") (rcv :receiver-a) (pur :production))
  (proposition `(:predicate :admissible (:artifact ,art) (:purpose ,pur)
                 (:receiver ,rcv))))

;;; ==================================================================
(format t "~%== Slice /1 substrate teeth ==~%")

;;; ---- T1: role-order normalization ⇒ equal ----
(let ((a (proposition '(:predicate :p (:beta 2) (:alpha 1))))
      (b (proposition '(:predicate :p (:alpha 1) (:beta 2)))))
  (ok "T1 role-order normalization ⇒ equal"
      (and (structured-proposition= a b)
           (equal a '(:predicate :p (:alpha 1) (:beta 2)))))
  (ok "T1b normalization idempotent"
      (equal a (proposition a))))

;;; ---- T2: duplicate roles refuse ----
(fires "T2 duplicate roles refuse" malformed-structured-proposition
  (proposition '(:predicate :p (:a 1) (:a 2))))

;;; ---- T3: ground refuses raw (:var …); (:quoted-datum (:var :x)) accepted ----
(fires "T3 ground refuses raw (:var …)" malformed-structured-proposition
  (proposition '(:predicate :p (:a (:var :x)))))
(let ((q (proposition '(:predicate :p (:a (:quoted-datum (:var :x)))))))
  (ok "T3b (:quoted-datum (:var :x)) accepted as literal"
      (equal q '(:predicate :p (:a (:quoted-datum (:var :x)))))))

;;; ---- T4: pattern variables bind deterministically ----
(multiple-value-bind (status bindings)
    (%match-proposition
     (proposition-pattern-normal-form
      (proposition-pattern '(:predicate :sig (:artifact (:var :a)) (:key (:var :k)))))
     (proposition '(:predicate :sig (:artifact "a1") (:key "K1")))
     '())
  (ok "T4 pattern variables bind deterministically"
      (and (eq status :match)
           (equal (cdr (assoc :a bindings)) "a1")
           (equal (cdr (assoc :k bindings)) "K1"))
      (format nil "~S" bindings)))

;;; ---- T5: wrong artifact ⇒ :mismatched, not :ambiguous ----
(install-dp)
(let ((supports (list (sw '(:predicate :digest-matches (:artifact "artifact-2"))))))
  (fires "T5 wrong artifact refuses" derivation-refused
    (derive :schema-name :de-praemissis :schema-version 1
            :conclusion (dp-conclusion)
            :supports supports
            :receiver (apply #'ctx-of :ctx-a supports)))
  (handler-case
      (derive :schema-name :de-praemissis :schema-version 1
              :conclusion (dp-conclusion) :supports supports
              :receiver (apply #'ctx-of :ctx-a supports))
    (derivation-refused (c)
      (let ((a (assessment-for (slice1-condition-receipt c) :digest-matches)))
        (ok "T5b disposition is :mismatched (not :ambiguous)"
            (and (eq (premise-assessment-disposition a) :mismatched)
                 (not (eq (premise-assessment-disposition a) :ambiguous))
                 (equal (cdr (first (premise-assessment-mismatched-candidates a)))
                        '(:artifact)))
            (format nil "~A, conflicting roles ~S"
                    (premise-assessment-disposition a)
                    (cdr (first (premise-assessment-mismatched-candidates a)))))))))

;;; ---- T6: ambiguity CONSTRUCTIBLE and fires ----
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :two-keys :version 1
  :conclusion (proposition-pattern '(:predicate :admissible (:artifact (:var :art))))
  :premises (list (proposition-pattern
                   '(:predicate :signature-valid (:artifact (:var :art)) (:key (:var :key)))))
  :locals '(:key)))
(let* ((s1 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-1"))))
       (s2 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-2"))))
       (supports (list s1 s2))
       (ctx (ctx-of :ctx-a s1 s2)))
  (fires "T6 ambiguity fires" derivation-refused
    (derive :schema-name :two-keys :schema-version 1
            :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")))
            :supports supports :receiver ctx))
  (handler-case
      (derive :schema-name :two-keys :schema-version 1
              :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")))
              :supports supports :receiver ctx)
    (derivation-refused (c)
      (let ((a (assessment-for (slice1-condition-receipt c) :signature-valid)))
        (ok "T6b disposition :ambiguous with 2 distinct environments"
            (and (eq (premise-assessment-disposition a) :ambiguous)
                 (= 2 (length (premise-assessment-ambiguities a)))
                 (= 2 (length (premise-assessment-matching-accessible-supports a))))
            (format nil "envs=~S" (premise-assessment-ambiguities a)))))))

;;; ---- T7: exact accessible match not defeated by irrelevant mismatched ----
(install-dp)
(let* ((good (sw '(:predicate :digest-matches (:artifact "artifact-1"))))
       (irrelevant (sw '(:predicate :digest-matches (:artifact "artifact-9"))))
       (supports (append (list good irrelevant) (cdr (full-supports))))
       (ctx (apply #'ctx-of :ctx-a supports)))
  (handler-case
      (progn
        (derive :schema-name :de-praemissis :schema-version 1
                :conclusion (dp-conclusion) :supports supports :receiver ctx)
        (ok "T7 exact match survives irrelevant mismatched candidate" t "granted"))
    (derivation-refused (c)
      (declare (ignore c))
      (ok "T7 exact match survives irrelevant mismatched candidate" nil "refused"))))

;;; ---- T8: accessible support + refuting support ⇒ both preserved, refused ----
(install-dp)
(let* ((supports (append (full-supports)
                         (list (refutation
                                :refutes '(:predicate :provenance-admissible
                                           (:artifact "artifact-1") (:purpose :production)
                                           (:receiver :receiver-a))
                                :source :auditor))))
       (ctx (apply #'ctx-of :ctx-a (remove-if-not #'lisp-plus-slice0:witness-p supports))))
  (fires "T8 refuting support blocks" derivation-refused
    (derive :schema-name :de-praemissis :schema-version 1
            :conclusion (dp-conclusion) :supports supports :receiver ctx))
  (handler-case
      (derive :schema-name :de-praemissis :schema-version 1
              :conclusion (dp-conclusion) :supports supports :receiver ctx)
    (derivation-refused (c)
      (let ((a (assessment-for (slice1-condition-receipt c) :provenance-admissible)))
        (ok "T8b both positive AND refuting preserved; disposition :refuted"
            (and (eq (premise-assessment-disposition a) :refuted)
                 (premise-assessment-matching-accessible-supports a)
                 (premise-assessment-refuting-supports a)))))))

;;; ---- T9: inaccessible exact support ⇒ residue, not missing ----
(install-dp)
(let* ((supports (full-supports))
       ;; every support accessible EXCEPT signature-valid (omitted from ctx)
       (ctx (apply #'ctx-of :ctx-a
                   (remove-if (lambda (w) (eq (second (lisp-plus-slice0:witness-for w))
                                              :signature-valid))
                              supports))))
  (fires "T9 inaccessible support blocks" derivation-refused
    (derive :schema-name :de-praemissis :schema-version 1
            :conclusion (dp-conclusion) :supports supports :receiver ctx))
  (handler-case
      (derive :schema-name :de-praemissis :schema-version 1
              :conclusion (dp-conclusion) :supports supports :receiver ctx)
    (derivation-refused (c)
      (let ((a (assessment-for (slice1-condition-receipt c) :signature-valid)))
        (ok "T9b disposition :inaccessible (residue), NOT :missing"
            (and (eq (premise-assessment-disposition a) :inaccessible)
                 (premise-assessment-matching-inaccessible-supports a)
                 (null (premise-assessment-matching-accessible-supports a))))))))

;;; ---- T10: schema v1 cannot satisfy v2 (frozen admits gate) ----
(let* ((k1 (%schema-admit-kind :de-praemissis 1))
       (k2 (%schema-admit-kind :de-praemissis 2))
       (p (proposition '(:predicate :admissible (:artifact "artifact-1"))))
       (v2-proc (lisp-plus-slice0:promotion-procedure
                 :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                              :procedure-id (lisp-plus-kernel0:make-identity :procedure "v2")
                              :version 2 :judgment-class :semantic
                              :result-vocabulary '(:verified))
                 :admits (list (list :derivation k2))))
       (v1-witness (lisp-plus-slice0:witness :for p :mode :derivation :kind k1
                                             :source :deriver))
       (the-claim (lisp-plus-slice0:claim :proposition p :by :deriver)))
  (ok "T10a v1 and v2 admit-keys differ" (not (eq k1 k2))
      (format nil "~S vs ~S" k1 k2))
  (fires "T10 v1 derivation refused by v2-keyed procedure"
      lisp-plus-slice0:insufficient-support-kind
    (lisp-plus-slice0:raise the-claim :to :verified :per v2-proc
                            :considering (list v1-witness))))

;;; ---- T11: derivation for Q cannot support P (frozen proposition-match) ----
(let* ((k1 (%schema-admit-kind :de-praemissis 1))
       (q (proposition '(:predicate :admissible (:artifact "artifact-Q"))))
       (p (proposition '(:predicate :admissible (:artifact "artifact-P"))))
       (proc (lisp-plus-slice0:promotion-procedure
              :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                           :procedure-id (lisp-plus-kernel0:make-identity :procedure "pforp")
                           :version 1 :judgment-class :semantic
                           :result-vocabulary '(:verified))
              :admits (list (list :derivation k1))))
       (witness-for-q (lisp-plus-slice0:witness :for q :mode :derivation :kind k1
                                                :source :deriver))
       (claim-p (lisp-plus-slice0:claim :proposition p :by :deriver)))
  (fires "T11 derivation for Q cannot support P"
      lisp-plus-slice0:wrong-proposition-support
    (lisp-plus-slice0:raise claim-p :to :verified :per proc
                            :considering (list witness-for-q))))

;;; ---- T12: transmitted receipt → testimony, cannot masquerade as derivation ----
(install-dp)
(let* ((supports (full-supports))
       (ctx (apply #'ctx-of :ctx-a supports)))
  (multiple-value-bind (granted-claim receipt)
      (derive :schema-name :de-praemissis :schema-version 1
              :conclusion (dp-conclusion) :supports supports :receiver ctx)
    (ok "T12-setup full coherent discharge GRANTS (behavior 10)"
        (and (lisp-plus-slice0:claim-p granted-claim)
             (lisp-plus-slice0:claim-judgment granted-claim)
             (eq (derivation-receipt-decision receipt) :granted))
        "derivation minted a real Slice /0 promotion")
    ;; transport the receipt as testimony, then try to reuse it locally
    (let* ((testimony (transported-testimony receipt :context-a :context-a))
           (schema (resolve-schema :de-praemissis 1))
           (proc (%build-conclusion-procedure schema))
           (conclusion (dp-conclusion))
           (claim (lisp-plus-slice0:claim :proposition conclusion :by :attacker)))
      (ok "T12a transported testimony is :mode :testimony :kind :derivation-report"
          (and (eq (lisp-plus-slice0:witness-mode testimony) :testimony)
               (eq (lisp-plus-slice0:witness-kind testimony) :derivation-report)))
      (fires "T12 testimony cannot masquerade as local derivation (frozen gate)"
          lisp-plus-slice0:slice0-condition
        (lisp-plus-slice0:raise claim :to :verified :per proc
                                :considering (list testimony)
                                :receiver :context-a))
      ;; report WHICH frozen gate fired (do not assume)
      (handler-case
          (lisp-plus-slice0:raise claim :to :verified :per proc
                                  :considering (list testimony) :receiver :context-a)
        (lisp-plus-slice0:slice0-condition (c)
          (format t "       (T12 frozen refusal type: ~A)~%" (type-of c)))))))

;;; ==================================================================
;;; Constructor-refusal checks.
(format t "~%== Constructor-refusal checks ==~%")

;; duplicate role (also T2) — pattern path
(fires "pattern duplicate role refuses" malformed-structured-proposition
  (proposition-pattern '(:predicate :p (:a 1) (:a (:var :x)))))

;; undeclared variable in a schema premise
(fires "undeclared schema variable refuses" schema-construction-error
  (judgment-schema
   :name :bad :version 1
   :conclusion (proposition-pattern '(:predicate :c (:a (:var :art))))
   :premises (list (proposition-pattern '(:predicate :p (:a (:var :art)) (:b (:var :undeclared)))))))

;; schema-local appearing in the conclusion refuses
(fires "schema-local in conclusion refuses" schema-construction-error
  (judgment-schema
   :name :bad2 :version 1
   :conclusion (proposition-pattern '(:predicate :c (:k (:var :key))))
   :premises (list (proposition-pattern '(:predicate :p (:k (:var :key)))))
   :locals '(:key)))

;; unbound conclusion variable at derive time
(install-dp)
(fires "unbound conclusion variable refuses" unbound-conclusion-variable
  (derive :schema-name :de-praemissis :schema-version 1
          ;; conclusion missing :receiver — ?rcv cannot bind
          :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")
                                     (:purpose :production)))
          :supports (full-supports)))

;; duplicate DIFFERENT (name,version) registration refuses; identical is OK
(clear-schema-registry)
(let ((s1 (judgment-schema :name :dup :version 1
                           :conclusion (proposition-pattern '(:predicate :c (:a (:var :x))))
                           :premises (list (proposition-pattern '(:predicate :p (:a (:var :x)))))))
      (s2 (judgment-schema :name :dup :version 1
                           :conclusion (proposition-pattern '(:predicate :c (:a (:var :x))))
                           :premises (list (proposition-pattern '(:predicate :q (:a (:var :x))))))))
  (register-schema s1)
  (ok "identical re-registration is idempotent-OK"
      (judgment-schema-p (register-schema s1)))
  (fires "different schema, same (name,version) refuses" schema-registration-conflict
    (register-schema s2)))

;; resolve-schema on absent (name,version) refuses; no auto-latest
(fires "resolve-schema absent refuses" schema-not-found
  (resolve-schema :nonexistent 99))

;; backward compatibility: a structured proposition flows through Slice /0 claim
(ok "backward-compat: structured proposition is a lawful Slice /0 claim"
    (lisp-plus-slice0:claim-p
     (lisp-plus-slice0:claim :proposition (proposition '(:predicate :tests-passed
                                                         (:suite "suite-a") (:as-of 41)))
                             :by :ci)))

;; why on a derivation receipt renders from structured fields
(install-dp)
(handler-case
    (derive :schema-name :de-praemissis :schema-version 1
            :conclusion (dp-conclusion)
            :supports (list (sw '(:predicate :digest-matches (:artifact "artifact-1"))))
            :receiver (ctx-of :ctx-a))
  (derivation-refused (c)
    (let ((r (slice1-condition-receipt c)))
      (ok "why extractor accepts the derivation receipt" (eq (why r) r))
      (render-derivation-why r (make-string-output-stream))
      (ok "render-derivation-why runs from structured fields" t))))

;;; ==================================================================
(format t "~%slice1 selftest: ~D passed, ~D failed~%" *pass* *fail*)
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
