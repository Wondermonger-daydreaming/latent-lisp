;;;; stage-restart.lisp — the REDIVIVA: a genuinely new process over
;;;; durable bytes and declared configuration alone.
;;;;
;;;; What it inherits: the journal's bytes (grant · attempt:prepared ·
;;;; attempt:frontier-crossed — and NOTHING after the frontier), the
;;;; world's bytes (cell written, one ledger entry — which this process
;;;; has not yet looked at when it makes its first refusal), and the
;;;; authorization receipt's preserved bytes.  What it does NOT inherit:
;;;; any memory of the dead process, any acknowledgment, any knowledge of
;;;; whether the dispatch landed.
;;;;
;;;; Its charge, in order:
;;;;   1. derive the standing from bytes: crossed-and-unsettled — an open
;;;;      attempt whose effect is nowhere accounted;
;;;;   2. REFUSE BLIND RETRY FROM BYTES ALONE (the crown law's novel
;;;;      half): a fresh mint at the current prefix is lawful, but
;;;;      authorization of a new attempt into the seat refuses
;;;;      unsafe-retry, and re-authorization of the DEAD attempt's own
;;;;      identity refuses duplicate-attempt-identity — both before any
;;;;      frontier, both from durable bytes, the world not yet consulted;
;;;;   3. refuse INLINE reconciliation (unstructured-uncertainty): the
;;;;      §10.8 record must exist before resolution may be attempted;
;;;;   4. STRUCTURE the uncertainty: declare-uncertain-effect journals the
;;;;      §10.8 record built from the journaled facts (kernel /0's own
;;;;      constructor validating UNC-1) — and the seat stays closed;
;;;;   5. RECONCILE with evidence: the declared procedure carries the
;;;;      journaled external-request identity to the surviving world's
;;;;      ledger — the entry IS there — resolution :applied, with the
;;;;      counterfactual exhibited (cell already VII, ledger exactly one
;;;;      entry: a blind retry would have double-applied);
;;;;   6. the seat is lawfully free (fold-derived, from bytes); a fresh
;;;;      authorization into it succeeds; a second reconciliation returns
;;;;      its disposition without a new transition;
;;;;   7. LAW 6: the dead process's authorization receipt is byte-unchanged
;;;;      and still truthful about the prefix it names — the failure after
;;;;      authorization invalidated nothing.
;;;;
;;;; Truncation control: with DE_EFFECTU_DIE=1 this stage exits 3 mid-run
;;;; with no RESULT sentinel (the parent proves an unfinished restart
;;;; never reads as a clean one).
;;;;
;;;; Output protocol: CHECK ok|FAIL · NOTE · RESULT: (exit 0 iff zero
;;;; failures).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

(defvar *v-checks* 0)
(defvar *v-failures* 0)

(defun vcheck (label thunk)
  (incf *v-checks*)
  (let ((label (format nil label))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "CHECK ok ~a~%" label)
        (progn (incf *v-failures*)
               (format t "CHECK FAIL ~a~@[ (~a)~]~%" label
                       (when (consp outcome) (second outcome)))))))

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments)))

;;; ---------------------------------------------------------------------------
;;; Admissible inputs: argv paths + declared configuration + durable bytes.

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *run-directory* (pathname (third *arguments*)))

