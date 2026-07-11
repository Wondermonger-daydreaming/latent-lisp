;;;; kernel-hardened.lisp — Mneme v1: the SEMANTIC-UNFORGEABILITY hardening
;;;;
;;;; Second commit, built on GPT Sol's cold-chair review + co-design pass (2026-07-11).
;;;; The v0 kernel.lisp enforced the intended ROUTE; this enforces the INVARIANT:
;;;; a caller cannot mint authenticated state through the supported exported API.
;;;;
;;;; THREAT MODEL (Sol's ceiling, stated exactly):
;;;;   Mneme v1 resists adversarial use of its documented exported API and treats
;;;;   serialized input as hostile data. It does NOT defend against code permitted
;;;;   to access implementation-private symbols (mneme::), redefine objects, inspect
;;;;   lexical secrets, or mutate implementation-private registries within the same
;;;;   Lisp image. Package locks (not used here) would be diagnostic guardrails, not
;;;;   a security boundary.  In scope: beasts #1 (adversarial API clients) + #3
;;;;   (untrusted serialized input). Out: #2 (same-image code). Deferred: #4 (crypto).
;;;;
;;;; The four Sol amendments enforced below:
;;;;   A1  exported defstruct readers are setf-able  -> private %accessors + plain defun readers.
;;;;   A2  a read-only reader can return a mutable cons tree -> canonicalize on ingress,
;;;;       keep private, return defensive copies. (Shallow immutability ≠ epistemic immutability.)
;;;;   A3  "is an attestation" must not mean "was authentically minted" -> raise-claim validates
;;;;       MINT-REGISTRY membership + target + scope + validity + issuer, never attestation-p.
;;;;   A4  the verifier must not funcall a caller-named function -> a private procedure registry;
;;;;       propositions name a registered PROCEDURE-ID, never a live function.
;;;;
;;;; Load ALONE (own package MNEME):  sbcl --script adversarial-conformance.lisp

(require :sb-md5)

;; Implementation package — exports NOTHING. The public surface is split into two
;; facade packages at end-of-file: MNEME.CLIENT (adversarially callable) and
;; MNEME.OPERATOR (trusted bootstrap). Sol's rule: packages must enforce the
;; boundary the prose only describes — a comment is not an authority boundary.
(defpackage #:mneme (:use #:cl))

(in-package #:mneme)

;;; ── boring floor ────────────────────────────────────────────────────────────
(defvar *clock* 9000)
(defun tick () (incf *clock*))
(defun digest (s) (format nil "~(~{~2,'0x~}~)"
                          (coerce (sb-md5:md5sum-string (if (stringp s) s (format nil "~s" s))) 'list)))

;;; ── typed conditions (A: inspectable failures, not generic error) ────────────
(define-condition mneme-error (error) ((detail :initarg :detail :reader detail :initform nil))
  (:report (lambda (c s) (format s "MNEME ~a: ~a" (type-of c) (detail c)))))
(define-condition authority-violation     (mneme-error) ())
(define-condition invalid-attestation     (mneme-error) ())
(define-condition scope-mismatch          (mneme-error) ())
(define-condition unsafe-procedure        (mneme-error) ())
(define-condition schema-mismatch         (mneme-error) ())
(define-condition handoff-state-violation (mneme-error) ())
(defmacro ensure (test kind fmt &rest args)
  `(unless ,test (error ',kind :detail (format nil ,fmt ,@args))))

;;; ── PRIVATE registries (out of the client's reach except via mneme::) ────────
(defvar *procedure-registry* (make-hash-table :test 'eql))   ; id -> (impl version effect)
(defvar *capability-tokens*  (make-hash-table :test 'eq))    ; token -> capability (live custody)
(defvar *attestation-mint*   (make-hash-table :test 'eq))    ; mint-id -> t (did THIS runtime issue it?)

;;; ── procedure registry (A4: no fdefinition from caller data) ─────────────────
(defstruct (procrec (:constructor %make-procrec) (:conc-name %pr-) (:copier nil) (:predicate nil))
  id impl version effect)
(defun register-procedure (id impl &key (version 1) (effect :pure))
  "Operator op. Admit a (preferably pure) procedure under a stable ID. The verifier
   resolves an ID only through this private registry — never a caller-supplied function."
  (ensure (and (symbolp id) (functionp impl)) schema-mismatch "register-procedure: bad id/impl")
  (setf (gethash id *procedure-registry*) (%make-procrec :id id :impl impl :version version :effect effect))
  id)

;;; ── verifier capability (A: opaque, private ctor, registry-membership is validity) ──
(defstruct (verifier-capability (:constructor %make-cap) (:conc-name %cap-) (:copier nil))
  token principal event-kinds procedure-ids (validity :valid))
(defun grant-authority (principal event-kinds procedure-ids)
  "Operator/bootstrap op. Mint a bearer capability and record its token. Holding it lets
   you REQUEST verification; it cannot make the verifier lie (verify re-runs the procedure).
   COPIES the scope lists on ingress — the grantee must not be able to widen its own warrant
   by mutating the cons cells it passed in (Sol's mutable-lunchbox catch)."
  (ensure (and (listp event-kinds) (listp procedure-ids)
               (every #'symbolp event-kinds) (every #'symbolp procedure-ids))
          schema-mismatch "capability scopes must be lists of symbols")
  (let* ((token (gensym "CAP"))
         (cap (%make-cap :token token :principal principal
                         :event-kinds (copy-list event-kinds)      ; Mneme owns these cons cells
                         :procedure-ids (copy-list procedure-ids))))
    (setf (gethash token *capability-tokens*) cap)
    cap))
(defun revoke-authority (cap)
  "Operator op. Revoke a capability: drop its token from the registry and mark it stale.
   Subsequent verify requests through it raise authority-violation."
  (when (verifier-capability-p cap)
    (remhash (%cap-token cap) *capability-tokens*)
    (setf (%cap-validity cap) :revoked))
  cap)
(defun %cap-live-p (cap kind proc-id)
  (and (verifier-capability-p cap)
       (eq (gethash (%cap-token cap) *capability-tokens*) cap)   ; registry membership, not shape
       (eq (%cap-validity cap) :valid)
       (member kind (%cap-event-kinds cap))
       (member proc-id (%cap-procedure-ids cap))))

;;; ── canonical proposition (A2: copy on ingress, keep private, small grammar) ──
;;; grammar:  (:equals (:call PROC-ID INPUT) EXPECTED)   PROC-ID a symbol; INPUT/EXPECTED inert data
(defun %safe-data-p (x &optional (depth 0))
  (and (<= depth 32)
       (typecase x
         ((or number symbol string character) t)   ; NO structures, arrays, hash-tables
         (cons (and (%safe-data-p (car x) (1+ depth)) (%safe-data-p (cdr x) (1+ depth))))
         (t nil))))
(defun %canonicalize-proposition (p)
  (ensure (%safe-data-p p) schema-mismatch "proposition contains unsafe payload")
  (ensure (and (consp p) (eq (first p) :equals) (consp (second p))
               (eq (first (second p)) :call) (symbolp (second (second p))))
          schema-mismatch "unsupported proposition shape: ~s" p)
  (copy-tree p))                                    ; our private, immutable copy
(defun %fingerprint (canonical) (digest (prin1-to-string canonical)))

;;; ── claim: ONE immutable aggregate; predecessor vs authenticated warrant SETS ──
(defstruct (claim (:constructor %make-claim) (:conc-name %claim-) (:copier nil) (:predicate %claim-real-p))
  canonical fingerprint (predecessor-warrants '()) (authenticated-warrants '()) provenance as-of)
(defun assert-claim (proposition &key as-of)
  "Client construction. Always yields an UNauthenticated claim — there is no exported
   path to a graded/authenticated claim except verify-proposition + raise-claim."
  (let ((c (%canonicalize-proposition proposition)))
    (%make-claim :canonical c :fingerprint (%fingerprint c) :as-of as-of)))
;; A1+A2: exported readers are PLAIN FUNCTIONS (no setf expander) returning DEFENSIVE COPIES.
(defun claim-proposition (c) (copy-tree (%claim-canonical c)))
(defun claim-authenticated-warrants (c) (copy-list (%claim-authenticated-warrants c)))
(defun claim-predecessor-warrants (c) (copy-list (%claim-predecessor-warrants c)))
(defun claim-provenance (c) (copy-tree (%claim-provenance c)))
(defun claim-authenticated-p (c) (and (%claim-authenticated-warrants c) t))

;;; ── attestation: private ctor; minted ONLY inside verify-proposition ─────────
(defstruct (attestation (:constructor %make-att) (:conc-name %att-) (:copier nil) (:predicate nil))
  mint-id principal event-kind procedure-id procedure-version target-fingerprint scope verdict validity issued-at)
;; readers only (defensive; no constructor, no predicate exported)
(defun attestation-principal    (a) (%att-principal a))
(defun attestation-verdict      (a) (%att-verdict a))
(defun attestation-procedure-id (a) (%att-procedure-id a))
(defun attestation-event-kind   (a) (%att-event-kind a))
(defun attestation-scope        (a) (%att-scope a))

(defun verify-proposition (proposition capability &key (event-kind :execution) (scope :default))
  "Requires a live capability authorized for (event-kind, proc-id). Resolves the procedure
   ONLY through the private registry, RE-RUNS it, reads EXPECTED from the proposition, and
   mints an attestation recorded in the private mint registry. Callers cannot mint one."
  (let* ((canon (%canonicalize-proposition proposition)))
    (destructuring-bind (rel (ck proc-id input) expected) canon
      (declare (ignore rel ck))
      (let ((pr (gethash proc-id *procedure-registry*)))
        (ensure pr unsafe-procedure "procedure ~s not registered — refusing arbitrary dispatch" proc-id)
        (ensure (%cap-live-p capability event-kind proc-id)
                authority-violation "capability may not issue ~a for ~s" event-kind proc-id)
        (let* ((actual (funcall (%pr-impl pr) input))          ; the registered impl, never caller code
               (mint-id (gensym "ATT")))
          (setf (gethash mint-id *attestation-mint*) t)
          (%make-att :mint-id mint-id :principal (%cap-principal capability)
                     :event-kind event-kind :procedure-id proc-id :procedure-version (%pr-version pr)
                     :target-fingerprint (%fingerprint canon) :scope scope
                     :verdict (if (equal actual expected) :supports :refutes)
                     :validity :valid :issued-at (tick)))))))

(defun raise-claim (claim attestation &key (scope :default))
  "A3: nominal typing must not impersonate authentication. Validate PROVENANCE, not shape."
  (ensure (and (%claim-real-p claim) (typep attestation 'attestation)) invalid-attestation "wrong argument types")
  (ensure (gethash (%att-mint-id attestation) *attestation-mint*)      ; did THIS runtime mint it?
          invalid-attestation "attestation was not minted by this runtime")
  (ensure (equal (%att-target-fingerprint attestation) (%claim-fingerprint claim))
          scope-mismatch "attestation faces a different located claim")
  (ensure (eq (%att-verdict attestation) :supports) invalid-attestation "attestation does not support")
  (ensure (eq (%att-validity attestation) :valid) invalid-attestation "attestation is not valid now")
  (ensure (eq (%att-scope attestation) scope) scope-mismatch "attestation scope ~s ≠ ~s" (%att-scope attestation) scope)
  (%make-claim :canonical (%claim-canonical claim) :fingerprint (%claim-fingerprint claim)
               :predecessor-warrants (%claim-predecessor-warrants claim)
               :authenticated-warrants (cons attestation (%claim-authenticated-warrants claim))
               :provenance (%claim-provenance claim) :as-of (%claim-as-of claim)))

;;; ── mortal handoff: prepared → committed → received → revived ────────────────
;;; freeze serializes warrants AS INERT DATA (never live attestations).
(defstruct (receipt (:constructor %make-receipt) (:conc-name %rcpt-) (:copier nil))
  content-digest status path)
(defun receipt-status (r) (%rcpt-status r))
(defun receipt-path   (r) (%rcpt-path r))
(defun %warrant->data (a)
  (list :principal (%att-principal a) :event-kind (%att-event-kind a) :procedure-id (%att-procedure-id a)
        :procedure-version (%att-procedure-version a) :verdict (%att-verdict a) :scope (%att-scope a)))
(defun freeze (claim)
  (let ((text (with-standard-io-syntax
                (prin1-to-string
                 (list :tag :mneme :schema 2 :proposition (%claim-canonical claim)
                       :as-of (%claim-as-of claim)
                       :predecessor-warrants (mapcar #'%warrant->data (%claim-authenticated-warrants claim)))))))
    (values text (digest text))))

;;; A/#3: hostile-data decoder. *read-eval* nil + #S/#. disabled + one-form + inert-only.
(defvar *safe-readtable*
  (let ((rt (copy-readtable nil)))
    (set-dispatch-macro-character #\# #\S (lambda (s c n) (declare (ignore s c n))
                                            (error 'schema-mismatch :detail "#S struct literal refused")) rt)
    (set-dispatch-macro-character #\# #\. (lambda (s c n) (declare (ignore s c n))
                                            (error 'schema-mismatch :detail "#. read-eval refused")) rt)
    rt))
(defun %safe-decode (text)
  (ensure (and (stringp text) (<= (length text) 100000)) schema-mismatch "input too large / not a string")
  (multiple-value-bind (form idx)
      (with-standard-io-syntax
        (let ((*read-eval* nil) (*readtable* *safe-readtable*)) (read-from-string text)))
    (let ((next (with-standard-io-syntax
                  (let ((*read-eval* nil) (*readtable* *safe-readtable*))
                    (read-from-string text nil :eof :start idx)))))
      (ensure (eq next :eof) schema-mismatch "trailing data after first form"))
    (ensure (%safe-data-p form) schema-mismatch "decoded form contains non-inert payload")
    (ensure (and (eq (getf form :tag) :mneme) (eql (getf form :schema) 2)) schema-mismatch "unknown schema")
    form))                                          ; an INERT plist — never a live attestation/capability

(defun prepare (claim)
  (multiple-value-bind (text dig) (freeze claim)
    (list :text text :receipt (%make-receipt :content-digest dig :status :prepared))))
(defun commit (prepared store)
  (let* ((r (getf prepared :receipt))
         (path (namestring (merge-pathnames (format nil "mneme-~a.sexp" (%rcpt-content-digest r))
                                            (pathname store)))))
    (ensure-directories-exist path)
    (with-open-file (s (concatenate 'string path ".tmp") :direction :output :if-exists :supersede)
      (write-string (getf prepared :text) s) (finish-output s))
    (rename-file (concatenate 'string path ".tmp") path)
    (setf (%rcpt-status r) :committed (%rcpt-path r) path) r))
(defun receive (receipt)
  (ensure (eq (%rcpt-status receipt) :committed) handoff-state-violation "cannot receive: not committed")
  (let ((text (with-open-file (s (%rcpt-path receipt))
                (let ((b (make-string (file-length s)))) (read-sequence b s) b))))
    (ensure (string= (digest text) (%rcpt-content-digest receipt)) schema-mismatch "digest mismatch (forged)")
    (setf (%rcpt-status receipt) :received) (values receipt text)))

(defun revive (text-or-receipt)
  "A4/L5-L7: reconstruct as DATA, mark discontinuity, grant NO present authority.
   Authenticated set begins EMPTY; inherited warrants become predecessor testimony only.
   :revived is the fourth transition; a receipt cannot be revived twice."
  (let* ((receipt (when (receipt-p text-or-receipt) text-or-receipt))
         (text (if receipt (nth-value 1 (receive receipt)) text-or-receipt)))
    (when receipt
      (ensure (member (%rcpt-status receipt) '(:received)) handoff-state-violation
              "revive expects a :received receipt, got ~s" (%rcpt-status receipt))
      (setf (%rcpt-status receipt) :revived))
    (let* ((d (%safe-decode text))
           (canon (%canonicalize-proposition (getf d :proposition))))
      (%make-claim :canonical canon :fingerprint (%fingerprint canon)
                   :predecessor-warrants (getf d :predecessor-warrants)   ; inert history, opens no door
                   :authenticated-warrants '()                            ; empty, always
                   :provenance (list :revived t :predecessor-digest (digest text) :as-of (getf d :as-of))
                   :as-of (getf d :as-of)))))
(defun replay-and-attest (claim capability &key (event-kind :execution) (scope :default))
  "The explicit successor act: re-run verification with the successor's own capability and
   raise afresh. The only way a revived claim regains authenticated standing."
  (raise-claim claim (verify-proposition (%claim-canonical claim) capability
                                          :event-kind event-kind :scope scope)
               :scope scope))

;;; ── the two public surfaces (mechanically separated, per Sol) ───────────────
;; MNEME.CLIENT — the adversarially-callable surface. Everything a hostile client sees.
(defpackage #:mneme.client
  (:use)
  (:import-from #:mneme
   #:mneme-error #:authority-violation #:invalid-attestation #:scope-mismatch
   #:unsafe-procedure #:schema-mismatch #:handoff-state-violation
   #:assert-claim #:claim-proposition #:claim-authenticated-warrants
   #:claim-predecessor-warrants #:claim-provenance #:claim-authenticated-p
   #:verify-proposition #:raise-claim
   #:attestation-principal #:attestation-verdict #:attestation-procedure-id
   #:attestation-event-kind #:attestation-scope
   #:freeze #:prepare #:commit #:receive #:revive #:replay-and-attest
   #:receipt-status #:receipt-path)
  (:export
   #:mneme-error #:authority-violation #:invalid-attestation #:scope-mismatch
   #:unsafe-procedure #:schema-mismatch #:handoff-state-violation
   #:assert-claim #:claim-proposition #:claim-authenticated-warrants
   #:claim-predecessor-warrants #:claim-provenance #:claim-authenticated-p
   #:verify-proposition #:raise-claim
   #:attestation-principal #:attestation-verdict #:attestation-procedure-id
   #:attestation-event-kind #:attestation-scope
   #:freeze #:prepare #:commit #:receive #:revive #:replay-and-attest
   #:receipt-status #:receipt-path))

;; MNEME.OPERATOR — TRUSTED bootstrap. Registers procedures and mints/revokes authority.
;; NOT part of the adversarial client surface. A client that holds this is the operator.
(defpackage #:mneme.operator
  (:use)
  (:import-from #:mneme #:register-procedure #:grant-authority #:revoke-authority)
  (:export #:register-procedure #:grant-authority #:revoke-authority))

(format t "mneme v1 (hardened) loaded: client ~a exported / operator ~a exported (trusted)~%"
        (let ((n 0)) (do-external-symbols (s :mneme.client) (declare (ignore s)) (incf n)) n)
        (let ((n 0)) (do-external-symbols (s :mneme.operator) (declare (ignore s)) (incf n)) n))
