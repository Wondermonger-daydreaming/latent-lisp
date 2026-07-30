;;;; run-mutation-gate.lisp — the BILATERAL mutation gate (sealed contract
;;;; §13), both directions, each mutant killed by its exact predicate.
;;;;
;;;; Run from the latent-lisp root:
;;;;
;;;;   sbcl --script mneme/vertical0/mutants/run-mutation-gate.lisp
;;;;
;;;; Exit 0 iff every check passed.  Two reported sections, two independent
;;;; LIVE counters (omission-killed, addition-killed): nothing here is a
;;;; remembered total.
;;;;
;;;; THE STANDARD, stated so it can be held against the transcript:
;;;;
;;;;   A mutant that dies of a generic crash proves nothing.  Every
;;;;   rule-omission kill below names the predicate that did the killing and
;;;;   asserts it BY CONDITION TYPE where a condition exists, or by the
;;;;   declared clause of a named grading predicate where one does not (and
;;;;   says which).  Every rule-addition kill names the §12 founded-progress
;;;;   row it violates and asserts that the row's transition FAILED while
;;;;   its exact durable preconditions held.
;;;;
;;;;   A machine that passes by refusing everything has not passed: the
;;;;   universal-abstention composite installs all nine spurious refusals at
;;;;   once and the gate requires that it does NOT produce a passing
;;;;   campaign.
;;;;
;;;; Every mutant runs the REAL program (program/campaign.lisp's own forms)
;;;; with exactly one rule changed; no predicate is imitated and no
;;;; predecessor source is touched.  Scratch runs live under
;;;; runs/scratch-mutation-*/; runs/campaign-1 and runs/control-* are
;;;; preserved evidence and are never written.
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "../support/forms-loader.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../support/gate-support.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-vertical0)

(defun scratch (name)
  (merge-pathnames (format nil "mneme/vertical0/runs/scratch-mutation-~a/"
                           name)))

(defun mcheck (description thunk) (gcheck "M" description thunk))

(defun record-omission-kill (name predicate strict-ok mutant-ok)
  (incf *omission-total*)
  (let ((killed (and strict-ok mutant-ok t)))
    (when killed (incf *omission-killed*))
    (mcheck (format nil "KILLED (rule-omission) ~a — two-sided, by ~a"
                    name predicate)
            (lambda () killed))))

(defun record-addition-kill (name obligation strict-ok mutant-ok)
  (incf *addition-total*)
  (let ((killed (and strict-ok mutant-ok t)))
    (when killed (incf *addition-killed*))
    (mcheck (format nil "KILLED (rule-addition) ~a — §12 obligation ~
                         \"~a\" did not happen though its preconditions held"
                    name obligation)
            (lambda () killed))))

(defun events-or-nil (root)
  (when (mini-store-present-p root)
    (handler-case (mini-store-events root) (error () nil))))

(defun has-p (events id) (and events (has-event-p events id)))

(gnote "vertical0 mutation gate — bilateral (contract §13).  Every kill ~
        names its predicate.")
(gnote "no pid, no clock, no temporary name appears below: the twin run ~
        must be byte-identical.~%")

;;; Gate teeth, evaluated FIRST so the tooth-firing child is cheap: a gate
;;; whose own failure path has never fired is a gate nobody has tested.
(when (equal (sb-ext:posix-getenv "VERTICAL0_MUTATION_PLANT_FAULT") "1")
  (mcheck "PLANTED FAULT — this check must FAIL and the gate must exit 1"
    (lambda () nil))
  (gnote "~%vertical0 mutation gate: ~a check~:p, ~a failure~:p"
         *gate-checks* *gate-failures*)
  (format t "RESULT: FAIL~%")
  (sb-ext:exit :code 1))

(when (equal (sb-ext:posix-getenv "VERTICAL0_MUTATION_DIE") "1")
  (gnote "VERTICAL0_MUTATION_DIE=1 — dying mid-run WITHOUT a RESULT ~
          sentinel (planted truncation)")
  (sb-ext:exit :code 3))

;;; ===========================================================================
(gnote "== loader fidelity: the mutant child with NO defect IS the program ==")

(let* ((config (mini-config :seats +bank-full-clean+ :order '("seat-alpha")))
       (real-root (scratch "fidelity-real"))
       (mutant-root (scratch "fidelity-mutant")))
  (run-mini-campaign real-root config :program :real)
  (run-mini-campaign mutant-root config :program :mutant)
  (mcheck "mutants/mutant-child.lisp with VERTICAL0_DEFECTS empty produces a ~
           journal BYTE-IDENTICAL to program/campaign.lisp's over the same ~
           fresh configuration — the forms-loader reproduces CL:LOAD, so ~
           every mutant below is the real program with exactly one rule ~
           changed"
    (lambda ()
      (equalp (read-octet-file (merge-pathnames "exec/store/EVENTS.pj0"
                                                real-root))
              (read-octet-file (merge-pathnames "exec/store/EVENTS.pj0"
                                                mutant-root))))))

;;; ===========================================================================
(gnote "~%== RULE-OMISSION — an unjustified action or claim, each killed by ~
        its exact named predicate ==")

;;; --- O1 unsafe retry allowed ------------------------------------------------
(let* ((config (mini-config :seats +bank-frontier+ :order '("seat-torn")
                            :request-loss '("seat-torn")))
       (strict-root (scratch "o1-strict"))
       (mutant-root (scratch "o1-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:unsafe-retry-allowed)))
       (strict-events (events-or-nil strict-root))
       (mutant-events (events-or-nil mutant-root))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O1 STRICT: the CAP2-W1 pre-declaration scan refuses blind ~
                 retry from durable bytes alone — the refusal record is ~
                 journaled naming condition unsafe-retry, and the standing ~
                 stays :uncertain-unresolved"
          (lambda ()
            (let ((scan (find-event strict-events
                                    :event-id
                                    "vertical-event:e-seat-torn-retry-scan")))
              (and (eql 0 (mini-life-exit-code (last-life strict)))
                   scan
                   (equal "unsafe-retry"
                          (body-string (event-body scan) "vertical"
                                       "condition"))
                   (eq :uncertain-unresolved
                       (nth-value 0 (derive-effect-standing
                                     (nth-value 1 (mini-store-events
                                                   strict-root))
                                     "a-seat-torn"))))))))
  (setf mutant-ok
        (mcheck "O1 MUTANT (scan bypassed, fresh key authorizes a retry into ~
                 the poisoned seat): dies signalling exactly UNSAFE-RETRY, ~
                 and no second frontier crossing was ever journaled"
          (lambda ()
            (and (equal "UNSAFE-RETRY"
                        (mini-life-condition-type (last-life mutant)))
                 (not (has-p mutant-events
                             "cap2-event:e-a-seat-torn-retry-frontier"))))))
  (record-omission-kill "unsafe-retry-allowed"
                        "unsafe-retry (Kernel /0 §14.1 · CAP2-W1)"
                        strict-ok mutant-ok))

;;; --- O2 revoked capability accepted ----------------------------------------
(let* ((config (mini-config :seats +bank-revoked+ :order '("seat-dead")
                            :revoked '("seat-dead")))
       (strict-root (scratch "o2-strict"))
       (mutant-root (scratch "o2-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:revoked-accepted)))
       (strict-events (events-or-nil strict-root))
       (mutant-events (events-or-nil mutant-root))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O2 STRICT: the FRESH /0 fold refuses by name — the ~
                 journaled refusal is capability-revoked, and nothing ~
                 crossed"
          (lambda ()
            (let ((refusal (find-event
                            strict-events
                            :event-id "vertical-event:e-seat-dead-refusal")))
              (and refusal
                   (equal "capability-revoked"
                          (body-string (event-body refusal) "vertical"
                                       "refusal"))
                   (not (has-p strict-events
                               "cap2-event:e-a-seat-dead-frontier")))))))
  (setf mutant-ok
        (mcheck "O2 MUTANT (mints from the refusal anyway): dies signalling ~
                 exactly CAP1-MINT-REFUSED — a refusal cannot authorize ~
                 minting — with no frontier crossed"
          (lambda ()
            (and (equal "CAP1-MINT-REFUSED"
                        (mini-life-condition-type (last-life mutant)))
                 (not (has-p mutant-events
                             "cap2-event:e-a-seat-dead-frontier"))))))
  (record-omission-kill "revoked-accepted"
                        "capability-revoked (fresh /0 fold) -> cap1-mint-refused"
                        strict-ok mutant-ok))

;;; --- O3 scope mismatch accepted --------------------------------------------
(let* ((config (mini-config :seats +bank-full-clean+ :order '("seat-alpha")))
       (strict-root (scratch "o3-strict"))
       (mutant-root (scratch "o3-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:scope-mismatch-accepted)))
       (mutant-events (events-or-nil mutant-root))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O3 STRICT: with the capability's resource equal to the ~
                 effect's cell the attempt is authorized and settles"
          (lambda ()
            (and (eql 0 (mini-life-exit-code (last-life strict)))
                 (has-p (events-or-nil strict-root)
                        "cap2-event:e-a-seat-alpha-settled")))))
  (setf mutant-ok
        (mcheck "O3 MUTANT (the key is presented against a cell it does not ~
                 name): dies signalling exactly CAP2-EFFECT-NOT-AUTHORIZED ~
                 — exact four-term equality — with no frontier crossed"
          (lambda ()
            (and (equal "CAP2-EFFECT-NOT-AUTHORIZED"
                        (mini-life-condition-type (last-life mutant)))
                 (not (has-p mutant-events
                             "cap2-event:e-a-seat-alpha-frontier"))))))
  (record-omission-kill "scope-mismatch-accepted"
                        "cap2-effect-not-authorized (exact four-term equality)"
                        strict-ok mutant-ok))

;;; --- O4 budget ceiling ignored ---------------------------------------------
(let* ((config (mini-config
                :seats '((:id "seat-alpha" :route :full-clean
                          :shape "nonempty" :estimate "1000000/1"
                          :cell "cella-alpha"))
                :order '("seat-alpha")))
       (strict-root (scratch "o4-strict"))
       (mutant-root (scratch "o4-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:budget-ignored)))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O4 STRICT: fold(spent)+declared-estimate exceeds the ~
                 declared ceiling, so the seat dies signalling exactly ~
                 BUDGET-CEILING-EXCEEDED BEFORE any frontier — no mint, no ~
                 dispatch, no crossing"
          (lambda ()
            (and (equal "BUDGET-CEILING-EXCEEDED"
                        (mini-life-condition-type (last-life strict)))
                 (not (has-p (events-or-nil strict-root)
                             "cap2-event:e-a-seat-alpha-frontier"))))))
  (setf mutant-ok
        (mcheck "O4 MUTANT (the ceiling check never refuses): the forbidden ~
                 act is committed — the frontier IS crossed and the seat ~
                 settles with the fold over the ceiling"
          (lambda ()
            (and (eql 0 (mini-life-exit-code (last-life mutant)))
                 (has-p (events-or-nil mutant-root)
                        "cap2-event:e-a-seat-alpha-frontier")
                 (has-p (events-or-nil mutant-root)
                        "cap2-event:e-a-seat-alpha-settled")))))
  (record-omission-kill "budget-ignored" "budget-ceiling-exceeded (contract §8)"
                        strict-ok mutant-ok))

;;; --- O5 acknowledgment promoted to settlement ------------------------------
(let* ((config (mini-config :seats +bank-stream+ :order '("seat-song")))
       (strict-root (scratch "o5-strict"))
       (mutant-root (scratch "o5-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:ack-promoted-to-settlement)))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O5 STRICT: settlement rides the captured envelope — the ~
                 custody record and the projection are both durable"
          (lambda ()
            (and (eql 0 (mini-life-exit-code (last-life strict)))
                 (has-p (events-or-nil strict-root)
                        "vertical-event:e-seat-song-envelope-custody")
                 (has-p (events-or-nil strict-root)
                        "ap0-event:e-seat-song-projection")))))
  (setf mutant-ok
        (mcheck "O5 MUTANT (the acknowledgment is treated as terminal ~
                 settlement and the seat is projected with nothing in ~
                 custody): dies signalling exactly PROVIDER-ENVELOPE-MISSING ~
                 (AP-ENV-4), and no projection record exists"
          (lambda ()
            (and (equal "PROVIDER-ENVELOPE-MISSING"
                        (mini-life-condition-type (last-life mutant)))
                 (not (has-p (events-or-nil mutant-root)
                             "ap0-event:e-seat-song-projection"))))))
  (record-omission-kill "ack-promoted-to-settlement"
                        "provider-envelope-missing (AP-ENV-4; an ~
                         acknowledgment has no settling force — AP-ACK-4)"
                        strict-ok mutant-ok))

;;; --- O6 partial stream promoted to complete --------------------------------
(let* ((config (mini-config
                :seats +bank-stream+ :order '("seat-song")
                :route-pauses '((:streaming
                                 "STREAM-CHUNK-CUSTODY-COMMITTED"))))
       (policy (lambda (life seat boundary occurrence)
                 (declare (ignore seat boundary occurrence))
                 (if (= life 1) :eof :continue)))
       (strict-root (scratch "o6-strict"))
       (mutant-root (scratch "o6-mutant"))
       (strict (run-mini-campaign strict-root config :policy policy))
       (mutant (run-mini-campaign mutant-root config :policy policy
                                  :defects '(:partial-promoted-complete)))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O6 STRICT: the partial is CLOSED, never resumed — the typed ~
                 refusal stream-resume-would-duplicate is journaled with ~
                 exactly 1 chunk preserved, and the census standing is ~
                 present-partial / crossed-unsettled-partial-closed"
          (lambda ()
            (let* ((events (events-or-nil strict-root))
                   (closure (find-event
                             events :event-id
                             "vertical-event:e-seat-song-stream-closure"))
                   (outcome (seat-outcome-from-census events "seat-song")))
              (and closure
                   (equal "stream-resume-would-duplicate"
                          (body-string (event-body closure) "vertical"
                                       "condition"))
                   (eql 1 (body-integer (event-body closure) "vertical"
                                        "chunks-preserved"))
                   (equal "present-partial" (getf outcome :manifestation))
                   (equal "crossed-unsettled-partial-closed"
                          (getf outcome :effect))
                   (eql 1 (getf outcome :chunks-preserved)))))))
  (setf mutant-ok
        (mcheck "O6 MUTANT (the stream is resumed from chunk zero so the ~
                 partial can be called complete): dies signalling exactly ~
                 DUPLICATE-ATTEMPT-IDENTITY — resumption requires a second ~
                 crossing of an attempt the validated prefix already binds ~
                 — and no closure record and no census were ever written"
          (lambda ()
            (and (equal "DUPLICATE-ATTEMPT-IDENTITY"
                        (mini-life-condition-type (last-life mutant)))
                 (not (has-p (events-or-nil mutant-root)
                             "vertical-event:e-seat-song-stream-closure"))
                 (not (has-p (events-or-nil mutant-root)
                             "vertical-event:e-census"))))))
  (mcheck "O6 companion leg — the same forbidden SHAPE, presented to ~
           Adapter /0's own validator, is rejected by name: the frozen ~
           BAD-PART-01 fixture (captured chunks erased because no terminal ~
           arrived) refuses partial-manifestation-erasure (AP-STR-7)"
    (lambda ()
      (multiple-value-bind (verdict condition)
          (lisp-plus-adapter0:validate-case
           (lisp-plus-adapter0:read-pjs-fixture
            (merge-pathnames "vectors/adversarial/BAD-PART-01.pjs"
                             lisp-plus-adapter0:+reissue-root+)))
        (and (eq :reject verdict)
             (equal "partial-manifestation-erasure" condition)))))
  (record-omission-kill "partial-promoted-complete"
                        "duplicate-attempt-identity + census partial standing ~
                         (companion: partial-manifestation-erasure)"
                        strict-ok mutant-ok))

;;; --- O7 projection promoted to truth ---------------------------------------
(let* ((config (mini-config :seats +bank-full-clean+ :order '("seat-alpha")))
       (strict-root (scratch "o7-strict"))
       (mutant-root (scratch "o7-mutant"))
       (strict (run-mini-campaign strict-root config))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:projection-promoted-to-truth)))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O7 STRICT: interpretation is a separate transformation and ~
                 journals a receipt — procedure vertical-interpretation-0, ~
                 version 0, BINDING the input projection receipt identity, ~
                 claiming a structural class and never truth"
          (lambda ()
            (let* ((events (events-or-nil strict-root))
                   (receipt (find-event
                             events :event-id
                             "vertical-event:e-seat-alpha-interpretation"))
                   (body (and receipt (event-body receipt))))
              (and (eql 0 (mini-life-exit-code (last-life strict)))
                   body
                   (equal "vertical-interpretation-0"
                          (body-string body "vertical" "procedure-id"))
                   (body-string body "vertical"
                               "input-projection-receipt-id")
                   (body-string body "vertical" "structural-class"))))))
  (setf mutant-ok
        (mcheck "O7 MUTANT (the projection is claimed as verified semantics): ~
                 the journaled interpretation carries NO ~
                 input-projection-receipt-id and NO structural class — a ~
                 claim copied without a transformation receipt"
          (lambda ()
            (let* ((events (events-or-nil mutant-root))
                   (receipt (find-event
                             events :event-id
                             "vertical-event:e-seat-alpha-interpretation"))
                   (body (and receipt (event-body receipt))))
              (and body
                   (null (body-string body "vertical"
                                      "input-projection-receipt-id"))
                   (null (body-string body "vertical" "structural-class"))
                   (equal "verified-semantics"
                          (body-string body "vertical"
                                       "semantic-standing")))))))
  (mcheck "O7 companion leg — the same forbidden SHAPE at Adapter /0: the ~
           frozen BAD-TRUTH-01 fixture (a verified-semantics claim on a ~
           projection) refuses adapter-truth-minting (AP-PRJ-2)"
    (lambda ()
      (multiple-value-bind (verdict condition)
          (lisp-plus-adapter0:validate-case
           (lisp-plus-adapter0:read-pjs-fixture
            (merge-pathnames "vectors/adversarial/BAD-TRUTH-01.pjs"
                             lisp-plus-adapter0:+reissue-root+)))
        (and (eq :reject verdict)
             (equal "adapter-truth-minting" condition)))))
  (record-omission-kill "projection-promoted-to-truth"
                        "the transformation-receipt requirement (companion: ~
                         adapter-truth-minting)"
                        strict-ok mutant-ok))

;;; --- O8 missing cost treated as zero ---------------------------------------
(let* ((config (mini-config :seats +bank-two-clean+
                            :order '("seat-alpha" "seat-beta")))
       (strict-root (scratch "o8-strict"))
       (mutant-root (scratch "o8-mutant"))
       ;; Both arms carry the PLANT (a durable cost record with no readable
       ;; canonical amount).  Only the mutant arm disables the rule.
       (strict (run-mini-campaign strict-root config
                                  :defects '(:cost-record-without-amount)))
       (mutant (run-mini-campaign mutant-root config
                                  :defects '(:cost-record-without-amount
                                             :missing-cost-as-zero)))
       strict-ok mutant-ok)
  (setf strict-ok
        (mcheck "O8 STRICT: the budget fold REFUSES an unreadable journaled ~
                 cost — its declared clause is \"missing cost is never ~
                 zero\" — so the next seat never reaches a frontier.  ~
                 PREDICATE-NAMED, not condition-typed: the fold's refusal is ~
                 a SIMPLE-ERROR carrying that clause, and this gate asserts ~
                 the clause, not merely that something failed"
          (lambda ()
            (let ((child-error (mini-life-child-error (last-life strict))))
              (and (equal "SIMPLE-ERROR"
                          (mini-life-condition-type (last-life strict)))
                   child-error
                   (search "missing cost is never zero" child-error)
                   (not (has-p (events-or-nil strict-root)
                               "cap2-event:e-a-seat-beta-frontier")))))))
  (setf mutant-ok
        (mcheck "O8 MUTANT (unreadable folds as zero): the forbidden act is ~
                 committed — the fold returns a total that silently treats ~
                 the missing amount as free, and the campaign runs to a ~
                 census on it"
          (lambda ()
            (and (eql 0 (mini-life-exit-code (last-life mutant)))
                 (has-p (events-or-nil mutant-root)
                        "cap2-event:e-a-seat-beta-frontier")
                 (has-p (events-or-nil mutant-root)
                        "vertical-event:e-census")))))
  (mcheck "O8 companion leg — at Adapter /0 the category error is refused ~
           upstream: a schedule-less extraction returns the TYPED ~
           missing-cost marker, which is not a record and not a number, so ~
           no zero can be substituted for it (AP-COST-4)"
    (lambda ()
      (let* ((live (bind-live-adapter
                    (descriptor-by-identity "fake-reference-0")
                    :instance-label "gate-cost"))
             (prepared (prepare-invocation
                        live (make-invocation-spec
                              :logical-operation-id "op-o8"
                              :attempt-id "a-o8" :run-label "o8")))
             (handle (dispatch prepared :live-adapter live)))
        (await-terminal handle)
        (let ((marker (extract-cost live handle "fake-cost-procedure-1")))
          (and (missing-cost-marker-p marker)
               (not (numberp marker))
               (stringp (lisp-plus-adapter0:missing-cost-marker-reason
                         marker)))))))
  (record-omission-kill "missing-cost-as-zero"
                        "the budget-fold missing-is-never-zero predicate ~
                         (PREDICATE-NAMED; companion: AP-COST-4 typed marker)"
                        strict-ok mutant-ok))

;;; --- O9 finalizer-only fact accepted ---------------------------------------
;;; In-process, over a COPY of the preserved campaign-1 journal.  The census
;;; procedure is loadable without the orchestration module (contract §11),
;;; which is exactly what makes this test possible.
(let* ((root (scratch "o9"))
       (store-dir (merge-pathnames "store/" root))
       (config (read-vertical-config
                #p"mneme/vertical0/VERTICAL-PROGRAM-CONFIG.sexp"))
       strict-ok mutant-ok)
  (fresh-directory root)
  (copy-tree-directory #p"mneme/vertical0/runs/campaign-1/exec/store/" root)
  (let* ((store (open-store store-dir))
         (strict-record (nth-value 0 (derive-census store config
                                                    :derivation-origin
                                                    "reconstructed")))
         mutant-record)
    (setf strict-ok
          (mcheck "O9 STRICT: a census derived in a fresh fold from the ~
                   PRIMARY durable journal alone (a read-only copy of the ~
                   campaign-1 store; census.lisp loaded without the ~
                   orchestration module) asserts 12 seats and is stable ~
                   across two derivations"
            (lambda ()
              (and (equalp (encode-pjs0 strict-record)
                           (encode-pjs0
                            (nth-value 0 (derive-census
                                          store config
                                          :derivation-origin
                                          "reconstructed"))))
                   (eql 12 (length (census-outcomes store config)))))))
    (install-defects '(:finalizer-only-fact-accepted))
    (setf mutant-record (nth-value 0 (derive-census store config
                                                    :derivation-origin
                                                    "reconstructed")))
    (setf mutant-ok
          (mcheck "O9 MUTANT (the census asserts a per-seat fact held only in ~
                   a finalizer-owned cell): the DELETION PROOF fails — the ~
                   mutant census is not canonically equal to the census the ~
                   primary evidence supports"
            (lambda ()
              (not (equalp (encode-pjs0 strict-record)
                           (encode-pjs0 mutant-record))))))
    (mcheck "O9 named-cell localization tooth: MAKUNBOUND the finalizer cell ~
             and the illicit dependency signals UNBOUND-VARIABLE whose ~
             CELL-ERROR-NAME is exactly the finalizer-only symbol — the ~
             tooth localizes the leak, it does not merely detect it"
      (lambda ()
        (makunbound '*finalizer-only-cache*)
        (handler-case (progn (derive-census store config) nil)
          (unbound-variable (condition)
            (eq '*finalizer-only-cache* (cell-error-name condition))))))
    (uninstall-defects)
    (setf *finalizer-only-cache* '(:label "finalizer-only-fact"))
    (mcheck "O9 restoration: with the defect uninstalled the census is once ~
             more byte-equal to the strict derivation (the gate leaves the ~
             program as it found it)"
      (lambda ()
        (equalp (encode-pjs0 strict-record)
                (encode-pjs0 (nth-value 0 (derive-census
                                           store config
                                           :derivation-origin
                                           "reconstructed"))))))
    (record-omission-kill "finalizer-only-fact-accepted"
                          "the deletion-proof inequality + the named-cell ~
                           tooth (unbound-variable / cell-error-name)"
                          strict-ok mutant-ok)))

;;; --- O10 no-sync durability ------------------------------------------------
(let* ((strict-root (scratch "o10-strict"))
       (mutant-root (scratch "o10-mutant"))
       strict-ok mutant-ok)
  (flet ((sync-arm (root durability)
           (let ((config (mini-config
                          :seats +bank-stream+ :order '("seat-song")
                          :route-pauses '((:streaming
                                           "STREAM-CHUNK-CUSTODY-COMMITTED"))
                          :durability durability))
                 (trace (merge-pathnames "trace-life1.txt" root)))
             (fresh-directory root)
             (setup-mini-exec (merge-pathnames "exec/" root) config)
             (let ((life (run-mini-life
                          (merge-pathnames "exec/" root)
                          :trace-path trace
                          :policy (lambda (l s b o)
                                    (declare (ignore l s b o)) :kill))))
               (let ((events (cl-user::parse-trace trace))
                     (failures 0))
                 ;; The SHIPPED witness checker, reused read-only.
                 (let ((cl-user::*checks* 0) (cl-user::*failures* 0)
                       (*standard-output* (make-broadcast-stream)))
                   (cl-user::check-sync-before-every-ready durability events)
                   (cl-user::check-killed-tail durability events "W-mini")
                   (setf failures cl-user::*failures*))
                 (list :killed (mini-life-killed-p life)
                       :witness-failures failures
                       :journal-fsyncs
                       (length (cl-user::events-matching
                                events :op :fsync :path-suffix "EVENTS.pj0"))
                       :status
                       (prefix-report-status
                        (validate-journal
                         (open-store (merge-pathnames "exec/store/" root))))))))))
    (let ((strict (sync-arm strict-root "synced"))
          (mutant (sync-arm mutant-root "best-effort")))
      (setf strict-ok
            (mcheck "O10 STRICT (declared durability synced): the shipped ~
                     witness checker passes with zero failures — every ~
                     readiness marker came after the last journal append's ~
                     fsync returned, and no semantic write occurred between ~
                     the final marker and SIGKILL"
              (lambda () (and (getf strict :killed)
                              (zerop (getf strict :witness-failures))
                              (plusp (getf strict :journal-fsyncs))))))
      (setf mutant-ok
            (mcheck "O10 MUTANT (the same program on a best-effort journal): ~
                     the shipped witness checker KILLS it — zero ~
                     fsync(EVENTS.pj0) calls exist anywhere in the trace, so ~
                     the readiness marker is unbacked.  AND the corpse's ~
                     bytes still validate :VALID — readable bytes after ~
                     SIGKILL are NOT the passing condition (contract §4)"
              (lambda () (and (getf mutant :killed)
                              (plusp (getf mutant :witness-failures))
                              (zerop (getf mutant :journal-fsyncs))
                              (eq :valid (getf mutant :status))))))))
  (record-omission-kill "no-sync-durability"
                        "the external strace witness ~
                         (check-sync-before-every-ready)"
                        strict-ok mutant-ok))

;;; --- O11 W1 settled through script knowledge -------------------------------
(let* ((config (mini-config
                :seats +bank-control+ :order '("seat-control")
                :route-pauses '((:frontier-only
                                 "EFFECT-FRONTIER-CROSSED-UNSETTLED"))
                :request-loss '("seat-control")))
       strict-ok mutant-ok)
  (flet ((arm (root applied-p defects)
           (let ((exec (merge-pathnames "exec/" root)))
             (run-mini-campaign
              root config :defects defects
              :policy (lambda (life seat boundary occurrence)
                        (declare (ignore life seat occurrence))
                        (cond
                          ((equal boundary "EFFECT-FRONTIER-CROSSED-UNSETTLED")
                           :eof)
                          ((equal boundary "CONTROL-DISPOSITION-COMMITTED")
                           ;; Order-enforced exactly as contract §6 requires:
                           ;; the concurrent provider plays ONLY after the
                           ;; disposition is durable.
                           (when applied-p
                             (write-text-file
                              (merge-pathnames
                               "fake-world/provider-domain.sexp" exec)
                              (provider-domain-with-entry)))
                           :continue)
                          (t :continue))))
             (let* ((events (events-or-nil root))
                    (outcome (find-event
                              events :event-id
                              "vertical-event:e-seat-control-control-outcome")))
               (and outcome (body-string (event-body outcome) "vertical"
                                         "standing"))))))
    (let ((strict-a (arm (scratch "o11-strict-a") t nil))
          (strict-b (arm (scratch "o11-strict-b") nil nil))
          (mutant-a (arm (scratch "o11-mutant-a") t '(:w1-settled-by-script)))
          (mutant-b (arm (scratch "o11-mutant-b") nil
                         '(:w1-settled-by-script))))
      (setf strict-ok
            (mcheck "O11 STRICT: each arm reaches its TRUE standing through ~
                     lawful class-B reconciliation — arm A (effect applied ~
                     provider-side) effect-standing-with-evidence, arm B ~
                     (not applied) settled-no-effect"
              (lambda ()
                (and (equal "effect-standing-with-evidence" strict-a)
                     (equal "settled-no-effect" strict-b)))))
      (setf mutant-ok
            (mcheck "O11 MUTANT (the recovery settles from knowledge of how ~
                     the fake script behaves, reading no class-B evidence): ~
                     WRONG IN ONE ARM — it answers settled-no-effect in ~
                     BOTH, so in arm A it denies an effect the provider ~
                     domain records"
              (lambda ()
                (and (equal "settled-no-effect" mutant-a)
                     (equal "settled-no-effect" mutant-b)
                     (not (equal mutant-a strict-a))))))))
  (mcheck "O11 companion leg — settlement WITHOUT reconciliation evidence is ~
           refused by name at Adapter /0: reconcile-request answering ~
           not-found with no complete-domain conjunction signals ~
           RECONCILIATION-INSUFFICIENT, and with a merely ASSERTED ~
           completeness witness signals ADAPTER-WITNESS-BOUNDARY-MISSING ~
           (AP-REC-6: exact identity + complete authoritative domain + a ~
           distinct OBSERVED witness, or no settlement)"
    (lambda ()
      (let ((live (bind-live-adapter
                   (descriptor-by-identity "fake-reference-0")
                   :instance-label "gate-rec")))
        (and (signals-exactly lisp-plus-adapter0:reconciliation-insufficient
               (reconcile-request live "gate-rec-1" :result "not-found"
                                  :provider-request-id "pr-gate-1"))
             (signals-exactly
                 lisp-plus-adapter0:adapter-witness-boundary-missing
               (reconcile-request live "gate-rec-2" :result "not-found"
                                  :provider-request-id "pr-gate-2"
                                  :domain-complete t
                                  :completeness-witness
                                  '(:evidence-id "e" :boundary "b"
                                    :procedure-id "p" :standing "validated"
                                    :origin "asserted")))))))
  (record-omission-kill "w1-settled-by-script"
                        "the §6 wrong-in-one-arm grading predicate ~
                         (companion: reconciliation-insufficient / ~
                         adapter-witness-boundary-missing)"
                        strict-ok mutant-ok))

;;; ===========================================================================
(gnote "~%== RULE-ADDITION — a spurious refusal where §12 declares a founded ~
        transition ==")

(defvar *founded-strict-root* (scratch "founded-strict"))
(defvar *founded-strict* nil)
(defvar *founded-events* nil)

(setf *founded-strict* (run-mini-campaign *founded-strict-root*
                                          (config-founded)
                                          :policy #'founded-policy))
(setf *founded-events* (events-or-nil *founded-strict-root*))

(gnote "the founded baseline: four seats, three lives, two restarts.  Every ~
        §12 row below is a POSITIVE obligation this run discharges; each ~
        mutant then fails exactly one of them.")

(defvar *founded-ok* nil)
(setf *founded-ok*
      (list
       :authority
       (mcheck "§12 fresh authority on untouched seat — mint -> authorize ~
                yields an authorization receipt (cap2 attempt:prepared for ~
                seat-alpha)"
         (lambda () (has-p *founded-events*
                           "cap2-event:e-a-seat-alpha-prepared")))
       :budget
       (mcheck "§12 sufficient budget before frontier — the attempt proceeds ~
                and its cost record is journaled, with no refusal record"
         (lambda () (and (has-p *founded-events* "ap0-event:e-seat-alpha-cost")
                         (not (has-p *founded-events*
                                     "vertical-event:e-seat-alpha-refusal")))))
       :dispatch
       (mcheck "§12 one lawful dispatch — frontier-crossed + AP0 dispatch + ~
                crossing-evidence-binding are all durable"
         (lambda () (frontier-group-present-p *founded-events* "seat-alpha")))
       :chunk
       (mcheck "§12 one journaled partial chunk — chunk ordinal 1 is durable, ~
                journaled before delivery"
         (lambda () (has-p *founded-events* "ap0-event:e-seat-song-chunk-1")))
       :projection
       (mcheck "§12 one valid envelope projection — live for seat-alpha, and ~
                DERIVED from captured bytes for seat-sealed after its restart"
         (lambda () (and (has-p *founded-events*
                                "ap0-event:e-seat-alpha-projection")
                         (has-p *founded-events*
                                "vertical-event:e-seat-sealed-projection"))))
       :consumption
       (mcheck "§12 one committed projection consumption — the consumption ~
                record references the projection receipt identity"
         (lambda () (has-p *founded-events*
                           "vertical-event:e-seat-alpha-consumption")))
       :settled
       (mcheck "§12 one evidence-settled execution — seat-alpha settles, and ~
                the post-frontier failure seat-slammed reconciles against ~
                surviving world evidence"
         (lambda () (and (has-p *founded-events*
                                "cap2-event:e-a-seat-alpha-settled")
                         (has-p *founded-events*
                                "cap2-event:e-a-seat-slammed-reconciled"))))
       :untouched
       (mcheck "§12 untouched seat resumed after restart — seat-slammed is ~
                ABSENT from the life-2 journal snapshot and its complete ~
                record set appears only in life 3"
         (lambda ()
           (let ((life2 (snapshot-events *founded-strict-root* 2)))
             (and life2
                  (not (has-event-p life2 "ap0-event:e-seat-slammed-prepared"))
                  (has-p *founded-events*
                         "ap0-event:e-seat-slammed-prepared")
                  (has-p *founded-events*
                         "cap2-event:e-a-seat-slammed-reconciled")))))
       :census
       (mcheck "§12 founded nonempty census assertion — a 4-seat outcome map ~
                is journaled and the campaign completes"
         (lambda ()
           (and (has-p *founded-events* "vertical-event:e-census")
                (has-p *founded-events* "vertical-event:e-campaign-complete")
                (eql 0 (mini-life-exit-code (last-life *founded-strict*))))))))

(defun addition-mutant (name obligation strict-key absent-ids
                        &key extra-check)
  "Run the founded baseline with NAME installed and require that every id in
ABSENT-IDS is missing from the durable evidence."
  (let* ((root (scratch (format nil "add-~a"
                                (string-downcase (symbol-name name)))))
         (results (run-mini-campaign root (config-founded)
                                     :defects (list name)
                                     :policy #'founded-policy))
         (events (events-or-nil root))
         (mutant-ok
           (mcheck (format nil "~a MUTANT: ~:[the transition is refused ~
                                though its preconditions hold~;~:*~{~a~^, ~} ~
                                absent from durable evidence though the ~
                                transition's preconditions held~]"
                           (string-downcase (symbol-name name)) absent-ids)
             (lambda ()
               (and (notany (lambda (id) (has-p events id)) absent-ids)
                    (or (null extra-check)
                        (funcall extra-check events results)))))))
    (record-addition-kill (string-downcase (symbol-name name)) obligation
                          (getf *founded-ok* strict-key) mutant-ok)))

(addition-mutant :deny-every-mint
                 "fresh authority on untouched seat" :authority
                 '("cap2-event:e-a-seat-alpha-prepared"
                   "cap2-event:e-a-seat-alpha-frontier"))
(addition-mutant :every-seat-poisoned
                 "one lawful dispatch" :dispatch
                 '("cap2-event:e-a-seat-alpha-frontier"
                   "ap0-event:e-seat-alpha-dispatch"
                   "ap0-event:e-seat-song-chunk-1"))
(addition-mutant :every-budget-exhausted
                 "sufficient budget before frontier" :budget
                 '("cap2-event:e-a-seat-alpha-frontier"
                   "ap0-event:e-seat-alpha-cost"))
(addition-mutant :suppress-every-dispatch
                 "one lawful dispatch" :dispatch
                 '("cap2-event:e-a-seat-alpha-frontier"
                   "cap2-event:e-a-seat-alpha-settled"))
(addition-mutant :refuse-every-projection
                 "one valid envelope projection" :projection
                 '("ap0-event:e-seat-alpha-projection"
                   "vertical-event:e-seat-sealed-projection"))
(addition-mutant :refuse-every-consumption
                 "one committed projection consumption" :consumption
                 '("vertical-event:e-seat-alpha-consumption"
                   "vertical-event:e-seat-sealed-consumption"))
(addition-mutant :preserve-uncertainty-despite-evidence
                 "one evidence-settled execution" :settled
                 '("cap2-event:e-a-seat-slammed-reconciled")
                 :extra-check
                 (lambda (events results)
                   (declare (ignore results))
                   ;; The uncertainty was STRUCTURED and the surviving world
                   ;; ledger is complete: the evidence was there to be used.
                   (and (has-p events "cap2-event:e-a-seat-slammed-uncertain")
                        (has-p events "ap0-event:e-seat-slammed-dispatch"))))
(addition-mutant :every-manifestation-unresolved
                 "founded nonempty census assertion" :census
                 '()
                 :extra-check
                 (lambda (events results)
                   (declare (ignore results))
                   ;; The census exists but resolves nothing, though every
                   ;; seat's manifestation is derivable from durable bytes.
                   (and (has-p events "vertical-event:e-census")
                        (every (lambda (seat)
                                 (equal "unresolved"
                                        (getf (seat-outcome-from-census
                                               events seat)
                                              :manifestation)))
                               '("seat-alpha" "seat-song" "seat-sealed"
                                 "seat-slammed")))))
(addition-mutant :refuse-founded-census
                 "founded nonempty census assertion" :census
                 '("vertical-event:e-census"
                   "vertical-event:e-campaign-complete"))

;;; --- the universal-abstention composite ------------------------------------
(let* ((root (scratch "add-universal-abstention"))
       (results (run-mini-campaign root (config-founded)
                                   :defects (defects-of-class :addition)
                                   :policy #'founded-policy))
       (events (events-or-nil root)))
  (mcheck "UNIVERSAL ABSTENTION composite — all nine spurious refusals ~
           installed at once: the machine refuses EVERYTHING and this is NOT ~
           a passing campaign.  No frontier crossed, no chunk, no ~
           projection, no consumption, no settlement, no census, no ~
           campaign-complete, and the last life does not exit 0"
    (lambda ()
      (and (notany (lambda (id) (has-p events id))
                   '("cap2-event:e-a-seat-alpha-frontier"
                     "cap2-event:e-a-seat-alpha-settled"
                     "ap0-event:e-seat-song-chunk-1"
                     "ap0-event:e-seat-alpha-projection"
                     "vertical-event:e-seat-alpha-consumption"
                     "cap2-event:e-a-seat-slammed-reconciled"
                     "vertical-event:e-census"
                     "vertical-event:e-campaign-complete"))
           (not (eql 0 (mini-life-exit-code (last-life results)))))))
  (mcheck "UNIVERSAL ABSTENTION — and the abstention is VISIBLE, not silent: ~
           every seat carries a journaled refusal record naming the invented ~
           refusal, so the gate is reading refusals rather than a crash"
    (lambda ()
      (every (lambda (seat)
               (let ((refusal (find-event
                               events :event-id
                               (format nil "vertical-event:e-~a-refusal"
                                       seat))))
                 (and refusal
                      (equal "spurious-poisoned-seat"
                             (body-string (event-body refusal) "vertical"
                                          "refusal")))))
             '("seat-alpha" "seat-song" "seat-sealed" "seat-slammed")))))

;;; ===========================================================================
(gnote "~%== gate teeth — a gate that has never fired is untested ==")

(mcheck "the planted-fault tooth FIRES: a child gate with ~
         VERTICAL0_MUTATION_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED FAULT ~
         — the gate can fail, so its PASS is evidence"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script"
                           "mneme/vertical0/mutants/run-mutation-gate.lisp")
                     :search t :output output :error output
                     :environment
                     (cons "VERTICAL0_MUTATION_PLANT_FAULT=1"
                           (sb-ext:posix-environ))))
           (text (get-output-stream-string output)))
      (and (eql 1 (sb-ext:process-exit-code process))
           (search "FAIL PLANTED FAULT" text)))))

(mcheck "the truncation tooth FIRES: a child gate with ~
         VERTICAL0_MUTATION_DIE=1 exits 3 with NO RESULT sentinel — ~
         truncation before a canonical result is detectable as exactly that ~
         pair, never mistakable for a pass"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script"
                           "mneme/vertical0/mutants/run-mutation-gate.lisp")
                     :search t :output output :error output
                     :environment (cons "VERTICAL0_MUTATION_DIE=1"
                                        (sb-ext:posix-environ))))
           (text (get-output-stream-string output)))
      (and (eql 3 (sb-ext:process-exit-code process))
           (not (search "RESULT:" text))))))

;;; ===========================================================================

(gnote "~%RULE-OMISSION killed: ~a of ~a (live counter)"
       *omission-killed* *omission-total*)
(gnote "RULE-ADDITION killed: ~a of ~a (live counter)"
       *addition-killed* *addition-total*)
(gnote "vertical0 mutation gate: ~a check~:p, ~a failure~:p"
       *gate-checks* *gate-failures*)
(if (and (zerop *gate-failures*)
         (= *omission-killed* *omission-total*)
         (= *addition-killed* *addition-total*))
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
