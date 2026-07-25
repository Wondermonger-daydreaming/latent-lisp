;;;; SMOKE-2.lisp — Slice /2 PUBLIC smoke program (the near-stranger's read).
;;;;
;;;; Mini-domain: A SEED VAULT DEPOSIT DESK.  A depositor's accession is
;;;; "lodged" only when two separate things hold: the vault accepted custody (a
;;;; standing the desk derives) AND the cryo transfer actually crossed into the
;;;; chamber (an EFFECT — and that is where Slice /1 stopped).
;;;;
;;;; Slice /2's whole contribution is the second premise.  The desk performs the
;;;; transfer, gets an issued Core /0 account back, and turns that account into a
;;;; SOURCE BASIS bound to the exact request it was performed for.  A premise
;;;; that demands a source basis cannot be discharged by a witness the desk
;;;; minted with its own hand, nor by that witness raised into a verified claim.
;;;;
;;;; WHAT THIS PROGRAM DOES NOT SHOW, stated first so nothing below is over-read:
;;;; that the transfer physically happened.  The adapter is a scripted fake.  A
;;;; source basis says the Core /0 runtime minted that exact account content in
;;;; THIS image for THAT request, and that the account REPORTS a field.  Whether
;;;; the world matches the account is not a question this language can ask.
;;;;
;;;; This program lives ENTIRELY on single-colon exported surfaces of
;;;; lisp-plus-slice2 / lisp-plus-core0 / lisp-plus-slice1 / lisp-plus-slice0 /
;;;; lisp-plus-kernel0.  It defines its OWN fixtures and copies no specimen
;;;; helper.  Ten numbered demonstrations, each under a pass/fail check.
;;;;
;;;; Run: sbcl --non-interactive --load SMOKE-2.lisp   (exit 0 on 10/10)

(unless (find-package :lisp-plus-slice2)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "slice2.lisp" *load-truename*))))
(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-core-0/fake-courier.lisp" *load-truename*))))

(defpackage #:slice2-public-smoke (:use #:cl))
(in-package #:slice2-public-smoke)

;;; ------------------------------------------------------------------
;;; Own fixtures — thin adapters over the public surface, for THIS domain.

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defparameter *accession* "SV-2026-0417")

(defun transfer-request (accession)
  "The exact request the desk performs, and the exact request a source basis
must be bound to.  The desk holds this; it never reads it back out of an
account, because no operation lets it."
  `(:predicate :deliver (:payload ,(format nil "cryo transfer / ~A" accession))))

(defun vault-key ()
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates '(:deliver))))

(defun perform-transfer (&key (script :clean-commit) (accession *accession*))
  "Cross the frontier for real, through Core /0, and keep the whole account."
  (multiple-value-bind (adapter world)
      (lisp-plus-fake-courier:make-fake-courier :script script)
    (declare (ignore world))
    (handler-case
        (nth-value 1 (lisp-plus-core0:perform
                      :adapter adapter :request (transfer-request accession)
                      :authority (vault-key)
                      :process (lisp-plus-core0:process-context
                                :label "seed-vault/cryo-transfer")))
      (lisp-plus-core0:core0-interrupted (c)
        (lisp-plus-core0:core0-condition-evidence c)))))

(defun at-the-vault (&rest supports)
  "The receiving position.  A source basis is reached by its SOURCE-BASIS
IDENTITY, a witness by its WITNESS-ID, a judged claim by its CLAIM-ID — one
membership rule read against three durable identities.  Nothing is ambiently
reachable."
  (lisp-plus-slice0:receiver-context
   :context-id :seed-vault
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice2:source-basis-p s)
                    (list (lisp-plus-slice2:source-basis-identity s)))
                   ((lisp-plus-slice0:witness-p s)
                    (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)
                    (list (lisp-plus-slice0:claim-id s)))))
           supports)))

(defun run/2 (schema conclusion supports)
  "DERIVE/2, recovering the receipt either way.  The desk needs this wrapper for
the same reason the lending desk needed one: DERIVE/2 SIGNALS on refusal, and
for a deposit desk refusal is not exceptional."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice2:derive/2 :schema schema :conclusion conclusion
                                     :supports supports
                                     :receiver (apply #'at-the-vault supports))
        (values receipt claim :granted))
    (lisp-plus-slice2:slice2-derivation-refused (c)
      (values (lisp-plus-slice2:slice2-condition-receipt c) nil :refused))))

(defun admission (receipt predicate)
  (find predicate (lisp-plus-slice2:slice2-receipt-admissions receipt)
        :key (lambda (a)
               (second (lisp-plus-slice2:premise-admission-premise-pattern a)))))

(defun disposition (receipt predicate)
  (lisp-plus-slice2:premise-admission-disposition (admission receipt predicate)))

;;; ------------------------------------------------------------------
;;; The two schemas.  THE SEPARATION IS THE DESIGN: one schema concludes
;;; something about the ACCOUNT; a second, domain schema takes that standing as
;;; a premise.  No relation ever produces :ACCESSION-LODGED (D2-0.6).

(defun install-schemas ()
  (lisp-plus-slice1:clear-schema-registry)
  ;; Schema 1 — from a generic account-report proposition to a DOMAIN standing
  ;; about the transfer account.  Note the conclusion's name: it is about the
  ;; ACCOUNT reporting a completed transfer, not about seeds being cold.
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :transfer-account-standing :version 1
    :conclusion (pp '(:predicate :transfer-account-reports-completion
                      (:accession (:var :accession))))
    :premises (list (pp '(:predicate :core0-account-reports-outcome
                          (:attempt (:var :attempt)) (:request (:var :request))
                          (:outcome :completed))))
    :locals '(:attempt :request)))
  ;; Schema 2 — the domain schema.  TWO premises, and they need DIFFERENT
  ;; contracts: custody acceptance is an ordinary judged claim; the transfer
  ;; premise must be source-bound.
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :lodging-standing :version 1
    :conclusion (pp '(:predicate :accession-lodged (:accession (:var :accession))))
    :premises (list (pp '(:predicate :custody-accepted
                          (:accession (:var :accession)) (:curator (:var :curator))))
                    (pp '(:predicate :transfer-account-reports-completion
                          (:accession (:var :accession)))))
    :locals '(:curator))))

;;; Contracts — data, named, inspectable.
(defun source-bound-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :cryo-transfer-source-bound
   :accepted-clauses
   '((:source-basis :relations (:core0-account-reports-outcome)))))

(defun custody-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :custody-by-direct-survey
   :accepted-clauses
   '((:asserted-witness :mode :direct :kind :custody-survey
      :truth-ceiling :asserted))))

(defun account-standing-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :transfer-standing-by-judgment
   :accepted-clauses '((:verified-judged-claim))))

(defun account-schema ()
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :transfer-account-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :transfer-account-standing 1)
   :premise-contracts (list (list 0 (source-bound-contract)))))

(defun lodging-schema ()
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :lodging-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :lodging-standing 1)
   :premise-contracts (list (list 0 (custody-contract))
                            (list 1 (account-standing-contract)))))

;;; ------------------------------------------------------------------
;;; Harness.
(defvar *passed* 0)
(defvar *failed* 0)
(defun check (n label bool)
  (if bool
      (progn (incf *passed*) (format t "  [~2D] PASS  ~A~%" n label))
      (progn (incf *failed*) (format t "  [~2D] FAIL  ~A~%" n label))))

(install-schemas)
(format t "== SMOKE-2 — Slice /2 public smoke: a seed vault deposit desk ==~%")

;;; (1) the contract is DATA a reader can inspect
(format t "~%(1) an admission contract is a value, not a closure~%")
(let ((c (source-bound-contract)))
  (format t "    clauses  ~S~%" (lisp-plus-slice2:support-admission-contract-accepted-clauses c))
  (format t "    ceilings ~S~%" (lisp-plus-slice2:support-admission-contract-truth-ceilings c))
  (check 1 "a contract carries inspectable clauses and a recorded truth ceiling per species"
         (and (lisp-plus-slice2:support-admission-contract-p c)
              (equal (lisp-plus-slice2:support-admission-contract-accepted-clauses c)
                     '((:source-basis :relations (:core0-account-reports-outcome))))
              (equal (lisp-plus-slice2:support-admission-contract-truth-ceilings c)
                     '((:source-basis . :current-image-issued-account-report))))))

;;; (2) contracts attach PER PREMISE, and the two differ in the same schema
(format t "~%(2) one schema, two premises, two different contracts~%")
(let ((s (lodging-schema)))
  (format t "    premise 0 -> ~S~%"
          (lisp-plus-slice2:support-admission-contract-contract-id
           (lisp-plus-slice2:slice2-schema-contract-for-premise s 0)))
  (format t "    premise 1 -> ~S~%"
          (lisp-plus-slice2:support-admission-contract-contract-id
           (lisp-plus-slice2:slice2-schema-contract-for-premise s 1)))
  (check 2 "each premise names its own contract; there is no schema-wide policy"
         (and (eq :custody-by-direct-survey
                  (lisp-plus-slice2:support-admission-contract-contract-id
                   (lisp-plus-slice2:slice2-schema-contract-for-premise s 0)))
              (eq :transfer-standing-by-judgment
                  (lisp-plus-slice2:support-admission-contract-contract-id
                   (lisp-plus-slice2:slice2-schema-contract-for-premise s 1))))))

;;; (3) a premise left without a contract REFUSES — no implicit default
(format t "~%(3) an uncontracted premise cannot exist~%")
(let ((refused
        (handler-case
            (progn (lisp-plus-slice2:make-slice2-schema
                    :schema-id :incomplete
                    :base-schema (lisp-plus-slice1:resolve-schema :lodging-standing 1)
                    :premise-contracts (list (list 0 (custody-contract))))
                   nil)
          (lisp-plus-slice2:premise-contract-missing (c) (declare (ignore c)) t))))
  (check 3 "omitting a premise's contract refuses with a typed condition, never a permissive default"
         refused))

;;; (4) the crossing, and the source basis bound to its exact request
(format t "~%(4) perform the transfer, then bind a source basis to the exact request~%")
(defparameter *account* (perform-transfer))
(defparameter *basis*
  (lisp-plus-slice2:establish-core0-source-basis
   :evidence *account* :request (transfer-request *accession*)
   :relation :core0-account-reports-outcome
   :expected-outcome :completed))
(format t "    account issued for this request  ~S~%"
        (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
         *account* (transfer-request *accession*)))
(format t "    the basis produces              ~S~%"
        (lisp-plus-slice2:source-basis-proposition *basis*))
(check 4 "a source basis binds an issued account, the exact request, one relation, one proposition and one ceiling"
       (and (lisp-plus-slice2:source-basis-p *basis*)
            (lisp-plus-slice2:source-basis-established-in-current-image-p *basis*)
            (eq :completed (lisp-plus-slice2:source-basis-account-outcome *basis*))
            (equal (lisp-plus-slice2:source-basis-request *basis*)
                   (np (transfer-request *accession*)))
            (eq :current-image-issued-account-report
                (lisp-plus-slice2:source-basis-truth-ceiling *basis*))))

;;; (5) the source-bound premise discharges, and the receipt says why
(format t "~%(5) the source-bound premise discharges~%")
(defparameter *account-standing* nil)
(multiple-value-bind (r claim decision)
    (run/2 (account-schema)
           (np `(:predicate :transfer-account-reports-completion
                 (:accession ,*accession*)))
           (list *basis*))
  (setf *account-standing* claim)
  (format t "    decision ~S ; premise ~S~%" decision
          (disposition r :core0-account-reports-outcome))
  (check 5 "a genuine source basis discharges the premise and the derivation grants"
         (and (eq decision :granted) claim
              (eq :satisfied (disposition r :core0-account-reports-outcome))
              (equal (list *basis*)
                     (lisp-plus-slice2:slice2-receipt-source-bases-used r)))))

