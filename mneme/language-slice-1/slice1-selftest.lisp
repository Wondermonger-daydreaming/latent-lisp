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
;;; Ownership teeth T18–T26 (AUDIT-1 continuation, Kimi B1/B2 confirmed by the
;;; chair's independent reproduction).  Two defect families:
;;;   B1 — MUTABLE LEAVES were shared with storage.  COPY-TREE copies conses and
;;;        shares every atom, but a Common Lisp STRING is a mutable atom, so a
;;;        caller-held (or reader-returned) string aliased straight into stored
;;;        propositions, patterns and granted receipts.  Cured by %COPY-VALUE
;;;        (COPY-TREE + COPY-SEQ at string leaves) at the one construction
;;;        chokepoint and at every structural egress reader.
;;;   B2 — the JUDGMENT-SCHEMA constructor retained the caller's :PREMISES /
;;;        :LOCALS / :UNIQUE-LOCALS list SPINES (`:read-only t` protects the
;;;        slot, not the list), so post-registration SETF on a caller-held cons
;;;        rewrote a registered schema — including erasing a declared uniqueness
;;;        constraint.  Cured by COPY-LIST at construction.
;;; Each tooth below FAILS against pre-repair semantics and PASSES after.
;;; DECLARED RESIDUAL — SHRUNK BY D2.  This once read: a (:quoted-datum …)
;;; payload that is neither a cons nor a string (vector, hash-table, struct,
;;; adjustable array) remains CALLER-OWNED.  %COPY-VALUE still does not detach
;;; such an object, but since D2 almost none can ARRIVE: a quoted payload must
;;; cross the kernel0 CD/0 codec boundary, and vectors, hash-tables and ordinary
;;; structs refuse at construction (teeth T28d/T28e).
;;; NOT SHRUNK TO ZERO — THE ONE SURVIVOR: a kernel0 DURABLE-IDENTITY is a
;;; registered canonicalization subject, so it is still a lawful quoted payload
;;; and is still undetached.  Benign for slot rewriting (all its slots are
;;; :read-only), and named here rather than rounded away (tooth T28k).
;;; Strings inside a quoted payload are still detached by %COPY-VALUE, as T22
;;; shows.  See the %COPY-VALUE ceiling note.
(format t "~%== Ownership teeth (AUDIT-1 continuation B1/B2) ==~%")

;;; ---- T18 caller string -> stored proposition ----
(let* ((s (copy-seq "alpha"))
       (p (proposition (list :predicate :p (list :r s)))))
  (setf (char s 0) #\Z)                                ; vandalize the caller's string
  (ok "T18 caller-held string leaf does not rewrite the stored proposition"
      (equal p '(:predicate :p (:r "alpha")))
      (format nil "stored = ~S" p)))

;;; ---- T19 caller string -> GRANTED receipt conclusion ----
(clear-schema-registry)
(register-schema
 (judgment-schema :name :t19 :version 1
   :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
   :premises (list (proposition-pattern '(:predicate :ev (:x (:var :x)))))))
(let* ((s (copy-seq "V1"))
       (w (sw (list :predicate :ev (list :x (copy-seq "V1"))))))
  (multiple-value-bind (claim r)
      (derive :schema-name :t19 :schema-version 1
              :conclusion (proposition (list :predicate :ok (list :x s)))
              :supports (list w) :receiver (ctx-of :ctx w))
    (declare (ignore claim))
    (setf (char s 0) #\Z)                              ; vandalize AFTER the grant
    (ok "T19 caller-held string does not rewrite a GRANTED receipt's conclusion"
        (equal (derivation-receipt-conclusion r) '(:predicate :ok (:x "V1")))
        (format nil "receipt conclusion = ~S" (derivation-receipt-conclusion r)))))

;;; ---- T20 reader-returned string -> storage (the defensive copy must be deep
;;;      enough to include the string leaves it hands out) ----
(let ((w (sw '(:predicate :ev (:x "V1")))))
  (multiple-value-bind (claim r)
      (derive :schema-name :t19 :schema-version 1
              :conclusion (proposition '(:predicate :ok (:x "V1")))
              :supports (list w) :receiver (ctx-of :ctx w))
    (declare (ignore claim))
    (let* ((returned (derivation-receipt-conclusion r))
           (leaf (second (assoc :x (cddr returned)))))
      (setf (char leaf 0) #\Q)                         ; vandalize the RETURNED leaf
      (ok "T20 mutating a reader-returned string leaf leaves the receipt UNCHANGED"
          (equal (derivation-receipt-conclusion r) '(:predicate :ok (:x "V1")))
          (format nil "receipt conclusion on re-read = ~S"
                  (derivation-receipt-conclusion r))))))

;;; ---- T21 ADJUSTABLE string at an ordinary leaf: the stored value's LENGTH
;;;      must not follow the caller's fill pointer ----
(let* ((a (make-array 3 :element-type 'character :adjustable t
                        :fill-pointer 3 :initial-contents '(#\a #\b #\c)))
       (p (proposition (list :predicate :p (list :r a)))))
  (setf (fill-pointer a) 1)                            ; shrink the caller's string
  (ok "T21 adjustable string leaf: stored value keeps its own length"
      (equal p '(:predicate :p (:r "abc")))
      (format nil "stored = ~S" p)))

;;; ---- T22 string inside a (:quoted-datum …) payload — the payload rides in the
;;;      cons tree, so its string leaves ARE detached (the cons-and-string part of
;;;      the declared ceiling, asserted; the non-cons/non-string part is not) ----
(let* ((s (copy-seq "inner"))
       (p (proposition (list :predicate :p (list :r (list :quoted-datum s))))))
  (setf (char s 0) #\Z)
  (ok "T22 string inside a quoted-datum payload is detached from the caller"
      (equal p '(:predicate :p (:r (:quoted-datum "inner"))))
      (format nil "stored = ~S" p)))

;;; ---- T23 :premises spine retained by the constructor ----
(clear-schema-registry)
(let* ((pat-a (proposition-pattern '(:predicate :ev-a (:x (:var :x)))))
       (pat-b (proposition-pattern '(:predicate :ev-b (:x (:var :x)))))
       (pl (list pat-a)))                              ; caller keeps this spine
  (register-schema
   (judgment-schema :name :t23 :version 1
     :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
     :premises pl))
  (setf (car pl) pat-b)                                ; vandalize post-registration
  (let ((head (second (proposition-pattern-normal-form
                       (first (judgment-schema-premises (resolve-schema :t23 1)))))))
    (ok "T23 :premises spine is snapshotted at construction (registry UNCHANGED)"
        (eq head :ev-a)
        (format nil "registered premise predicate = ~S" head))))

;;; ---- T24 :locals spine retained by the constructor ----
(clear-schema-registry)
(let* ((lo (list :tag))
       (schema (judgment-schema :name :t24 :version 1
                 :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
                 :premises (list (proposition-pattern
                                  '(:predicate :ev (:x (:var :x)) (:tag (:var :tag)))))
                 :locals lo)))
  (register-schema schema)
  (setf (car lo) :wiped)
  (ok "T24 :locals spine is snapshotted at construction (declaration UNCHANGED)"
      (equal (judgment-schema-locals (resolve-schema :t24 1)) '(:tag))
      (format nil "registered locals = ~S" (judgment-schema-locals (resolve-schema :t24 1)))))

;;; ---- T25 :unique-locals spine, and T25b its BEHAVIOURAL consequence: a
;;;      declared uniqueness constraint must still bite after caller vandalism ----
(clear-schema-registry)
(let* ((ul (list :tag))
       (schema (judgment-schema :name :t25 :version 1
                 :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
                 :premises (list (proposition-pattern
                                  '(:predicate :ev (:x (:var :x)) (:tag (:var :tag)))))
                 :locals '(:tag) :unique-locals ul)))
  (register-schema schema)
  (setf (car ul) :wiped)
  (ok "T25 :unique-locals spine is snapshotted at construction (declaration UNCHANGED)"
      (equal (judgment-schema-unique-locals (resolve-schema :t25 1)) '(:tag))
      (format nil "registered unique-locals = ~S"
              (judgment-schema-unique-locals (resolve-schema :t25 1))))
  (let ((e1 (sw '(:predicate :ev (:x "X1") (:tag "T1"))))
        (e2 (sw '(:predicate :ev (:x "X1") (:tag "T2")))))
    (handler-case
        (multiple-value-bind (claim r)
            (derive :schema-name :t25 :schema-version 1
                    :conclusion (proposition '(:predicate :ok (:x "X1")))
                    :supports (list e1 e2) :receiver (ctx-of :ctx e1 e2))
          (declare (ignore claim))
          (ok "T25b declared uniqueness still REFUSES after caller vandalism" nil
              (format nil "GRANTED instead — decision=~S conflicts=~S"
                      (derivation-receipt-decision r)
                      (derivation-receipt-uniqueness-conflicts r))))
      (derivation-refused (c)
        (let ((uc (derivation-receipt-uniqueness-conflicts (slice1-condition-receipt c))))
          (ok "T25b declared uniqueness still REFUSES after caller vandalism"
              (and uc (member :tag uc :key #'first) t)
              (format nil "refused; conflicts = ~S" uc)))))))

;;; ---- T26 the B2 residual: a STRING literal inside a premise PATTERN.  A spine
;;;      copy cannot reach it; only %COPY-VALUE at the construction chokepoint can ----
(clear-schema-registry)
(let* ((s (copy-seq "lit"))
       (pat (proposition-pattern (list :predicate :ev (list :x (list :var :x))
                                       (list :lit s)))))
  (register-schema
   (judgment-schema :name :t26 :version 1
     :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
     :premises (list pat)))
  (setf (char s 0) #\Z)
  (let ((nf (proposition-pattern-normal-form
             (first (judgment-schema-premises (resolve-schema :t26 1))))))
    (ok "T26 premise-pattern string literal is detached from the caller"
        (equal nf '(:predicate :ev (:lit "lit") (:x (:var :x))))
        (format nil "registered premise nf = ~S" nf))))

;;; ---- T27 (D1) the POST-THRESHOLD refusal carries a receipt.  The schema is
;;;      RESOLVED and the conclusion is already a lawful normal form; only the
;;;      BINDING failed.  That is a constructible derivation attempt, so
;;;      UNBOUND-CONCLUSION-VARIABLE must carry a derivation-receipt exactly as
;;;      DERIVATION-REFUSED does — and the receipt must be HONEST: :refused, the
;;;      resolved schema name/version, the lawful conclusion, the acting origin
;;;      context, and EMPTY assessment structure (no premise was assessed, so no
;;;      assessment, binding, environment, conflict, strongest-result or repair
;;;      option may be invented) ----
(clear-schema-registry)
(register-schema
 (judgment-schema
  :name :t27 :version 1
  :conclusion (proposition-pattern
               '(:predicate :ok (:x (:var :x)) (:y (:var :y))))
  :premises (list (proposition-pattern '(:predicate :ev (:x (:var :x)))))))
(let ((conclusion (proposition '(:predicate :ok (:x "A"))))   ; role :y absent
      (ctx (lisp-plus-slice0:receiver-context :context-id :ctx-t27
                                              :accessible-supports '())))
  (handler-case
      (progn (derive :schema-name :t27 :schema-version 1
                     :conclusion conclusion :supports '() :receiver ctx)
             (ok "T27 unbound-conclusion-variable carries a receipt" nil
                 "no condition fired (expected a refusal)"))
    (unbound-conclusion-variable (c)
      (let ((r (slice1-condition-receipt c)))
        (ok "T27a unbound-conclusion-variable carries a derivation-receipt"
            (derivation-receipt-p r)
            (format nil "receipt = ~S" r))
        (ok "T27b the receipt is honest for what is known at the threshold"
            (and (derivation-receipt-p r)
                 (eq (derivation-receipt-schema-name r) :t27)
                 (eql (derivation-receipt-schema-version r) 1)
                 (equal (derivation-receipt-conclusion r) conclusion)
                 (eq (derivation-receipt-decision r) :refused)
                 (null (derivation-receipt-assessments r))
                 (null (derivation-receipt-bindings r))
                 (null (derivation-receipt-complete-binding-environments r))
                 (null (derivation-receipt-uniqueness-conflicts r))
                 (null (derivation-receipt-strongest-lawful-result r))
                 (null (derivation-receipt-repair-options r))
                 (lisp-plus-kernel0:durable-identity-p
                  (derivation-receipt-identity r))
                 (eq (derivation-receipt-origin-context r) :ctx-t27))
            (and (derivation-receipt-p r)
                 (format nil "schema=(~S ~S) decision=~S assessments=~S ~
bindings=~S envs=~S conflicts=~S strongest=~S repairs=~S origin=~S"
                         (derivation-receipt-schema-name r)
                         (derivation-receipt-schema-version r)
                         (derivation-receipt-decision r)
                         (derivation-receipt-assessments r)
                         (derivation-receipt-bindings r)
                         (derivation-receipt-complete-binding-environments r)
                         (derivation-receipt-uniqueness-conflicts r)
                         (derivation-receipt-strongest-lawful-result r)
                         (derivation-receipt-repair-options r)
                         (derivation-receipt-origin-context r))))))))

;;; ---- T27c the three PRE-threshold exits still lawfully carry NO receipt.
;;;      A receipt there would be a fiction (no schema, or no lawful conclusion) ----
(clear-schema-registry)
(register-schema
 (judgment-schema :name :t27 :version 1
   :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
   :premises (list (proposition-pattern '(:predicate :ev (:x (:var :x)))))))
(let ((pre-threshold-receipts '()))
  ;; (1) pattern-used-as-ground — fires before schema resolution
  (handler-case
      (derive :schema-name :t27 :schema-version 1
              :conclusion (proposition-pattern '(:predicate :ok (:x (:var :x))))
              :supports '())
    (pattern-used-as-ground (c)
      (push (list :pattern-used-as-ground (slice1-condition-receipt c))
            pre-threshold-receipts)))
  ;; (2) schema-not-found — schema resolution FAILED
  (handler-case
      (derive :schema-name :t27-absent :schema-version 99
              :conclusion (proposition '(:predicate :ok (:x "A")))
              :supports '())
    (schema-not-found (c)
      (push (list :schema-not-found (slice1-condition-receipt c))
            pre-threshold-receipts)))
  ;; (3) malformed-structured-proposition — the conclusion never became lawful
  (handler-case
      (derive :schema-name :t27 :schema-version 1
              :conclusion '(:predicate :ok (:x 1.5d0))
              :supports '())
    (malformed-structured-proposition (c)
      (push (list :malformed-structured-proposition (slice1-condition-receipt c))
            pre-threshold-receipts)))
  (ok "T27c the three pre-threshold exits lawfully carry NO receipt"
      (and (= 3 (length pre-threshold-receipts))
           (every (lambda (e) (null (second e))) pre-threshold-receipts))
      (format nil "~S" pre-threshold-receipts)))

;;; ---- T28 (D2) a (:quoted-datum …) payload must be Canonical Datum /0.
;;;      The quoted escape protects literal data whose SHAPE would be read as a
;;;      variable; it is NOT a host-language escape hatch.  The check delegates
;;;      to the kernel0 codec boundary (REQUIRE-CANONICAL as a discard-result
;;;      probe), never to a local hand-written vocabulary ----
(format t "~%== D2 quoted-datum payload boundary ==~%")

;; BITE: a float behind the tag used to construct successfully; it must now refuse.
(fires "T28a (:quoted-datum 1.5) refuses — float is not CD/0"
       malformed-structured-proposition
  (proposition '(:predicate :p (:r (:quoted-datum 1.5d0)))))

;; The other classes the ruling names, each behind the tag.
(fires "T28b (:quoted-datum <bare symbol>) refuses"
       malformed-structured-proposition
  (proposition (list :predicate :p (list :r (list :quoted-datum 'foo)))))
(fires "T28c (:quoted-datum <dotted list>) refuses"
       malformed-structured-proposition
  (proposition (list :predicate :p (list :r (list :quoted-datum (cons :a :b))))))
(fires "T28d (:quoted-datum <host vector>) refuses"
       malformed-structured-proposition
  (proposition (list :predicate :p (list :r (list :quoted-datum (vector 1 2))))))
(fires "T28e (:quoted-datum <hash-table>) refuses"
       malformed-structured-proposition
  (proposition (list :predicate :p (list :r (list :quoted-datum (make-hash-table))))))
(fires "T28f (:quoted-datum \"\") refuses — empty string is not CD/0"
       malformed-structured-proposition
  (proposition (list :predicate :p (list :r (list :quoted-datum "")))))

;; The same boundary holds inside a PATTERN, not only in ground data.
(fires "T28g the boundary holds inside a proposition-pattern too"
       malformed-structured-proposition
  (proposition-pattern '(:predicate :p (:x (:var :x)) (:r (:quoted-datum 1.5d0)))))

;;; ---- T28h GUARD (passes BOTH pre- and post-repair, like T27c): Δ5's actual
;;;      purpose survives.  A proper list of keywords IS acceptable at the CD/0
;;;      boundary, so var-shaped literal data is still lawful behind the tag —
;;;      this is the check that would have caught a DATUM-P-based gate ----
(let ((q (proposition '(:predicate :p (:a (:quoted-datum (:var :x)))))))
  (ok "T28h GUARD (:quoted-datum (:var :x)) is STILL lawful after D2"
      (equal q '(:predicate :p (:a (:quoted-datum (:var :x)))))
      (format nil "constructed = ~S" q)))
(let ((q (proposition '(:predicate :p (:a (:quoted-datum :kw))
                        (:b (:quoted-datum 42))
                        (:c (:quoted-datum "s"))
                        (:d (:quoted-datum (:a :b :c)))))))
  (ok "T28i GUARD lawful CD/0 payloads (keyword, integer, string, list) still pass"
      (equal q '(:predicate :p (:a (:quoted-datum :kw)) (:b (:quoted-datum 42))
                 (:c (:quoted-datum "s")) (:d (:quoted-datum (:a :b :c)))))
      (format nil "constructed = ~S" q)))

;;; ---- T28k the boundary is the kernel0 CODEC's, not a "no structs" rule.  A
;;;      kernel0 DURABLE-IDENTITY is a REGISTERED canonicalization subject, so it
;;;      crosses and is a lawful quoted payload — while an ordinary host struct
;;;      does not and refuses.  Pinned so the rule is never restated as the
;;;      tidier-but-false "no struct may be a quoted payload" ----
(let ((id (lisp-plus-kernel0:make-identity :receipt "r-1")))
  (ok "T28k a kernel0 durable-identity payload is LAWFUL (it crosses the codec)"
      (handler-case
          (normal-form-p (proposition (list :predicate :p
                                            (list :r (list :quoted-datum id)))))
        (malformed-structured-proposition () nil))
      "registered canonicalization subject: durable-identity-p -> identity->datum"))
(fires "T28l an ORDINARY host struct payload refuses (it does not cross)"
       malformed-structured-proposition
  (proposition (list :predicate :p
                     (list :r (list :quoted-datum
                                    (proposition-pattern
                                     '(:predicate :q (:x (:var :x)))))))))

;; The payload is checked but NOT REWRITTEN — the probe discards its conversion.
(let* ((payload (list :a "b" 3))
       (q (proposition (list :predicate :p (list :r (list :quoted-datum payload))))))
  (ok "T28j the payload is checked, never converted — the literal survives verbatim"
      (equal q '(:predicate :p (:r (:quoted-datum (:a "b" 3)))))
      (format nil "stored = ~S" q)))

;;; ==================================================================
;;; T29 / T30 — the two SOL DESIGN RULING decisions (SLICE1-SOL-DESIGN-RULING-
;;; FORKS.md, adopted by the owner).  Every tooth below was run against the
;;; pre-patch slice1.lisp FIRST and reported a failure there; the verbatim
;;; bite-and-cure transcript is `_staging/catena-teeth-evidence.txt`.
;;;
;;;   DECISION 1 (T29a-j) — do not erase the identity of the conclusion when it
;;;                         becomes evidence.
;;;   DECISION 2 (T30a-h) — do not erase the plurality of the evidence when it
;;;                         becomes a conclusion.
;;; ==================================================================

(defmacro c-guarded (name &body body)
  "Run BODY; any escaping condition is a FAILURE reported with its type — so a
missing reader or a missing behaviour fails as loudly as a wrong value."
  (let ((c (gensym)))
    `(handler-case (progn ,@body)
       (error (,c) (ok ,name nil (format nil "~A: ~A" (type-of ,c) ,c))))))

(defun c-ctx (id &rest ids)
  "A receiver context over explicit durable ids (witness ids AND claim ids)."
  (lisp-plus-slice0:receiver-context :context-id id :accessible-supports ids))

(defun c-attempt (name version conclusion supports receiver)
  "(values RECEIPT CLAIM DECISION) — a derivation attempt that never escapes."
  (handler-case
      (multiple-value-bind (claim receipt)
          (derive :schema-name name :schema-version version
                  :conclusion conclusion :supports supports
                  :receiver receiver :by :registrar)
        (values receipt claim :granted))
    (derivation-refused (c) (values (slice1-condition-receipt c) nil :refused))))

(defun install-judged-claim-schemas ()
  (clear-schema-registry)
  ;; source: mints a governed :verified judgment on (:predicate :standing …)
  (register-schema
   (judgment-schema
    :name :j-source :version 1
    :conclusion (proposition-pattern
                 '(:predicate :standing (:who (:var :w)) (:authority (:var :a))))
    :premises (list (proposition-pattern
                     '(:predicate :dues-clear (:who (:var :w))
                       (:authority (:var :a)))))))
  ;; target: consumes the judged claim as premise support
  (register-schema
   (judgment-schema
    :name :j-target :version 1
    :conclusion (proposition-pattern '(:predicate :may-act (:who (:var :w))))
    :premises (list (proposition-pattern
                     '(:predicate :standing (:who (:var :w))
                       (:authority (:var :auth))))
                    (proposition-pattern
                     '(:predicate :in-good-order (:who (:var :w)))))
    :locals '(:auth)))
  ;; target-unique: same, with the authority local DECLARED UNIQUE
  (register-schema
   (judgment-schema
    :name :j-target-unique :version 1
    :conclusion (proposition-pattern '(:predicate :may-act (:who (:var :w))))
    :premises (list (proposition-pattern
                     '(:predicate :standing (:who (:var :w))
                       (:authority (:var :auth))))
                    (proposition-pattern
                     '(:predicate :in-good-order (:who (:var :w)))))
    :locals '(:auth) :unique-locals '(:auth))))

(defun granted-standing (who authority)
  "A REAL governed :verified judgment: derive it, hand back the raised claim."
  (let* ((w (sw `(:predicate :dues-clear (:who ,who) (:authority ,authority))))
         (ctx (c-ctx :ctx-source (lisp-plus-slice0:witness-id w))))
    (values (derive :schema-name :j-source :schema-version 1
                    :conclusion `(:predicate :standing (:who ,who)
                                  (:authority ,authority))
                    :supports (list w) :receiver ctx :by :registrar))))

(defun refuted-standing (who authority)
  "A REAL governed :refuted judgment through the frozen RAISE."
  (let* ((p (proposition `(:predicate :standing (:who ,who) (:authority ,authority))))
         (c (lisp-plus-slice0:claim :proposition p :by :registrar))
         (w (lisp-plus-slice0:witness :for p :mode :direct :kind :observation
                                      :source :auditor :polarity :refutes))
         (proc (lisp-plus-slice0:promotion-procedure
                :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                             :procedure-id (lisp-plus-kernel0:make-identity
                                            :procedure "teeth/standing-audit")
                             :version 1 :judgment-class :semantic
                             :result-vocabulary '(:verified :refuted))
                :admits '((:direct :observation)))))
    (values (lisp-plus-slice0:raise c :to :refuted :per proc
                                    :considering (list w) :receiver :ctx-source))))

(install-judged-claim-schemas)

;;; ---- T29a a VERIFIED judged claim DISCHARGES a matching ground premise ----
(c-guarded "T29a verified judged claim DISCHARGES a matching ground premise"
  (let* ((c (granted-standing "ann" :warden))
         (g (sw '(:predicate :in-good-order (:who "ann"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "ann")) (list c g) ctx)
      (declare (ignore claim))
      (ok "T29a verified judged claim DISCHARGES a matching ground premise"
          (and (eq decision :granted)
               (eq (premise-assessment-disposition (assessment-for r :standing))
                   :satisfied))
          (format nil "decision=~S standing=~S" decision
                  (premise-assessment-disposition (assessment-for r :standing)))))))

;;; ---- T29b a :REFUTED judged claim does NOT discharge, and is NAMED ----
(c-guarded "T29b a :REFUTED judged claim does NOT discharge (and is NAMED)"
  (let* ((c (refuted-standing "bea" :warden))
         (g (sw '(:predicate :in-good-order (:who "bea"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "bea")) (list c g) ctx)
      (declare (ignore claim))
      (let* ((a (assessment-for r :standing))
             (roster (premise-assessment-judged-claims a))
             (entry (first roster)))
        (ok "T29b a :REFUTED judged claim does NOT discharge (and is NAMED)"
            (and (eq decision :refused)
                 (eq (premise-assessment-disposition a) :missing)
                 (= 1 (length roster))
                 (eq (getf entry :outcome) :judgment-not-verified)
                 (eq (getf entry :judgment) :refuted))
            (format nil "decision=~S disposition=~S roster=~S" decision
                    (premise-assessment-disposition a)
                    (mapcar (lambda (e) (list (getf e :outcome) (getf e :judgment)))
                            roster)))))))

;;; ---- T29c an UNJUDGED claim does not discharge ----
(c-guarded "T29c an UNJUDGED claim does not discharge; roster says :UNJUDGED"
  (let* ((c (lisp-plus-slice0:claim
             :proposition (proposition '(:predicate :standing (:who "cyd")
                                         (:authority :warden)))
             :by :registrar))
         (g (sw '(:predicate :in-good-order (:who "cyd"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "cyd")) (list c g) ctx)
      (declare (ignore claim))
      (let* ((a (assessment-for r :standing))
             (entry (first (premise-assessment-judged-claims a))))
        (ok "T29c an UNJUDGED claim does not discharge; roster says :UNJUDGED"
            (and (eq decision :refused)
                 (eq (premise-assessment-disposition a) :missing)
                 (eq (getf entry :outcome) :unjudged))
            (format nil "decision=~S disposition=~S outcome=~S" decision
                    (premise-assessment-disposition a) (getf entry :outcome)))))))

;;; ---- T29d a claim whose JUDGMENT BASIS is not inspectable does not discharge.
;;;      PLANTED with the frozen internal constructors ON PURPOSE: the public
;;;      surface cannot mint a basis-less judgment (every RAISE stamps a
;;;      procedure-id), so without a plant this guard would never fire and would
;;;      be untested rather than passing ----
(c-guarded "T29d a claim with an UNINSPECTABLE judgment basis does not discharge"
  (let* ((p (proposition '(:predicate :standing (:who "dee") (:authority :warden))))
         (jr (lisp-plus-slice0::%make-judgment-record
              :judgment :verified :procedure-id nil :procedure-version 1
              :support-ids '() :receiver :ctx-t :ordinal 1))
         (c (lisp-plus-slice0::%make-claim
             :id (lisp-plus-kernel0:make-identity :claim "claim-basisless")
             :proposition p :commitment :asserted :asserted-by :registrar
             :judgment jr :lineage nil :ordinal 1))
         (g (sw '(:predicate :in-good-order (:who "dee"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "dee")) (list c g) ctx)
      (declare (ignore claim))
      (let* ((a (assessment-for r :standing))
             (entry (first (premise-assessment-judged-claims a))))
        (ok "T29d a claim with an UNINSPECTABLE judgment basis does not discharge"
            (and (eq decision :refused)
                 (eq (getf entry :outcome) :judgment-basis-unavailable))
            (format nil "decision=~S outcome=~S" decision (getf entry :outcome)))))))

;;; ---- T29e the receipt RECORDS the claim identity AND the judgment basis
;;;      (ruling condition 6) ----
(c-guarded "T29e the receipt RECORDS the supporting claim identity and judgment basis"
  (let* ((c (granted-standing "eve" :warden))
         (g (sw '(:predicate :in-good-order (:who "eve"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "eve")) (list c g) ctx)
      (declare (ignore claim decision))
      (let* ((a (assessment-for r :standing))
             (e (find :discharged (premise-assessment-judged-claims a)
                      :key (lambda (x) (getf x :outcome)))))
        (ok "T29e the receipt RECORDS the supporting claim identity and judgment basis"
            (and e
                 (lisp-plus-kernel0:identity= (getf e :claim-id)
                                              (lisp-plus-slice0:claim-id c))
                 (eq (getf e :judgment) :verified)
                 (lisp-plus-kernel0:durable-identity-p (getf e :procedure-id))
                 (getf e :procedure-version)
                 (getf e :support-ids))
            (format nil "claim-id=~A procedure=~A v~S supports=~D"
                    (and e (lisp-plus-kernel0:identity-key (getf e :claim-id)))
                    (and e (lisp-plus-kernel0:identity-key (getf e :procedure-id)))
                    (and e (getf e :procedure-version))
                    (length (and e (getf e :support-ids)))))))))

;;; ---- T29f a FABRICATED :direct witness restating the proposition inherits NO
;;;      judgment standing — the receipt distinguishes the two routes ----
(c-guarded "T29f a FABRICATED :direct witness inherits NO judgment standing"
  (let* ((fake (sw '(:predicate :standing (:who "fay") (:authority :warden))))
         (g (sw '(:predicate :in-good-order (:who "fay"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:witness-id fake)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "fay")) (list fake g) ctx)
      (declare (ignore claim))
      (let ((a (assessment-for r :standing)))
        (ok "T29f a FABRICATED :direct witness inherits NO judgment standing"
            (and (eq decision :granted)
                 (null (premise-assessment-judged-claims a))
                 (premise-assessment-matching-accessible-supports a))
            (format nil "granted by witness; judged-claim basis recorded=~S"
                    (premise-assessment-judged-claims a)))))))

;;; ---- T29g a verified claim the RECEIVER cannot reach is residue, not absence ----
(c-guarded "T29g a verified claim INACCESSIBLE to the receiver is residue, and is NAMED"
  (let* ((c (granted-standing "gus" :warden))
         (g (sw '(:predicate :in-good-order (:who "gus"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:witness-id g)))) ; claim id omitted
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "gus")) (list c g) ctx)
      (declare (ignore claim))
      (let* ((a (assessment-for r :standing))
             (entry (first (premise-assessment-judged-claims a))))
        (ok "T29g a verified claim INACCESSIBLE to the receiver is residue, and is NAMED"
            (and (eq decision :refused)
                 (eq (premise-assessment-disposition a) :inaccessible)
                 (eq (getf entry :outcome) :inaccessible-to-receiver))
            (format nil "disposition=~S outcome=~S"
                    (premise-assessment-disposition a) (getf entry :outcome)))))))

;;; ---- T29h a BARE PROPOSITION that merely unifies does not discharge ----
(c-guarded "T29h a BARE PROPOSITION that merely unifies does not discharge"
  (let* ((bare (proposition '(:predicate :standing (:who "hal") (:authority :warden))))
         (g (sw '(:predicate :in-good-order (:who "hal"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "hal")) (list bare g) ctx)
      (declare (ignore claim))
      (let ((a (assessment-for r :standing)))
        (ok "T29h a BARE PROPOSITION that merely unifies does not discharge"
            (and (eq decision :refused)
                 (eq (premise-assessment-disposition a) :missing)
                 (null (premise-assessment-judged-claims a)))
            (format nil "decision=~S disposition=~S" decision
                    (premise-assessment-disposition a)))))))

;;; ---- T29i declared uniqueness still governs a claim-discharged premise:
;;;      two verified claims disagreeing on a declared-unique local are
;;;      :AMBIGUOUS, never a grant ----
(c-guarded "T29i two verified claims conflicting on a DECLARED-UNIQUE local are :AMBIGUOUS"
  (let* ((c1 (granted-standing "ivy" :warden))
         (c2 (granted-standing "ivy" :treasurer))
         (g (sw '(:predicate :in-good-order (:who "ivy"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c1)
                     (lisp-plus-slice0:claim-id c2)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target-unique 1 '(:predicate :may-act (:who "ivy"))
                   (list c1 c2 g) ctx)
      (declare (ignore claim))
      (let ((a (assessment-for r :standing)))
        (ok "T29i two verified claims conflicting on a DECLARED-UNIQUE local are :AMBIGUOUS"
            (and (eq decision :refused)
                 (eq (premise-assessment-disposition a) :ambiguous)
                 (equal (mapcar #'first (derivation-receipt-uniqueness-conflicts r))
                        '(:auth)))
            (format nil "decision=~S disposition=~S conflicts=~S" decision
                    (premise-assessment-disposition a)
                    (mapcar #'first (derivation-receipt-uniqueness-conflicts r))))))))

;;; ---- T29j THE MISDIRECTION IS GONE.  The repair advice used to tell the
;;;      programmer to supply exactly what the programmer had supplied; it now
;;;      names the claim it saw and the reason it did not discharge ----
(c-guarded "T29j repair advice NAMES the seen-but-not-discharging claim"
  (let* ((c (refuted-standing "jan" :warden))
         (g (sw '(:predicate :in-good-order (:who "jan"))))
         (ctx (c-ctx :ctx-t (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r claim decision)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "jan")) (list c g) ctx)
      (declare (ignore claim decision))
      (let* ((ro (derivation-receipt-repair-options r))
             (repair (cdr (find :standing ro :key (lambda (e) (second (car e)))))))
        (ok "T29j repair advice NAMES the seen-but-not-discharging claim"
            (and repair (getf repair :judged-claims-seen-but-not-discharging))
            (format nil "repair=~S" repair))))))

;;; ==================================================================
;;; T30 — DECISION 2: the complete canonical set of grounding environments.
;;; TWO premises: the first MULTIPLIES the environment set on a non-unique
;;; local, so the SECOND is assessed under several complete environments — the
;;; exact site where the singular ground-instance was a traversal accident.
;;; :ZZZ is a conclusion variable and :AAA a declared local, so the DECLARED
;;; order (:ZZZ :AAA) is the REVERSE of host symbol-name order.
;;; ==================================================================

(defun install-g-mult ()
  (clear-schema-registry)
  (register-schema
   (judgment-schema
    :name :g-mult :version 1
    :conclusion (proposition-pattern '(:predicate :ok (:who (:var :zzz))))
    :premises (list (proposition-pattern
                     '(:predicate :tagged (:who (:var :zzz)) (:tag (:var :aaa))))
                    (proposition-pattern
                     '(:predicate :countersigned (:who (:var :zzz))
                       (:tag (:var :aaa)))))
    :locals '(:aaa))))

(defun g-run (tags &key (who "ann") (order :forward))
  (let* ((ws (append
              (mapcar (lambda (tg) (sw `(:predicate :tagged (:who ,who) (:tag ,tg))))
                      tags)
              (mapcar (lambda (tg) (sw `(:predicate :countersigned (:who ,who)
                                         (:tag ,tg))))
                      tags)))
         (sup (if (eq order :reverse) (reverse ws) ws))
         (ctx (apply #'c-ctx :ctx-g (mapcar #'lisp-plus-slice0:witness-id ws))))
    (c-attempt :g-mult 1 `(:predicate :ok (:who ,who)) sup ctx)))

(defun g-tags (receipt)
  (mapcar (lambda (i) (second (assoc :tag (cddr i))))
          (premise-assessment-ground-instances
           (assessment-for receipt :countersigned))))

(install-g-mult)

;;; ---- T30a two traversal orders produce the SAME canonical sequence ----
(c-guarded "T30a two support traversal orders produce the SAME canonical ground-instance sequence"
  (let ((ga (premise-assessment-ground-instances
             (assessment-for (g-run '("b" "ab")) :countersigned)))
        (gb (premise-assessment-ground-instances
             (assessment-for (g-run '("b" "ab") :order :reverse) :countersigned))))
    (ok "T30a two support traversal orders produce the SAME canonical ground-instance sequence"
        (and (equal ga gb) (= 2 (length ga)))
        (format nil "n=~D equal=~A" (length ga) (equal ga gb)))))

;;; ---- T30b two DISTINCT complete environments BOTH remain recorded ----
(c-guarded "T30b both distinct complete grounding environments REMAIN RECORDED"
  (let ((tags (g-tags (g-run '("b" "ab")))))
    (ok "T30b both distinct complete grounding environments REMAIN RECORDED"
        (and (= 2 (length tags))
             (member "b" tags :test #'equal)
             (member "ab" tags :test #'equal))
        (format nil "tags=~S" tags))))

;;; ---- T30c byte-identical environments DEDUPLICATE ----
(c-guarded "T30c byte-identical environments deduplicate to ONE canonical instance"
  (let ((tags (g-tags (g-run '("b" "b")))))
    (ok "T30c byte-identical environments deduplicate to ONE canonical instance"
        (equal tags '("b")) (format nil "tags=~S" tags))))

;;; ---- T30d the single-environment case stays straightforward ----
(c-guarded "T30d single environment: a plural set of ONE, and the singular projection returns it"
  (let* ((a (assessment-for (g-run '("b")) :countersigned))
         (g (premise-assessment-ground-instances a)))
    (ok "T30d single environment: a plural set of ONE, and the singular projection returns it"
        (and (= 1 (length g))
             (equal (premise-assessment-ground-instance a) (first g)))
        (format nil "n=~D singular=~S" (length g)
                (premise-assessment-ground-instance a)))))

;;; ---- T30e the singular projection NEVER selects from a plural set ----
(c-guarded "T30e the singular projection REFUSES above cardinality one (never selects)"
  (let ((a (assessment-for (g-run '("b" "ab")) :countersigned)))
    (handler-case
        (ok "T30e the singular projection REFUSES above cardinality one (never selects)"
            nil (format nil "it SELECTED ~S from a plural set"
                        (premise-assessment-ground-instance a)))
      (slice1-condition (c)
        (ok "T30e the singular projection REFUSES above cardinality one (never selects)"
            t (format nil "caught ~A" (type-of c)))))))

;;; ---- T30f the ordering is CANONICAL BYTES, not printed representation.
;;;      With tags "b" and "ab": PRINTED, ((:TAG . "ab")) sorts before
;;;      ((:TAG . "b")); by CANONICAL BYTES the string length varint decides and
;;;      "b" comes first.  The recorded order is the byte order ----
(c-guarded "T30f environments are ordered by CANONICAL BYTES, not printed representation"
  (let ((tags (g-tags (g-run '("ab" "b")))))
    (ok "T30f environments are ordered by CANONICAL BYTES, not printed representation"
        (equal tags '("b" "ab"))
        (format nil "byte order=~S ; printed order would be ~S" tags '("ab" "b")))))

;;; ---- T30g bindings WITHIN an environment follow DECLARED variable order ----
(c-guarded "T30g bindings within an environment follow DECLARED variable order"
  (let ((env (first (derivation-receipt-complete-binding-environments (g-run '("b"))))))
    (ok "T30g bindings within an environment follow DECLARED variable order"
        (equal (mapcar #'car env) '(:zzz :aaa))
        (format nil "order=~S (host symbol order would be ~S)"
                (mapcar #'car env) '(:aaa :zzz)))))

;;; ---- T30h decision AND the complete-environment set stay invariant under
;;;      traversal order (the Delta-2 M3 guarantee, re-pinned over the new
;;;      canonical ordering) ----
(c-guarded "T30h decision and complete-environment set stay invariant under traversal order"
  (multiple-value-bind (r-a claim-a d-a) (g-run '("b" "ab"))
    (declare (ignore claim-a))
    (multiple-value-bind (r-b claim-b d-b) (g-run '("b" "ab") :order :reverse)
      (declare (ignore claim-b))
      (ok "T30h decision and complete-environment set stay invariant under traversal order"
          (and (eq d-a d-b)
               (equal (derivation-receipt-complete-binding-environments r-a)
                      (derivation-receipt-complete-binding-environments r-b)))
          (format nil "decisions=~S/~S" d-a d-b)))))

;;; ==================================================================
;;; T31 — CHARTER-DELTA-3: the unsupported-support residue (R-SUPPORT-1).
;;;
;;; The defect these teeth kill: an element of :SUPPORTS that was none of the
;;; three recognized species fell through all three filters and VANISHED —
;;; through every public reader, supplying it was indistinguishable from
;;; supplying nothing, while a failed CLAIM was at least recorded.
;;;
;;; The line these teeth hold: the residue is VISIBLE and still INADMISSIBLE.
;;; Every arm asserts BOTH halves — the decision/disposition is exactly what the
;;; recognized species alone produce, AND the receipt says something was
;;; supplied.  NB: the real Core /0 effect account is exercised in
;;; de-bibliotheca-peregrina, NOT here — this suite must not acquire a
;;; dependency on Language Core /0, and the classifier must not have one either.

(install-judged-claim-schemas)          ; keeps :j-source / :j-target available
(register-schema
 (judgment-schema
  :name :u-residue :version 1
  :conclusion (proposition-pattern '(:predicate :concluded (:subject (:var :s))))
  :premises (list (proposition-pattern
                   '(:predicate :happened (:subject (:var :s)))))))

(defparameter *u-want* '(:predicate :happened (:subject :thing)))
(defparameter *u-goal* '(:predicate :concluded (:subject :thing)))

(defun u-run (supports &optional ctx)
  "(values RECEIPT DECISION DISPOSITION RESIDUE) for the one-premise schema."
  (multiple-value-bind (receipt claim decision)
      (c-attempt :u-residue 1 *u-goal* supports ctx)
    (declare (ignore claim))
    (values receipt decision
            (premise-assessment-disposition (assessment-for receipt :happened))
            (derivation-receipt-unsupported-supports receipt))))

(defun u-descriptors (&rest indices)
  (loop for i in indices
        collect (list :index i :reason :unsupported-support-species)))

(defun u-holds-p (tree object)
  "Does TREE hold OBJECT anywhere, by identity or by equality?  Used to prove the
receipt keeps NO handle on, and NO transcription of, an unsupported value."
  (cond ((eq tree object) t)
        ((equalp tree object) t)
        ((consp tree) (or (u-holds-p (car tree) object)
                          (u-holds-p (cdr tree) object)))
        (t nil)))

(defun u-render (receipt)
  (with-output-to-string (s) (render-derivation-why receipt s)))

;;; ---- U1 no supports at all: no residue, and nothing is invented ----
(c-guarded "U1 :supports NIL yields NO residue"
  (multiple-value-bind (r d disp res) (u-run '())
    (declare (ignore r))
    (ok "U1 :supports NIL yields NO residue"
        (and (null res) (eq d :refused) (eq disp :missing))
        (format nil "decision=~S disposition=~S residue=~S" d disp res))))

;;; ---- U2 one unsupported value ALONE: same disposition, residue at index 0.
;;;      This is the exact pair the defect made indistinguishable ----
(c-guarded "U2 an unsupported value alone: disposition still :MISSING, residue at index 0"
  (multiple-value-bind (r2 d2 disp2 res2) (u-run (list 17))
    (multiple-value-bind (r0 d0 disp0 res0) (u-run '())
      (ok "U2 an unsupported value alone: disposition still :MISSING, residue at index 0"
          (and (eq d2 :refused) (eq disp2 :missing)
               (equal res2 (u-descriptors 0))
               ;; the decision half is IDENTICAL to supplying nothing …
               (eq d2 d0) (eq disp2 disp0)
               ;; … and the receipts are no longer indistinguishable
               (not (equal res2 res0))
               ;; and no premise-level field acquired it
               (null (premise-assessment-judged-claims (assessment-for r2 :happened)))
               (null (premise-assessment-matching-accessible-supports
                      (assessment-for r2 :happened)))
               (null (premise-assessment-matching-inaccessible-supports
                      (assessment-for r2 :happened)))
               (null (premise-assessment-mismatched-candidates
                      (assessment-for r2 :happened)))
               (null (premise-assessment-refuting-supports
                      (assessment-for r2 :happened)))
               (equal (derivation-receipt-repair-options r2)
                      (derivation-receipt-repair-options r0)))
          (format nil "residue=~S vs nothing-supplied residue=~S" res2 res0)))))

;;; ---- U3 the classifier has NO species knowledge beyond the three admitted
;;;      ones.  Two unrelated unsupported values — a host integer and a Slice /1
;;;      JUDGMENT-SCHEMA, which is a first-class object of this very slice —
;;;      produce the SAME descriptor.  A value is residue because it is not one
;;;      of the three, never because the classifier recognized what it is.
;;;      (The real Core /0 effect account is exercised in the application, not
;;;      here: this suite takes no Core /0 dependency, and neither does the
;;;      classifier — there is no blacklist to test.) ----
(c-guarded "U3 unsupported species are not discriminated: unrelated values give the SAME descriptor"
  (let ((schema-object (resolve-schema :u-residue 1)))
    (multiple-value-bind (r-a d-a disp-a res-a) (u-run (list 17))
      (declare (ignore r-a))
      (multiple-value-bind (r-b d-b disp-b res-b) (u-run (list schema-object))
        (ok "U3 unsupported species are not discriminated: unrelated values give the SAME descriptor"
            (and (equal res-a res-b) (equal res-a (u-descriptors 0))
                 (eq d-a d-b) (eq disp-a disp-b)
                 ;; and the residue transcribes nothing about the object
                 (not (u-holds-p res-b schema-object))
                 (not (u-holds-p (derivation-receipt-unsupported-supports r-b)
                                 schema-object)))
            (format nil "integer=>~S schema-object=>~S" res-a res-b))))))

;;; ---- U4 a matching lawful witness + an unsupported value: the decision is
;;;      IDENTICAL to the witness alone, and the residue is visible ----
(c-guarded "U4 lawful witness + unsupported: identical decision, residue visible"
  (let* ((w (sw *u-want*))
         (ctx (ctx-of :u-ctx w)))
    (multiple-value-bind (r-w d-w disp-w res-w) (u-run (list w) ctx)
      (multiple-value-bind (r-b d-b disp-b res-b) (u-run (list w 17) ctx)
        (ok "U4 lawful witness + unsupported: identical decision, residue visible"
            (and (eq d-w :granted) (eq d-b :granted)
                 (eq disp-w :satisfied) (eq disp-b :satisfied)
                 (null res-w) (equal res-b (u-descriptors 1))
                 (equal (derivation-receipt-bindings r-w)
                        (derivation-receipt-bindings r-b))
                 (equal (derivation-receipt-complete-binding-environments r-w)
                        (derivation-receipt-complete-binding-environments r-b))
                 (eq (derivation-receipt-strongest-lawful-result r-w)
                     (derivation-receipt-strongest-lawful-result r-b))
                 (= (length (premise-assessment-matching-accessible-supports
                             (assessment-for r-b :happened)))
                    1))
            (format nil "~S/~S vs ~S/~S residue=~S" d-w disp-w d-b disp-b res-b))))))

;;; ---- U5 a matching VERIFIED judged claim + an unsupported value: the claim
;;;      still discharges, its identity and judgment basis are still inspectable,
;;;      and the residue is visible.  (Two-premise :J-TARGET, as T29a.) ----
(c-guarded "U5 judged claim + unsupported: still discharges, basis inspectable, residue visible"
  (let* ((c (granted-standing "ann" :warden))
         (g (sw '(:predicate :in-good-order (:who "ann"))))
         (ctx (c-ctx :u-ctx-5 (lisp-plus-slice0:claim-id c)
                     (lisp-plus-slice0:witness-id g))))
    (multiple-value-bind (r-a claim-a d-a)
        (c-attempt :j-target 1 '(:predicate :may-act (:who "ann"))
                   (list c g) ctx)
      (declare (ignore claim-a))
      (multiple-value-bind (r-b claim-b d-b)
          (c-attempt :j-target 1 '(:predicate :may-act (:who "ann"))
                     (list c 17 g) ctx)
        (declare (ignore claim-b))
        (let* ((a-b (assessment-for r-b :standing))
               (jc (first (premise-assessment-judged-claims a-b))))
          (ok "U5 judged claim + unsupported: still discharges, basis inspectable, residue visible"
              (and (eq d-a :granted) (eq d-b :granted)
                   (eq :satisfied (premise-assessment-disposition a-b))
                   (null (derivation-receipt-unsupported-supports r-a))
                   (equal (derivation-receipt-unsupported-supports r-b)
                          (u-descriptors 1))
                   ;; identity AND judgment basis still on the roster
                   jc (eq :discharged (getf jc :outcome))
                   (lisp-plus-kernel0:identity= (getf jc :claim-id)
                                                (lisp-plus-slice0:claim-id c))
                   (eq :verified (getf jc :judgment))
                   (getf jc :procedure-id)
                   ;; and the two receipts agree on everything but the residue
                   (equal (derivation-receipt-bindings r-a)
                          (derivation-receipt-bindings r-b)))
              (format nil "~S/~S outcome=~S residue=~S" d-a d-b
                      (and jc (getf jc :outcome))
                      (derivation-receipt-unsupported-supports r-b))))))))

;;; ---- U6 a matching refutation + an unsupported value: still :REFUTED, the
;;;      refuting support is still named, residue visible ----
(c-guarded "U6 refutation + unsupported: still :REFUTED, refuting support named, residue visible"
  (let ((ref (refutation :refutes *u-want* :source :auditor)))
    (multiple-value-bind (r-a d-a disp-a res-a) (u-run (list ref))
      (multiple-value-bind (r-b d-b disp-b res-b) (u-run (list ref 17))
        (ok "U6 refutation + unsupported: still :REFUTED, refuting support named, residue visible"
            (and (eq d-a :refused) (eq d-b :refused)
                 (eq disp-a :refuted) (eq disp-b :refuted)
                 (null res-a) (equal res-b (u-descriptors 1))
                 (= 1 (length (premise-assessment-refuting-supports
                               (assessment-for r-b :happened))))
                 (equal (derivation-receipt-strongest-lawful-result r-a)
                        (derivation-receipt-strongest-lawful-result r-b)))
            (format nil "~S/~S vs ~S/~S residue=~S" d-a disp-a d-b disp-b res-b))))))

;;; ---- U7 input order and duplicates: (uA witness uB uA) records 0, 2, 3 —
;;;      NO deduplication, NO reordering, and the witness's index is skipped ----
(c-guarded "U7 caller order preserved, duplicates NOT deduplicated"
  (let* ((w (sw *u-want*))
         (ctx (ctx-of :u-ctx-7 w))
         (u-a 17)
         (u-b :not-a-support))
    (multiple-value-bind (r d disp res) (u-run (list u-a w u-b u-a) ctx)
      (declare (ignore r))
      (ok "U7 caller order preserved, duplicates NOT deduplicated"
          (and (equal res (u-descriptors 0 2 3))
               (= 3 (length res))
               (eq d :granted) (eq disp :satisfied))
          (format nil "residue=~S (indices ~S)" res
                  (mapcar (lambda (u) (getf u :index)) res))))))

;;; ---- U8 NO RAW-OBJECT ALIAS.  Supply a MUTABLE unsupported object; mutate the
;;;      caller's own handle afterwards; the descriptors are unchanged, and the
;;;      receipt holds neither the object nor a transcription of it ----
(c-guarded "U8 no raw-object alias: mutating the supplied object cannot touch the receipt"
  (let* ((mutable (list :payload "before"))
         (receipt (u-run (list mutable)))
         (before (derivation-receipt-unsupported-supports receipt))
         (held-before (u-holds-p before mutable)))
    (setf (second mutable) "AFTER-MUTATION")
    (setf (car mutable) :clobbered)
    (let ((after (derivation-receipt-unsupported-supports receipt)))
      (ok "U8 no raw-object alias: mutating the supplied object cannot touch the receipt"
          (and (equal before (u-descriptors 0))
               (equal after before)
               (not held-before)
               (not (u-holds-p after mutable))
               (not (u-holds-p after "AFTER-MUTATION"))
               ;; the descriptor is EXACTLY the two declared keys, nothing else
               (= 4 (length (first after)))
               (eq :unsupported-support-species (getf (first after) :reason))
               (integerp (getf (first after) :index)))
          (format nil "before=~S after=~S" before after)))))

;;; ---- U9 DEFENSIVE EGRESS.  Clobber the returned list AND a returned plist; a
;;;      second read still returns the stored descriptors ----
(c-guarded "U9 defensive egress: a clobbered read cannot revise the stored receipt"
  (let* ((receipt (u-run (list 17 :also-unsupported)))
         (first-read (derivation-receipt-unsupported-supports receipt))
         (expected (u-descriptors 0 1)))
    (setf (getf (first first-read) :reason) :clobbered)
    (setf (getf (second first-read) :index) 999)
    (setf (cdr first-read) nil)
    (let ((second-read (derivation-receipt-unsupported-supports receipt)))
      (ok "U9 defensive egress: a clobbered read cannot revise the stored receipt"
          (and (equal second-read expected)
               (not (equal first-read second-read))
               ;; structurally equal across reads, and NOT the same conses
               (equal second-read (derivation-receipt-unsupported-supports receipt))
               (not (eq second-read (derivation-receipt-unsupported-supports receipt))))
          (format nil "clobbered=~S stored=~S" first-read second-read)))))

;;; ---- U10 recognized species are NEVER double-recorded as residue ----
(c-guarded "U10 recognized species are never double-recorded as residue"
  (let* ((w (sw *u-want*))
         (c (granted-standing "bo" :warden))
         (ref (refutation :refutes '(:predicate :unrelated (:subject :other))
                          :source :auditor))
         (ctx (ctx-of :u-ctx-10 w)))
    (multiple-value-bind (r d disp res) (u-run (list w ref c) ctx)
      (declare (ignore r))
      (ok "U10 recognized species are never double-recorded as residue"
          (and (null res) (eq d :granted) (eq disp :satisfied))
          (format nil "three recognized supports, residue=~S decision=~S" res d)))))

;;; ---- U11 the renderer reports indices ONLY when the stored reader is
;;;      nonempty — and reports them on GRANTED and REFUSED receipts alike ----
(c-guarded "U11 the renderer reports residue exactly when the stored reader is nonempty"
  (let* ((w (sw *u-want*))
         (ctx (ctx-of :u-ctx-11 w))
         (clean-refused (u-render (u-run '())))
         (clean-granted (u-render (u-run (list w) ctx)))
         (dirty-refused (u-render (u-run (list 17))))
         (dirty-granted (u-render (u-run (list w 17 :x) ctx))))
    (flet ((has (s sub) (search sub s)))
      (ok "U11 the renderer reports residue exactly when the stored reader is nonempty"
          (and (not (has clean-refused "unsupported supplied values"))
               (not (has clean-granted "unsupported supplied values"))
               (has dirty-refused "unsupported supplied values: 1")
               (has dirty-refused ":supports[0] — unsupported support species")
               ;; present on a GRANTED receipt too, with the caller's indices
               (has dirty-granted "unsupported supplied values: 2")
               (has dirty-granted ":supports[1] — unsupported support species")
               (has dirty-granted ":supports[2] — unsupported support species")
               ;; and it never prints the value or a host type
               (not (has dirty-refused "17")))
          (format nil "clean-granted-len=~D dirty-granted-len=~D"
                  (length clean-granted) (length dirty-granted))))))

;;; ---- U12 THE OLD BEHAVIOUR IS KILLED.  Simulate the pre-Delta-3
;;;      implementation exactly — the three independent filters, whose union was
;;;      a PROPER SUBSET of :SUPPORTS, and no residue — and show this cluster
;;;      FAILS on the exact disappearance defect: the unsupported-only arm
;;;      becomes indistinguishable from the nothing-supplied arm again.  Then
;;;      restore and show green.  A gate that has never fired is untested. ----
(c-guarded "U12 the pre-Delta-3 three-filter implementation FAILS these teeth (then restores green)"
  (let ((cured (symbol-function '%classify-supports))
        (disappeared nil) (restored nil))
    (unwind-protect
         (progn
           (setf (symbol-function '%classify-supports)
                 (lambda (supports)
                   ;; verbatim the old shape: three filters, everything outside
                   ;; their union silently dropped
                   (values (remove-if-not #'lisp-plus-slice0:witness-p supports)
                           (remove-if-not #'refutation-p supports)
                           (remove-if-not #'lisp-plus-slice0:claim-p supports)
                           nil)))
           (multiple-value-bind (r-u d-u disp-u res-u) (u-run (list 17))
             (multiple-value-bind (r-n d-n disp-n res-n) (u-run '())
               (setf disappeared
                     (list :residue-gone (null res-u)
                           :u2-would-fail (not (equal res-u (u-descriptors 0)))
                           :indistinguishable
                           (and (eq d-u d-n) (eq disp-u disp-n)
                                (equal res-u res-n)
                                (equal (derivation-receipt-repair-options r-u)
                                       (derivation-receipt-repair-options r-n))
                                (equal (u-render r-u) (u-render r-n)))
                           :u11-would-fail
                           (not (search "unsupported supplied values"
                                        (u-render r-u))))))))
      (setf (symbol-function '%classify-supports) cured))
    (multiple-value-bind (r-u d-u disp-u res-u) (u-run (list 17))
      (declare (ignore r-u))
      (setf restored (and (equal res-u (u-descriptors 0))
                          (eq d-u :refused) (eq disp-u :missing))))
    (ok "U12 the pre-Delta-3 three-filter implementation FAILS these teeth (then restores green)"
        (and (getf disappeared :residue-gone)
             (getf disappeared :u2-would-fail)
             (getf disappeared :indistinguishable)
             (getf disappeared :u11-would-fail)
             restored)
        (format nil "old=~S ; restored-green=~S" disappeared restored))))

;;; ==================================================================
(format t "~%slice1 selftest: ~D passed, ~D failed~%" *pass* *fail*)
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
