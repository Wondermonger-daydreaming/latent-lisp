;;;; stage-restart.lisp — the REDIVIVUS: a genuinely new process that
;;;; cannot inherit the key, and proves it.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation
;;;; AFTER the first life has exited.  Its entire admissible input is:
;;;;
;;;;   (1) the DURABLE BYTES of the store directory named in argv,
;;;;   (2) the DURABLE BYTES of the preserved public record (authorization
;;;;       receipt, minting receipt, printed key form) in the run directory
;;;;       named in argv,
;;;;   (3) DECLARED CONFIGURATION — specimen-common.lisp: the fixed nonce,
;;;;       durability, bootstrap issuer, minter principal, the store
;;;;       identity DERIVED from that configuration, and the declared
;;;;       charge (including this life's own query identity).
;;;;
;;;; It has no access to the dead process's memory: no minting context, no
;;;; recognition table, no object.  The journal has NOT advanced — the old
;;;; authorization receipt is still CURRENT, the minting receipt still
;;;; truthful — and the key is still DEAD: this stage's whole point is that
;;;; a complete, current, truthful public record cannot be presented, only
;;;; a freshly minted object can, and fresh minting requires the fresh /0
;;;; derivation, not any preserved description.
;;;;
;;;; One deliberate, labelled exception to the public-surface discipline:
;;;; the counterfeit below is built through the lane's INTERNAL constructor
;;;; (:: hostile path) from the minting receipt's public fields — to prove
;;;; that even the real constructor, fed the complete public record, does
;;;; not resurrect the key.
;;;;
;;;; Output protocol (parsed and renumbered by the parent runner):
;;;;   CHECK ok|FAIL <label> · NOTE <text> · RESULT: <n> checks, <f> failures
;;;; Exit 0 iff zero failures.  No pid, timestamp, or path is printed.
;;;;
;;;; — CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability1)

(defvar *r-checks* 0)
(defvar *r-failures* 0)

