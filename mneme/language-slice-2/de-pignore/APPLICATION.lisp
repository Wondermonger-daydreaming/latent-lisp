;;;; APPLICATION.lisp — de-pignore, concerning the pledge.   REVIEW-1 HARDENED.
;;;;
;;;; AN APPLICATION-PRIVATE SPECIMEN.  Not Language Obligation /0.  Nothing here
;;;; is exported from any governing package, nothing earns public standing, and
;;;; no governing layer is modified.
;;;;
;;;; THE SINGLE QUESTION:
;;;;
;;;;   Can an explicitly elected evidentiary requirement concerning one exact
;;;;   Slice /2 premise remain identifiable and open across unrelated intervening
;;;;   derivations, then be reconciled by an admissible witness under the
;;;;   retained rule, without creating a new language layer and without mutating
;;;;   an object from :OPEN to :CLOSED?
;;;;
;;;; ---------------------------------------------------------------------------
;;;; REVIEW 1 — what this file used to claim, and what it actually did.
;;;; The before-repair witness is REVIEW-1-EVIDENCE.txt; 6 of 7 counterexamples
;;;; reproduced.  Every one was a LABEL standing in for the thing it named:
;;;;
;;;;   R1  "a re-registered schema makes the obligation unaddressable"
;;;;       -> tested only that the CALLER's wrapper was not EQ to the stored one.
;;;;          Handing back the ORIGINAL wrapper reconciled happily.
;;;;   R2  "distinct obligations have distinct identities"
;;;;       -> content-equal obligations shared one identity; A's receipt closed B.
;;;;   R3  "admissible witness for this exact premise"
;;;;       -> compared witness MODE and KIND and nothing else.  A witness about a
;;;;          DIFFERENT VESSEL reconciled.
;;;;   R4  PLEDGE verified no relation between receipt and live schema at all.
;;;;   R5  two distinct elected acts were indistinguishable by identity.
;;;;   R6  "canonical" was PRIN1-TO-STRING -> READ-FROM-STRING, which leaked
;;;;       PRINT-NOT-READABLE, REJECTED CD/0 data, and did not terminate on a
;;;;       circular cons.
;;;;   R7  the reconciliation receipt had no identity of its own.
;;;;
;;;; All seven are repaired below and each has a tooth.
;;;; ---------------------------------------------------------------------------
;;;;
;;;; WHAT THE SHAPE IS BORROWED FROM.  Kernel /0's unresolved-effect carries no
;;;; resolved flag ("no record-local resolved flag exists" —
;;;; kernel0/uncertain-effect.lisp:52) and openness is derived by folding events
;;;; (kernel0/folds.lisp:447); a reconciliation resolves only when the result is
;;;; determinate AND residue is NIL (folds.lisp:421).  This specimen reproduces
;;;; that SHAPE over a NON-EFFECT SUBJECT and imports no Kernel /0 record type.
;;;;
;;;; DECLARED SCOPE RESTRICTION (§4).  The specimen is narrowed to:
;;;;   one ground premise · one asserted-witness contract ·
;;;;   no receiver-dependent accessibility beyond the probe's own receiver ·
;;;;   no cross-premise binding dependency.
;;;; Within that restriction admissibility is decided by the REAL Slice /2 path
;;;; (a controlled DERIVE/2 probe), never by a private re-implementation.
;;;;
;;;; WHAT THIS SPECIMEN DOES NOT SHOW:
;;;;   * NO PERSISTENCE.  PJ0 is adopted as a spec but no journal store is wired
;;;;     into Kernel /0's in-memory core.  The fold consumes a caller-supplied
;;;;     ordered list.  No store, no replay, no cross-image claim.
;;;;   * NO GLOBAL EXACTLY-ONCE.  :ALREADY-RECONCILED is enforceable only
;;;;     relative to the history the caller supplies.  See §IX and check T24.
;;;;   * NO AUTHORITY.  A reconciliation receipt mints no claim, source basis,
;;;;     derivation basis, capability, authority or standing.
;;;;   * IN-IMAGE ADDRESSABILITY ONLY.  Liveness is an EQ test against the
;;;;     currently registered Slice /1 base object.  It is never dressed up as a
;;;;     durable cross-image identity.
;;;;   * PLEDGE verifies receipt/context concordance and live base anatomy.  It
;;;;     does NOT prove which Slice /2 wrapper object was passed to the earlier
;;;;     DERIVE/2 call; the substrate does not record that.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp

