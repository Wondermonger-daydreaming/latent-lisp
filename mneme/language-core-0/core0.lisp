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
   ;; the ONE public issuance check (Evidence Issuance Erratum /0, R-ISSUANCE-0.7).
   ;; core0-evidence-p is a TYPE predicate; this is the ISSUANCE predicate.
   #:core0-evidence-current-image-issued-p
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
   #:unissued-evidence
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
            capability-scope-violation ambient-authority-forbidden
            ;; Evidence Issuance Erratum /0 R-ISSUANCE-0.5.  Its meaning is
            ;; EXACTLY: "this content is not registered as Core /0-issued in
            ;; this image."  It says nothing about how the value was produced
            ;; and makes no accusation about the caller.
            unissued-evidence))

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
;;; EVIDENCE ISSUANCE — governed by CORE0-EVIDENCE-ISSUANCE-ERRATUM-0.md
;;; (owner-adopted, 2026-07-25).  Core /0 had been treating one object as DATA
;;; when it constructed it and PROVENANCE when it consumed it.  This section
;;; gives it one ontology: a core0-evidence has provenance standing exactly
;;; when its EXACT CANONICAL ACCOUNT CONTENT was issued by Core /0 in the
;;; current Lisp image.
;;;
;;;   core0-evidence-p                        a TYPE predicate.  Nothing more.
;;;   core0-evidence-current-image-issued-p   the ISSUANCE predicate.
;;;
;;; Three decisions the erratum makes, enacted here and nowhere else:
;;;   R-ISSUANCE-0.2  authenticity belongs to CONTENT, not to the host object's
;;;                   pointer identity.  An exact copy is issued; the same
;;;                   object after content mutation is not.  There is NO EQ
;;;                   membership anywhere in this section.
;;;   R-ISSUANCE-0.3  the registry is governed by EXACT canonical octets.  The
;;;                   hex rendering is an INDEX; a key hit alone never answers
;;;                   the question — the stored octets are compared element by
;;;                   element before this code says yes.
;;;   R-ISSUANCE-0.9  the registry is IMAGE-LOCAL.  Nothing here earns crash
;;;                   survival, durability, cross-image standing, or
;;;                   serialization authenticity.
;;;
;;; CEILING (R-ISSUANCE-0.10).  A positive answer establishes AT MOST: this
;;; exact canonical account content was minted by the Core /0 runtime in this
;;; Lisp image.  It does NOT establish that the external-world deed occurred,
;;; that the provider told the truth, that the adapter is honest, that the
;;; account's semantic interpretation is correct, or that the effect is
;;; settled.  NO cryptographic-security claim is made or implied.

