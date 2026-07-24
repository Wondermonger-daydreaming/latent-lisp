;;;; core0.lisp — Lisp+ Language Core /0 substrate: the smallest effectful seam.
;;;;
;;;; Governed by LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER.md (this directory,
;;;; INCLUDING AMENDMENT 1) + LANGUAGE-SLICES-0-1-SYNTHESIS.md §3 (the lowering
;;;; contract) + OWNER-RULING-TWO-DOORS-EVIDENCE-TEST.md (the two-door ruling).
;;;; Slice /0, Slice /1, and kernel0 are FROZEN dependencies — loaded, never
;;;; edited.  Public working forms (names provisional, earned by specimen only,
;;;; work-order §2):
;;;;   (process-context :label …)         — execution-standing context (Amendment-1
;;;;                                         name; NOT consequence-context)
;;;;   (fixture-sealed-ruling …)          — a deterministic fake sealed ruling
;;;;   (mint-capability :ruling …)        — mint the live opaque capability
;;;;   (perform :adapter :request          — the ONE new governed effect-capable act
;;;;            :authority :process)
;;;;   (outcome-kind OUTCOME)             — the three-way VIEW over a perform outcome
;;;;   (continue-from EVIDENCE …)         — in-image continuation over evidence
;;;;   (why OBJECT) (render-core0-why …)  — the uniform explanation door
;;;;
;;;; DISCIPLINE.  All greens produced by this substrate are SELF-CONSISTENCY
;;;; CERTIFICATION, never independent conformance (AP0 §24.1).  Nothing here
;;;; relies on PJ0, claims durability across process death, or claims AP0
;;;; conformance: the fake adapter is a labeled scripted subset, and every
;;;; event sequence is an in-memory kernel0 object.  The two doors share ONE
;;;; substrate (identity, CD/0 boundary, the `why` registry, the refusal/repair
;;;; grammar, the no-boolean law); they are NOT unified by any outcome
;;;; projection (derive's decision stays binary; perform's view stays three-way).
;;;;
;;;; House style inherited from slice0/slice1: typed condition hierarchy in the
;;;; live SIGNALLING path (never an inert condition initializer — the kernel0
;;;; defect-receipt lesson), read-only defstructs with (:copier nil) and
;;;; copy-disciplined public readers, %-prefixed internals, receipts on every
;;;; path, NO boolean success anywhere, NO bare manifestation value ever.

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../language-slice-1/slice1.lisp" *load-truename*))))

