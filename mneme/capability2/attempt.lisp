;;;; attempt.lisp — the explicit effect invocation: the first door where
;;;; something actually happens.
;;;;
;;;; ATTEMPT-PROTECTED-EFFECT is the lane's perform-CLASS door (the two-door
;;;; law): announced effect-possibility (the authorization receipt's §10.1/
;;;; §10.2 declaration), authority-bearing (the presented live capability),
;;;; journaled (attempt:prepared and attempt:frontier-crossed BEFORE
;;;; dispatch; acknowledgment and terminal AFTER), manifested (the world's
;;;; durable bytes), retry-disciplined (the §14.1 gate at authorization +
;;;; the staleness conjunction here).  It deliberately claims NONE of the
;;;; Kernel §19.3/§19.2 reserved verbs (prepare-effect / cross-frontier /
;;;; settle-effect / begin-attempt ...) and does not collide with core0's
;;;; occupied PERFORM.
;;;;
;;;; THE PREFLIGHT (§10.4 R-SYN-3, adjudicated order; every refusal typed,
;;;; pre-frontier, external-effect :NOT-ENTERED, journal + world + cell all
;;;; untouched):
;;;;   1. the world is declared (required durable sink availability);
;;;;   2. the authorization-to-attempt receipt is present and structurally
;;;;      one (CAP2-AUTHORIZATION-MISSING);
;;;;   3. the receipt binds the CURRENT validated prefix — fresh
;;;;      validate-journal, four facets (CAP2-STALE-AUTHORIZATION, both
;;;;      prefixes named).  THIS is the §11.6 re-check at the frontier:
;;;;      revocation (or ANY commit) between authorization and invocation
;;;;      moves the prefix and refuses here, before any dispatch.  The
;;;;      check-then-effect gap is closed by prefix-binding + re-check; the
;;;;      Constitution's E6 atomic-authority-ledger property is NOT
;;;;      claimed;
;;;;   4. the capability is presented FRESH under the receipt's exact terms
;;;;      (capability1's discipline; its typed refusals propagate);
;;;;   5. the receipt licenses THIS invocation — capability public identity
;;;;      match (CAP2-AUTHORIZATION-MISMATCH);
;;;;   6. the attempt identity is unbound in the prefix
;;;;      (DUPLICATE-ATTEMPT-IDENTITY — :408, before any frontier).
;;;;
;;;; UNRESOLVED-PREDECESSOR RESTRICTIONS AT INVOCATION (adjudicated): the
;;;; §14.1 fold runs at AUTHORIZATION (authorize.lisp), and every journal
;;;; event that could create a new unresolved predecessor necessarily moves
;;;; the validated prefix, which refuses HERE as staleness (step 3).  The
;;;; conjunction {gate at authorization} + {exact prefix re-check at
;;;; invocation} is what establishes §10.4 step 5 at the frontier; a
;;;; second fold here would be an unreachable gate on the strict path, and
;;;; this lane does not plant unreachable gates.
;;;;
;;;; THE FRONTIER (§10.3): attempt:prepared then attempt:frontier-crossed
;;;; are journaled, THEN the adapter is dispatched.  From the first
;;;; journaled byte of frontier-crossed onward, no failure may be rewritten
;;;; as refusal (§9.2) — every later outcome is settlement, uncertainty, or
;;;; reconciliation, never "it didn't happen".
;;;;
;;;; SETTLEMENT (AP-ACK-4, executable): the acknowledgment is journaled as
;;;; TESTIMONY.  Settlement is derived by VERIFYING the acknowledgment's
;;;; evidence against the surviving world (re-read the ledger entry,
;;;; recompute its digest, re-read the cell bytes) — only then is
;;;; effect:settled journaled, naming the evidence.  An acknowledgment
;;;; carrying no verifiable evidence (the scripted :acknowledgment-ambiguous
;;;; class, or evidence that fails verification) settles NOTHING: the
;;;; §10.8 record is constructed (kernel /0's own constructor validates
;;;; UNC-1) and journaled, and the seat is thereafter closed to blind
;;;; dispatch.  The planted defect :ACK-PROMOTES-TO-SETTLED (mutants.lisp)
;;;; is the design this file forbids — settlement from the acknowledgment
;;;; class alone — kept alive in one guarded branch to be killed.
;;;;
;;;; PLANTED INTERRUPTION POINTS (deterministic, suites/specimen only;
;;;; production value NIL): :REQUEST-LOST stops after frontier-crossed is
;;;; journaled and before the adapter is called (the request that never
;;;; landed — reconciliation branch (b)); the acknowledgment-window death
;;;; itself is planted in the ADAPTER (world.lisp, env-var; board point 2).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defun %receipt-string (receipt name)
  (lisp-plus-cd0:string-datum-value (record-field receipt "receipt" name)))