(defparameter +core0-issuance-datum-format+ "core0/evidence-issuance-datum/v0"
  "The canonical-content format identifier.  It is bound INTO the datum, so a
future format revision cannot be mistaken for this one.")

(defparameter +core0-issuance-account-version+ 0
  "The account version R-ISSUANCE-0.4 requires be bound.  Core /0 stores no
version SLOT; the version of the account SHAPE is this constant, and it is
bound into the canonical content rather than into the structure.")

(defun %iss-key (name)
  "A CD/0 record key in the Core /0 issuance namespace."
  (lisp-plus-cd0:make-identifier-datum
   '("lisp-plus-core0" "evidence-issuance") (list name)))

(defun %iss-entry (name value-datum)
  (lisp-plus-cd0:make-record-entry (%iss-key name) value-datum))

(defun %iss-refuse (what value)
  "An internal invariant breach, not a governed refusal: Core /0 built an
account field for which this closed encoder has no canonical representation.
Loud by design — silently declining to register would leave a genuine account
unissued, which is exactly the failure this section exists to prevent.  (House
precedent: SIGNAL-CORE0's own contract breaches use a plain ERROR.)"
  (error "core0 issuance datum: no canonical representation for ~A: ~S"
         what (type-of value)))

(defun %iss-record (type-name entries)
  "A tagged CD/0 record.  The RECORD-TYPE tag makes two different record types
with coinciding field sets canonically distinct.  CD/0 sorts record entries by
key octets and refuses duplicate keys, so field ORDER here is not load-bearing
and the encoding is deterministic by construction."
  (lisp-plus-cd0:make-record-datum
   (cons (%iss-entry "record-type" (lisp-plus-cd0:make-string-datum type-name))
         entries)))

(defun %iss-symbol-datum (s)
  "An INTERNED symbol as a CD/0 identifier.  Refuses an uninterned symbol,
whose name alone would not distinguish it.  No printer, no host address."
  (unless (symbol-package s)
    (%iss-refuse "an uninterned symbol" s))
  (lisp-plus-cd0:make-identifier-datum
   '("common-lisp" "symbol")
   (list (package-name (symbol-package s)) (symbol-name s))))

;; The record encoders below are mutually recursive with %ISS-DATUM (a record
;; holds values; a value may be a record).  Declared here so the walker compiles
;; without forward-reference warnings, exactly as the shape of the data requires.
(declaim (ftype (function (t) t)
                %iss-process-context-datum %iss-event-datum %iss-attempt-datum
                %iss-uncertain-effect-datum %iss-manifestation-datum
                %iss-reconciliation-receipt-datum %iss-axis-datum
                %iss-determinacy-datum %iss-stream-relation-datum))

(defun %iss-datum (value)
  "Canonical CD/0 representation of one account value.

A CLOSED, ENUMERATED dispatcher — NOT a general serializer.  It has no default
branch: every scalar leaf it admits is converted by the GOVERNED kernel0
boundary (REQUIRE-CANONICAL) or by a named CD/0 constructor, every record it
admits is one of the enumerated Core /0 / Kernel /0 record types a Core /0
account can contain, and everything else REFUSES.  It reads no host address, no
pointer identity, no hash-table identity, and no printer output; it calls no
SXHASH.  Every CD/0 datum it builds is inert and snapshots its input, so no
mutable alias is retained.

NIL encodes as UNIT, T as BOOLEAN-TRUE, any other interned symbol as a symbol
identifier: three disjoint treatments, each total on its own domain.  (NIL is
both `absent` and `the empty list` in the host, so those two encode alike —
they are the same host value, and no two DISTINCT host values collide here.)

INHERITED CEILING, not widened: Slice /1 declares that a circular or
pathologically deep value diverges inside REQUIRE-CANONICAL's own recursion
rather than refusing.  This walker inherits that exposure unchanged."
  (cond
    ((null value) (lisp-plus-cd0:make-unit-datum))
    ((eq value t) (lisp-plus-cd0:make-boolean-datum t))
    ((stringp value) (lisp-plus-cd0:make-string-datum value))
    ((keywordp value) (lisp-plus-kernel0:require-canonical value))
    ((integerp value) (lisp-plus-kernel0:require-canonical value))
    ((lisp-plus-kernel0:durable-identity-p value)
     (lisp-plus-kernel0:require-canonical value))
    ((symbolp value) (%iss-symbol-datum value))
    ((consp value)
     (unless (%proper-list-p value) (%iss-refuse "a dotted list" value))
     (lisp-plus-cd0:make-sequence-datum (mapcar #'%iss-datum value)))
    ((process-context-p value) (%iss-process-context-datum value))
    ((lisp-plus-kernel0:kernel0-event-p value) (%iss-event-datum value))
    ((lisp-plus-kernel0:attempt-p value) (%iss-attempt-datum value))
    ((lisp-plus-kernel0:uncertain-effect-p value)
     (%iss-uncertain-effect-datum value))
    ((lisp-plus-kernel0:manifestation-p value) (%iss-manifestation-datum value))
    ((lisp-plus-kernel0:reconciliation-receipt-p value)
     (%iss-reconciliation-receipt-datum value))
    ((lisp-plus-kernel0:axis-p value) (%iss-axis-datum value))
    ((lisp-plus-kernel0:determinacy-p value) (%iss-determinacy-datum value))
    ((lisp-plus-kernel0:stream-relation-p value)
     (%iss-stream-relation-datum value))
    (t (%iss-refuse "an unenumerated host value" value))))

(defun %iss-process-context-datum (c)
  (%iss-record
   "core0/process-context"
   (list (%iss-entry "label" (%iss-datum (%process-context-label c)))
         (%iss-entry "process-id" (%iss-datum (%process-context-process-id c)))
         (%iss-entry "logical-operation-id"
                     (%iss-datum (%process-context-logical-operation-id c)))
         (%iss-entry "seat-id" (%iss-datum (%process-context-seat-id c))))))

(defun %iss-event-datum (e)
  "All TWELVE kernel0-event slots, each through its EXPORTED reader."
  (macrolet ((f (name reader)
               `(%iss-entry ,name (%iss-datum (,reader e)))))
    (%iss-record
     "kernel0/event"
     (list (f "event-type" lisp-plus-kernel0:kernel0-event-event-type)
           (f "extension-p" lisp-plus-kernel0:kernel0-event-extension-p)
           (f "process-id" lisp-plus-kernel0:kernel0-event-process-id)
           (f "logical-operation-id"
              lisp-plus-kernel0:kernel0-event-logical-operation-id)
           (f "seat-id" lisp-plus-kernel0:kernel0-event-seat-id)
           (f "attempt-id" lisp-plus-kernel0:kernel0-event-attempt-id)
           (f "external-request-id"
              lisp-plus-kernel0:kernel0-event-external-request-id)
           (f "exposure-id" lisp-plus-kernel0:kernel0-event-exposure-id)
           (f "machine-configuration-id"
              lisp-plus-kernel0:kernel0-event-machine-configuration-id)
           (f "effect-id" lisp-plus-kernel0:kernel0-event-effect-id)
           (f "manifestation-id" lisp-plus-kernel0:kernel0-event-manifestation-id)
           (f "payload" lisp-plus-kernel0:kernel0-event-payload)))))

(defun %iss-attempt-datum (a)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader a)))))
    (%iss-record
     "kernel0/attempt"
     (list (f "attempt-id" lisp-plus-kernel0:attempt-attempt-id)
           (f "logical-operation-id" lisp-plus-kernel0:attempt-logical-operation-id)
           (f "seat-id" lisp-plus-kernel0:attempt-seat-id)
           (f "process-id" lisp-plus-kernel0:attempt-process-id)
           (f "predecessor-attempts" lisp-plus-kernel0:attempt-predecessor-attempts)
           (f "exposure-id" lisp-plus-kernel0:attempt-exposure-id)
           (f "machine-configuration-id"
              lisp-plus-kernel0:attempt-machine-configuration-id)
           (f "external-request-id" lisp-plus-kernel0:attempt-external-request-id)
           (f "supersession-records"
              lisp-plus-kernel0:attempt-supersession-records)))))

(defun %iss-uncertain-effect-datum (u)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader u)))))
    (%iss-record
     "kernel0/uncertain-effect"
     (list (f "kind" lisp-plus-kernel0:uncertain-effect-kind)
           (f "attempt" lisp-plus-kernel0:uncertain-effect-attempt)
           (f "external-request" lisp-plus-kernel0:uncertain-effect-external-request)
           (f "possible-effects" lisp-plus-kernel0:uncertain-effect-possible-effects)
           (f "known-facts" lisp-plus-kernel0:uncertain-effect-known-facts)
           (f "reconciliation-procedure"
              lisp-plus-kernel0:uncertain-effect-reconciliation-procedure)
           (f "retry-policy" lisp-plus-kernel0:uncertain-effect-retry-policy)))))

(defun %iss-manifestation-datum (m)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader m)))))
    (%iss-record
     "kernel0/manifestation"
     (list (f "manifestation-id" lisp-plus-kernel0:manifestation-manifestation-id)
           (f "attempt-id" lisp-plus-kernel0:manifestation-attempt-id)
           (f "kind" lisp-plus-kernel0:manifestation-kind)
           (f "status" lisp-plus-kernel0:manifestation-status)
           (f "payload-id" lisp-plus-kernel0:manifestation-payload-id)
           (f "absence-state" lisp-plus-kernel0:manifestation-absence-state)
           (f "parser-id" lisp-plus-kernel0:manifestation-parser-id)
           (f "source-boundary" lisp-plus-kernel0:manifestation-source-boundary)
           (f "visibility" lisp-plus-kernel0:manifestation-visibility)
           (f "emptiness-rule-id" lisp-plus-kernel0:manifestation-emptiness-rule-id)
           (f "adapter-identity" lisp-plus-kernel0:manifestation-adapter-identity)
           (f "producer-identity" lisp-plus-kernel0:manifestation-producer-identity)
           (f "stream-relation" lisp-plus-kernel0:manifestation-stream-relation)))))

(defun %iss-stream-relation-datum (r)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader r)))))
    (%iss-record
     "kernel0/stream-relation"
     (list (f "stream-id" lisp-plus-kernel0:stream-relation-stream-id)
           (f "relation-kind" lisp-plus-kernel0:stream-relation-relation-kind)
           (f "chunk-record-ids" lisp-plus-kernel0:stream-relation-chunk-record-ids)
           (f "projection-receipt-id"
              lisp-plus-kernel0:stream-relation-projection-receipt-id)))))

(defun %iss-determinacy-datum (d)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader d)))))
    (%iss-record
     "kernel0/determinacy"
     (list (f "mode" lisp-plus-kernel0:determinacy-mode)
           (f "alternatives" lisp-plus-kernel0:determinacy-alternatives)
           (f "evidence" lisp-plus-kernel0:determinacy-evidence)))))

(defun %iss-axis-datum (a)
  "Every EXPORTED axis reader.

STATED EXCLUSION, not an omission: the kernel0 AXIS-NAME slot is an INTERNAL
discriminator with no exported reader (verified by live symbol-status
enumeration), so binding it would require a package-boundary violation in a
frozen layer.  It is not a core0-evidence account field; it is fixed by the
constructor that built the axis and is mirrored by the enclosing plist key of
the reconciliation receipt, which IS bound."
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader a)))))
    (%iss-record
     "kernel0/axis"
     (list (f "value" lisp-plus-kernel0:axis-value)
           (f "determinacy" lisp-plus-kernel0:axis-determinacy)
           (f "evidence" lisp-plus-kernel0:axis-evidence)
           (f "procedure-id" lisp-plus-kernel0:axis-procedure-id)
           (f "frontier-qualifier" lisp-plus-kernel0:axis-frontier-qualifier)
           (f "uncertain-effect-ref" lisp-plus-kernel0:axis-uncertain-effect-ref)
           (f "effect-group" lisp-plus-kernel0:axis-effect-group)
           (f "judgment-class" lisp-plus-kernel0:axis-judgment-class)
           (f "procedure-version" lisp-plus-kernel0:axis-procedure-version)))))

(defun %iss-reconciliation-receipt-datum (r)
  (macrolet ((f (name reader) `(%iss-entry ,name (%iss-datum (,reader r)))))
    (%iss-record
     "kernel0/reconciliation-receipt"
     (list (f "target-attempt-id"
              lisp-plus-kernel0:reconciliation-receipt-target-attempt-id)
           (f "procedure-id" lisp-plus-kernel0:reconciliation-receipt-procedure-id)
           (f "procedure-version"
              lisp-plus-kernel0:reconciliation-receipt-procedure-version)
           (f "new-evidence" lisp-plus-kernel0:reconciliation-receipt-new-evidence)
           (f "previous-axis-values+determinacy"
              lisp-plus-kernel0:reconciliation-receipt-previous-axis-values+determinacy)
           (f "resulting-axis-values+determinacy"
              lisp-plus-kernel0:reconciliation-receipt-resulting-axis-values+determinacy)
           (f "unresolved-residue"
              lisp-plus-kernel0:reconciliation-receipt-unresolved-residue)))))

(defun %core0-evidence-issuance-datum (evidence)
  "The canonical issuance content of EVIDENCE: an INERT Canonical Datum /0
value built from every semantic account field the erratum adopts
(R-ISSUANCE-0.4), including the internally stored canonical request — which is
bound here WITHOUT becoming publicly readable (R-ISSUANCE-0.11).

STATED EXCLUSION, decided rather than omitted: the `adapter` slot holds a LIVE
core0-adapter object whose DISPATCH and LEDGER-QUERY slots are host closures.
A closure has no canonical representation, and the object's pointer identity is
forbidden content (R-ISSUANCE-0.4).  What the slot canonically MEANS — which
adapter — is bound in full: the adapter's stable IDENTITY is already its own
account field, and the stored object's NAME and VERSION are bound beside it,
with an explicit presence flag.  Two adapter objects agreeing on identity, name
and version are canonically indistinguishable here, and that is the stated
ceiling."
  (let ((adapter (%core0-evidence-adapter evidence)))
    (%iss-record
     "core0/evidence-account"
     (list
      (%iss-entry "datum-format"
                  (lisp-plus-cd0:make-string-datum +core0-issuance-datum-format+))
      (%iss-entry "account-version"
                  (%iss-datum +core0-issuance-account-version+))
      (%iss-entry "process" (%iss-datum (%core0-evidence-process evidence)))
      (%iss-entry "attempt-id" (%iss-datum (%core0-evidence-attempt-id evidence)))
      (%iss-entry "seat-id" (%iss-datum (%core0-evidence-seat-id evidence)))
      (%iss-entry "adapter-identity"
                  (%iss-datum (%core0-evidence-adapter-identity evidence)))
      (%iss-entry "adapter-present" (%iss-datum (if adapter t nil)))
      (%iss-entry "adapter-name"
                  (%iss-datum (and adapter (core0-adapter-name adapter))))
      (%iss-entry "adapter-version"
                  (%iss-datum (and adapter (core0-adapter-version adapter))))
      (%iss-entry "request" (%iss-datum (%core0-evidence-request evidence)))
      (%iss-entry "events" (%iss-datum (%core0-evidence-events evidence)))
      (%iss-entry "manifestation"
                  (%iss-datum (%core0-evidence-manifestation evidence)))
      (%iss-entry "ledger-token"
                  (%iss-datum (%core0-evidence-ledger-token evidence)))
      (%iss-entry "reconciliation-receipts"
                  (%iss-datum (%core0-evidence-reconciliation-receipts evidence)))
      (%iss-entry "refusal-reason"
                  (%iss-datum (%core0-evidence-refusal-reason evidence)))))))

;;; ------------------------------------------------------------------
;;; The PRIVATE, IMAGE-LOCAL issuance registry of exact canonical contents.
;;; NOT exported, no public reader, no public writer (R-ISSUANCE-0.7).
;;;
;;; This is deliberately NOT modelled on the capability's liveness token.  That
;;; check is `(consp token)` — a slot that must be non-nil — which authorises
;;; copies and self-declared scopes; a token in a slot rides along with any
;;; structure copy.  There is no token here and no non-nil test: the key is the
;;; account's exact canonical octets, and the authority is a byte-for-byte
;;; comparison.

(defvar *core0-issuance-registry* (make-hash-table :test #'equal)
  "Exact canonical account contents issued by Core /0 in THIS image.  Keys are
the lowercase hex rendering of the canonical octets — an INDEX only; values are
fresh defensive copies of the octets themselves, which are the authority.  The
hex index is lossless (hex is injective on octet strings), so no collision is
possible AND no collision could establish issuance either way: the exact-octet
comparison below runs on every lookup and is what answers the question.")

(defun %core0-issuance-content (evidence)
  "(values INDEX-KEY EXACT-OCTETS) for EVIDENCE's CURRENT account content.

ONE encoding produces both, so the index can never name bytes other than the
ones returned beside it.  Recomputed on every call — never cached on the object
— so content mutation is DETECTED rather than papered over."
  (let ((encoded (lisp-plus-cd0:canonical-octets
                  (%core0-evidence-issuance-datum evidence))))
    (values (lisp-plus-cd0:octets-to-hex encoded)
            (lisp-plus-cd0:octets-copy encoded))))

(defun %core0-octets-identical-p (a b)
  "Byte-for-byte equality.  The authority of the registry."
  (and (= (length a) (length b))
       (loop for i below (length a) always (= (aref a i) (aref b i)))))

(defun %issue-core0-evidence (evidence)
  "Register EVIDENCE's exact canonical content as Core /0-issued in this image,
then return it.  Called ONLY at internal Core /0 evidence-minting sites, on a
value Core /0 itself just constructed — NEVER on a caller-supplied value, and
never merely because a value was presented to a public entry point."
  (multiple-value-bind (key octets) (%core0-issuance-content evidence)
    ;; both the key string and the stored octets are fresh, defensively-copied
    ;; values; the registry retains no caller-reachable structure.
    (setf (gethash key *core0-issuance-registry*) octets)
    evidence))

(defun %core0-issued-content-p (evidence)
  "Internal: is EVIDENCE's CURRENT canonical content registered as issued here?
The hex key only selects a candidate; the answer is the exact-octet comparison."
  (and (core0-evidence-p evidence)
       (multiple-value-bind (key octets) (%core0-issuance-content evidence)
         (let ((stored (gethash key *core0-issuance-registry*)))
           (and stored (%core0-octets-identical-p stored octets) t)))))

(defun %clear-core0-issuance-registry ()
  "Image hygiene / test isolation, after Slice /1's CLEAR-SCHEMA-REGISTRY
precedent — but INTERNAL: no public registry access is authorised
(R-ISSUANCE-0.7).  Core /0 had no reset path before this section; this is it.
Nothing in the registry's semantics depends on insertion order, so clearing and
re-issuing in any order reproduces the same answers."
  (clrhash *core0-issuance-registry*)
  (values))

(defun core0-evidence-current-image-issued-p (evidence)
  "Is EVIDENCE's CURRENT canonical account content registered as issued by the
Core /0 runtime in THIS Lisp image?

EXACT CEILING (Evidence Issuance Erratum /0, R-ISSUANCE-0.10).  A true answer
establishes AT MOST:

    this exact canonical account content was minted by the Core /0 runtime in
    this Lisp image.

It does NOT establish that the external-world deed occurred, that the provider
told the truth, that the adapter is honest, that the account's semantic
interpretation is correct, that the downstream domain proposition holds, or
that the effect is settled.  It is NOT a type predicate (that is
CORE0-EVIDENCE-P), NOT an external-truth predicate, NOT a settlement predicate,
NOT a domain-condition predicate, and NOT a persistence predicate.  No
cryptographic-security claim is made or implied.

Observable sensitivity: a genuine account and an EXACT COPY of one both answer
true; a blank object, a coherent caller-built account, a caller-built account
reusing a genuine attempt identity, and a genuine account whose content has
been mutated all answer false — and a mutated account answers true again once
its content is restored exactly.

It CONSULTS the private registry and does not mutate it; it does not consult
the adapter's ledger; and it infers issuance from no proxy — not from type, not
from attempt identity, not from event validation, not from the fold, not from
adapter identity, not from a ledger token, not from a procedure identity.

Answers false — never signals — for a value that is not a core0-evidence, and
for an account whose content has no canonical representation at all."
  (handler-case (%core0-issued-content-p evidence)
    (error () nil)))

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
         ;; ISSUANCE SITE 1 of 4 — a pre-frontier refusal genuinely issues a
         ;; Core /0 account (it rides out inside the typed condition), so it is
         ;; registered before it escapes (R-ISSUANCE-0.8).
         (evidence (%issue-core0-evidence
                    (%make-core0-evidence
                     :process process :attempt-id attempt-id :seat-id seat
                     :adapter-identity adapter-identity :request request
                     :events events* :manifestation nil :ledger-token nil
                     :reconciliation-receipts nil :refusal-reason reason)))
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
                    ;; ISSUANCE SITE 2 of 4 — the clean commit.
                    (evidence (%issue-core0-evidence
                               (%make-core0-evidence
                                :process process :attempt-id attempt-id :seat-id seat
                                :adapter-identity adapter-identity :adapter adapter-obj
                                :request nf :events events :manifestation manifestation
                                :ledger-token ledger-token
                                :reconciliation-receipts nil :refusal-reason nil))))
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
                    ;; ISSUANCE SITE 3 of 4 — the W1-shaped interruption.  The
                    ;; surviving account rides out inside core0-interrupted and
                    ;; is precisely the value continue-from later consumes, so
                    ;; it MUST be registered before it escapes.
                    (evidence (%issue-core0-evidence
                               (%make-core0-evidence
                                :process process :attempt-id attempt-id :seat-id seat
                                :adapter-identity adapter-identity :adapter adapter-obj
                                :request nf :events events :manifestation nil
                                :ledger-token nil ; the program was NOT told a token
                                :reconciliation-receipts nil :refusal-reason nil))))
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
  "Continue an interrupted attempt from its SURVIVING evidence — where
`surviving` now has a definition and a check (Evidence Issuance Erratum /0,
R-ISSUANCE-0.5/0.6): a core0-evidence whose EXACT CURRENT canonical account
content is registered as issued by Core /0 in this Lisp image.  An exact
defensive copy of an issued account survives; a structurally coherent account
that was never issued does not, and neither does an issued account whose
content has since changed.

Derives standing from the events (never self-report); PROVES blind retry unsafe
via live check-retry-safety and refuses it; reconciles against the adapter's
ledger (a witness of limited jurisdiction).  ADAPTER is the live adapter;
AUTHORITY a FRESH live capability (a historical mint-receipt is refused — a
record that authority existed is not live authority).  Returns a
continuation-result.

For content that is not registered as issued here, NOTHING authority-bearing
happens: the adapter's ledger is not consulted, no reconciliation receipt is
minted, no replacement evidence is issued, and no runtime-issued record is
derived from the supplied account.  The refusal means exactly that the content
is not known to have been issued by Core /0 in this image; it makes no claim
about how the value was produced."
  (unless (core0-evidence-p evidence)
    (signal-core0 'malformed-request
                  :failed-invariant "CONTINUE-FROM requires core0-evidence"
                  :offending-field :evidence :offending-value evidence))
  ;; Issuance check — the EARLIEST point after basic type checking, and before
  ;; every authority-bearing action: before the authority check, before adapter
  ;; resolution, before the fold, before the ledger query, before any receipt.
  (unless (%core0-issued-content-p evidence)
    (signal-core0 'unissued-evidence
                  :failed-invariant
                  "continue-from continues from evidence Core /0 issued: this ~
value's current canonical account content is not registered as Core /0-issued ~
in this image, so no ledger is consulted and no receipt is minted"
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
                ;; ISSUANCE SITE 4 of 4 — the replacement evidence a VALIDATED
                ;; continue-from mints.  Reached only after the issuance check
                ;; below has accepted the supplied account.
                (evidence* (%issue-core0-evidence
                            (%make-core0-evidence
                             :process process :attempt-id attempt-id :seat-id seat
                             :adapter-identity (%core0-evidence-adapter-identity evidence)
                             :adapter adapter-obj :request request
                             :events events* :manifestation manifestation
                             :ledger-token token
                             :reconciliation-receipts (list receipt)
                             :refusal-reason nil))))
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