(defpackage #:lisp-plus-core0
  (:use #:cl)
  (:export
   ;; execution-standing context (Amendment 1: process-context, not consequence-)
   #:process-context #:process-context-p
   #:process-context-process-id #:process-context-logical-operation-id
   #:process-context-seat-id #:process-context-label
   ;; the minimal capability model
   #:fixture-sealed-ruling #:fixture-sealed-ruling-p
   #:mint-capability #:capability #:capability-p
   #:capability-scope #:capability-mint-receipt-of
   ;; the governed act + its view + continuation
   #:perform #:outcome-kind #:continue-from
   ;; adapter protocol (the fake lives in lisp-plus-fake-courier)
   #:core0-adapter #:core0-adapter-p #:core0-adapter-identity
   #:core0-adapter-version #:core0-adapter-name #:make-adapter
   #:register-adapter #:resolve-adapter
   ;; evidence + reconciliation result
   #:core0-evidence #:core0-evidence-p
   #:core0-evidence-process #:core0-evidence-attempt-id #:core0-evidence-seat-id
   #:core0-evidence-adapter-identity #:core0-evidence-events
   #:core0-evidence-manifestation #:core0-evidence-ledger-token
   #:core0-evidence-reconciliation-receipts #:core0-evidence-refusal-reason
   #:continuation-result #:continuation-result-p
   #:continuation-result-disposition #:continuation-result-standing
   #:continuation-result-reconciliation-receipt #:continuation-result-evidence
   #:continuation-result-required-action
   ;; explanation
   #:why #:render-core0-why
   ;; conditions
   #:core0-condition #:core0-condition-failed-invariant
   #:core0-condition-offending-field #:core0-condition-offending-value
   #:core0-condition-evidence #:core0-condition-outcome
   #:core0-refused #:unknown-adapter #:malformed-request
   #:capability-scope-violation #:ambient-authority-forbidden
   #:core0-interrupted #:blind-retry-refused
   #:signal-core0 #:with-core0-restarts))

(in-package #:lisp-plus-core0)

;;; ==================================================================
;;; Deterministic ordinal (constitutive order; no wall clock — slice0 §4).

(defvar *core0-ordinal* 0)
(defun %next-ordinal () (incf *core0-ordinal*))

(defun %k-id (domain name) (lisp-plus-kernel0:make-identity domain name))

(defun %proper-list-p (x)
  (and (listp x)
       (loop for tail = x then (cdr tail)
             while (consp tail) finally (return (null tail)))))

;;; ==================================================================
;;; Condition layer — PARALLEL to slice0/slice1 (mirrors their style; NOT a
;;; kernel0-condition subtype, whose restart whitelist is kernel-internal).
;;; ALL contract enforcement lives in SIGNAL-CORE0 and WITH-CORE0-RESTARTS —
;;; never in a condition initializer (inert under SBCL 2.4.6's MAKE-CONDITION;
;;; the kernel0 defect-receipt lesson is law here).  Every refusal is typed,
;;; carries the offending field/value, the evidence-so-far, and — for a
;;; pre-frontier refusal — a refused OUTCOME whose view is :refused.

(define-condition core0-condition (error)
  ((failed-invariant :initarg :failed-invariant
                     :reader core0-condition-failed-invariant)
   (offending-field :initarg :offending-field :initform nil
                    :reader core0-condition-offending-field)
   (offending-value :initarg :offending-value :initform nil
                    :reader core0-condition-offending-value)
   (evidence :initarg :evidence :initform nil
             :reader core0-condition-evidence)
   (outcome :initarg :outcome :initform nil
            :reader core0-condition-outcome))
  (:report (lambda (c stream)
             (format stream "~A: ~A"
                     (type-of c) (core0-condition-failed-invariant c)))))

(macrolet ((families (base &rest names)
             `(progn ,@(loop for n in names
                             collect `(define-condition ,n (,base) ())))))
  ;; pre-frontier refusals (execution :refused, no frontier-crossed event)
  (families core0-condition core0-refused core0-interrupted blind-retry-refused)
  (families core0-refused unknown-adapter malformed-request
            capability-scope-violation ambient-authority-forbidden))

(defun signal-core0 (condition-type &rest initargs
                     &key failed-invariant &allow-other-keys)
  "The one live core0 signalling path.  FAILED-INVARIANT must be a non-empty
string; CONDITION-TYPE must be a core0-condition subtype.  (All contract
enforcement lives here, not in an INITIALIZE-INSTANCE guard — such guards are
inert under SBCL 2.4.6's MAKE-CONDITION, as slice0/kernel0 record.)"
  (unless (and (stringp failed-invariant) (plusp (length failed-invariant)))
    (error "core0 condition contract: FAILED-INVARIANT must be a non-empty string"))
  (unless (and (symbolp condition-type) (subtypep condition-type 'core0-condition))
    (error "core0 condition contract: ~S is not a core0-condition" condition-type))
  (error (apply #'make-condition condition-type initargs)))

;;; The restart whitelist — homologous to slice0's §9 / kernel0's §20.9.
;;; Enforced at macroexpansion time (the one place a whitelist can gate before
;;; a program runs), never in an inert initializer.  These are the lawful
;;; consequential repairs; CONTINUE-ANYWAY and blind RETRY are not expressible.
(defparameter *core0-restart-names*
  '(begin-reconciliation
    authorize-supersession
    abandon-uncertain-effect
    stop-and-export-evidence))

(defun %core0-restart-name-p (name)
  (member name *core0-restart-names* :test #'eq))

(defmacro with-core0-restarts (clauses &body body)
  "RESTART-CASE limited to the lawful core0 consequential-repair names.  A
blind retry, a CONTINUE-ANYWAY, or an arbitrary standing assignment cannot be
expressed through this vocabulary by a well-formed program.  The whitelist is
package state (surface discipline, not host closure), gated at macroexpansion."
  (dolist (clause clauses)
    (unless (and (consp clause) (%core0-restart-name-p (car clause)))
      (error "core0 restart clause not permitted (see *core0-restart-names*): ~S"
             clause)))
  `(restart-case (progn ,@body) ,@clauses))

;;; ==================================================================
;;; The no-boolean / no-bare-value guards.  The slices' law ("no scalar
;;; standing, no boolean summary") extended to the effectful door: perform
;;; never returns a bare value, and no success-p is mintable.  These are the
;;; enforcement points the selftest teeth bite against.

(defun %require-outcome (value field)
  "Refuse a bare (non-outcome) value where a structured 4-axis outcome is
required.  A bare value has amputated the execution context (synthesis §3b):
it cannot say whether the effect was prepared, refused, committed, duplicated,
or reconstructed."
  (unless (lisp-plus-kernel0:outcome-p value)
    (signal-core0 'malformed-request
                  :failed-invariant
                  (format nil "a governed effect result MUST be a structured ~
kernel0 4-axis outcome, never a bare ~A value" field)
                  :offending-field field
                  :offending-value value))
  value)

(defun %forbid-boolean-summary (value field)
  "Refuse a boolean where a structured view/record is required.  The
no-boolean law: success-p is unmintable (synthesis §3b law 2)."
  (when (member value '(t nil) :test #'eq)
    (signal-core0 'malformed-request
                  :failed-invariant
                  (format nil "a governed result MUST NOT be summarised as a ~
boolean; ~A carries a structured view, never success/failure truth" field)
                  :offending-field field
                  :offending-value value))
  value)

;;; ==================================================================
;;; process-context — the execution-STANDING context (owner ruling: a distinct
;;; axis from derive's receiver-context, which is an evidentiary POSITION).
;;; A constructor-made object (receiver-context precedent), never a with-… macro
;;; (a binding macro would establish ambient standing — forbidden).  It mints
;;; and holds the three shared context identities a perform lowers against, so
;;; a continuation shares the process/seat rather than reconstructing them.

(defstruct (process-context (:constructor %make-process-context)
                            (:conc-name %process-context-) (:copier nil))
  (label nil :read-only t)                 ; the caller's non-empty name string
  (process-id nil :read-only t)            ; kernel0 :process identity
  (logical-operation-id nil :read-only t)  ; kernel0 :logical-operation identity
  (seat-id nil :read-only t))              ; kernel0 :seat identity

(defun process-context (&key label)
  "Construct an execution-standing context named LABEL (a non-empty string).
Mints the process/logical-operation/seat identities deterministically from the
label so a continuation shares the same standing."
  (unless (and (stringp label) (plusp (length label)))
    (signal-core0 'malformed-request
                  :failed-invariant
                  "a process-context :label MUST be a non-empty string"
                  :offending-field :label :offending-value label))
  (%make-process-context
   :label (copy-seq label)
   :process-id (%k-id :process (format nil "core0/process/~A" label))
   :logical-operation-id
   (%k-id :logical-operation (format nil "core0/operation/~A" label))
   :seat-id (%k-id :seat (format nil "core0/seat/~A" label))))

;; Readers: identities are immutable structs (pass through); the label copies.
(defun process-context-label (c) (copy-seq (%process-context-label c)))
(defun process-context-process-id (c) (%process-context-process-id c))
(defun process-context-logical-operation-id (c)
  (%process-context-logical-operation-id c))
(defun process-context-seat-id (c) (%process-context-seat-id c))

;;; ==================================================================
;;; Minimal capability — the LIVE opaque object (Kernel §11.1–11.2), minted
;;; from a FIXTURE sealed ruling (synthesis §5.3, chair's recommendation).  Its
;;; liveness is a fresh un-serializable TOKEN: the capability is NOT
;;; reconstructible from its serialized fields (§11.2) — the mint-receipt (a
;;; durable record ABOUT the past) carries NO token, so a record that authority
;;; existed is never live authority (board law).  Frontier check + equal-or-
;;; narrower recorded.  NO revocation registry, NO restoration flow (lane 2's).

(defstruct (fixture-sealed-ruling (:constructor %make-fixture-sealed-ruling)
                                  (:conc-name %fixture-sealed-ruling-)
                                  (:copier nil))
  (minter-id nil :read-only t)         ; :principal identity that authorizes minting
  (authorizing-claim-id nil :read-only t) ; :claim identity of the authorizing ruling
  (adapter-name nil :read-only t)      ; the adapter the scope authorizes
  (predicates nil :read-only t))       ; the request predicates the scope authorizes

(defun fixture-sealed-ruling (&key adapter-name predicates (minter "fixture-minter"))
  "A deterministic, fake sealed ruling that AUTHORISES minting a capability of
scope (:adapter ADAPTER-NAME :predicates PREDICATES).  A sealed ruling is not
itself a capability (Kernel §11.3): it authorises the mint."
  (unless (and (symbolp adapter-name) adapter-name)
    (signal-core0 'malformed-request
                  :failed-invariant "a sealed ruling MUST name an adapter (a symbol)"
                  :offending-field :adapter-name :offending-value adapter-name))
  (unless (and (%proper-list-p predicates) predicates
               (every #'keywordp predicates))
    (signal-core0 'malformed-request
                  :failed-invariant
                  "a sealed ruling MUST name a non-empty list of authorised request predicates"
                  :offending-field :predicates :offending-value predicates))
  (%make-fixture-sealed-ruling
   :minter-id (%k-id :principal (format nil "core0/minter/~A" minter))
   :authorizing-claim-id
   (%k-id :claim (format nil "core0/sealed-ruling/~A/~D" minter (%next-ordinal)))
   :adapter-name adapter-name
   :predicates (copy-list predicates)))

(defstruct (capability (:constructor %make-capability)
                       (:conc-name %capability-) (:copier nil))
  (token nil :read-only t)         ; fresh un-serializable cons — liveness is EQ
  (scope nil :read-only t)         ; (:adapter NAME :predicates (…)) — equal-or-narrower
  (mint-receipt nil :read-only t)) ; kernel0 capability-mint-receipt (durable, tokenless)

(defun capability-scope (cap)
  "The capability's authorised scope, as a fresh structural copy."
  (copy-tree (%capability-scope cap)))

(defun capability-mint-receipt-of (cap)
  "The durable minting receipt — a record that authority was minted, never live
authority itself."
  (%capability-mint-receipt cap))

(defun mint-capability (&key ruling)
  "Mint the live opaque capability authorised by RULING (a fixture-sealed-ruling):
validate the authorising ruling, derive scope, create the live opaque object
(a fresh token, NOT reconstructible from serialized fields), and emit a
capability-mint-receipt.  Minimal §11.3 minting only — no revocation registry,
no restoration flow."
  (unless (fixture-sealed-ruling-p ruling)
    (signal-core0 'malformed-request
                  :failed-invariant "MINT-CAPABILITY requires a fixture-sealed-ruling"
                  :offending-field :ruling :offending-value ruling))
  (let* ((cap-id (%k-id :capability
                        (format nil "core0/capability/~D" (%next-ordinal))))
         (scope (list :adapter (%fixture-sealed-ruling-adapter-name ruling)
                      :predicates
                      (copy-list (%fixture-sealed-ruling-predicates ruling))))
         (receipt
           (lisp-plus-kernel0:make-capability-mint-receipt
            :receipt-id (%k-id :receipt
                               (format nil "core0/mint-receipt/~D" (%next-ordinal)))
            :capability-id cap-id
            :minted-by (%fixture-sealed-ruling-minter-id ruling)
            :authorizing-claim-id (%fixture-sealed-ruling-authorizing-claim-id ruling)
            :derived-scope scope
            :delegates nil
            :revocation-registry nil
            :expiry :none)))
    (%make-capability
     ;; the liveness token: a fresh cons per mint.  Two capabilities are never
     ;; EQ, and NOTHING in the tokenless mint-receipt can reconstruct it.
     :token (list :core0-capability-liveness)
     :scope scope
     :mint-receipt receipt)))

(defun %capability-live-p (cap)
  "A capability is live iff it is a capability object carrying its token."
  (and (capability-p cap) (consp (%capability-token cap))))

(defun %check-capability-at-frontier (cap adapter-name predicate)
  "Frontier check (Kernel §11.4).  Refuses a missing/mismatched/ambient
authority PRE-frontier, and records the requested (adapter, predicate) as
equal-or-narrower than the capability scope.  Returns the narrowed scope."
  (unless (%capability-live-p cap)
    (signal-core0 'ambient-authority-forbidden
                  :failed-invariant
                  "authority MUST be an explicit live capability object, never ~
ambient or a durable receipt (a record that authority existed is not live authority)"
                  :offending-field :authority :offending-value cap))
  (let ((scope (%capability-scope cap)))
    (unless (eq (getf scope :adapter) adapter-name)
      (signal-core0 'capability-scope-violation
                    :failed-invariant
                    (format nil "the capability authorises adapter ~S, not ~S"
                            (getf scope :adapter) adapter-name)
                    :offending-field :adapter :offending-value adapter-name))
    (unless (member predicate (getf scope :predicates) :test #'eq)
      (signal-core0 'capability-scope-violation
                    :failed-invariant
                    (format nil "the capability does not authorise request ~
predicate ~S (authorised: ~S)" predicate (getf scope :predicates))
                    :offending-field :predicate :offending-value predicate))
    ;; equal-or-narrower recorded: the effect's scope is exactly this one act.
    (list :adapter adapter-name :predicates (list predicate))))

;;; ==================================================================
;;; The adapter protocol.  perform drives an adapter that declares a stable
;;; identity+version and two functions: DISPATCH (perform-side crossing) and
;;; LEDGER-QUERY (continuation-side witness of limited jurisdiction).  The
;;; deterministic fake lives in fake-courier.lisp; this is only the contract.
;;;
;;; DISPATCH returns a plist describing what happened at the frontier:
;;;   :crossed BOOL  :committed BOOL  :ledger-token TOKEN|nil
;;;   :acknowledged BOOL  :manifestation-status STATUS  :local-record-lands BOOL
;;;   :reason KEYWORD
;;; An acknowledgment has NO settling force by itself (AP-ACK-4): perform
;;; records it as an event, and the kernel FOLD settles.
;;;
;;; LEDGER-QUERY returns one of:
;;;   (:answered :committed TOKEN) | (:answered :not-committed) | (:withheld)

(defstruct (core0-adapter (:constructor %make-core0-adapter)
                          (:conc-name %core0-adapter-) (:copier nil))
  (name nil :read-only t)          ; the designator symbol
  (identity nil :read-only t)      ; kernel0 :principal identity (stable)
  (version nil :read-only t)       ; nonnegative integer
  (dispatch nil :read-only t)      ; function (adapter request attempt-id) -> plist
  (ledger-query nil :read-only t)) ; function (adapter attempt-id request) -> plist

(defun core0-adapter-name (a) (%core0-adapter-name a))
(defun core0-adapter-identity (a) (%core0-adapter-identity a))
(defun core0-adapter-version (a) (%core0-adapter-version a))
(defun %adapter-dispatch (a request attempt-id)
  (funcall (%core0-adapter-dispatch a) a request attempt-id))
(defun %adapter-ledger-query (a attempt-id request)
  (funcall (%core0-adapter-ledger-query a) a attempt-id request))

;; The public adapter constructor — the protocol object is owned by core0, so a
;; fake adapter (a labeled scripted subset) plugs in through this, not by
;; reaching into core0's internals.  A production/real adapter is out of Core /0
;; scope; this shell carries no provider I/O of its own.
(defun make-adapter (&key name identity version dispatch ledger-query)
  "Construct a core0-adapter from a stable NAME (designator symbol), IDENTITY
(kernel0 :principal identity), nonnegative-integer VERSION, and the two protocol
functions DISPATCH and LEDGER-QUERY."
  (unless (and (symbolp name) name)
    (signal-core0 'malformed-request
                  :failed-invariant "an adapter MUST have a symbol NAME"
                  :offending-field :name :offending-value name))
  (unless (and (integerp version) (not (minusp version)))
    (signal-core0 'malformed-request
                  :failed-invariant "an adapter VERSION MUST be a nonnegative integer"
                  :offending-field :version :offending-value version))
  (unless (and (functionp dispatch) (functionp ledger-query))
    (signal-core0 'malformed-request
                  :failed-invariant "an adapter MUST supply DISPATCH and LEDGER-QUERY functions"
                  :offending-field :protocol :offending-value (list dispatch ledger-query)))
  (%make-core0-adapter :name name :identity identity :version version
                       :dispatch dispatch :ledger-query ledger-query))

(defvar *adapters* '()
  "Registry of registered adapter objects, by name (a designator symbol).")

(defun register-adapter (adapter)
  "Register ADAPTER under its name so a symbol designator resolves to it.
Idempotent-OK on an EQ re-registration; a different object under a live name
refuses."
  (unless (core0-adapter-p adapter)
    (signal-core0 'malformed-request
                  :failed-invariant "REGISTER-ADAPTER requires a core0-adapter"
                  :offending-field :adapter :offending-value adapter))
  (let ((existing (cdr (assoc (%core0-adapter-name adapter) *adapters*))))
    (cond ((null existing)
           (push (cons (%core0-adapter-name adapter) adapter) *adapters*))
          ((eq existing adapter) existing)
          (t (signal-core0 'unknown-adapter
                           :failed-invariant
                           (format nil "a different adapter is already registered ~
under ~S" (%core0-adapter-name adapter))
                           :offending-field :name
                           :offending-value (%core0-adapter-name adapter)))))
  adapter)

(defun resolve-adapter (designator)
  "Resolve an adapter DESIGNATOR: a core0-adapter object passes through; a symbol
is looked up in the registry; anything unknown REFUSES (typed).  An unknown
adapter is declared unknown, never silently absent (AP0 §4)."
  (cond ((core0-adapter-p designator) designator)
        ((and (symbolp designator) (cdr (assoc designator *adapters*))))
        (t (signal-core0 'unknown-adapter
                         :failed-invariant
                         (format nil "no adapter resolves the designator ~S; an ~
unknown adapter is declared unknown, never treated as absent" designator)
                         :offending-field :adapter :offending-value designator))))

;;; ==================================================================
;;; Evidence — the structured second value, and what a refusal/interruption
;;; carries.  It holds the in-memory event sequence (the testimony), the
;;; attempt/seat/process identities, the manifestation, and — DISTINCT from the
;;; adapter's ledger world — the ledger token the program was TOLD.  Standing is
;;; ALWAYS fold-derived from EVENTS, never read off a self-reported field here.

(defstruct (core0-evidence (:constructor %make-core0-evidence)
                           (:conc-name %core0-evidence-) (:copier nil))
  (process nil :read-only t)                ; the process-context
  (attempt-id nil :read-only t)             ; kernel0 :attempt identity
  (seat-id nil :read-only t)                ; kernel0 :seat identity
  (adapter-identity nil :read-only t)       ; the adapter's stable identity
  (adapter nil :read-only t)                ; the adapter object (for continuation)
  (request nil :read-only t)                ; the canonical request
  (events nil :read-only t)                 ; kernel0-event list (immutable records)
  (manifestation nil :read-only t)          ; kernel0 manifestation record | nil
  (ledger-token nil :read-only t)           ; testimony: the token the program was told
  (reconciliation-receipts nil :read-only t)
  (refusal-reason nil :read-only t))        ; string for a pre-frontier refusal | nil

(defun core0-evidence-process (e) (%core0-evidence-process e))
(defun core0-evidence-attempt-id (e) (%core0-evidence-attempt-id e))
(defun core0-evidence-seat-id (e) (%core0-evidence-seat-id e))
(defun core0-evidence-adapter-identity (e) (%core0-evidence-adapter-identity e))
(defun core0-evidence-request (e) (copy-tree (%core0-evidence-request e)))
(defun core0-evidence-events (e) (copy-list (%core0-evidence-events e)))
(defun core0-evidence-manifestation (e) (%core0-evidence-manifestation e))
(defun core0-evidence-ledger-token (e) (%core0-evidence-ledger-token e))
(defun core0-evidence-reconciliation-receipts (e)
  (copy-list (%core0-evidence-reconciliation-receipts e)))
(defun core0-evidence-refusal-reason (e) (%core0-evidence-refusal-reason e))

;;; ==================================================================
;;; Canonical request discipline.  A request is a Slice /1 GROUND structured
;;; proposition in normal form — CD/0-lawful data, never a host object.  Its
;;; predicate is the scope-check key.

(defun %canonical-request (request)
  "Return the request in Slice /1 normal form, or REFUSE (malformed-request)."
  (handler-case
      (let ((nf (lisp-plus-slice1:proposition request)))
        nf)
    (error (c)
      (signal-core0 'malformed-request
                    :failed-invariant
                    (format nil "the :request MUST be a Slice /1 ground structured ~
proposition (CD/0-lawful); ~A" (type-of c))
                    :offending-field :request :offending-value request))))

(defun %request-predicate (normal-form) (second normal-form))

;;; ==================================================================
;;; Determinacy / axis helpers for the outcome the lowering constructs.

(defun %determinate (&optional evidence)
  (lisp-plus-kernel0:make-determinacy :mode :determinate :evidence evidence))

(defun %bounded-determinacy (alternatives)
  (lisp-plus-kernel0:make-determinacy :mode :bounded
                                      :alternatives alternatives :evidence nil))

(defparameter +delivery-alternatives+ '(:delivered :not-delivered))

(defun %settled-effect-axis (effect-group settle-id)
  (lisp-plus-kernel0:make-effect-axis
   :value :settled :determinacy (%determinate (list settle-id))
   :evidence (list settle-id) :effect-group effect-group))

(defun %bounded-effect-axis (effect-group uncertain-effect)
  (lisp-plus-kernel0:make-effect-axis
   :value :bounded
   :determinacy (%bounded-determinacy +delivery-alternatives+)
   :uncertain-effect-ref uncertain-effect :effect-group effect-group))

(defun %not-entered-effect-axis (effect-group)
  (lisp-plus-kernel0:make-effect-axis
   :value :not-entered :determinacy (%determinate) :effect-group effect-group))

(defun %build-outcome (&key process attempt-id execution manifestation-axis
                            effects interpretation)
  (lisp-plus-kernel0:make-outcome
   :process-id (process-context-process-id process)
   :logical-operation-id (process-context-logical-operation-id process)
   :seat-id (process-context-seat-id process)
   :attempt-id attempt-id
   :execution execution
   :manifestation manifestation-axis
   :effects effects
   :interpretation interpretation))

(defun %present-manifestation (attempt-id token-name)
  "A PRESENT manifestation on the non-AP0 :producer-identity branch (the fake
courier is a labeled scripted subset, never AP0-conformant).  Its payload
identity is preserved; the bare payload string is never the value."
  (lisp-plus-kernel0:make-manifestation
   :manifestation-id (%k-id :manifestation
                            (format nil "core0/manifestation/~D" (%next-ordinal)))
   :attempt-id attempt-id
   :kind :courier-receipt
   :status :present
   :payload-id (%k-id :receipt token-name)
   :producer-identity (%k-id :principal "core0/fake-courier-producer")
   :source-boundary :fake-courier-boundary))

;;; ==================================================================
;;; The in-memory kernel0-event builders (each a thin, named constructor so the
;;; lawful order is legible and validate-event-sequence governs it).

(defun %ev (type process seat &key attempt operation effect manifestation
                                    external payload)
  (lisp-plus-kernel0:make-kernel0-event
   :event-type type
   :process-id (process-context-process-id process)
   :logical-operation-id operation
   :seat-id seat
   :attempt-id attempt
   :effect-id effect
   :manifestation-id manifestation
   :external-request-id external
   :payload payload))

(defun %genesis-events (process seat attempt attempt-record)
  "process-created -> seat-reserved -> attempt-begun (with the attempt record)."
  (list (%ev :process-created process nil)
        (%ev :seat-reserved process seat)
        (%ev :attempt-begun process seat
             :attempt attempt
             :operation (process-context-logical-operation-id process)
             :payload (list :attempt attempt-record))))

;;; ==================================================================
;;; PERFORM — the ONE new governed effect-capable act.  Its door is defined by
;;; the possibility of a lawful, ACCOUNTED external-effect frontier crossing —
;;; NOT by purity, determinism, expense, or durable-journal production
;;; (Amendment 1(b); owner ruling Finding 1).  It lowers per synthesis §3a
;;; steps 1–8 over an in-memory kernel0-event sequence and returns
;;; (values OUTCOME EVIDENCE).  Pre-frontier refusals SIGNAL a typed condition
;;; carrying the evidence-so-far AND a refused outcome (view :refused).  It
;;; NEVER returns a bare manifestation value; there is NO boolean success.

(defun %refused-outcome (process attempt-id effect-group)
  "A refused OUTCOME: execution :refused (pre-frontier — NO frontier qualifier),
effect :not-entered, manifestation absent (:refused-pre-effect)."
  (%build-outcome
   :process process :attempt-id attempt-id
   :execution (lisp-plus-kernel0:make-execution-axis
               :value :refused :determinacy (%determinate))
   :manifestation-axis
   (lisp-plus-kernel0:make-manifestation-axis
    :value '(:absent :state :refused-pre-effect) :determinacy (%determinate))
   :effects (%not-entered-effect-axis effect-group)
   :interpretation (lisp-plus-kernel0:make-interpretation-axis
                    :value :not-attempted :determinacy (%determinate))))

(defun %refuse-pre-frontier (condition-type process attempt-id seat effect-group
                             events adapter-identity request reason
                             &key offending-field offending-value)
  "Emit the terminal :attempt-refused event, build the refused evidence + refused
outcome, and SIGNAL.  No frontier-crossed event exists ⇒ the view is :refused."
  (let* ((events* (append events
                          (list (%ev :attempt-refused process seat
                                     :attempt attempt-id
                                     :operation (process-context-logical-operation-id
                                                 process)))))
         (evidence (%make-core0-evidence
                    :process process :attempt-id attempt-id :seat-id seat
                    :adapter-identity adapter-identity :request request
                    :events events* :manifestation nil :ledger-token nil
                    :reconciliation-receipts nil :refusal-reason reason))
         (outcome (%refused-outcome process attempt-id effect-group)))
    (signal-core0 condition-type
                  :failed-invariant reason
                  :offending-field offending-field
                  :offending-value offending-value
                  :evidence evidence :outcome outcome)))

(defun perform (&key adapter request authority process)
  "The governed effect-capable act.  Lowers a surface call into the §19.8
pipeline over an in-memory kernel0 event sequence and returns
(values OUTCOME EVIDENCE).  ADAPTER is a designator; REQUEST a Slice /1 ground
proposition (CD/0-lawful); AUTHORITY an explicit live capability (never
ambient); PROCESS a process-context.  Pre-frontier refusals SIGNAL a typed
core0-refused carrying evidence-so-far and a refused outcome.  A W1-shaped
interruption SIGNALS core0-interrupted carrying the surviving evidence.  Never
returns a bare value; no boolean success anywhere."
  (unless (process-context-p process)
    (signal-core0 'malformed-request
                  :failed-invariant "perform :process MUST be a process-context"
                  :offending-field :process :offending-value process))
  (let* ((seat (process-context-seat-id process))
         (operation (process-context-logical-operation-id process))
         (attempt-id (%k-id :attempt (format nil "core0/attempt/~D" (%next-ordinal))))
         (effect-group (%k-id :effect (format nil "core0/effect/~D" (%next-ordinal))))
         ;; step 1 — attempt identity minted per invocation
         (attempt-record
           (lisp-plus-kernel0:make-attempt
            :attempt-id attempt-id :logical-operation-id operation
            :seat-id seat :process-id (process-context-process-id process)
            :predecessor-attempts nil :machine-configuration-id nil
            :supersession-records nil))
         (events (%genesis-events process seat attempt-id attempt-record))
         ;; canonical request (CD/0-lawful) — refuses a malformed host request
         (nf (%canonical-request request))
         (predicate (%request-predicate nf))
         (adapter-obj (resolve-adapter adapter))          ; step 3a — unknown REFUSES
         (adapter-name (%core0-adapter-name adapter-obj))
         (adapter-identity (%core0-adapter-identity adapter-obj)))
    ;; step 2 — authority check AT the frontier (explicit, never ambient).
    ;; A missing/mismatched/ambient authority refuses PRE-frontier.
    (handler-case
        (%check-capability-at-frontier authority adapter-name predicate)
      (core0-refused (c)
        (%refuse-pre-frontier (type-of c) process attempt-id seat effect-group
                              events adapter-identity nf
                              (core0-condition-failed-invariant c)
                              :offending-field (core0-condition-offending-field c)
                              :offending-value (core0-condition-offending-value c))))
    ;; step 4 — effect preparation (pre-frontier closure; no implicit fallback)
    (let ((events (append events
                          (list (%ev :effect-prepared process seat
                                     :attempt attempt-id :effect effect-group)))))
      ;; step 6 — adapter invocation.  An ack has NO settling force by itself.
      (let* ((report (%adapter-dispatch adapter-obj nf attempt-id))
             (crossed (getf report :crossed))
             (committed (getf report :committed))
             (ledger-token (getf report :ledger-token))
             (acknowledged (getf report :acknowledged))
             (local-lands (getf report :local-record-lands))
             (reason (getf report :reason)))
        (unless crossed
          ;; the adapter refused at its boundary before the frontier — pre-frontier.
          (return-from perform
            (%refuse-pre-frontier
             'core0-refused process attempt-id seat effect-group events
             adapter-identity nf
             (format nil "adapter refused before the frontier~@[: ~A~]" reason)
             :offending-field :adapter :offending-value adapter-name)))
        ;; the frontier IS crossed from here on.
        (let ((events (append events
                              (list (%ev :frontier-crossed process seat
                                         :attempt attempt-id :effect effect-group)))))
          (when acknowledged
            (setf events
                  (append events
                          (list (%ev :request-acknowledged process seat
                                     :attempt attempt-id
                                     :external
                                     (%k-id :external-request
                                            (format nil "core0/req/~D"
                                                    (%next-ordinal))))))))
          (cond
            ;; ---- committed AND the local record landed: clean commit ----
            ((and committed local-lands)
             (let* ((manifestation (%present-manifestation attempt-id ledger-token))
                    (mid (lisp-plus-kernel0:manifestation-manifestation-id manifestation))
                    (settle-id (%k-id :receipt
                                      (format nil "core0/settle/~D" (%next-ordinal))))
                    (events (append events
                                    (list (%ev :manifestation-recorded process seat
                                               :attempt attempt-id :manifestation mid)
                                          (%ev :effect-settled process seat
                                               :attempt attempt-id :effect effect-group)
                                          (%ev :attempt-completed process seat
                                               :attempt attempt-id))))
                    (outcome
                      (%build-outcome
                       :process process :attempt-id attempt-id
                       :execution (lisp-plus-kernel0:make-execution-axis
                                   :value :completed :determinacy (%determinate)
                                   :frontier-qualifier :post-frontier)
                       :manifestation-axis
                       (lisp-plus-kernel0:make-manifestation-axis
                        :value manifestation :determinacy (%determinate))
                       :effects (%settled-effect-axis effect-group settle-id)
                       :interpretation
                       (lisp-plus-kernel0:make-interpretation-axis
                        :value :not-applicable :determinacy (%determinate))))
                    (evidence (%make-core0-evidence
                               :process process :attempt-id attempt-id :seat-id seat
                               :adapter-identity adapter-identity :adapter adapter-obj
                               :request nf :events events :manifestation manifestation
                               :ledger-token ledger-token
                               :reconciliation-receipts nil :refusal-reason nil)))
               ;; fold-derived cross-check: the outcome's axes are NOT self-report —
               ;; they agree with the independent fold over the same events.
               (lisp-plus-kernel0:validate-event-sequence events)
               (%require-outcome outcome :perform-result)
               (values outcome evidence)))
            ;; ---- committed in the ledger but the local record did NOT land ----
            ;; the W1-shaped kill: the effect is UNCERTAIN from the program's
            ;; local view.  Record a bounded effect + SIGNAL core0-interrupted.
            (t
             (let* ((uncertain
                      (lisp-plus-kernel0:make-uncertain-effect
                       :kind :provider-call :attempt attempt-id
                       :external-request '(:unavailable :reason :killed-before-local-record)
                       :possible-effects +delivery-alternatives+
                       :known-facts nil
                       :reconciliation-procedure
                       (%k-id :procedure "core0/reconcile-courier")))
                    (events (append events
                                    (list (%ev :effect-bounded process seat
                                               :attempt attempt-id :effect effect-group
                                               :payload (list :uncertain-effect uncertain))
                                          (%ev :attempt-failed process seat
                                               :attempt attempt-id))))
                    (outcome
                      (%build-outcome
                       :process process :attempt-id attempt-id
                       :execution (lisp-plus-kernel0:make-execution-axis
                                   :value :failed :determinacy (%determinate)
                                   :frontier-qualifier :post-frontier)
                       :manifestation-axis
                       (lisp-plus-kernel0:make-manifestation-axis
                        :value '(:absent :state :withheld) :determinacy (%determinate))
                       :effects (%bounded-effect-axis effect-group uncertain)
                       :interpretation
                       (lisp-plus-kernel0:make-interpretation-axis
                        :value :not-attempted :determinacy (%determinate))))
                    (evidence (%make-core0-evidence
                               :process process :attempt-id attempt-id :seat-id seat
                               :adapter-identity adapter-identity :adapter adapter-obj
                               :request nf :events events :manifestation nil
                               :ledger-token nil ; the program was NOT told a token
                               :reconciliation-receipts nil :refusal-reason nil)))
               (lisp-plus-kernel0:validate-event-sequence events)
               (signal-core0 'core0-interrupted
                             :failed-invariant
                             "the effect frontier was crossed but the local outcome ~
record did not land; the effect is UNCERTAIN and MUST be reconciled, never blindly retried"
                             :offending-field :local-record :offending-value reason
                             :evidence evidence :outcome outcome)))))))))

;;; ==================================================================
;;; OUTCOME-KIND — the three-way VIEW over a PERFORM outcome ONLY (synthesis
;;; §3b, exactly).  A projection over the 4-axis × per-axis-determinacy lattice
;;; — never a boolean, never a replacement for the full record (always
;;; reachable via outcome-axis).  NOT applicable to derivation receipts (the
;;; two-door decision-arity law: derive stays binary, perform stays three-way).
;;;
;;;   :refused        the attempt terminated pre-frontier — execution :refused,
;;;                   no frontier crossed (Kernel §12.6); the typed refusal
;;;                   named the failed precondition
;;;   :committed      execution :completed AND the effect axis is :settled/
;;;                   :compensated under :determinate determinacy (no unresolved
;;;                   uncertain effect)
;;;   :indeterminate  otherwise (bounded/indeterminate effect, or non-terminal /
;;;                   post-frontier failure)
;;;
;;; Faithfulness note: perform builds these axes FROM its lowering, so the view
;;; is fold-consistent by construction (a selftest tooth cross-checks the fold).

(defun outcome-kind (outcome)
  "The three-way view of a perform OUTCOME.  Refuses a non-outcome (never
manufactures a bare answer)."
  (unless (lisp-plus-kernel0:outcome-p outcome)
    (signal-core0 'malformed-request
                  :failed-invariant
                  "OUTCOME-KIND requires a structured kernel0 outcome (a perform ~
result); it never manufactures a bare answer"
                  :offending-field :outcome :offending-value outcome))
  (let* ((exec (lisp-plus-kernel0:outcome-axis outcome :execution))
         (eff (lisp-plus-kernel0:outcome-axis outcome :effects))
         (exec-value (lisp-plus-kernel0:axis-value exec))
         (eff-value (lisp-plus-kernel0:axis-value eff))
         (eff-determinate
           (eq (lisp-plus-kernel0:determinacy-mode
                (lisp-plus-kernel0:axis-determinacy eff))
               :determinate)))
    (cond
      ((eq exec-value :refused) :refused)
      ((and (eq exec-value :completed)
            (member eff-value '(:settled :compensated) :test #'eq)
            eff-determinate)
       :committed)
      (t :indeterminate))))

;;; ==================================================================
;;; CONTINUE-FROM — in-image continuation over EVIDENCE.  Standing is
;;; fold-derived (fold-attempt-outcome), never self-reported.  Blind
;;; re-invocation is refused by LIVE check-retry-safety (the central tooth).
;;; Reconciliation queries the adapter's ledger (a witness of limited
;;; jurisdiction) → a reconciliation-receipt + narrowed standing when the
;;; ledger answers, or an indeterminate result naming known/unknown/
;;; required-action when it withholds.  Both are superior to lying.
;;;
;;; This is NOT crash-survival: the event sequence survived because the image
;;; did.  Nothing here demonstrates durability across process death.

(defstruct (continuation-result (:constructor %make-continuation-result)
                                (:conc-name %continuation-result-) (:copier nil))
  (disposition nil :read-only t)          ; :reconciled | :indeterminate
  (standing nil :read-only t)             ; kernel0 attempt-outcome-standing (fold-derived)
  (reconciliation-receipt nil :read-only t)
  (evidence nil :read-only t)             ; the narrowed core0-evidence
  (required-action nil :read-only t))     ; when indeterminate: what would resolve it

(defun continuation-result-disposition (r) (%continuation-result-disposition r))
(defun continuation-result-standing (r) (%continuation-result-standing r))
(defun continuation-result-reconciliation-receipt (r)
  (%continuation-result-reconciliation-receipt r))
(defun continuation-result-evidence (r) (%continuation-result-evidence r))
(defun continuation-result-required-action (r)
  (copy-tree (%continuation-result-required-action r)))

(defun %prove-blind-retry-unsafe (events seat)
  "The central tooth, wired into the real path: PROVE — via LIVE
check-retry-safety — that blindly re-invoking (a fresh attempt in the same
seat) is unsafe, then refuse to do it.  Returns T when the live fold fired its
refusal; SIGNALS blind-retry-refused if the guard did NOT fire (which would
mean the surviving evidence carries no unresolved effect to protect)."
  (let* ((retry-attempt (%k-id :attempt
                               (format nil "core0/blind-retry/~D" (%next-ordinal))))
         (retry-events
           (append events
                   (list (lisp-plus-kernel0:make-kernel0-event
                          :event-type :attempt-begun
                          :seat-id seat :attempt-id retry-attempt
                          :payload nil)))))
    (handler-case
        (progn
          (lisp-plus-kernel0:check-retry-safety retry-events seat)
          ;; the live fold did NOT refuse — there is nothing to reconcile.
          (signal-core0 'blind-retry-refused
                        :failed-invariant
                        "continue-from found no unresolved effect for this seat; ~
there is nothing to reconcile and no retry is warranted"
                        :offending-field :seat :offending-value seat))
      (lisp-plus-kernel0:unsafe-retry ()
        ;; GOOD: the live no-blind-retry law fired.  We refuse to retry.
        t))))

(defun continue-from (evidence &key adapter authority)
  "Continue an interrupted attempt from its surviving EVIDENCE.  Derives
standing from the events (never self-report); PROVES blind retry unsafe via
live check-retry-safety and refuses it; reconciles against the adapter's ledger
(a witness of limited jurisdiction).  ADAPTER is the live adapter; AUTHORITY a
FRESH live capability (a historical mint-receipt is refused — a record that
authority existed is not live authority).  Returns a continuation-result."
  (unless (core0-evidence-p evidence)
    (signal-core0 'malformed-request
                  :failed-invariant "CONTINUE-FROM requires core0-evidence"
                  :offending-field :evidence :offending-value evidence))
  ;; authority must be FRESH and LIVE — never re-minted from a historical record.
  (unless (%capability-live-p authority)
    (signal-core0 'ambient-authority-forbidden
                  :failed-invariant
                  "continue-from requires a FRESH live capability; a durable ~
mint-receipt (a record that authority existed) is not live authority"
                  :offending-field :authority :offending-value authority))
  (let* ((events (%core0-evidence-events evidence))
         (attempt-id (%core0-evidence-attempt-id evidence))
         (seat (%core0-evidence-seat-id evidence))
         (process (%core0-evidence-process evidence))
         (adapter-obj (or adapter (%core0-evidence-adapter evidence)))
         ;; (1) standing is fold-derived from events — never trust a self-report
         (standing (lisp-plus-kernel0:fold-attempt-outcome events attempt-id)))
    (unless (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing)
      ;; nothing to continue: no unresolved effect (fold-derived).
      (return-from continue-from
        (%make-continuation-result
         :disposition :indeterminate :standing standing
         :reconciliation-receipt nil :evidence evidence
         :required-action '(:no-unresolved-effect :nothing-to-reconcile))))
    ;; (2)+(3) prove blind retry unsafe via LIVE check-retry-safety, then refuse it
    (%prove-blind-retry-unsafe events seat)
    ;; (4) reconcile by querying the adapter's ledger (limited jurisdiction)
    (let* ((request (%core0-evidence-request evidence))
           (answer (%adapter-ledger-query adapter-obj attempt-id request)))
      (cond
        ((and (eq (first answer) :answered) (eq (second answer) :committed))
         ;; the ledger witnesses the committed row → settle by reconciliation.
         (let* ((token (third answer))
                (settle-id (%k-id :receipt
                                  (format nil "core0/ledger-witness/~D" (%next-ordinal))))
                (effect-group
                  ;; recover this attempt's effect group from its prepared event.
                  (loop for e in events
                        when (eq (lisp-plus-kernel0:kernel0-event-event-type e)
                                 :effect-prepared)
                          return (lisp-plus-kernel0:kernel0-event-effect-id e)))
                (uncertain (first (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effects
                                   standing)))
                (previous (%bounded-effect-axis effect-group uncertain))
                (resulting (%settled-effect-axis effect-group settle-id))
                (receipt (lisp-plus-kernel0:make-reconciliation-receipt
                          :target-attempt-id attempt-id
                          :procedure-id (%k-id :procedure "core0/reconcile-courier")
                          :procedure-version 0
                          :new-evidence (list settle-id)
                          :previous-axis-values+determinacy (list :effects previous)
                          :resulting-axis-values+determinacy (list :effects resulting)
                          :unresolved-residue nil))
                (recon-event (lisp-plus-kernel0:make-kernel0-event
                              :event-type :attempt-reconciled
                              :seat-id seat :attempt-id attempt-id
                              :payload (list :reconciliation-receipt receipt)))
                (events* (append events (list recon-event)))
                ;; narrowed standing — fold again, now the effect is resolved.
                (narrowed (lisp-plus-kernel0:fold-attempt-outcome events* attempt-id))
                (manifestation (%present-manifestation attempt-id token))
                (evidence* (%make-core0-evidence
                            :process process :attempt-id attempt-id :seat-id seat
                            :adapter-identity (%core0-evidence-adapter-identity evidence)
                            :adapter adapter-obj :request request
                            :events events* :manifestation manifestation
                            :ledger-token token
                            :reconciliation-receipts (list receipt)
                            :refusal-reason nil)))
           (%make-continuation-result
            :disposition :reconciled :standing narrowed
            :reconciliation-receipt receipt :evidence evidence*
            :required-action nil)))
        (t
         ;; the ledger withheld (or definitively not-committed) → indeterminate,
         ;; naming known/unknown/required-action.  No new ledger row, no retry.
         (%make-continuation-result
          :disposition :indeterminate :standing standing
          :reconciliation-receipt nil :evidence evidence
          :required-action
          (list :known '(:frontier-crossed :effect-uncertain)
                :unknown '(:whether-the-effect-settled)
                :required-action
                (if (eq (first answer) :withheld)
                    '(:obtain-a-jurisdiction-bearing-witness-of-the-ledger)
                    '(:the-ledger-reports-not-committed :supersede-or-abandon)))))))))

;;; ==================================================================
;;; WHY — the ONE uniform explanation door, SHARED across both doors (owner
;;; ruling: the extractor registry takes both).  A core0-evidence explains
;;; itself from its structured fields — standing derived from EVENTS, never a
;;; self-reported flag.  Registered into the frozen Slice /0 registry exactly as
;;; Slice /1 did — one receipted `::`, named in CORE0-DEFECT-RECEIPT-0.md.

;; RECEIPTED INTERNAL ACCESS — see CORE0-DEFECT-RECEIPT-0.md (sole licensed :: in Core /0).
;; Idempotent registration: the predicate is the SYMBOL 'core0-evidence-p (EQ
;; across reloads, a lawful funcall designator at the frozen WHY loop) — not
;; #'core0-evidence-p, which is a fresh function object each load.  The
;; find-guard makes reloading core0.lisp install no duplicate.
(unless (find 'core0-evidence-p lisp-plus-slice0::*why-extractors* :key #'car)
  (push (cons 'core0-evidence-p #'identity) lisp-plus-slice0::*why-extractors*))

(defun why (object)
  "Core /0 façade over the uniform WHY: a core0-evidence explains itself from
its structured fields; anything else is delegated to Slice /1's WHY (which
delegates to Slice /0's)."
  (if (core0-evidence-p object)
      object
      (lisp-plus-slice1:why object)))

(defun %perform-view (evidence)
  "Derive the three-way view of an evidence's attempt from its EVENTS ALONE
(fold-derived, never self-reported).  :refused when no frontier-crossed event
exists; else the fold's terminal class + effect standing decide."
  (let ((events (%core0-evidence-events evidence)))
    (if (not (some (lambda (e)
                     (eq (lisp-plus-kernel0:kernel0-event-event-type e)
                         :frontier-crossed))
                   events))
        :refused
        (let ((standing (lisp-plus-kernel0:fold-attempt-outcome
                         events (%core0-evidence-attempt-id evidence))))
          (cond
            ((lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p standing)
             :indeterminate)
            ((eq (lisp-plus-kernel0:attempt-outcome-standing-terminal-class standing)
                 :completed)
             :committed)
            (t :indeterminate))))))

(defun render-core0-why (evidence &optional (stream t))
  "Prose derived from the evidence's structured fields ONLY — never a fact
absent from the record (Slice /0 discipline, inherited).  The three-way view is
recomputed from the events by fold, not read from a stored summary."
  (unless (core0-evidence-p evidence)
    (signal-core0 'malformed-request
                  :failed-invariant "RENDER-CORE0-WHY requires a core0-evidence"
                  :offending-field :evidence :offending-value evidence))
  (format stream "~&[core0 ~A] attempt ~A~%"
          (%perform-view evidence)
          (lisp-plus-kernel0:identity-key (%core0-evidence-attempt-id evidence)))
  (when (%core0-evidence-refusal-reason evidence)
    (format stream "  refused (pre-frontier): ~A~%"
            (%core0-evidence-refusal-reason evidence)))
  (format stream "  events: ~{~A~^ -> ~}~%"
          (mapcar #'lisp-plus-kernel0:kernel0-event-event-type
                  (%core0-evidence-events evidence)))
  (when (%core0-evidence-ledger-token evidence)
    (format stream "  ledger token (testimony, NOT the payload): ~A~%"
            (%core0-evidence-ledger-token evidence)))
  (when (%core0-evidence-manifestation evidence)
    (format stream "  manifestation: ~A (status ~A)~%"
            (lisp-plus-kernel0:identity-key
             (lisp-plus-kernel0:manifestation-manifestation-id
              (%core0-evidence-manifestation evidence)))
            (lisp-plus-kernel0:manifestation-status
             (%core0-evidence-manifestation evidence))))
  (dolist (r (%core0-evidence-reconciliation-receipts evidence))
    (format stream "  reconciled: target ~A via ~A~%"
            (lisp-plus-kernel0:identity-key
             (lisp-plus-kernel0:reconciliation-receipt-target-attempt-id r))
            (lisp-plus-kernel0:identity-key
             (lisp-plus-kernel0:reconciliation-receipt-procedure-id r))))
  evidence)