(vnote "rediviva: durable bytes + declared configuration only; no memory ~
        of the first life exists in this process")

(defvar *store* (open-store *store-directory*))
(defvar *bootstrap* (specimen-bootstrap))
(defvar *context* (make-minting-context :label "rediviva"))

(vcheck "the reopened store validates :valid with exactly 3 frames — ~
         grant · attempt:prepared · attempt:frontier-crossed — and no ~
         tail: the first life's story ends mid-attempt, at the crossed ~
         frontier"
  (lambda ()
    (let ((report (validate-journal *store*)))
      (and (eq :valid (prefix-report-status report))
           (= 3 (prefix-report-frame-count report))
           (null (prefix-report-tail-sha256 report))))))

(vcheck "the standing derived from bytes alone is CROSSED-UNSETTLED: the ~
         frontier was crossed and no settlement, no acknowledgment, no ~
         uncertainty record, no reconciliation exists — an open attempt ~
         whose effect is nowhere accounted (LAW 4: this is its own state; ~
         it is not refusal and not failure, and nothing in the bytes ~
         rewrites it as either)"
  (lambda ()
    (eq :crossed-unsettled (derive-effect-standing *store* *first-attempt*))))

;;; A fresh key at the current prefix IS mintable — authority derivation
;;; still answers :authorized; the grant stands.  What the seat's history
;;; forbids is DISPATCH, not authority.
(defvar *key* (charged-mint *store* *bootstrap* *context* *restart-query*))

(vcheck "a fresh live key mints at the current prefix (the grant stands; ~
         authority is derivable) — minting consulted only the journal and ~
         wrote nothing"
  (lambda ()
    (and (live-capability-p *key*)
         (= 3 (prefix-report-frame-count (validate-journal *store*))))))

(when (equal (sb-ext:posix-getenv "DE_EFFECTU_DIE") "1")
  (vnote "dying mid-restart (planted truncation control)")
  (finish-output)
  (sb-ext:exit :code 3 :abort t))

(vcheck "THE CROWN LAW, FROM BYTES ALONE: authorization of a NEW attempt ~
         into the dead process's seat refuses kernel /0's unsafe-retry — ~
         the journaled frontier-crossed with no settlement carries the ~
         §14.1 prohibition across process death; neither this process's ~
         memory (it has none) nor the world (not yet consulted) ~
         participates in the refusal"
  (lambda ()
    (handler-case
        (progn (charged-authorize *store* *bootstrap* *context* *key*
                                  *restart-auth-query* *second-attempt*)
               nil)
      (lisp-plus-kernel0:unsafe-retry () t))))

(vcheck "the dead attempt's own identity cannot be innocently re-run ~
         either: authorization under a-001 refuses ~
         duplicate-attempt-identity BEFORE any frontier (:408 — a retry ~
         after uncertain execution is not an innocent first attempt in ~
         either spelling)"
  (lambda ()
    (handler-case
        (progn (charged-authorize *store* *bootstrap* *context* *key*
                                  *restart-auth-query* *first-attempt*)
               nil)
      (lisp-plus-kernel0:duplicate-attempt-identity () t))))

(defvar *world* (open-world *world-directory*))

(vcheck "reconciliation WITHOUT the structured record refuses ~
         unstructured-uncertainty (§10.8: inline uncertainty is unlawful; ~
         the record must be journaled before resolution may be attempted)"
  (lambda ()
    (handler-case
        (progn (reconcile-uncertain-effect *store* *world* *first-attempt*
                                           :process-name "rediviva")
               nil)
      (lisp-plus-kernel0:unstructured-uncertainty () t))))

(vcheck "the uncertainty is STRUCTURED from journaled facts: ~
         declare-uncertain-effect builds the §10.8 record through kernel ~
         /0's own constructor (UNC-1 validated: named finite alternatives, ~
         known facts, identified reconciliation procedure, retry-policy ~
         forbidden-without-reconciliation) and journals it in the fixture ~
         grammar — 4 frames now"
  (lambda ()
    (multiple-value-bind (disposition record)
        (declare-uncertain-effect *store* *first-attempt*
                                  :process-name "rediviva")
      (and (eq disposition :declared)
           (lisp-plus-kernel0:uncertain-effect-p record)
           (eq :forbidden-without-reconciliation
               (uncertain-effect-retry-policy record))
           (= 4 (prefix-report-frame-count (validate-journal *store*)))
           (eq :uncertain-unresolved
               (derive-effect-standing *store* *first-attempt*))))))

;;; The declaration moved the prefix, staling the key — the /1 doctrine:
;;; authority is re-derived at each moved prefix and stays cheap to
;;; re-derive; DISPATCH is what the seat's history forbids.
(defvar *key-2* (charged-mint *store* *bootstrap* *context*
                              *restart-query-post-declare*))