;;; (6) a desk-minted witness for the SAME proposition is refused
(format t "~%(6) the desk mints its own witness for the same proposition~%")
(defparameter *self-minted*
  (lisp-plus-slice0:witness
   :for (lisp-plus-slice2:source-basis-proposition *basis*)
   :mode :direct :kind :chamber-ledger :source :seed-vault
   :procedure (lisp-plus-core0:core0-evidence-attempt-id *account*)
   :content (list :ledger-token
                  (lisp-plus-core0:core0-evidence-ledger-token *account*))))
(multiple-value-bind (r claim decision)
    (run/2 (account-schema)
           (np `(:predicate :transfer-account-reports-completion
                 (:accession ,*accession*)))
           (list *self-minted*))
  (declare (ignore claim))
  (let ((a (admission r :core0-account-reports-outcome)))
    (format t "    slice /1 said ~S ; slice /2 says ~S~%"
            (lisp-plus-slice2:premise-admission-base-disposition a)
            (lisp-plus-slice2:premise-admission-disposition a))
    (check 6 "a witness the desk minted — carrying the REAL attempt id and the REAL token — is recognized, NOT admitted, and refused"
           (and (eq decision :refused)
                (eq :not-admitted (lisp-plus-slice2:premise-admission-disposition a))
                (equal (list *self-minted*)
                       (lisp-plus-slice2:premise-admission-recognized-not-admitted a))
                ;; and the narrowing is visible: Slice /1 would have granted
                (eq :satisfied
                    (lisp-plus-slice2:premise-admission-base-disposition a))))))

;;; (7) the same witness RAISED into a genuinely :VERIFIED claim is still refused
(format t "~%(7) the same witness, raised the lawful way, is still not a source basis~%")
(defparameter *ledger-reading*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "seed-vault/read-the-chamber-ledger")
                :version 1 :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits '((:direct :chamber-ledger))))
(defparameter *raised*
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim
    :proposition (lisp-plus-slice2:source-basis-proposition *basis*)
    :by :seed-vault)
   :to :verified :per *ledger-reading* :considering (list *self-minted*)
   :receiver :seed-vault))
(multiple-value-bind (r claim decision)
    (run/2 (account-schema)
           (np `(:predicate :transfer-account-reports-completion
                 (:accession ,*accession*)))
           (list *raised*))
  (declare (ignore claim))
  (format t "    the claim really is ~S~%"
          (lisp-plus-slice0:judgment-record-judgment
           (lisp-plus-slice0:claim-judgment *raised*)))
  (check 7 "a genuinely :VERIFIED claim is NOT a source basis, and a source-bound premise refuses it"
         (and (eq decision :refused)
              (eq :verified (lisp-plus-slice0:judgment-record-judgment
                             (lisp-plus-slice0:claim-judgment *raised*)))
              (eq :not-admitted (disposition r :core0-account-reports-outcome)))))

