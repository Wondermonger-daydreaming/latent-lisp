;;;; slice1-selftest.lisp — substrate teeth for Lisp+ Slice /1.
;;;;
;;;; Δ6 teeth T1–T12 (CHARTER-DELTA-1.md) plus the constructor-refusal checks,
;;;; plus AUDIT-1 mutation/aliasing teeth T13–T16 (defensive-copy breach F).
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

;;; ---- T6 (REVISED per CHARTER-DELTA-2): declared uniqueness ⇒ :ambiguous refusal ----
;;; SUPERSEDING WARRANT: CHARTER-DELTA-2 —
;;;   (:ambiguity :only-from-declared-uniqueness-constraint)
;;; The two-key plurality is ambiguity now ONLY because :key is DECLARED unique.
;;; Delta-1's "undeclared plurality ⇒ :ambiguous" is superseded: that case now
;;; GRANTS (see T6b).  Plurality is evidence; ambiguity begins only where the
;;; schema declared that a choice matters.
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :two-keys :version 1
  :conclusion (proposition-pattern '(:predicate :admissible (:artifact (:var :art))))
  :premises (list (proposition-pattern
                   '(:predicate :signature-valid (:artifact (:var :art)) (:key (:var :key)))))
  :locals '(:key) :unique-locals '(:key)))
(let* ((s1 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-1"))))
       (s2 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-2"))))
       (supports (list s1 s2))
       (ctx (ctx-of :ctx-a s1 s2)))
  (fires "T6 declared-unique :key conflict refuses :ambiguous" derivation-refused
    (derive :schema-name :two-keys :schema-version 1
            :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")))
            :supports supports :receiver ctx))
  (handler-case
      (derive :schema-name :two-keys :schema-version 1
              :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")))
              :supports supports :receiver ctx)
    (derivation-refused (c)
      (let* ((r (slice1-condition-receipt c))
             (a (assessment-for r :signature-valid))
             (uc (derivation-receipt-uniqueness-conflicts r)))
        (ok "T6-detail :key named as conflict, premise :ambiguous, BOTH envs preserved"
            (and (eq (derivation-receipt-decision r) :refused)
                 (eq (premise-assessment-disposition a) :ambiguous)
                 (= 1 (length uc))
                 (eq (first (first uc)) :key)
                 (= 2 (length (second (first uc))))   ; two surviving :key values
                 (= 2 (length (derivation-receipt-complete-binding-environments r)))
                 (= 2 (length (premise-assessment-matching-accessible-supports a))))
            (format nil "conflict=~S envs=~D" uc
                    (length (derivation-receipt-complete-binding-environments r))))))))

;;; ---- T6b (CHARTER-DELTA-2): SAME two supports, NO uniqueness declared ⇒ GRANT ----
;;; Warrant: CHARTER-DELTA-2 supersedes CHARTER-DELTA-1 — undeclared plurality is
;;; redundant sufficiency (grant, both environments preserved), NOT doubt.
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :two-keys-open :version 1
  :conclusion (proposition-pattern '(:predicate :admissible (:artifact (:var :art))))
  :premises (list (proposition-pattern
                   '(:predicate :signature-valid (:artifact (:var :art)) (:key (:var :key)))))
  :locals '(:key)))                    ; NO :unique-locals ⇒ existential
(let* ((s1 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-1"))))
       (s2 (sw '(:predicate :signature-valid (:artifact "artifact-1") (:key "KEY-2"))))
       (supports (list s1 s2))
       (ctx (ctx-of :ctx-a s1 s2)))
  (multiple-value-bind (claim receipt)
      (derive :schema-name :two-keys-open :schema-version 1
              :conclusion (proposition '(:predicate :admissible (:artifact "artifact-1")))
              :supports supports :receiver ctx)
    (ok "T6b undeclared plurality GRANTS with 2 complete environments (Delta-2)"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision receipt) :granted)
             (= 2 (length (derivation-receipt-complete-binding-environments receipt)))
             (derivation-receipt-multiply-supported-p receipt)
             (null (derivation-receipt-uniqueness-conflicts receipt)))
        (format nil "envs=~D multiply-supported=~S"
                (length (derivation-receipt-complete-binding-environments receipt))
                (derivation-receipt-multiply-supported-p receipt)))))

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
;;; Mutation / aliasing teeth (AUDIT-1 breach F: no defensive copies).
;;; Each must FAIL against pre-repair semantics and PASS after repairs 1–3.
(format t "~%== Mutation / aliasing teeth (AUDIT-1 F) ==~%")

;;; ---- T13 input-aliasing: a caller-held cons must not alias into a stored
;;;      schema premise (kills A7/A7b + input half of F1) ----
(clear-schema-registry)
(let* ((val-list (list 1 2 3))                       ; caller keeps this cons
       (prem-form (list :predicate :p (list :items val-list)))
       (pat (proposition-pattern prem-form))
       (concl (proposition-pattern '(:predicate :c (:a (:var :art)))))
       (schema (judgment-schema :name :alias-test :version 1
                                :conclusion concl :premises (list pat))))
  (register-schema schema)
  (setf (first val-list) :WIPED)                     ; vandalize the original
  (let ((stored (proposition-pattern-normal-form
                 (first (judgment-schema-premises (resolve-schema :alias-test 1))))))
    (ok "T13 input-aliasing: mutating caller list leaves stored premise UNCHANGED"
        (equal stored '(:predicate :p (:items (1 2 3))))
        (format nil "stored premise = ~S" stored))))

;;; ---- T14 registry-spine: mutating the list handed out by the premises
;;;      reader must not rewrite registry state (kills return half of F1) ----
(install-dp)
(let ((prem-list (judgment-schema-premises (resolve-schema :de-praemissis 1))))
  (setf (car prem-list) :WIPED)                      ; vandalize the returned spine
  (let ((stored (judgment-schema-premises (resolve-schema :de-praemissis 1))))
    (ok "T14 registry-spine: mutating returned premises list leaves registry UNCHANGED"
        (and (= 4 (length stored)) (proposition-pattern-p (first stored)))
        (format nil "first stored premise still a pattern: ~S"
                (proposition-pattern-p (first stored))))))

;;; ---- T15 receipt-immutability: a past receipt must not be silently rewritten
;;;      by whoever holds it (kills F2 — "recorded, never erased") ----
(install-dp)
(handler-case
    (derive :schema-name :de-praemissis :schema-version 1
            :conclusion (dp-conclusion)
            :supports (list (sw '(:predicate :digest-matches (:artifact "artifact-2"))))
            :receiver (ctx-of :ctx-a))
  (derivation-refused (c)
    (let* ((receipt (slice1-condition-receipt c))
           (asmts (derivation-receipt-assessments receipt))
           (len-before (length asmts)))
      (setf (car asmts) :WIPED)                       ; vandalize the returned list
      (let ((reread (derivation-receipt-assessments receipt)))
        (ok "T15 receipt-immutability: mutating returned assessments leaves the receipt UNCHANGED"
            (and (= len-before (length reread))
                 (premise-assessment-p (first reread)))
            (format nil "first assessment on re-read = ~S"
                    (if (premise-assessment-p (first reread))
                        (premise-assessment-disposition (first reread))
                        (first reread))))))))

;;; ---- T16 seam-idempotence: reloading slice1.lisp installs no duplicate
;;;      why-extractor (AUDIT-1 repair 3; the receipt's "single push" enforced) ----
;; RECEIPTED INTERNAL ACCESS — see SLICE0-DEFECT-RECEIPT-1.md; this check verifies
;; the receipted seam ITSELF (the sole other licensed :: in Slice /1's surface).
(let ((len-before (length lisp-plus-slice0::*why-extractors*)))
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "slice1.lisp" *load-truename*)))
  (let ((len-after (length lisp-plus-slice0::*why-extractors*)))
    (ok "T16 seam-idempotence: reload adds no duplicate extractor (total growth 0)"
        (= len-before len-after)
        (format nil "len before=~D after=~D" len-before len-after))))

;;; ---- T17 pattern-nf immutability: the fourth aliasing path (AUDIT-1 repair 2,
;;;      adjudication extension) — mutating the nf returned by the pattern reader
;;;      must not vandalize a registered schema ----
(let* ((cpat (proposition-pattern '(:predicate :t17c (:x (:var :x)))))
       (prem (proposition-pattern '(:predicate :t17p (:x (:var :x)))))
       (sch (judgment-schema :name :t17-probe :version 1
                             :conclusion cpat :premises (list prem) :locals '())))
  (register-schema sch)
  (let* ((resolved (resolve-schema :t17-probe 1))
         (nf (proposition-pattern-normal-form
              (first (judgment-schema-premises resolved)))))
    (setf (car nf) :VANDALIZED)                      ; vandalize the returned nf
    (let* ((renf (proposition-pattern-normal-form
                  (first (judgment-schema-premises (resolve-schema :t17-probe 1))))))
      (ok "T17 pattern-nf immutability: mutating returned normal-form leaves the registry UNCHANGED"
          (eq (car renf) :predicate)
          (format nil "stored nf head on re-read = ~S" (car renf))))))

;;; ==================================================================
;;; Multiplicity teeth (CHARTER-DELTA-2 M1–M12).  Plurality is evidence;
;;; ambiguity begins only at a declared uniqueness constraint.
(format t "~%== Multiplicity teeth (CHARTER-DELTA-2 M1–M12) ==~%")

;; A reusable non-unique two-support fixture: one premise binds schema-local
;; :tag; two supports for the SAME conclusion differ only in :tag ⇒ two complete
;; coherent environments.
(defun install-m (name unique-locals)
  (clear-schema-registry)
  (register-schema
   (judgment-schema
    :name name :version 1
    :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
    :premises (list (proposition-pattern
                     '(:predicate :evidence (:x (:var :x)) (:tag (:var :tag)))))
    :locals '(:tag) :unique-locals unique-locals)))
(defun m-concl () (proposition '(:predicate :ok (:x "X1"))))
(defun m-derive (name supports)
  (derive :schema-name name :schema-version 1 :conclusion (m-concl)
          :supports supports :receiver (apply #'ctx-of :ctx supports)))

;;; ---- M1: two sufficient NON-unique environments GRANT ----
(install-m :m1 '())
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2")))))
  (multiple-value-bind (claim r) (m-derive :m1 (list e1 e2))
    (ok "M1 two sufficient non-unique environments GRANT"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision r) :granted)
             (= 2 (length (derivation-receipt-complete-binding-environments r)))))))

;;; ---- M2: ALL sufficient environments are in the receipt ----
(install-m :m2 '())
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2")))))
  (multiple-value-bind (claim r) (m-derive :m2 (list e1 e2))
    (declare (ignore claim))
    (let* ((envs (derivation-receipt-complete-binding-environments r))
           (tags (sort (loop for e in envs collect (cdr (assoc :tag e)))
                       #'string<)))
      (ok "M2 all sufficient environments present in receipt"
          (equal tags '("T1" "T2"))
          (format nil "tags=~S" tags)))))

;;; ---- M3: support ORDER changes neither decision nor environment set ----
(install-m :m3 '())
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2")))))
  (multiple-value-bind (c-a r-a) (m-derive :m3 (list e1 e2))
    (declare (ignore c-a))
    (multiple-value-bind (c-b r-b) (m-derive :m3 (list e2 e1))
      (declare (ignore c-b))
      (ok "M3 support order changes neither decision nor environment set"
          (and (eq (derivation-receipt-decision r-a)
                   (derivation-receipt-decision r-b))
               (equal (derivation-receipt-complete-binding-environments r-a)
                      (derivation-receipt-complete-binding-environments r-b)))
          (format nil "envs-a=~S envs-b=~S"
                  (derivation-receipt-complete-binding-environments r-a)
                  (derivation-receipt-complete-binding-environments r-b))))))

;;; ---- M4: a DUPLICATE identical support does not invent a second derivation ----
(install-m :m4 '())
(let* ((e (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e-dup (sw '(:predicate :evidence (:x "X1") (:tag "T1")))))
  (multiple-value-bind (claim r) (m-derive :m4 (list e e-dup))
    (ok "M4 duplicate identical support ⇒ exactly ONE environment, still GRANT"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision r) :granted)
             (= 1 (length (derivation-receipt-complete-binding-environments r))))
        (format nil "envs=~D" (length (derivation-receipt-complete-binding-environments r))))))

;;; ---- M5: two DISTINCT supports yielding the SAME binding stay visible as
;;;      multiple supports WITHOUT becoming ambiguity (declared unique :tag) ----
(install-m :m5 '(:tag))
(let* ((e-a (sw '(:predicate :evidence (:x "X1") (:tag "T1")) :source :signer-a))
       (e-b (sw '(:predicate :evidence (:x "X1") (:tag "T1")) :source :signer-b)))
  (multiple-value-bind (claim r) (m-derive :m5 (list e-a e-b))
    (let ((a (assessment-for r :evidence)))
      (ok "M5 distinct supports, same binding ⇒ multiple supports visible, no ambiguity, GRANT"
          (and (lisp-plus-slice0:claim-p claim)
               (eq (derivation-receipt-decision r) :granted)
               (= 1 (length (derivation-receipt-complete-binding-environments r)))
               (= 2 (length (premise-assessment-matching-accessible-supports a)))
               (null (derivation-receipt-uniqueness-conflicts r)))
          (format nil "supports=~D envs=~D"
                  (length (premise-assessment-matching-accessible-supports a))
                  (length (derivation-receipt-complete-binding-environments r)))))))

;;; ---- M6: conflict on a DECLARED unique local REFUSES ----
(install-m :m6 '(:tag))
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2")))))
  (fires "M6 conflict on declared unique local REFUSES" derivation-refused
    (m-derive :m6 (list e1 e2))))

;;; ---- M7: conflict on a NON-unique local does NOT refuse ----
(install-m :m7 '())
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2")))))
  (multiple-value-bind (claim r) (m-derive :m7 (list e1 e2))
    (ok "M7 conflict on a non-unique local does NOT refuse (GRANT)"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision r) :granted)))))

;;; ---- M8: an undeclared local in :unique-locals refuses schema construction ----
(fires "M8 undeclared local in :unique-locals refuses construction" schema-construction-error
  (judgment-schema
   :name :m8 :version 1
   :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
   :premises (list (proposition-pattern '(:predicate :evidence (:x (:var :x)) (:tag (:var :tag)))))
   :locals '(:tag) :unique-locals '(:not-a-local)))

;;; ---- M9: mutating the unique-locals reader list cannot revise registered behavior ----
(install-m :m9 '(:tag))
(let* ((resolved (resolve-schema :m9 1))
       (decl (judgment-schema-unique-locals resolved)))
  (setf (car decl) :WIPED)                        ; vandalize the returned list
  (let* ((reread (judgment-schema-unique-locals (resolve-schema :m9 1)))
         (e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
         (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2"))))
         (still-refuses
           (handler-case (progn (m-derive :m9 (list e1 e2)) nil)
             (derivation-refused (c) (declare (ignore c)) t))))
    (ok "M9 mutating unique-locals reader cannot revise registered behavior"
        (and (equal reread '(:tag)) still-refuses)
        (format nil "reread=~S still-refuses=~S" reread still-refuses))))

;;; ---- M10: a hidden prose-only incompatibility is NOT inferred (Case C as a tooth) ----
(install-m :m10 '())                              ; no uniqueness declared
(let* ((e-vendor (sw '(:predicate :evidence (:x "X1") (:tag "vendor"))))
       (e-self   (sw '(:predicate :evidence (:x "X1") (:tag "self-signed")))))
  (multiple-value-bind (claim r) (m-derive :m10 (list e-vendor e-self))
    (ok "M10 prose-incompatible names ('vendor' vs 'self-signed') NOT inferred ⇒ GRANT + both envs"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision r) :granted)
             (= 2 (length (derivation-receipt-complete-binding-environments r)))
             (null (derivation-receipt-uniqueness-conflicts r))))))

;;; ---- M11: refutation still blocks even WITH a complete positive environment ----
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :m11 :version 1
  :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
  :premises (list (proposition-pattern '(:predicate :evidence (:x (:var :x)))))))
(let* ((good (sw '(:predicate :evidence (:x "X1"))))
       (ref (refutation :refutes '(:predicate :evidence (:x "X1")) :source :auditor))
       (supports (list good ref)))
  (fires "M11 refutation blocks even with a complete positive environment" derivation-refused
    (derive :schema-name :m11 :schema-version 1 :conclusion (m-concl)
            :supports supports
            :receiver (apply #'ctx-of :ctx (remove-if-not #'lisp-plus-slice0:witness-p supports))))
  (handler-case
      (derive :schema-name :m11 :schema-version 1 :conclusion (m-concl)
              :supports supports
              :receiver (apply #'ctx-of :ctx (remove-if-not #'lisp-plus-slice0:witness-p supports)))
    (derivation-refused (c)
      (let* ((r (slice1-condition-receipt c))
             (a (assessment-for r :evidence)))
        (ok "M11-detail :refuted disposition, positive support present, complete env existed"
            (and (eq (premise-assessment-disposition a) :refuted)
                 (premise-assessment-matching-accessible-supports a)
                 (premise-assessment-refuting-supports a)
                 (>= (length (derivation-receipt-complete-binding-environments r)) 1))
            (format nil "complete-envs=~D"
                    (length (derivation-receipt-complete-binding-environments r))))))))

;;; ---- M12: an incomplete environment for one candidate does not defeat a complete one ----
;;; premise1 binds :tag two ways (T1, T2); premise2 (:confirm) exists ONLY for T1,
;;; so the T2 branch is incomplete.  Even with :tag DECLARED unique, the surviving
;;; complete environment is single ⇒ no conflict ⇒ GRANT.
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :m12 :version 1
  :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
  :premises (list (proposition-pattern '(:predicate :evidence (:x (:var :x)) (:tag (:var :tag))))
                  (proposition-pattern '(:predicate :confirm (:x (:var :x)) (:tag (:var :tag)))))
  :locals '(:tag) :unique-locals '(:tag)))
(let* ((e1 (sw '(:predicate :evidence (:x "X1") (:tag "T1"))))
       (e2 (sw '(:predicate :evidence (:x "X1") (:tag "T2"))))
       (c1 (sw '(:predicate :confirm (:x "X1") (:tag "T1"))))   ; only T1 confirmed
       (supports (list e1 e2 c1)))
  (multiple-value-bind (claim r)
      (derive :schema-name :m12 :schema-version 1 :conclusion (m-concl)
              :supports supports :receiver (apply #'ctx-of :ctx supports))
    (ok "M12 incomplete T2 branch does not defeat the complete T1 environment ⇒ GRANT, 1 env, no conflict"
        (and (lisp-plus-slice0:claim-p claim)
             (eq (derivation-receipt-decision r) :granted)
             (= 1 (length (derivation-receipt-complete-binding-environments r)))
             (null (derivation-receipt-uniqueness-conflicts r)))
        (format nil "envs=~D" (length (derivation-receipt-complete-binding-environments r))))))

;;; ==================================================================
(format t "~%slice1 selftest: ~D passed, ~D failed~%" *pass* *fail*)
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