(vcheck "the seat stays closed after structuring: even a key re-minted at ~
         the post-declaration prefix — fully current — still refuses ~
         unsafe-retry, now carried by the journaled §10.8 record itself, ~
         rehydrated into kernel /0's own fold (authority is cheap to ~
         re-derive; dispatch is what the record forbids)"
  (lambda ()
    (handler-case
        (progn (charged-authorize *store* *bootstrap* *context* *key-2*
                                  *restart-auth-query* *second-attempt*)
               nil)
      (lisp-plus-kernel0:unsafe-retry () t))))

(vnote "reconciling: carrying the journaled external-request identity to ~
        the surviving world's request ledger")

(vcheck "RECONCILIATION RESOLVES :APPLIED WITH EVIDENCE: the world's ~
         ledger holds the entry under the journaled external-request ~
         identity — the dispatch DID land before the death.  The ~
         counterfactual stands in bytes: cella:septima already holds VII ~
         and the ledger exactly ONE applied entry — a blind retry would ~
         have appended a second application.  attempt:reconciled journaled ~
         (5 frames); the §14.2 receipt was built live through kernel /0's ~
         own constructor before the event was appended"
  (lambda ()
    (multiple-value-bind (resolution event receipt)
        (reconcile-uncertain-effect *store* *world* *first-attempt*
                                    :process-name "rediviva")
      (and (eq resolution :applied)
           event
           (lisp-plus-kernel0:reconciliation-receipt-p receipt)
           (equal "VII" (world-cell-value *world* "cella:septima"))
           (= 1 (world-ledger-count *world*))
           (= 5 (prefix-report-frame-count (validate-journal *store*)))
           (eq :reconciled (derive-effect-standing *store*
                                                   *first-attempt*))))))

(vcheck "ONLY NOW is the seat lawfully free (fold-derived, from bytes: ~
         kernel /0's own resolution predicate over the rehydrated ~
         receipt): authorization of a fresh attempt into the same seat ~
         succeeds — and it is an authorization, not an effect: the cell ~
         and ledger are byte-unmoved by it"
  (lambda ()
    (let* ((key-3 (charged-mint *store* *bootstrap* *context*
                                *restart-query-post-reconcile*))
           (auth (charged-authorize *store* *bootstrap* *context* key-3
                                    *restart-auth-query-2*
                                    *second-attempt*)))
      (and (%authorization-receipt-p auth)
           (equal "VII" (world-cell-value *world* "cella:septima"))
           (= 1 (world-ledger-count *world*))))))

(vcheck "a SECOND reconciliation of the same uncertain effect returns the ~
         precise disposition :already-reconciled naming the prior event — ~
         no new transition, no new frame (LAW 10)"
  (lambda ()
    (multiple-value-bind (disposition event)
        (reconcile-uncertain-effect *store* *world* *first-attempt*)
      (and (eq disposition :already-reconciled)
           event
           (= 5 (prefix-report-frame-count (validate-journal *store*)))))))

(vcheck "LAW 6 (failure after authorization does not retroactively ~
         invalidate authorization): the dead process's ~
         authorization-to-attempt receipt reads back from disk, decodes ~
         :canonical, and still truthfully names the licensed effect ~
         (cella:septima := VII, attempt a-001) and the exact prefix it ~
         was derived at (ordinal 1) — stale for reuse, true forever"
  (lambda ()
    (multiple-value-bind (decoded status)
        (decode-pjs0 (sp-read-octets
                      (auth-attempt-receipt-path *run-directory*)))
      (and decoded (eq :canonical status)
           (%authorization-receipt-p decoded)
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field decoded "receipt" "terminal-ordinal")))
           (string= "VII" (lisp-plus-cd0:string-datum-value
                           (record-field decoded "receipt" "value")))
           (string= "attempt:a-001"
                    (identifier-segment-string
                     (record-field decoded "receipt" "attempt-id")))))))

(vnote "the reconciliation read the world; it wrote nothing there — the ~
        parent verifies the world's bytes are sha-identical across this ~
        entire restart")

;;; ---------------------------------------------------------------------------

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