(unless (find-package :lisp-plus-slice2)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../slice2.lisp" *load-truename*))))

(defpackage #:de-pignore (:use #:cl))
(in-package #:de-pignore)

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

;;; ==================================================================
;;; 0.  THE SNAPSHOT BOUNDARY  (§6 — READ-FROM-STRING removed)
;;;
;;; Option B of the ruling: an explicitly IN-IMAGE boundary with a strict private
;;; tree vocabulary and a bounded defensive copier.  No printer, no reader, no
;;; READ-EVAL path, and no PRINT-OBJECT method can define identity here.
;;;
;;; The word "canonical" is reserved for actual Canonical Datum /0 values.  What
;;; this produces is a DEFENSIVE SNAPSHOT.

(define-condition unsupported-snapshot-value (error)
  ((value :initarg :value :reader unsupported-snapshot-value-value)
   (why   :initarg :why   :reader unsupported-snapshot-value-why))
  (:report (lambda (c s) (format s "unsupported value in snapshot: ~A"
                                 (unsupported-snapshot-value-why c)))))

(defparameter +snapshot-depth-limit+ 64)

(defun %snapshot (x &optional (depth 0) (seen nil))
  "Bounded defensive copy over a STRICT private vocabulary.
Accepted leaves: keyword, symbol, integer, ratio, character, string, any CD/0
DATUM, and any Kernel /0 DURABLE-IDENTITY (the last two accepted opaquely and by
reference — both are already immutable identity-bearing values, and R6 showed the
old boundary wrongly rejected CD/0 data outright).
Everything else, and any cycle, is a TYPED refusal."
  (when (> depth +snapshot-depth-limit+)
    (error 'unsupported-snapshot-value :value x :why "nesting deeper than the snapshot depth limit"))
  (cond
    ((null x) nil)
    ((keywordp x) x)
    ((symbolp x) x)
    ((integerp x) x)
    ((rationalp x) x)
    ((characterp x) x)
    ((stringp x) (copy-seq x))
    ((lisp-plus-cd0:datum-p x) x)          ; immutable canonical datum, by reference
    ((lisp-plus-kernel0:durable-identity-p x) x)   ; a durable identity IS an
                                           ; immutable identity value; admitting
                                           ; it by reference is the point
    ((consp x)
     (when (member x seen :test #'eq)
       (error 'unsupported-snapshot-value :value x :why "circular structure"))
     (let ((seen (cons x seen)))
       (cons (%snapshot (car x) (1+ depth) seen)
             (%snapshot (cdr x) (1+ depth) seen))))
    (t (error 'unsupported-snapshot-value :value x
              :why (format nil "~A is outside the snapshot vocabulary" (type-of x))))))

;;; ==================================================================
;;; I.  THE THREE APPLICATION-PRIVATE SPECIES
;;;
;;; Absent by design, each for a stated reason:
;;;   OPEN-OBLIGATION / DISCHARGED-OBLIGATION — openness is folded; the SAME
;;;     object stays in history after reconciliation, so openness must not be in
;;;     the type name.
;;;   DISCHARGE-ATTEMPT — the attempt IS the transition; its result is a receipt
;;;     or a refusal.  The live APIs never required a fourth persistent object.
;;;   OBLIGATION-SCHEMA — Slice /1 schemas + Slice /2 contracts are the rule layer.
;;;   OBLIGATION-REGISTRY — the fold takes its events as an argument.
;;;   OBLIGATION-STATUS — no mutable status field is permitted.
;;;
;;; NAMING.  It is an OBLIGATION-RECONCILIATION-RECEIPT, never a "discharge"
;;; receipt: a receipt may carry residue, and a name claiming discharge would let
;;; the label impersonate the event.

(defstruct (obligation (:constructor %make-obligation) (:copier nil)
                       (:conc-name %obligation-))
  ;; §2 — TWO distinguishable notions of identity.
  (occurrence-identity nil :read-only t)   ; WHICH elected act produced this
  (content-identity    nil :read-only t)   ; WHAT was pledged
  (pledge-act-id       nil :read-only t)   ; the explicit opening-act identity
  (pledge-intent       nil :read-only t)
  (refused-receipt-id  nil :read-only t)
  (premise-index       nil :read-only t)
  (subject-description nil :read-only t)
  (scope-description   nil :read-only t)
  (contract            nil :read-only t)   ; retained BY VALUE
  (contract-snapshot   nil :read-only t)   ; §5 — COMPLETE, inspectable
  (procedure-id        nil :read-only t)
  (procedure-version   nil :read-only t)
  (base-anchor         nil :read-only t)   ; §3 — the Slice /1 BASE object
  (schema-name         nil :read-only t)
  (schema-version      nil :read-only t)
  (conclusion          nil :read-only t))   ; retained so the probe can re-derive

(defstruct (obligation-reconciliation-receipt
            (:constructor %make-orr) (:copier nil) (:conc-name %orr-))
  (identity                   nil :read-only t)   ; §7 — its OWN identity
  (target-occurrence-identity nil :read-only t)
  (target-content-identity    nil :read-only t)
  (procedure-id               nil :read-only t)
  (procedure-version          nil :read-only t)
  (proposed-witness-snapshot  nil :read-only t)
  (retained-rule-snapshot     nil :read-only t)
  (previous-commitment        nil :read-only t)
  (resulting-commitment       nil :read-only t)
  (unresolved-residue         nil :read-only t)
  (disposition                nil :read-only t))

(defstruct (obligation-refusal
            (:constructor %make-obligation-refusal) (:copier nil)
            (:conc-name %oref-))
  (phase                      nil :read-only t)   ; §8 — :PLEDGE or :RECONCILE
  (target-occurrence-identity nil :read-only t)
  (reason                     nil :read-only t)
  (detail                     nil :read-only t)
  (offending-snapshot         nil :read-only t))

;;; ------------------------------------------------------------------
;;; APPLICATION-FACING READERS  (§2 — REVIEW 2)
;;;
;;; REVIEW 2 / D1: read-only DEFSTRUCT slots prevent slot REPLACEMENT.  They do
;;; NOT make a mutable value reachable through a reader immutable.  Every reader
;;; below previously handed the caller the stored cons, and D1 showed all six
;;; aliased: a caller holding only a READER could mutate an obligation's own
;;; identity, scope and retained contract.  Worse, the receipt's target and the
;;; obligation's identity were literally THE SAME CONS, so a caller could move
;;; BOTH SIDES of the fold's comparison at once and the tampering was invisible
;;; to it.
;;;
;;; Every aggregate-valued application-facing reader now returns a DEFENSIVE
;;; SNAPSHOT.  Internal % accessors still hand exact objects to trusted
;;; implementation code, which is where structure sharing is correct.
;;;
;;; OBLIGATION-CONTRACT and OBLIGATION-BASE-ANCHOR are REMOVED.  Both were unused
;;; convenience readers (no call site existed) exposing a live Slice /2 contract
;;; object and a live Slice /1 schema object.  Handing out the base anchor would
;;; leak the very object liveness is tested against.
;;;
;;; No writer is defined anywhere in this file.

(defun obligation-occurrence-identity (o) (%snapshot (%obligation-occurrence-identity o)))
(defun obligation-content-identity (o) (%snapshot (%obligation-content-identity o)))
(defun obligation-pledge-act-id (o) (%snapshot (%obligation-pledge-act-id o)))
(defun obligation-scope-description (o) (%snapshot (%obligation-scope-description o)))
(defun obligation-contract-snapshot (o) (%snapshot (%obligation-contract-snapshot o)))
(defun orr-identity (r) (%snapshot (%orr-identity r)))
(defun orr-target-occurrence (r) (%snapshot (%orr-target-occurrence-identity r)))
(defun orr-residue (r) (%snapshot (%orr-unresolved-residue r)))
(defun orr-resulting-commitment (r) (%orr-resulting-commitment r))   ; keyword atom
(defun orr-disposition (r) (%orr-disposition r))                     ; keyword atom
(defun oref-reason (r) (%oref-reason r))                             ; keyword atom
(defun oref-phase (r) (%oref-phase r))                               ; keyword atom
(defun oref-snapshot (r) (%snapshot (%oref-offending-snapshot r)))

;;; ------------------------------------------------------------------
;;; §5 — the COMPLETE contract snapshot, from public Slice /2 readers.

(defun %contract-snapshot (c)
  (list :contract-id            (lisp-plus-slice2:support-admission-contract-contract-id c)
        :contract-version       (lisp-plus-slice2:support-admission-contract-contract-version c)
        :accepted-clauses       (%snapshot (lisp-plus-slice2:support-admission-contract-accepted-clauses c))
        :proposition-relation   (lisp-plus-slice2:support-admission-contract-proposition-relation c)
        :receiver-accessibility (lisp-plus-slice2:support-admission-contract-receiver-accessibility c)
        :retain                 (%snapshot (lisp-plus-slice2:support-admission-contract-retain c))
        :truth-ceilings         (%snapshot (lisp-plus-slice2:support-admission-contract-truth-ceilings c))))

(defparameter +procedure-id+ :de-pignore/reconcile-elected-premise)
(defparameter +procedure-version+ 1)      ; bumped by REVIEW-1 hardening

;;; ------------------------------------------------------------------
;;; §2 — content identity EXCLUDES the act; occurrence identity INCLUDES it.

(defun %content-identity (act-intent receipt-id premise-index subject scope
                          contract-snapshot schema-name schema-version)
  (list :de-pignore/obligation-content
        :intent            act-intent
        :refused-receipt   receipt-id
        :premise-index     premise-index
        :subject           subject
        :scope             scope
        :contract-snapshot contract-snapshot
        :schema            (list schema-name schema-version)
        :procedure         +procedure-id+
        :procedure-version +procedure-version+))

(defun %occurrence-identity (act-id content-identity)
  (list :de-pignore/obligation-occurrence
        :pledge-act-id act-id
        :content       content-identity))

;;; ==================================================================
;;; II.  PLEDGE — the elected opening act   (§2, §3, §8)

(define-condition pledge-refused (error)
  ((refusal :initarg :refusal :reader pledge-refused-refusal))
  (:report (lambda (c s)
             (let ((r (pledge-refused-refusal c)))
               (format s "PLEDGE refused: ~A — ~A" (oref-reason r) (%oref-detail r))))))

(defun pledge-refused-reason (c) (oref-reason (pledge-refused-refusal c)))

(defun %pledge-refusal (reason detail &optional offending)
  (%make-obligation-refusal
   :phase :pledge :target-occurrence-identity nil
   :reason reason :detail detail
   :offending-snapshot (ignore-errors (%snapshot offending))))

(defun try-pledge (&key refused-receipt premise-index pledge-act-id pledge-intent
                        scope-description live-schema)
  "The quiet form.  Returns (values OBLIGATION nil) or (values nil REFUSAL).
Every refusal is a persistent, inspectable OBLIGATION-REFUSAL carrying an
offending snapshot — §8."
  (macrolet ((refuse (reason detail &optional offending)
               `(return-from try-pledge
                  (values nil (%pledge-refusal ,reason ,detail ,offending)))))
    (unless pledge-act-id
      (refuse :no-opening-act
              "PLEDGE requires an explicit opening-act identity; intention content is not occurrence identity"))
    (unless pledge-intent
      (refuse :no-elected-intent
              "a :MISSING disposition does not make an obligation; PLEDGE requires an explicit pledge-intent"))
    (unless (lisp-plus-slice2:slice2-receipt-p refused-receipt)
      (refuse :not-a-slice2-receipt "PLEDGE requires the exact refused Slice /2 derivation receipt"
              (type-of refused-receipt)))
    (unless (lisp-plus-slice2:slice2-schema-p live-schema)
      (refuse :not-a-slice2-schema ":LIVE-SCHEMA must be a Slice /2 schema value"
              (type-of live-schema)))
    ;; ---- §3: receipt / context concordance -------------------------------
    (let* ((base (lisp-plus-slice2:slice2-schema-base-schema live-schema))
           (name (lisp-plus-slice1:judgment-schema-name base))
           (version (lisp-plus-slice1:judgment-schema-version base))
           (premises (lisp-plus-slice1:judgment-schema-premises base))
           ;; §3 REVIEW 2 / D2: catch ONLY the documented absent-schema condition.
           ;; A broad (ERROR () NIL) here laundered a planted registry failure into
           ;; :BASE-SCHEMA-NO-LONGER-LIVE — an implementation failure wearing a
           ;; protocol outcome's name.  Anything unexpected now ESCAPES.
           (registered (handler-case (lisp-plus-slice1:resolve-schema name version)
                         (lisp-plus-slice1:schema-not-found () nil))))
      ;; R4: the receipt must belong to THIS schema.
      ;;
      ;; MEASURED LIMITATION, not assumed.  SLICE2-RECEIPT-SCHEMA-ID/-VERSION
      ;; report the SLICE /2 WRAPPER's id and version (measured: :SEAWORTHY/2
      ;; and 0), while the base carries (:SEAWORTHY . 1).  Slice /2 exports no
      ;; reader for a live wrapper's own id or version, so those values cannot be
      ;; compared directly against the supplied context.  Concordance is therefore
      ;; established by ANATOMY — premise-index bounds, the retained premise
      ;; pattern, and the COMPLETE contract snapshot, all checked below.  That is
      ;; strictly weaker than an identifier comparison, and it is stated here
      ;; rather than papered over.
      ;; R1: the live base must BE the currently registered object.
      (unless (and registered (eq registered base))
        (refuse :base-schema-no-longer-live
                "this Slice /2 context's base schema is not the object currently registered under its name and version"
                (list :schema name :version version :registered-p (and registered t))))
      (unless (and (integerp premise-index) (< -1 premise-index (length premises)))
        (refuse :no-such-premise "the live schema has no premise at that index"
                (list :premise-index premise-index :premise-count (length premises))))
      (let ((admission (find premise-index
                             (lisp-plus-slice2:slice2-receipt-admissions refused-receipt)
                             :key #'lisp-plus-slice2:premise-admission-index :test #'eql)))
        (unless admission
          (refuse :no-such-premise "the receipt carries no premise at that index" premise-index))
        (unless (eq :missing (lisp-plus-slice2:premise-admission-base-disposition admission))
          (refuse :premise-not-missing "that premise is not :MISSING — nothing is owed"
                  (lisp-plus-slice2:premise-admission-base-disposition admission)))
        ;; R4/§3: retained premise pattern must agree with the live premise.
        (let ((retained-pattern (lisp-plus-slice2:premise-admission-premise-pattern admission))
              (live-pattern (nth premise-index premises)))
          ;; MEASURED: PREMISE-ADMISSION-PREMISE-PATTERN already returns the
          ;; NORMAL FORM (a cons), not a PROPOSITION-PATTERN object; the live
          ;; premise is a pattern object and must be normalized to compare.
          (unless (equal retained-pattern
                         (lisp-plus-slice1:proposition-pattern-normal-form live-pattern))
            (refuse :premise-anatomy-drift
                    "the receipt's retained premise pattern disagrees with the live premise at that index"
                    (list :retained retained-pattern
                          :live (lisp-plus-slice1:proposition-pattern-normal-form live-pattern)))))
        ;; §5/§3: retained contract must agree with the live contract, in FULL.
        (let* ((retained (lisp-plus-slice2:premise-admission-contract admission))
               (live-contract (lisp-plus-slice2:slice2-schema-contract-for-premise
                               live-schema premise-index))
               (retained-snap (%contract-snapshot retained)))
          (unless (and live-contract
                       (equal retained-snap (%contract-snapshot live-contract)))
            (refuse :contract-drift
                    "the receipt's retained contract disagrees with the live contract for that premise"
                    (list :retained retained-snap
                          :live (and live-contract (%contract-snapshot live-contract)))))
          ;; ---- snapshots (may themselves refuse) ---------------------------
          (let (act intent scope subject)
            (handler-case
                (setf act     (%snapshot pledge-act-id)
                      intent  (%snapshot pledge-intent)
                      scope   (%snapshot scope-description)
                      subject (%snapshot (lisp-plus-slice2:premise-admission-premise-pattern admission)))
              (unsupported-snapshot-value (e)
                (refuse :unsupported-snapshot-value
                        (unsupported-snapshot-value-why e)
                        (type-of (unsupported-snapshot-value-value e)))))
            (let* ((content (%content-identity intent
                                               (lisp-plus-slice2:slice2-receipt-identity refused-receipt)
                                               premise-index subject scope retained-snap
                                               name version))
                   (occurrence (%occurrence-identity act content)))
              (values
               (%make-obligation
                :occurrence-identity occurrence
                :content-identity content
                :pledge-act-id act
                :pledge-intent intent
                :refused-receipt-id (lisp-plus-slice2:slice2-receipt-identity refused-receipt)
                :premise-index premise-index
                :subject-description subject
                :scope-description scope
                :contract retained
                :contract-snapshot retained-snap
                :procedure-id +procedure-id+
                :procedure-version +procedure-version+
                :base-anchor base            ; the SLICE /1 BASE, not the wrapper
                :schema-name name
                :schema-version version
                :conclusion (lisp-plus-slice2:slice2-receipt-conclusion refused-receipt))
               nil))))))))

(defun pledge (&rest args)
  "The loud wrapper.  Signals PLEDGE-REFUSED carrying the same persistent
OBLIGATION-REFUSAL that TRY-PLEDGE would have returned."
  (multiple-value-bind (ob refusal) (apply #'try-pledge args)
    (if ob ob (error 'pledge-refused :refusal refusal))))

;;; ==================================================================
;;; III.  TRY-RECONCILE-OBLIGATION      (§3, §4, §7)

(defun %call-derive/2-probe (live-schema conclusion witness receiver)
  "§3 REVIEW 2 / D2 — the ONLY place the probe touches DERIVE/2.

Catches EXACTLY the two documented protocol outcomes and nothing else:
  SLICE2-DERIVATION-REFUSED  an ordinary refusal, whose receipt is the datum the
                             probe needs to inspect;
  SLICE2-SCHEMA-ERROR        the documented unaddressable-schema condition.

An unexpected SIMPLE-ERROR, type error, or any other unclassified condition
ESCAPES, so the harness classifies it as an implementation failure instead of
letting it become :PREMISE-NOT-SATISFIED.  D2 showed the old broad handler
laundered exactly that.

This wrapper exists only to make the distinction testable.  It is not a policy
seam and accepts no caller-supplied procedure."
  (handler-case
      (nth-value 1 (lisp-plus-slice2:derive/2
                    :schema live-schema :conclusion conclusion
                    :supports (list witness) :receiver receiver))
    (lisp-plus-slice2:slice2-derivation-refused (c)
      (lisp-plus-slice2:slice2-condition-receipt c))
    (lisp-plus-slice2:slice2-schema-error () nil)))

(defun %probe-admission (obligation witness live-schema)
  "§4 — decide admissibility through the REAL Slice /2 path.

Runs the existing public DERIVE/2 as a CONTROLLED PROBE carrying the proposed
witness, and inspects the TARGET premise's own PREMISE-ADMISSION.  The overall
derivation may legitimately remain REFUSED because other premises are absent —
that is not the fact under test.  The fact under test is whether Slice /2, under
the retained contract and the live schema, reports THIS premise :SATISFIED.

No private re-implementation of admission exists in this file."
  (let* ((idx (%obligation-premise-index obligation))
         (conclusion (%obligation-conclusion obligation))
         (receiver (lisp-plus-slice0:receiver-context
                    :context-id :de-pignore/probe
                    :accessible-supports (list (lisp-plus-slice0:witness-id witness))))
         (receipt (%call-derive/2-probe live-schema conclusion witness receiver)))
    (if (null receipt)
        (values nil :probe-unavailable)
        (let ((a (find idx (lisp-plus-slice2:slice2-receipt-admissions receipt)
                       :key #'lisp-plus-slice2:premise-admission-index :test #'eql)))
          (if (null a)
              (values nil :no-such-premise-in-probe)
              (values (eq :satisfied (lisp-plus-slice2:premise-admission-disposition a))
                      (lisp-plus-slice2:premise-admission-disposition a)))))))

(defun try-reconcile-obligation (&key obligation proposed-witness live-schema
                                      (history nil))
  (let ((occ (%obligation-occurrence-identity obligation)))
    (macrolet ((refuse (reason detail &optional offending)
                 `(return-from try-reconcile-obligation
                    (values nil (%make-obligation-refusal
                                 :phase :reconcile
                                 :target-occurrence-identity occ
                                 :reason ,reason :detail ,detail
                                 :offending-snapshot (ignore-errors (%snapshot ,offending)))))))
      ;; (a) already reconciled, relative to the SUPPLIED history — §9.
      (unless (obligation-open-p obligation history)
        (refuse :already-reconciled
                "the supplied history already derives this obligation as not open; no second discharge is minted"
                (list :history-length (length history))))
      (unless (lisp-plus-slice2:slice2-schema-p live-schema)
        (refuse :not-a-slice2-schema ":LIVE-SCHEMA must be a Slice /2 schema value"
                (type-of live-schema)))
      ;; (b) R1 — LIVENESS IS AGAINST THE REGISTRY, not against the caller's object.
      (let* ((base (lisp-plus-slice2:slice2-schema-base-schema live-schema))
             (name (%obligation-schema-name obligation))
             (version (%obligation-schema-version obligation))
             ;; §3 REVIEW 2 / D2 — as above: only the documented condition.
             (registered (handler-case (lisp-plus-slice1:resolve-schema name version)
                           (lisp-plus-slice1:schema-not-found () nil))))
        (unless (eq base (%obligation-base-anchor obligation))
          (refuse :base-schema-no-longer-live
                  "the supplied Slice /2 context does not carry the base schema this obligation was opened against"))
        (unless (and registered (eq registered (%obligation-base-anchor obligation)))
          (refuse :base-schema-no-longer-live
                  "the base schema this obligation was opened against is no longer the object registered under its name and version; the same wrapper object cannot make a stale context look live"
                  (list :schema name :version version)))
        ;; (c) contract concordance still holds.
        (let ((live-contract (lisp-plus-slice2:slice2-schema-contract-for-premise
                              live-schema (%obligation-premise-index obligation))))
          (unless (and live-contract
                       (equal (%obligation-contract-snapshot obligation)
                              (%contract-snapshot live-contract)))
            (refuse :contract-drift
                    "the live contract for the target premise no longer matches the retained rule")))
        ;; (d) §4 — admissibility decided by the REAL Slice /2 path.
        (unless (lisp-plus-slice0:witness-p proposed-witness)
          (refuse :not-a-witness "the proposed reconciling support is not a witness"
                  (type-of proposed-witness)))
        (multiple-value-bind (satisfied disposition)
            (%probe-admission obligation proposed-witness live-schema)
          (unless satisfied
            (refuse :premise-not-satisfied
                    "under the retained contract and the live schema, DERIVE/2 does not report the target premise :SATISFIED for this witness"
                    (list :disposition disposition
                          :witness-for (lisp-plus-slice0:witness-for proposed-witness)
                          :witness-mode (lisp-plus-slice0:witness-mode proposed-witness)
                          :witness-kind (lisp-plus-slice0:witness-kind proposed-witness))))
          ;; (e) reconciled — §7: the receipt gets its OWN identity.
          (let* ((wsnap (%snapshot (list :witness-id (lisp-plus-slice0:witness-id proposed-witness)
                                         :for (lisp-plus-slice0:witness-for proposed-witness)
                                         :mode (lisp-plus-slice0:witness-mode proposed-witness)
                                         :kind (lisp-plus-slice0:witness-kind proposed-witness))))
                 (rule (%obligation-contract-snapshot obligation))
                 (identity (list :de-pignore/reconciliation
                                 :target-occurrence occ
                                 :target-content (%obligation-content-identity obligation)
                                 :witness wsnap
                                 :rule rule
                                 :procedure (%obligation-procedure-id obligation)
                                 :procedure-version (%obligation-procedure-version obligation)
                                 :previous :owed
                                 :resulting :reconciled
                                 :residue nil
                                 :disposition :reconciled)))
            (values (%make-orr
                     :identity identity
                     :target-occurrence-identity occ
                     :target-content-identity (%obligation-content-identity obligation)
                     :procedure-id (%obligation-procedure-id obligation)
                     :procedure-version (%obligation-procedure-version obligation)
                     :proposed-witness-snapshot wsnap
                     :retained-rule-snapshot rule
                     :previous-commitment :owed
                     :resulting-commitment :reconciled
                     :unresolved-residue nil
                     :disposition :reconciled)
                    nil)))))))

;;; ==================================================================
;;; IV.  OBLIGATION-OPEN-P — openness DERIVED, with EXACT conjuncts   (§7)
;;;
;;; A receipt closes an obligation only when ALL of these hold:
;;;   1. it targets the exact obligation OCCURRENCE identity;
;;;   2. it targets the exact obligation CONTENT identity;
;;;   3. procedure identity matches;
;;;   4. procedure version matches;
;;;   5. previous commitment is :OWED;
;;;   6. resulting commitment is :RECONCILED;
;;;   7. disposition is :RECONCILED;
;;;   8. unresolved residue is NIL.
;;; Refusals never alter the fold.  Nothing else in the history is consulted.

(defun %receipt-closes-p (obligation r)
  (and (equal (%orr-target-occurrence-identity r) (%obligation-occurrence-identity obligation))
       (equal (%orr-target-content-identity r) (%obligation-content-identity obligation))
       (eq (%orr-procedure-id r) (%obligation-procedure-id obligation))
       (eql (%orr-procedure-version r) (%obligation-procedure-version obligation))
       (eq (%orr-previous-commitment r) :owed)
       (eq (%orr-resulting-commitment r) :reconciled)
       (eq (%orr-disposition r) :reconciled)
       (null (%orr-unresolved-residue r))))

(defun obligation-open-p (obligation history)
  "Derived from the immutable obligation plus the caller-supplied ordered history.
Consults no status slot (none exists), no global archive, no ambient state.

§9 LIMIT: exactness is relative to the history supplied.  A caller who omits a
prior receipt can obtain another reconciliation.  The specimen has no store from
which to know otherwise and does NOT claim global exactly-once discharge."
  (let ((open t))
    (dolist (event history open)
      (when (and (obligation-reconciliation-receipt-p event)
                 (%receipt-closes-p obligation event))
        (setf open nil)))))

;;; ==================================================================
;;; V.  THE DOMAIN — a dry-dock survey desk
;;;
;;; Two premises, DIFFERENT contracts.  The ballast premise demands an ASSAY; a
;;; ballast SURVEY — same subject, similar prose, wrong instrument — is not
;;; admissible for it.  The wrong-KIND and wrong-SUBJECT teeth lean on different
;;; halves of that.

(defparameter *vessel* "DD-2026-0071")

(defun hull-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :hull-by-direct-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :hull-survey
                        :truth-ceiling :asserted))))

(defun ballast-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :ballast-by-direct-assay
   :accepted-clauses '((:asserted-witness :mode :direct :kind :ballast-assay
                        :truth-ceiling :asserted))))

;; §5 — a contract that differs ONLY in semantics the snapshot must notice.
(defun ballast-contract-variant ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :ballast-by-direct-assay          ; SAME id
   ;; MEASURED: Slice /2 refuses a contract naming one clause species twice
   ;; ("a premise whose accepted set has two answers has none"), so the variant
   ;; differs in the clause's OWN semantics, not by adding a second clause.
   :accepted-clauses '((:asserted-witness :mode :testimony :kind :ballast-assay
                        :truth-ceiling :asserted))))   ; SAME id, DIFFERENT mode