;;; (8) an account this image never issued cannot become a basis at all
(format t "~%(8) the same account, asked about a request it was not performed for~%")
(let ((refused
        (handler-case
            (progn (lisp-plus-slice2:establish-core0-source-basis
                    :evidence *account* :request (transfer-request "SV-2026-9999")
                    :relation :core0-account-reports-outcome)
                   nil)
          (lisp-plus-slice2:unissued-core0-account (c) (declare (ignore c)) t))))
  (check 8 "a genuine issued account is refused a basis for a request it does not belong to"
         refused))

;;; (9) the domain schema takes the account standing as an ordinary premise
(format t "~%(9) the domain standing, derived separately, from the account standing~%")
(defparameter *custody*
  (lisp-plus-slice0:witness
   :for (np `(:predicate :custody-accepted (:accession ,*accession*)
              (:curator :vault-registrar)))
   :mode :direct :kind :custody-survey :source :vault-registrar))
(multiple-value-bind (r claim decision)
    (run/2 (lodging-schema)
           (np `(:predicate :accession-lodged (:accession ,*accession*)))
           (list *custody* *account-standing*))
  (format t "    decision ~S~%" decision)
  (format t "    ceilings ~S~%"
          (mapcar #'lisp-plus-slice2:premise-admission-truth-ceilings
                  (lisp-plus-slice2:slice2-receipt-admissions r)))
  (check 9 "the two premises discharge under DIFFERENT contracts — an asserted survey and a judged claim — and the lodging grants"
         (and (eq decision :granted) claim
              (eq :satisfied (disposition r :custody-accepted))
              (eq :satisfied (disposition r :transfer-account-reports-completion))
              (equal (mapcar #'lisp-plus-slice2:premise-admission-truth-ceilings
                             (lisp-plus-slice2:slice2-receipt-admissions r))
                     '(((:asserted-witness . :asserted))
                       ((:verified-judged-claim . :prior-governed-judgment)))))))

;;; (10) no relation reaches the domain proposition
(format t "~%(10) the boundary, computed rather than asserted~%")
(let* ((produced (mapcar (lambda (rel)
                           (second (lisp-plus-slice2:source-basis-proposition
                                    (lisp-plus-slice2:establish-core0-source-basis
                                     :evidence *account*
                                     :request (transfer-request *accession*)
                                     :relation rel))))
                         (lisp-plus-slice2:core0-source-relations))))
  (format t "    the three relations produce ~S~%" produced)
  (format t "    the domain conclusion is    ~S~%" :accession-lodged)
  (check 10 "no source relation produces the domain conclusion; the desk had to derive it through a second, explicit schema"
         (and (= 3 (length produced))
              (not (member :accession-lodged produced))
              (not (member :transfer-account-reports-completion produced))
              (every (lambda (p) (eql 0 (search "CORE0-ACCOUNT-" (symbol-name p))))
                     produced))))

;;; ------------------------------------------------------------------
(format t "~%slice2 public smoke: ~D/~D, ~D failed~%"
        *passed* (+ *passed* *failed*) *failed*)
(format t "(the accounts above are scripted fake adapters — a real governed ~
in-image act,~% never evidence that any external deed occurred)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *failed*) 0 1))