(defun rcheck (label thunk)
  (incf *r-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *r-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun rnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; Negative control hook: a child invocation dies HERE, mid-run, before
;;; any verdict and before the RESULT sentinel.
(when (sb-posix:getenv "DE_CLAVE_DIE")
  (rnote "child control: dying mid-restart before any verdict (planted)")
  (sb-ext:exit :code 3))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *run-directory* (pathname (second *arguments*)))

(rnote "redivivus: durable bytes + declared configuration only; no dead ~
        process memory, no minting context, no key — only testimony")

(defvar *events-sha-before*
  (sha256-hex (sp-read-octets (merge-pathnames "EVENTS.pj0"
                                               *store-directory*))))

;;; 1. Open the surviving store; identity against DECLARED configuration.

(defvar *store* nil)

(rcheck "the surviving store opens and its derived identity EQUALS the ~
         identity derived from the declared configuration alone — the ~
         restart trusts config + bytes, never testimony"
  (lambda ()
    (setf *store* (open-store *store-directory*))
    (and (journal-store-p *store*)
         (string= (journal-store-store-id *store*) (expected-store-id)))))

(defvar *bootstrap* (specimen-bootstrap))
(defvar *report* (validate-journal *store*))

(rcheck "the validated prefix is exactly what the bytes say: :valid, 1 ~
         frame (the grant), no tail — the journal never recorded the mint, ~
         because a mint is not an event; the prefix has NOT moved since ~
         the key was minted, and the key is dead anyway"
  (lambda ()
    (and (eq :valid (prefix-report-status *report*))
         (= 1 (prefix-report-frame-count *report*))
         (null (prefix-report-tail-sha256 *report*)))))

;;; 2. L10 — the SAME authorization decision, reconstructed from history.

(rcheck "the SAME authorization decision is re-derived from durable bytes ~
         alone, declared as what it is: origin :reconstructed, decision ~
         :authorized, naming the SAME grant event g-001; the receipt bytes ~
         contain no occurrence of \"observed\""
  (lambda ()
    (let ((receipt (charged-query *store* *bootstrap* "q-reconstructed"
                                  :origin :reconstructed)))
      (and (eq :authorized (receipt-decision receipt))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-001")))
           (string= "origin:reconstructed"
                    (identifier-segment-string
                     (record-field receipt "receipt" "origin")))
           (null (search "observed"
                         (sp-octets-string (encode-pjs0 receipt))))))))

;;; 3. The preserved public record: complete, current, truthful — and dead.

(defvar *auth-octets* (sp-read-octets (auth-receipt-path *run-directory*)))
(defvar *old-auth* (decode-pjs0 *auth-octets*))
(defvar *mint-octets* (sp-read-octets (mint-receipt-path *run-directory*)))
(defvar *old-mint* (decode-pjs0 *mint-octets*))
(defvar *printed-key*
  (sp-octets-string (sp-read-octets (dead-key-print-path *run-directory*))))

(rcheck "the preserved record decodes canonically and is STILL CURRENT ~
         TESTIMONY: the authorization receipt reads :authorized at ~
         ordinal 1 and its binding still names the present validated ~
         prefix; the minting receipt reads kind cap1:minting with the same ~
         binding — nothing about these bytes went stale, which is exactly ~
         what makes what follows the point"
  (lambda ()
    (multiple-value-bind (auth auth-status) (decode-pjs0 *auth-octets*)
      (multiple-value-bind (mint mint-status) (decode-pjs0 *mint-octets*)
        (and auth (eq :canonical auth-status)
             mint (eq :canonical mint-status)
             (eq :authorized (receipt-decision auth))
             (receipt-current-p auth *report*
                                :store-id (journal-store-store-id *store*))
             (string= "cap1:minting"
                      (identifier-segment-string
                       (record-field mint "receipt" "kind")))
             (= 1 (lisp-plus-cd0:integer-datum-value
                   (record-field mint "receipt" "terminal-ordinal"))))))))

(defvar *context* (make-minting-context :label "redivivus"))

;;; 4. NOTHING ON DISK IS, OR CAN BECOME, THE KEY.

(rcheck "THE DEAD KEY CANNOT BE OBTAINED (i): presenting the preserved ~
         AUTHORIZATION receipt as a capability refuses with ~
         cap1-unrecognized-object — still-current justification is still ~
         not a key"
  (lambda ()
    (handler-case
        (progn (charged-presentation *store* *bootstrap* *context*
                                     *old-auth* "p-necro-auth")
               nil)
      (cap1-unrecognized-object () t))))

(rcheck "THE DEAD KEY CANNOT BE OBTAINED (ii): presenting the preserved ~
         MINTING receipt as a capability refuses with ~
         cap1-unrecognized-object, the receipt's claimed public identity ~
         reported as a claim — the fullest public description of the key, ~
         refused by name"
  (lambda ()
    (handler-case
        (progn (charged-presentation *store* *bootstrap* *context*
                                     *old-mint* "p-necro-mint")
               nil)
      (cap1-unrecognized-object (condition)
        (and (cap1-unrecognized-object-presented-public-id condition)
             (search "cap1-key"
                     (cap1-unrecognized-object-presented-public-id
                      condition)))))))

(rcheck "THE DEAD KEY CANNOT BE OBTAINED (iii): a mimic built through the ~
         lane's own INTERNAL constructor (the labelled hostile path) from ~
         the minting receipt's public fields — public identity, occurrence ~
         identity, all four terms, minter, all four binding facets, ~
         everything the disk knows — refuses with ~
         cap1-unrecognized-object: recognition is EQ membership in a table ~
         that died with the first life; NO serializable content re-enters ~
         it"
  (lambda ()
    (let ((mimic (%make-live-capability
                  :public-id (record-field *old-mint* "receipt"
                                           "capability-public-id")
                  :occurrence-id (record-field *old-mint* "receipt"
                                               "occurrence-id")
                  :subject (record-field *old-mint* "receipt" "subject")
                  :action (record-field *old-mint* "receipt" "action")
                  :resource (record-field *old-mint* "receipt" "resource")
                  :scope (record-field *old-mint* "receipt" "scope")
                  :minter (record-field *old-mint* "receipt" "minter")
                  :store-id (lisp-plus-cd0:string-datum-value
                             (record-field *old-mint* "receipt" "store-id"))
                  :terminal-ordinal (lisp-plus-cd0:integer-datum-value
                                     (record-field *old-mint* "receipt"
                                                   "terminal-ordinal"))
                  :valid-byte-count (lisp-plus-cd0:integer-datum-value
                                     (record-field *old-mint* "receipt"
                                                   "valid-byte-count"))
                  :terminal-digest (lisp-plus-cd0:string-datum-value
                                    (record-field *old-mint* "receipt"
                                                  "terminal-digest")))))
      ;; the mimic's binding is CURRENT (the prefix never moved) — so the
      ;; refusal below is recognition's, not staleness's.
      (and (= (live-capability-terminal-ordinal mimic)
              (prefix-report-frame-count *report*))
           (handler-case
               (progn (charged-presentation *store* *bootstrap* *context*
                                            mimic "p-necro-mimic")
                      nil)
             (cap1-unrecognized-object () t))))))

(rcheck "THE DEAD KEY CANNOT BE OBTAINED (iv): the preserved printed form ~
         cannot even be read back — READ-FROM-STRING on it signals (the ~
         #< syntax is reader-rejected); the label on the corpse is not a ~
         resurrection spell"
  (lambda ()
    (handler-case (progn (read-from-string *printed-key*) nil)
      (error () t))))

;;; 5. What CAN happen: a fresh derivation, a fresh mint, a NEW key.

(defvar *new-key* nil)
(defvar *new-mint-receipt* nil)

(rcheck "FRESH DERIVATION + FRESH MINT: this life's own query (declared ~
         identity q-vita-2) is :authorized and the bridge mints a NEW live ~
         key — recognized by THIS context, bound to the same (unmoved) ~
         prefix"
  (lambda ()
    (multiple-value-bind (object receipt)
        (mint-from-authorization *store* *bootstrap* *context*
                                 (charged-query *store* *bootstrap*
                                                *restart-query*)
                                 :minter *specimen-minter*)
      (setf *new-key* object *new-mint-receipt* receipt)
      (and (live-capability-p object)
           (context-recognizes-p *context* object)
           (= 1 (live-capability-terminal-ordinal object))))))

(rcheck "THE NEW KEY IS NEW: its public identity and minting occurrence ~
         identity both DIFFER from the dead key's (recorded in the ~
         preserved minting receipt), while both minting receipts link the ~
         SAME grant event g-001 — same authority lineage, different life, ~
         different key"
  (lambda ()
    (and (not (datum= (live-capability-public-id *new-key*)
                      (record-field *old-mint* "receipt"
                                    "capability-public-id")))
         (not (datum= (live-capability-occurrence-id *new-key*)
                      (record-field *old-mint* "receipt" "occurrence-id")))
         (datum= (record-field *new-mint-receipt* "receipt"
                               "grant-event-id")
                 (record-field *old-mint* "receipt" "grant-event-id"))
         (datum= (record-field *new-mint-receipt* "receipt"
                               "grant-event-id")
                 (identifier-from-segments '("cap0-event" "g-001"))))))

(rnote "dead key (from testimony): ~a"
       (identifier-segment-string
        (record-field *old-mint* "receipt" "capability-public-id")))
(rnote "new key (this life): ~a"
       (identifier-segment-string (live-capability-public-id *new-key*)))

(rcheck "the NEW key presents successfully at the current validated prefix ~
         — live authority has an opaque body again, in this process, ~
         because this process minted one"
  (lambda ()
    (string= "cap1:presented"
             (identifier-segment-string
              (record-field (charged-presentation *store* *bootstrap*
                                                  *context* *new-key*
                                                  "p-vita-2")
                            "receipt" "decision")))))

;;; The new life's minting receipt is preserved for the orchestrator's
;;; cross-life comparison and the tracked artifacts.
(sp-write-octets (mint-receipt-2-path *run-directory*)
                 (encode-pjs0 *new-mint-receipt*))

;;; 6. The restart changed nothing durable.

(rcheck "the restart WROTE NO FRAME: EVENTS.pj0 is byte-identical (sha256) ~
         across the whole reconstruction, four refused necromancies, fresh ~
         mint, and presentation — recognizing, refusing, and minting are ~
         process-local; only /0 events move the journal"
  (lambda ()
    (string= *events-sha-before*
             (sha256-hex (sp-read-octets
                          (merge-pathnames "EVENTS.pj0"
                                           *store-directory*))))))

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *r-checks* *r-failures*)
(sb-ext:exit :code (if (zerop *r-failures*) 0 1))