(defun install-schemas ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :seaworthy :version 1
    :conclusion (pp '(:predicate :vessel-seaworthy (:vessel (:var :vessel))))
    :premises (list (pp '(:predicate :hull-surveyed (:vessel (:var :vessel))))
                    (pp '(:predicate :ballast-assayed (:vessel (:var :vessel)))))))
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :berth-assigned :version 1
    :conclusion (pp '(:predicate :berth-assigned (:vessel (:var :vessel))))
    :premises (list (pp '(:predicate :berth-free (:vessel (:var :vessel))))))))

(defun seaworthy-schema (&key (ballast (ballast-contract)))
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :seaworthy/2
   :base-schema (lisp-plus-slice1:resolve-schema :seaworthy 1)
   :premise-contracts (list (list 0 (hull-contract)) (list 1 ballast))))

(defun berth-schema ()
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :berth-assigned/2
   :base-schema (lisp-plus-slice1:resolve-schema :berth-assigned 1)
   :premise-contracts
   (list (list 0 (lisp-plus-slice2:make-support-admission-contract
                  :contract-id :berth-by-direct-check
                  :accepted-clauses '((:asserted-witness :mode :direct :kind :berth-check
                                       :truth-ceiling :asserted)))))))

(defun w (predicate kind &optional (vessel *vessel*))
  (lisp-plus-slice0:witness
   :for (np `(:predicate ,predicate (:vessel ,vessel)))
   :mode :direct :kind kind :source :dry-dock-registrar))

(defun receiver (&rest supports)
  (lisp-plus-slice0:receiver-context
   :context-id :dry-dock
   :accessible-supports
   (mapcan (lambda (s) (when (lisp-plus-slice0:witness-p s)
                         (list (lisp-plus-slice0:witness-id s))))
           supports)))

(defun run/2 (schema conclusion supports)
  "THREE outcomes, deliberately distinguished — a semantic refusal is never
reported as a harness failure."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice2:derive/2 :schema schema :conclusion conclusion
                                     :supports supports
                                     :receiver (apply #'receiver supports))
        (values receipt claim :granted))
    (lisp-plus-slice2:slice2-derivation-refused (c)
      (values (lisp-plus-slice2:slice2-condition-receipt c) nil :refused))
    (lisp-plus-slice2:slice2-schema-error (c) (declare (ignore c))
      (values nil nil :unaddressable-schema))))

;;; A planted receipt maker, for fold-conjunct controls only (§7 permits this).
(defun %plant-receipt (ob &key (occurrence :ok) (content :ok) (procedure :ok)
                               (version :ok) (previous :owed) (resulting :reconciled)
                               (disposition :reconciled) (residue nil))
  (%make-orr
   :identity '(:planted)
   :target-occurrence-identity (if (eq occurrence :ok)
                                   (obligation-occurrence-identity ob) '(:wrong-occurrence))
   :target-content-identity (if (eq content :ok)
                                (obligation-content-identity ob) '(:wrong-content))
   :procedure-id (if (eq procedure :ok) +procedure-id+ :some-other-procedure)
   :procedure-version (if (eq version :ok) +procedure-version+ 99)
   :proposed-witness-snapshot '(:planted) :retained-rule-snapshot '(:planted)
   :previous-commitment previous :resulting-commitment resulting
   :unresolved-residue residue :disposition disposition))

;;; ==================================================================
;;; VI.  HARNESS — count DERIVED from verdicts actually produced.

(defvar *verdicts* '())
(defun ck (label bool)
  (push (list (1+ (length *verdicts*)) label (and bool t)) *verdicts*)
  (format t "  [~2D] ~:[FAIL~;ok  ~]  ~A~%" (length *verdicts*) (and bool t) label)
  (and bool t))
(defun verdict-count () (length *verdicts*))
(defun failure-count () (count nil *verdicts* :key #'third))

(install-schemas)
(format t "~&== de-pignore — concerning the pledge (REVIEW-1 HARDENED) ==~%")
(format t "   application-private · no persistence · no authority · in-image only~%")

(defparameter *hull* (w :hull-surveyed :hull-survey))
(defparameter *assay* (w :ballast-assayed :ballast-assay))
(defparameter *wrong-kind* (w :ballast-assayed :ballast-survey))
(defparameter *wrong-subject* (w :ballast-assayed :ballast-assay "DD-SOMEONE-ELSE"))
(defparameter *concl* (np `(:predicate :vessel-seaworthy (:vessel ,*vessel*))))
(defparameter *act-a* (lisp-plus-cd0:make-identifier-datum '("de-pignore") '("act" "A")))
(defparameter *act-b* (lisp-plus-cd0:make-identifier-datum '("de-pignore") '("act" "B")))

(defun fresh-world ()
  (install-schemas)
  (let* ((live (seaworthy-schema))
         (refused (nth-value 0 (run/2 live *concl* (list *hull*)))))
    (values live refused)))

(defun open-one (&key (act *act-a*) (intent '(:undertake :supply-ballast-assay))
                      (scope '(:scope :ballast)))
  (multiple-value-bind (live refused) (fresh-world)
    (multiple-value-bind (ob ref)
        (try-pledge :refused-receipt refused :premise-index 1 :pledge-act-id act
                    :pledge-intent intent :scope-description scope :live-schema live)
      (values ob ref live refused))))

(format t "~%-- VI.1  the inhabited evidentiary case --~%")

(multiple-value-bind (live refused) (fresh-world)
  (defparameter *live* live) (defparameter *refused* refused)
  (let ((a (find 1 (lisp-plus-slice2:slice2-receipt-admissions refused)
                 :key #'lisp-plus-slice2:premise-admission-index)))
    (ck "derive/2 without the assay refuses; premise 1 is :MISSING"
        (and a (eq :missing (lisp-plus-slice2:premise-admission-base-disposition a))))))

(defparameter *ob* (nth-value 0 (try-pledge :refused-receipt *refused* :premise-index 1
                                            :pledge-act-id *act-a*
                                            :pledge-intent '(:undertake :supply-ballast-assay)
                                            :scope-description '(:scope :ballast)
                                            :live-schema *live*)))
(ck "PLEDGE with an explicit opening act elects an immutable obligation" (obligation-p *ob*))
(ck "openness is DERIVED: obligation + no events => open" (obligation-open-p *ob* '()))

(defparameter *interv*
  (list (nth-value 2 (run/2 (berth-schema) (np `(:predicate :berth-assigned (:vessel ,*vessel*)))
                            (list (w :berth-free :berth-check))))
        (nth-value 2 (run/2 (berth-schema) (np '(:predicate :berth-assigned (:vessel "DD-OTHER")))
                            (list (w :berth-free :berth-check "DD-OTHER"))))))
(ck "two unrelated derivations intervene; the obligation survives"
    (and (= 2 (length *interv*)) (obligation-open-p *ob* '())))

(multiple-value-bind (r ref) (try-reconcile-obligation :obligation *ob* :proposed-witness *wrong-kind*
                                                       :live-schema *live* :history '())
  (defparameter *ref-kind* ref)
  (ck "T-WRONG-KIND  a lookalike of the wrong KIND (:ballast-survey) refuses"
      (and (null r) (eq :premise-not-satisfied (oref-reason ref)))))

;; R3 REPAIRED — the new tooth.
(multiple-value-bind (r ref) (try-reconcile-obligation :obligation *ob* :proposed-witness *wrong-subject*
                                                       :live-schema *live* :history '())
  (ck "T-WRONG-SUBJECT  correct mode and kind but a witness about ANOTHER VESSEL refuses (R3 repaired)"
      (and (null r) (eq :premise-not-satisfied (oref-reason ref)))))

(ck "a refusal leaves the fold unchanged" (obligation-open-p *ob* (list *ref-kind*)))

(multiple-value-bind (r ref) (try-reconcile-obligation :obligation *ob* :proposed-witness *assay*
                                                       :live-schema *live* :history (list *ref-kind*))
  (defparameter *receipt* r)
  (ck "the exact admissible witness reconciles via the REAL derive/2 path, residue NIL"
      (and (null ref) (obligation-reconciliation-receipt-p r) (null (orr-residue r)))))

(ck "the fold derives NOT open — no status slot was written"
    (not (obligation-open-p *ob* (list *ref-kind* *receipt*))))

(multiple-value-bind (drec claim dec) (run/2 *live* *concl* (list *hull* *assay*))
  (defparameter *drec* drec)
  (ck "a fresh derive/2 with the admitted support is GRANTED by existing machinery"
      (and (eq :granted dec) claim)))

;; R7 REPAIRED — real lineage, not NOT-EQ.
(ck "T-LINEAGE  the reconciliation receipt has its OWN identity, names the exact obligation occurrence, and cannot stand in for the derivation receipt's identity (R7 repaired)"
    (and (orr-identity *receipt*)
         (equal (orr-target-occurrence *receipt*) (obligation-occurrence-identity *ob*))
         (lisp-plus-slice2:slice2-receipt-identity *drec*)
         (not (equal (orr-identity *receipt*)
                     (lisp-plus-slice2:slice2-receipt-identity *drec*)))))

(format t "~%-- VI.2  the seven Review-1 counterexamples, now teeth --~%")

;; R1
(multiple-value-bind (ob ref live) (open-one)
  (declare (ignore ref))
  (install-schemas)                                   ; registry replaced beneath
  (multiple-value-bind (r ref2) (try-reconcile-obligation :obligation ob :proposed-witness *assay*
                                                          :live-schema live :history '())
    (ck "R1  handing back the ORIGINAL stale wrapper after re-registration now REFUSES :base-schema-no-longer-live"
        (and (null r) (eq :base-schema-no-longer-live (oref-reason ref2))))))

;; R2 + R5
(multiple-value-bind (live refused) (fresh-world)
  (let ((oa (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1 :pledge-act-id *act-a*
                                     :pledge-intent '(:undertake :same) :scope-description '(:s)
                                     :live-schema live)))
        (ob2 (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1 :pledge-act-id *act-b*
                                      :pledge-intent '(:undertake :same) :scope-description '(:s)
                                      :live-schema live))))
    (ck "R2/R5  identical content under DIFFERENT opening acts yields DISTINCT occurrence identities and IDENTICAL content identities"
        (and (not (equal (obligation-occurrence-identity oa) (obligation-occurrence-identity ob2)))
             (equal (obligation-content-identity oa) (obligation-content-identity ob2))))
    (multiple-value-bind (r ref) (try-reconcile-obligation :obligation oa :proposed-witness *assay*
                                                           :live-schema live :history '())
      (declare (ignore ref))
      (ck "R2  a receipt for obligation A no longer closes obligation B"
          (and r (not (obligation-open-p oa (list r))) (obligation-open-p ob2 (list r)))))))

;; R4
(multiple-value-bind (live refused) (fresh-world)
  (declare (ignore live))
  (multiple-value-bind (ob ref)
      (try-pledge :refused-receipt refused :premise-index 1 :pledge-act-id *act-a*
                  :pledge-intent '(:x) :scope-description '(:s) :live-schema (berth-schema))
    ;; §4 REVIEW 2 / D4: one deterministic fixture has ONE expected result.  The
    ;; old menu of three reasons let a PHANTOM survive inside it — a reason no
    ;; executable path emits.  BERTH-ASSIGNED has a single premise, so index 1 is
    ;; out of bounds and the exact reason is :NO-SUCH-PREMISE.
    (ck "R4  pledging a :SEAWORTHY/2 receipt against the unrelated BERTH schema refuses with the EXACT reason :NO-SUCH-PREMISE (no menu of accepted reasons)"
        (and (null ob) (eq :no-such-premise (oref-reason ref))))))

;; R6
(multiple-value-bind (live refused) (fresh-world)
  (flet ((try (v) (nth-value 1 (try-pledge :refused-receipt refused :premise-index 1
                                           :pledge-act-id *act-a* :pledge-intent v
                                           :scope-description '(:s) :live-schema live))))
    (ck "R6  a function object is a TYPED refusal, not PRINT-NOT-READABLE"
        (let ((r (try #'car))) (and r (eq :unsupported-snapshot-value (oref-reason r)))))
    (ck "R6  a circular cons is a TYPED refusal and TERMINATES"
        (let* ((c (list 1 2)) (_ (setf (cdr (last c)) c)) (r (try c)))
          (declare (ignore _))
          (and r (eq :unsupported-snapshot-value (oref-reason r)))))
    (ck "R6  a CD/0 datum is ACCEPTED (the old boundary rejected the system's own canonical species)"
        (obligation-p (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1
                                               :pledge-act-id *act-a*
                                               :pledge-intent (lisp-plus-cd0:make-identifier-datum '("i") '("j"))
                                               :scope-description '(:s) :live-schema live))))
    (ck "R6  no READ-FROM-STRING or PRIN1-TO-STRING CALL FORM exists in this file (the names appear only in the Review-1 header, describing what was removed)"
        (with-open-file (s (merge-pathnames "APPLICATION.lisp" *load-truename*))
          (let ((txt (make-string (file-length s))))
            (setf txt (string-upcase (subseq txt 0 (read-sequence txt s))))
            ;; The needles are ASSEMBLED AT RUNTIME so that this check's own
            ;; label — which necessarily names them — cannot trip it.  A literal
            ;; here would make the tooth bite itself.
            (and (null (search (concatenate 'string "(READ-FROM-" "STRING") txt))
                 (null (search (concatenate 'string "(PRIN1-TO-" "STRING") txt))))))))

(format t "~%-- VI.3  fold conjuncts (§7), contract identity (§5), history limit (§9) --~%")

(let ((ob *ob*))
  (ck "FOLD  wrong target occurrence does not close"
      (obligation-open-p ob (list (%plant-receipt ob :occurrence :wrong))))
  (ck "FOLD  wrong target content does not close"
      (obligation-open-p ob (list (%plant-receipt ob :content :wrong))))
  (ck "FOLD  wrong procedure version does not close"
      (obligation-open-p ob (list (%plant-receipt ob :version :wrong))))
  (ck "FOLD  wrong procedure identity does not close"
      (obligation-open-p ob (list (%plant-receipt ob :procedure :wrong))))
  (ck "FOLD  wrong disposition does not close"
      (obligation-open-p ob (list (%plant-receipt ob :disposition :partial))))
  (ck "FOLD  non-NIL residue does not close"
      (obligation-open-p ob (list (%plant-receipt ob :residue '(:still-owed)))))
  (ck "FOLD  wrong previous commitment does not close"
      (obligation-open-p ob (list (%plant-receipt ob :previous :already-reconciled))))
  (ck "FOLD  all conjuncts satisfied DOES close"
      (not (obligation-open-p ob (list (%plant-receipt ob))))))

;; §5 — a genuine contract-semantics difference.
(multiple-value-bind (live refused) (fresh-world)
  (declare (ignore live))
  (let ((variant-schema (seaworthy-schema :ballast (ballast-contract-variant))))
    (multiple-value-bind (ob ref)
        (try-pledge :refused-receipt refused :premise-index 1 :pledge-act-id *act-a*
                    :pledge-intent '(:x) :scope-description '(:s) :live-schema variant-schema)
      (ck "§5  a live contract with the SAME id but DIFFERENT accepted clauses is caught as :CONTRACT-DRIFT (the old NC14 label was false)"
          (and (null ob) (eq :contract-drift (oref-reason ref)))))))

(ck "§5  the obligation commits a COMPLETE contract snapshot, not merely CONTRACT-ID"
    (let ((s (obligation-contract-snapshot *ob*)))
      (and (getf s :contract-id) (getf s :accepted-clauses)
           (getf s :proposition-relation) (getf s :receiver-accessibility)
           (getf s :truth-ceilings) (member :contract-version s))))

;; §9 — the history limit, demonstrated not solved.
(multiple-value-bind (live refused) (fresh-world)
  (let* ((ob (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema live)))
         (r1 (nth-value 0 (try-reconcile-obligation :obligation ob :proposed-witness *assay*
                                                    :live-schema live :history '())))
         (again (nth-value 0 (try-reconcile-obligation :obligation ob :proposed-witness *assay*
                                                       :live-schema live :history '()))))
    (ck "T24 §9 LIMIT  with the prior receipt OMITTED the pure transition mints another receipt — :ALREADY-RECONCILED is relative to the supplied history; NO global exactly-once is claimed"
        (and r1 again
             (null (nth-value 1 (try-reconcile-obligation :obligation ob :proposed-witness *assay*
                                                          :live-schema live :history '())))
             (not (obligation-open-p ob (list r1)))))))

;; §8 — refusal shape.
(ck "§8  every PLEDGE refusal is a persistent OBLIGATION-REFUSAL with phase :PLEDGE and an offending snapshot"
    (let ((r (nth-value 1 (try-pledge :refused-receipt '(:not :a :receipt) :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema (berth-schema)))))
      (and (obligation-refusal-p r) (eq :pledge (oref-phase r)) (oref-snapshot r))))
(ck "§8  PLEDGE remains the loud wrapper and signals the same refusal object"
    (handler-case (progn (pledge :refused-receipt '(:nope) :premise-index 1 :pledge-act-id *act-a*
                                 :pledge-intent '(:x) :scope-description '(:s)
                                 :live-schema (berth-schema)) nil)
      (pledge-refused (c) (obligation-refusal-p (pledge-refused-refusal c)))))

;; retained controls — rebuilt against a FRESH world: the checks above
;; deliberately re-register the registry many times, so *live*/*refused*/*ob*
;; from VI.1 are legitimately stale by now.
(multiple-value-bind (live refused) (fresh-world)
  (setf *live* live *refused* refused
        *ob* (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent '(:undertake :x)
                                      :scope-description '(:scope :ballast) :live-schema live))
        *receipt* (nth-value 0 (try-reconcile-obligation
                                :obligation *ob* :proposed-witness *assay*
                                :live-schema live :history '()))))

(ck "NC  :MISSING without an elected intent constructs nothing"
    (let ((r (nth-value 1 (try-pledge :refused-receipt *refused* :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent nil
                                      :scope-description '(:s) :live-schema *live*))))
      (and r (eq :no-elected-intent (oref-reason r)))))
(ck "NC  PLEDGE without an opening-act identity refuses (§2)"
    (let ((r (nth-value 1 (try-pledge :refused-receipt *refused* :premise-index 1
                                      :pledge-act-id nil :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema *live*))))
      (and r (eq :no-opening-act (oref-reason r)))))
(ck "NC  a premise that is not :MISSING refuses — nothing is owed"
    (let ((r (nth-value 1 (try-pledge :refused-receipt *refused* :premise-index 0
                                      :pledge-act-id *act-a* :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema *live*))))
      (and r (eq :premise-not-missing (oref-reason r)))))
;; §2 REVIEW 2 — the CORRECTED immutability tooth.  Three distinct properties,
;; asserted separately, because Review 1 conflated them and claimed the third
;; while holding only the first two.
(ck "§2  immutability part 1 of 3 — NO SLOT WRITER exists and no slot is named like a status"
    (and (null (ignore-errors
                 (eval '(setf (de-pignore::%obligation-occurrence-identity de-pignore::*ob*) :x)) t))
         (notany (lambda (n) (search "STATUS" (string n)))
                 '(occurrence-identity content-identity pledge-act-id pledge-intent
                   refused-receipt-id premise-index subject-description scope-description
                   contract contract-snapshot procedure-id procedure-version base-anchor
                   schema-name schema-version conclusion))))
(ck "§2  immutability part 2 of 3 — CONSTRUCTION INPUT is defensively copied (caller's own list cannot reach the stored obligation)"
    (let* ((mut (list :scope :ballast :vessel "DD-CONSTRUCT"))
           (o (nth-value 0 (try-pledge :refused-receipt *refused* :premise-index 1
                                       :pledge-act-id *act-b* :pledge-intent '(:x)
                                       :scope-description mut :live-schema *live*)))
           (before (obligation-scope-description o)))
      (setf (getf mut :vessel) "DD-TAMPERED")
      (equal before (obligation-scope-description o))))

;;; The eight §2 reader-boundary teeth.  Each mutates a value obtained THROUGH a
;;; non-% reader and asserts the stored object did not move.  D1 showed all six
;;; aggregate readers aliased before this repair.
(macrolet ((no-alias (label reader)
             `(ck ,label
                  (let* ((before (,reader *ob*))
                         (view (,reader *ob*)))
                    (when (consp view) (setf (car view) :TAMPERED))
                    (equal before (,reader *ob*))))))
  (no-alias "§2  reader tooth 1 — mutating an OCCURRENCE-IDENTITY view does not change the obligation"
            obligation-occurrence-identity)
  (no-alias "§2  reader tooth 2 — mutating a CONTENT-IDENTITY view does not change the obligation"
            obligation-content-identity)
  (no-alias "§2  reader tooth 3 — mutating a SCOPE view does not change the retained scope"
            obligation-scope-description)
  (no-alias "§2  reader tooth 4 — mutating a CONTRACT-SNAPSHOT view does not change the retained contract"
            obligation-contract-snapshot))
(macrolet ((no-alias-r (label reader)
             `(ck ,label
                  (let* ((before (,reader *receipt*))
                         (view (,reader *receipt*)))
                    (when (consp view) (setf (car view) :TAMPERED))
                    (equal before (,reader *receipt*))))))
  (no-alias-r "§2  reader tooth 5 — mutating a RECEIPT-TARGET view does not retarget the receipt"
              orr-target-occurrence)
  (no-alias-r "§2  reader tooth 6 — mutating a RECEIPT-IDENTITY view does not change its identity"
              orr-identity))
(ck "§2  reader tooth 7 — mutating a REFUSAL-SNAPSHOT view does not change the refusal"
    (let* ((ref (nth-value 1 (try-pledge :refused-receipt '(:nope) :premise-index 1
                                         :pledge-act-id *act-a* :pledge-intent '(:x)
                                         :scope-description '(:s) :live-schema *live*)))
           (before (oref-snapshot ref))
           (view (oref-snapshot ref)))
      (when (consp view) (setf (car view) :TAMPERED))
      (equal before (oref-snapshot ref))))
(ck "§2  reader tooth 8 — an already minted valid receipt STILL closes its obligation after every caller-side view mutation above"
    (not (obligation-open-p *ob* (list *receipt*))))

;;; The four §3 error-classification teeth.
(ck "§3  an EXPECTED Slice /2 refusal is inspected normally (the probe reads the refusal's receipt)"
    (let ((r (nth-value 1 (try-reconcile-obligation :obligation *ob* :proposed-witness *wrong-kind*
                                                    :live-schema *live* :history '()))))
      (and r (eq :premise-not-satisfied (oref-reason r)))))
(ck "§3  EXPECTED absence from the registry yields the intended typed obligation refusal"
    (let ((o (nth-value 0 (try-pledge :refused-receipt *refused* :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema *live*))))
      (lisp-plus-slice1:clear-schema-registry)          ; schema-not-found now
      (let ((r (nth-value 1 (try-reconcile-obligation :obligation o :proposed-witness *assay*
                                                      :live-schema *live* :history '()))))
        (prog1 (and r (eq :base-schema-no-longer-live (oref-reason r)))
          (install-schemas)))))
(ck "§3  a planted UNEXPECTED condition from the probe wrapper ESCAPES and is classified as an IMPLEMENTATION failure, not an obligation refusal"
    (multiple-value-bind (live refused) (fresh-world)
      (let* ((o (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1
                                         :pledge-act-id *act-a* :pledge-intent '(:x)
                                         :scope-description '(:s) :live-schema live)))
             (orig (fdefinition 'lisp-plus-slice2:derive/2))
             (escaped nil) (laundered nil))
        (unwind-protect
             (progn
               (setf (fdefinition 'lisp-plus-slice2:derive/2)
                     (lambda (&rest a) (declare (ignore a))
                       (error "PLANTED UNEXPECTED CONDITION")))
               (handler-case
                   (multiple-value-bind (r ref)
                       (try-reconcile-obligation :obligation o :proposed-witness *assay*
                                                 :live-schema live :history '())
                     (declare (ignore r))
                     (setf laundered (and ref (oref-reason ref))))
                 (lisp-plus-slice2:slice2-derivation-refused () (setf escaped :protocol))
                 (error () (setf escaped :implementation-failure))))
          (setf (fdefinition 'lisp-plus-slice2:derive/2) orig))
        (and (eq :implementation-failure escaped) (null laundered)))))
;;; This tooth measures CODE, not TEXT — twice over, because the naive versions
;;; failed twice.  (a) The needle is assembled at runtime so the check's own label
;;; cannot match it.  (b) COMMENT LINES ARE STRIPPED and the search is restricted
;;; to the TRANSITION PATH (everything before the harness), because the explanatory
;;; comment that records what was removed necessarily quotes the removed form, and
;;; the harness legitimately contains a catch-all in order to CLASSIFY an escaping
;;; condition.  A check that cannot tell "this file mentions X" from "this code
;;; does X" is measuring prose.
(ck "§3  no broad catch-all handler remains in the TRANSITION PATH (comments stripped; harness excluded; needle assembled at runtime)"
    (with-open-file (s (merge-pathnames "APPLICATION.lisp" *load-truename*))
      (let* ((raw (make-string (file-length s)))
             (txt (progn (setf raw (subseq raw 0 (read-sequence raw s)))
                         (string-upcase raw)))
             (harness (search "VI.  HARNESS" txt))
             (path (subseq txt 0 (or harness (length txt))))
             (code (with-output-to-string (out)
                     (with-input-from-string (in path)
                       (loop for line = (read-line in nil nil) while line
                             for trimmed = (string-left-trim " " line)
                             unless (and (plusp (length trimmed))
                                         (char= #\; (char trimmed 0)))
                               do (write-line line out))))))
        (null (search (concatenate 'string "(ERR" "OR () N" "IL)") code)))))
;; The §3 registry tooth above deliberately clears and reinstalls the registry, so
;; *live* is legitimately stale by here.  Rebuild before the last control.
(multiple-value-bind (live refused) (fresh-world)
  (setf *live* live *refused* refused
        *ob* (nth-value 0 (try-pledge :refused-receipt refused :premise-index 1
                                      :pledge-act-id *act-a* :pledge-intent '(:x)
                                      :scope-description '(:s) :live-schema live))
        *receipt* (nth-value 0 (try-reconcile-obligation :obligation *ob*
                                                         :proposed-witness *assay*
                                                         :live-schema live :history '()))))
(ck "NC  the obligation receipt offered as a Slice /2 support leaves premise 1 :MISSING, no source or derivation basis"
    (multiple-value-bind (rec claim dec) (run/2 *live* *concl* (list *hull* *receipt*))
      (declare (ignore claim))
      (let ((a (and rec (find 1 (lisp-plus-slice2:slice2-receipt-admissions rec)
                              :key #'lisp-plus-slice2:premise-admission-index))))
        (and (eq :refused dec) a
             (eq :missing (lisp-plus-slice2:premise-admission-base-disposition a))
             (null (lisp-plus-slice2:premise-admission-source-bases a))
             (null (lisp-plus-slice2:premise-admission-derivation-bases a))))))

(format t "~%-- VI.4  generalization probes (unchanged, both negative) --~%")

(defparameter *inc*
  (let ((p (merge-pathnames "../../atelier/instruments/de-incantatione.lisp" *load-truename*)))
    (when (probe-file p)
      (with-open-file (s p) (let ((str (make-string (file-length s))))
                              (subseq str 0 (read-sequence str s)))))))
(ck "PROBE A  de-incantatione's rhyme-obligation is a retrospective closure certificate (carries closer-line/closer-word; no pledge or elect vocabulary)"
    (and *inc* (search "closer-line" *inc*) (search "closer-word" *inc*)
         (not (search "pledge" *inc*)) (not (search "elect" *inc*))))
(ck "PROBE B  CD/0-only incomplete program data has no elected opening act; PLEDGE cannot even be offered a subject"
    (let ((d (lisp-plus-cd0:make-sequence-datum
              (list (lisp-plus-cd0:make-identifier-datum '("probe") '("if"))
                    (lisp-plus-cd0:make-identifier-datum '("probe") '("hole"))))))
      (and (lisp-plus-cd0:datum-p d)
           (let ((r (nth-value 1 (try-pledge :refused-receipt d :premise-index 0
                                             :pledge-act-id *act-a* :pledge-intent '(:fill)
                                             :scope-description '(:s) :live-schema *live*))))
             (and r (eq :not-a-slice2-receipt (oref-reason r)))))))

(format t "~%== de-pignore: ~D checks produced / ~D failed ==~%" (verdict-count) (failure-count))
(format t "   count DERIVED from the verdict list this run accumulated.~%")
(format t "   This runner reports only what it executed and asserts no project~%")
(format t "   adoption, freeze or audit standing.~%")
(when (plusp (failure-count))
  (format t "~%   FAILED:~%")
  (dolist (v (reverse *verdicts*)) (unless (third v) (format t "     [~2D] ~A~%" (first v) (second v)))))
(finish-output)
(sb-ext:exit :code (if (plusp (failure-count)) 1 0))