(defun %receipt-integer (receipt name)
  (lisp-plus-cd0:integer-datum-value (record-field receipt "receipt" name)))

(defun %authorization-receipt-p (datum)
  (and datum
       (lisp-plus-cd0:record-datum-p datum)
       (let ((kind (record-field datum "receipt" "kind")))
         (and kind
              (lisp-plus-cd0:identifier-datum-p kind)
              (string= "cap2:authorization-to-attempt"
                       (identifier-segment-string kind))))))

(defun %check-authorization-current (store authorization)
  "Step 3: the receipt's four facets against the CURRENT validated prefix."
  (let* ((report (validate-journal store))
         (current-store-id (journal-store-store-id store))
         (current-ordinal (prefix-report-frame-count report))
         (current-bytes (prefix-report-valid-byte-count report))
         (current-digest (prefix-report-terminal-digest report)))
    (unless (and (string= (%receipt-string authorization "store-id")
                          current-store-id)
                 (= (%receipt-integer authorization "terminal-ordinal")
                    current-ordinal)
                 (= (%receipt-integer authorization "valid-byte-count")
                    current-bytes)
                 (string= (%receipt-string authorization "terminal-digest")
                          current-digest))
      (error 'cap2-stale-authorization
             :requirement-id "CAP2-INV-1"
             :authorization-store-id (%receipt-string authorization
                                                      "store-id")
             :authorization-terminal-ordinal
             (%receipt-integer authorization "terminal-ordinal")
             :authorization-valid-byte-count
             (%receipt-integer authorization "valid-byte-count")
             :authorization-terminal-digest
             (%receipt-string authorization "terminal-digest")
             :present-store-id current-store-id
             :present-terminal-ordinal current-ordinal
             :present-valid-byte-count current-bytes
             :present-terminal-digest current-digest
             :detail "the journal moved between authorization and ~
                      invocation; whatever moved it (an unrelated commit, ~
                      a revocation) the answer must be re-derived"))
    report))

(defun attempt-protected-effect (store bootstrap context capability
                                 authorization world
                                 &key (process-name "cap2-process")
                                      interruption defect)
  "Invoke the ONE exact protected effect the AUTHORIZATION licenses.
Returns (values status detail):
  :settled      — dispatched, acknowledged, and settlement DERIVED from
                  verified evidence; effect:settled journaled; DETAIL is
                  the acknowledgment class;
  :uncertain    — dispatched and acknowledged without verifiable evidence;
                  the §10.8 record journaled; DETAIL is the live
                  uncertain-effect record;
  :interrupted  — a planted deterministic interruption point stopped the
                  flow; DETAIL names the point.
Every refusal is a typed signal; refusals journal nothing and touch no
world byte.  INTERRUPTION is a planted test seam (:REQUEST-LOST); DEFECT
selects a planted mutant (:ACK-PROMOTES-TO-SETTLED); production values are
NIL."
  ;; 1-2. Required sink + the license itself.
  (%check-world world)
  (unless (%authorization-receipt-p authorization)
    (error 'cap2-authorization-missing
           :requirement-id "CAP2-INV-0"
           :presented-type (type-of authorization)
           :detail "invocation requires an authorization-to-attempt ~
                    receipt; nothing else licenses a protected effect"))
  ;; 3. Exact prefix re-check (the §11.6 frontier re-check).
  (%check-authorization-current store authorization)
  ;; 4. Fresh presentation under the receipt's exact terms.
  (let ((attempt-name (car (last (identifier-segments
                                  (record-field authorization
                                                "receipt" "attempt-id")))))
        (cell (record-field authorization "receipt" "cell"))
        (value (%receipt-string authorization "value")))
    (present-live-capability store bootstrap context capability
                             :subject (record-field authorization
                                                    "receipt" "subject")
                             :action (record-field authorization
                                                   "receipt" "action")
                             :resource (record-field authorization
                                                     "receipt" "resource")
                             :scope (record-field authorization
                                                  "receipt" "scope")
                             :presentation-id
                             (list "cap2-present"
                                   (format nil "invoke-~a" attempt-name)))
    ;; 5. The receipt licenses THIS capability.
    (let ((mismatches '()))
      (unless (datum= (record-field authorization "receipt"
                                    "capability-public-id")
                      (live-capability-public-id capability))
        (push "capability-public-id" mismatches))
      (unless (datum= cell (live-capability-resource capability))
        (push "cell" mismatches))
      (when mismatches
        (error 'cap2-authorization-mismatch
               :requirement-id "CAP2-INV-2"
               :facets (reverse mismatches)
               :detail "the authorization receipt does not license this ~
                        capability and effect")))
    ;; 6. Duplicate attempt identity — :408, before any frontier.
    (when (%attempt-identity-taken-p store attempt-name)
      (signal-kernel0
       'duplicate-attempt-identity
       :attempt-id (make-identity :attempt (format nil "attempt:~a"
                                                   attempt-name))
       :requirement-id "CAP2-INV-3"
       :failed-invariant
       "§6.6 and :408: this attempt identity is already bound in the ~
        validated prefix; one authorization licenses one attempt, once"))
    ;; ---- THE FRONTIER.  Everything above could still refuse with the
    ;; effect :not-entered; nothing below may be rewritten as refusal.
    (let ((seat-name (car (last (identifier-segments
                                 (record-field authorization
                                               "receipt" "seat-id"))))))
      (append-event store (make-attempt-prepared-event
                           :attempt-name attempt-name
                           :seat-name seat-name
                           :process-name process-name))
      (append-event store (make-frontier-crossed-event
                           :attempt-name attempt-name
                           :process-name process-name)))
    (when (eq interruption :request-lost)
      ;; Planted point: the frontier is journaled as crossed; the request
      ;; never reaches the world.  From the bytes alone this is
      ;; indistinguishable from a request lost in flight — which is the
      ;; point.
      (return-from attempt-protected-effect
        (values :interrupted :request-lost)))
    (let ((request-id-string (identifier-segment-string
                              (%external-request-identifier attempt-name)))
          (cell-name (identifier-segment-string cell)))
      (multiple-value-bind (ack-class ledger-entry-sha cells-sha)
          (%world-apply-request world request-id-string cell-name value)
        ;; The acknowledgment, journaled as testimony (AP-ACK-4: no
        ;; settling force by itself).
        (append-event store (make-acknowledged-event
                             :attempt-name attempt-name
                             :process-name process-name
                             :class ack-class
                             :ledger-entry-sha ledger-entry-sha
                             :cells-sha cells-sha))
        ;; Settlement — derived from VERIFIED evidence, never from the
        ;; class.  The mutant branch is the forbidden design, kept to be
        ;; killed.
        (if (if (eq defect :ack-promotes-to-settled)
                ;; PLANTED DEFECT: any acknowledgment "settles".
                t
                ;; STRICT: verify the acknowledgment's evidence against
                ;; the surviving world.
                (and (eq ack-class :provider-terminal)
                     ledger-entry-sha
                     cells-sha
                     (multiple-value-bind (found-p line line-sha)
                         (world-ledger-lookup world request-id-string)
                       (declare (ignore line))
                       (and found-p
                            (string= line-sha ledger-entry-sha)))
                     (string= (world-cells-sha256 world) cells-sha)
                     (equal (world-cell-value world cell-name) value)))
            (progn
              (append-event store
                            (make-effect-settled-event
                             :attempt-name attempt-name
                             :process-name process-name
                             :evidence-segments
                             (if (eq defect :ack-promotes-to-settled)
                                 (list (list "ack" "class-only"))
                                 (list (list "cap2-event"
                                             (format nil "e-~a-ack"
                                                     attempt-name))
                                       (list "world-ledger-entry"
                                             attempt-name)
                                       (list "world-ledger-entry-sha256"
                                             ledger-entry-sha)))))
              (values :settled ack-class))
            (let ((record
                    (make-uncertain-effect
                     :kind :external-write
                     :attempt (make-identity
                               :attempt (format nil "attempt:~a"
                                                attempt-name))
                     :external-request (make-identity
                                        :external-request request-id-string)
                     :possible-effects '(:cell-written :cell-not-written)
                     :known-facts (list
                                   (make-identity
                                    :receipt
                                    (format nil "cap2-event:e-~a-frontier"
                                            attempt-name))
                                   (make-identity
                                    :receipt
                                    (format nil "cap2-event:e-~a-ack"
                                            attempt-name)))
                     :reconciliation-procedure
                     (make-identity :procedure
                                    (identifier-segment-string
                                     (identifier-from-segments
                                      +reconciliation-procedure-segments+)))
                     :retry-policy :forbidden-without-reconciliation)))
              (append-event store
                            (make-effect-uncertain-event
                             :attempt-name attempt-name
                             :process-name process-name
                             :known-fact-segments
                             (list (list "cap2-event"
                                         (format nil "e-~a-frontier"
                                                 attempt-name))
                                   (list "cap2-event"
                                         (format nil "e-~a-ack"
                                                 attempt-name)))))
              (values :uncertain record)))))))
