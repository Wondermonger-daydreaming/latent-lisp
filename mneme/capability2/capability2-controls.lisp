;;;; capability2-controls.lisp — the owner's vertical, inhabited end to
;;;; end, plus the negative controls.
;;;;
;;;; Run:  sbcl --script mneme/capability2/capability2-controls.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: fixed nonces (declared PJ-META-1 deviation, test fixtures
;;;; only), declared identities, no pid/timestamp/path in the transcript.
;;;;
;;;; Gate teeth: CAP2_CONTROLS_PLANT_FAULT=1 plants a failing check (exit
;;;; 1); CAP2_CONTROLS_DIE=1 kills the run mid-flight (exit 3, no RESULT:
;;;; sentinel).  The final two checks spawn exactly those children.
;;;;
;;;; The restart-flavored controls here reopen the store and world from
;;;; bytes via OPEN-STORE / OPEN-WORLD within THIS process — they prove the
;;;; derivations consult bytes, not which process holds them; the genuinely
;;;; NEW-process restart is the specimen's jurisdiction
;;;; (de-effectu-incerto/).
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability2)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defvar *root* #p"mneme/capability2/scratch-controls/")
(when (probe-file *root*)
  (sb-ext:delete-directory *root* :recursive t))

(note "capability2-controls — the effect vertical and its negative controls")
(note "governing sentence: a recognized, current capability may justify ~
       attempting one exact protected effect — but neither the capability ~
       nor its presentation receipt proves that the effect occurred.~%")

;;; ---------------------------------------------------------------------------
(note "== the owner's vertical, end to end ==")

(defvar *store* nil)
(defvar *world* nil)
(defvar *bootstrap* nil)
(defvar *context* nil)
(defvar *key* nil)

(multiple-value-setq (*store* *world* *bootstrap* *context* *key*)
  (%kill-scenario *root* "vertical" :script :apply))

(defvar *cells-sha-0* (world-cells-sha256 *world*))

(check "fresh live capability presentation: the minted key presents ~
        successfully at the current prefix under its exact terms — and ~
        presenting it changed NOTHING (cell bytes and ledger byte-compared ~
        unchanged; journal frame count still 1)"
  (lambda ()
    (let ((receipt (present-live-capability *store* *bootstrap* *context*
                                            *key*
                                            :subject +kill-subject+
                                            :action +kill-action+
                                            :resource +kill-cell+
                                            :scope +kill-scope+
                                            :presentation-id
                                            '("cap2-present" "vertical-0"))))
      (and (string= "cap1:presented"
                    (identifier-segment-string
                     (record-field receipt "receipt" "decision")))
           (string= *cells-sha-0* (world-cells-sha256 *world*))
           (= 0 (world-ledger-count *world*))
           (= 1 (prefix-report-frame-count (validate-journal *store*)))))))

(defvar *auth* nil)

(check "authorization to attempt: the §11.4-subset check passes (fresh /0 ~
        fold :authorized · fresh presentation · exact effect match · ~
        attempt identity unbound · seat fold clean) and yields the ~
        prefix-bound authorization-to-attempt receipt — while the cell, ~
        the ledger, and the journal remain untouched (law 2)"
  (lambda ()
    (setf *auth* (%kill-authorize *store* *bootstrap* *context* *key*
                                  "a-001"))
    (and (%authorization-receipt-p *auth*)
         (= 1 (%receipt-integer *auth* "terminal-ordinal"))
         (datum= (record-field *auth* "receipt" "capability-public-id")
                 (live-capability-public-id *key*))
         (string= *cells-sha-0* (world-cells-sha256 *world*))
         (= 0 (world-ledger-count *world*))
         (= 1 (prefix-report-frame-count (validate-journal *store*))))))

(check "explicit effect invocation: attempt:prepared and ~
        attempt:frontier-crossed journaled per the fixture grammar, the ~
        adapter dispatched, the ONE exact cell set — and settlement ~
        DERIVED from verified evidence, not from the acknowledgment class ~
        (AP-ACK-4): status :settled with class :provider-terminal"
  (lambda ()
    (multiple-value-bind (status detail)
        (attempt-protected-effect *store* *bootstrap* *context* *key*
                                  *auth* *world*
                                  :process-name "vertical")
      (and (eq status :settled)
           (eq detail :provider-terminal)
           (equal "VII" (world-cell-value *world* "cella:septima"))
           (= 1 (world-ledger-count *world*))))))

(check "the durable journal account holds the whole story in order: grant ~
        · attempt:prepared · attempt:frontier-crossed · ~
        request:acknowledged · effect:settled — five frames, :valid, no ~
        tail; queries and receipts are NOT in it"
  (lambda ()
    (let* ((report (validate-journal *store*))
           (events (prefix-report-events report))
           (kinds (loop for index below (fill-pointer events)
                        collect (%event-kind-string (aref events index)))))
      (and (eq :valid (prefix-report-status report))
           (= 5 (prefix-report-frame-count report))
           (equal kinds '("capability0:granted"
                          "attempt:prepared"
                          "attempt:frontier-crossed"
                          "request:acknowledged"
                          "effect:settled"))))))

(check "the acknowledgment was journaled as TESTIMONY: the ~
        request:acknowledged event carries class ack:provider-terminal ~
        plus the ledger-entry and cell-store digests — and those digests ~
        re-verify RIGHT NOW against the surviving world's bytes"
  (lambda ()
    (multiple-value-bind (standing details)
        (derive-effect-standing *store* "a-001")
      (declare (ignore standing))
      (let ((ack (getf details :acknowledged)))
        (multiple-value-bind (found-p line line-sha)
            (world-ledger-lookup *world* "external-request:cap2:a-001")
          (declare (ignore line))
          (and ack found-p
               (string= "ack:provider-terminal"
                        (identifier-segment-string
                         (%body-field ack "ack" "acknowledgment-class")))
               (string= line-sha
                        (lisp-plus-cd0:string-datum-value
                         (%body-field ack "ack" "ledger-entry-sha256")))
               (string= (world-cells-sha256 *world*)
                        (lisp-plus-cd0:string-datum-value
                         (%body-field ack "ack" "cells-sha256")))))))))

(check "the cell was set EXACTLY ONCE (the ledger holds one applied entry ~
        under this request identity) and the effect standing derived from ~
        bytes is :settled"
  (lambda ()
    (and (= 1 (world-ledger-count *world* "external-request:cap2:a-001"))
         (eq :settled (derive-effect-standing *store* "a-001")))))

;;; ---------------------------------------------------------------------------
(note "~%== negative controls: authorization refusals ==")

(check "NC-1 wrong effect vs capability terms: a request for cella:nona ~
        against the cella:septima capability refuses ~
        cap2-effect-not-authorized; nothing journaled, nothing written"
  (lambda ()
    (let ((frames (prefix-report-frame-count (validate-journal *store*)))
          (key (%kill-remint *store* *bootstrap* *context* "nc1")))
      (handler-case
          (progn (authorize-effect-attempt *store* *bootstrap* *context* key
                                           :capability-id +kill-capability+
                                           :query-name "q-nc1"
                                           :subject +kill-subject+
                                           :action +kill-action+
                                           :resource +kill-cell+
                                           :scope +kill-scope+
                                           :cell '("cella" "nona")
                                           :value "VII"
                                           :attempt-name "a-nc1"
                                           :seat-name "sedes-2")
                 nil)
        (cap2-effect-not-authorized ()
          (and (= frames (prefix-report-frame-count
                          (validate-journal *store*)))
               (= 1 (world-ledger-count *world*))))))))

(check "NC-2 duplicate attempt identity refuses BEFORE the frontier: a ~
        fresh, current key asking to re-run attempt a-001 refuses ~
        kernel /0's duplicate-attempt-identity; frame count unchanged"
  (lambda ()
    (let ((frames (prefix-report-frame-count (validate-journal *store*)))
          (key (%kill-remint *store* *bootstrap* *context* "nc2")))
      (handler-case
          (progn (%kill-authorize *store* *bootstrap* *context* key "a-001")
                 nil)
        (lisp-plus-kernel0:duplicate-attempt-identity ()
          (= frames (prefix-report-frame-count (validate-journal *store*))))))))

(check "NC-3 revoked capability at authorization: after the revocation ~
        commits, the FRESH /0 fold refuses and ~
        cap2-attempt-authorization-refused names the fold's reason ~
        (capability-revoked) — the revocation check runs before the ~
        object's own staleness can mask it"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "revoked" :script :apply)
      (declare (ignore world))
      (append-event store (make-revocation-event
                           :event-id '("cap0-event" "r-001")
                           :capability-id +kill-capability+
                           :issuer +kill-issuer+))
      (handler-case
          (progn (%kill-authorize store bootstrap context key "a-rv1")
                 nil)
        (cap2-attempt-authorization-refused (condition)
          (and (eq :fresh-derivation-refused
                   (cap2-attempt-authorization-refused-basis condition))
               (search "revoked"
                       (format nil "~a"
                               (cap2-attempt-authorization-refused-fresh-reason
                                condition)))
               t))))))

(check "NC-4 a merely-advanced (unrevoked) journal refuses the OLD key as ~
        cap1-stale-capability at presentation — the same conjunction, ~
        named as staleness because that is what it is"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "advanced" :script :apply)
      (declare (ignore world))
      (append-event store (make-grant-event
                           :event-id '("cap0-event" "g-adv")
                           :capability-id '("cap" "alia")
                           :subject '("subj" "alia")
                           :action '("act" "alia")
                           :resource '("res" "alia")
                           :scope '("scope" "alia")
                           :issuer +kill-issuer+))
      (handler-case
          (progn (%kill-authorize store bootstrap context key "a-adv")
                 nil)
        (cap1-stale-capability () t)))))

;;; ---------------------------------------------------------------------------
(note "~%== negative controls: invocation refusals (law 7, law 8) ==")

(check "NC-5 LAW 8 (revocation at the frontier): authorize, THEN commit ~
        the matching revocation, THEN invoke — invocation refuses ~
        cap2-stale-authorization naming both prefixes.  The mechanism is ~
        PREFIX-STALENESS (the revocation moved the prefix); the fresh /0 ~
        fold, asked directly, names the revocation itself.  No atomic ~
        authority ledger is claimed (Constitution E6 unmet)"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "law8" :script :apply)
      (let ((auth (%kill-authorize store bootstrap context key "a-l8"))
            (cells-sha (world-cells-sha256 world)))
        (append-event store (make-revocation-event
                             :event-id '("cap0-event" "r-l8")
                             :capability-id +kill-capability+
                             :issuer +kill-issuer+))
        (and (handler-case
                 (progn (attempt-protected-effect store bootstrap context
                                                  key auth world)
                        nil)
               (cap2-stale-authorization (condition)
                 (= 1 (cap2-stale-authorization-authorization-terminal-ordinal
                       condition))))
             ;; the frontier was NOT crossed: no attempt event, no world
             ;; byte (law 7's discipline at this gate).
             (= 2 (prefix-report-frame-count (validate-journal store)))
             (string= cells-sha (world-cells-sha256 world))
             ;; and the /0 fold, asked directly, does not answer
             ;; :authorized any more — the revocation governs derivation.
             (handler-case
                 (not (eq :authorized
                          (receipt-decision
                           (query-live-authority store bootstrap
                                                 :query-id '("cap0-query"
                                                             "q-l8-after")
                                                 :capability-id
                                                 +kill-capability+
                                                 :subject +kill-subject+
                                                 :action +kill-action+
                                                 :resource +kill-cell+
                                                 :scope +kill-scope+))))
               (error () t)))))))

(check "NC-6 LAW 7 (refusal is pre-frontier): across every refusal ~
        exercised in this suite so far, no refused invocation journaled an ~
        attempt event or touched a world byte — exhibited here on the ~
        vertical store: exactly ONE attempt's events exist (a-001's four), ~
        and the world ledger still holds exactly one entry"
  (lambda ()
    (let* ((report (validate-journal *store*))
           (events (prefix-report-events report))
           (attempt-kinds
             (loop for index below (fill-pointer events)
                   for kind = (%event-kind-string (aref events index))
                   when (member kind '("attempt:prepared"
                                       "attempt:frontier-crossed")
                                :test #'equal)
                     collect kind)))
      (and (= 2 (length attempt-kinds))
           (= 1 (world-ledger-count *world*))))))

;;; ---------------------------------------------------------------------------
(note "~%== the uncertain outcome, same-life (law 3, law 4) ==")

(defvar *amb-store* nil)
(defvar *amb-world* nil)
(defvar *amb-bootstrap* nil)
(defvar *amb-context* nil)
(defvar *amb-key* nil)

(multiple-value-setq (*amb-store* *amb-world* *amb-bootstrap* *amb-context*
                      *amb-key*)
  (%kill-scenario *root* "ambiguous" :script :ambiguous))

(check "LAW 3 + LAW 4 (acknowledgment is not settlement; uncertainty is ~
        not failure): the ambiguous acknowledgment yields status ~
        :uncertain — a typed state of its own, not a refusal, not a ~
        failure — with the §10.8 record journaled carrying UNC-1's default ~
        retry policy; the attempt's terminal standing stays OPEN"
  (lambda ()
    (multiple-value-bind (status record)
        (%kill-uncertain-state *amb-store* *amb-world* *amb-bootstrap*
                               *amb-context* *amb-key* "a-001")
      (and (eq status :uncertain)
           (lisp-plus-kernel0:uncertain-effect-p record)
           (eq :forbidden-without-reconciliation
               (uncertain-effect-retry-policy record))
           (eq :uncertain-unresolved
               (derive-effect-standing *amb-store* "a-001"))
           ;; not rewritten as refusal or failure: the journal's last
           ;; event is effect:uncertain, and no refusal/failure event
           ;; exists in this lane's vocabulary at all.
           (let* ((report (validate-journal *amb-store*))
                  (events (prefix-report-events report)))
             (equal "effect:uncertain"
                    (%event-kind-string
                     (aref events (1- (fill-pointer events))))))))))

(check "NC-7 blind retry SAME LIFE: a FRESH, fully current key still ~
        cannot license dispatch into the poisoned seat — authorization ~
        refuses kernel /0's unsafe-retry (the seat's history binds ~
        regardless of key freshness); the ledger still holds ONE entry"
  (lambda ()
    (let ((key (%kill-remint *amb-store* *amb-bootstrap* *amb-context*
                             "amb-2")))
      (handler-case
          (progn (%kill-authorize *amb-store* *amb-bootstrap* *amb-context*
                                  key "a-002")
                 nil)
        (lisp-plus-kernel0:unsafe-retry ()
          (= 1 (world-ledger-count *amb-world*)))))))

(check "NC-8 blind retry FROM BYTES: reopening the store and the world ~
        from their durable bytes alone (open-store / open-world — fresh ~
        handles, no shared in-memory state) and asking to dispatch into ~
        the seat refuses unsafe-retry identically — the prohibition lives ~
        in the bytes, not in this process's memory (the genuinely ~
        new-process form is the specimen's)"
  (lambda ()
    (let ((store (open-store (merge-pathnames "ambiguous/store/" *root*)))
          (world (open-world (merge-pathnames "ambiguous/world/" *root*))))
      (declare (ignorable world))
      (handler-case
          (progn (check-retry-safety-from-store
                  store :seat-name "sedes-1"
                  :candidate-attempt-name "a-003")
                 nil)
        (lisp-plus-kernel0:unsafe-retry () t)))))

;;; ---------------------------------------------------------------------------
(note "~%== reconciliation: both branches, with evidence (law 9, law 10) ==")

(check "BRANCH (a) — the request LANDED: reconciliation queries the ~
        surviving world by the journaled external-request identity, finds ~
        the ledger entry, and resolves :applied with evidence; the ~
        COUNTERFACTUAL stands in bytes — the cell already holds VII and ~
        the ledger exactly one entry, so a blind retry would have ~
        double-applied"
  (lambda ()
    (multiple-value-bind (resolution event receipt)
        (reconcile-uncertain-effect *amb-store* *amb-world* "a-001"
                                    :process-name "controls")
      (and (eq resolution :applied)
           event
           (lisp-plus-kernel0:reconciliation-receipt-p receipt)
           (equal "VII" (world-cell-value *amb-world* "cella:septima"))
           (= 1 (world-ledger-count *amb-world*))
           (eq :reconciled (derive-effect-standing *amb-store* "a-001"))))))

(check "after reconciliation the seat is lawfully FREE: the composed gate ~
        passes from bytes, and a fresh key's authorization into the same ~
        seat succeeds (new attempt identity — the old one stays refused as ~
        duplicate)"
  (lambda ()
    (and (check-retry-safety-from-store *amb-store* :seat-name "sedes-1"
                                        :candidate-attempt-name "a-004")
         (let ((key (%kill-remint *amb-store* *amb-bootstrap* *amb-context*
                                  "amb-3")))
           (and (%authorization-receipt-p
                 (%kill-authorize *amb-store* *amb-bootstrap* *amb-context*
                                  key "a-004"))
                (handler-case
                    (progn (%kill-authorize *amb-store* *amb-bootstrap*
                                            *amb-context* key "a-001")
                           nil)
                  (lisp-plus-kernel0:duplicate-attempt-identity () t)))))))

(check "LAW 10 second reconciliation: reconciling the same uncertain ~
        effect again returns the precise disposition :already-reconciled ~
        naming the prior event — no new transition, no new frame"
  (lambda ()
    (let ((frames (prefix-report-frame-count (validate-journal *amb-store*))))
      (multiple-value-bind (disposition event)
          (reconcile-uncertain-effect *amb-store* *amb-world* "a-001")
        (and (eq disposition :already-reconciled)
             event
             (= frames (prefix-report-frame-count
                        (validate-journal *amb-store*))))))))

(check "BRANCH (b) — the request NEVER LANDED: after a frontier journaled ~
        as crossed with the request lost before dispatch, reconciliation ~
        finds NO ledger entry and resolves :not-applied with the ledger's ~
        own digest as absence evidence; the cell is byte-identically ~
        untouched"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "lost" :script :apply)
      (let ((auth (%kill-authorize store bootstrap context key "a-lost"))
            (cells-sha (world-cells-sha256 world)))
        (and (eq :interrupted
                 (nth-value 0 (attempt-protected-effect
                               store bootstrap context key auth world
                               :interruption :request-lost)))
             (eq :crossed-unsettled (derive-effect-standing store "a-lost"))
             (eq :declared (nth-value 0 (declare-uncertain-effect
                                         store "a-lost"
                                         :process-name "controls")))
             (eq :not-applied
                 (nth-value 0 (reconcile-uncertain-effect
                               store world "a-lost"
                               :process-name "controls")))
             (string= cells-sha (world-cells-sha256 world))
             (= 0 (world-ledger-count world))
             ;; and a fresh attempt under a NEW identity is now lawful and
             ;; succeeds — the effect happens EXACTLY ONCE, now.
             (let* ((key-2 (%kill-remint store bootstrap context "lost-2"))
                    (auth-2 (%kill-authorize store bootstrap context key-2
                                             "a-lost-2")))
               (and (eq :settled
                        (nth-value 0 (attempt-protected-effect
                                      store bootstrap context key-2 auth-2
                                      world :process-name "controls")))
                    (equal "VII" (world-cell-value world "cella:septima"))
                    (= 1 (world-ledger-count world)))))))))

(check "NC-9 inline uncertainty without the §10.8 record: reconciling a ~
        crossed-unsettled attempt whose uncertainty was never STRUCTURED ~
        refuses kernel /0's unstructured-uncertainty — declare first, ~
        then reconcile"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "inline" :script :apply)
      (let ((auth (%kill-authorize store bootstrap context key "a-in1")))
        (attempt-protected-effect store bootstrap context key auth world
                                  :interruption :request-lost)
        (handler-case
            (progn (reconcile-uncertain-effect store world "a-in1") nil)
          (lisp-plus-kernel0:unstructured-uncertainty () t))))))

(check "NC-10 reconciliation with insufficient evidence: when the world's ~
        request ledger is GONE, reconciliation refuses kernel /0's ~
        reconciliation-insufficient — an unanswerable world resolves ~
        nothing, in either direction (PJ-FOLD-1)"
  (lambda ()
    (multiple-value-bind (store world bootstrap context key)
        (%kill-scenario *root* "insuff" :script :apply)
      (let ((auth (%kill-authorize store bootstrap context key "a-ins")))
        (attempt-protected-effect store bootstrap context key auth world
                                  :interruption :request-lost)
        (declare-uncertain-effect store "a-ins" :process-name "controls")
        (delete-file (merge-pathnames "REQUEST-LEDGER.txt"
                                      (%world-directory world)))
        (and (handler-case
                 (progn (reconcile-uncertain-effect store world "a-ins")
                        nil)
               (lisp-plus-kernel0:reconciliation-insufficient () t))
             ;; and the refusal resolved nothing: the standing is still
             ;; uncertain and the gate still refuses.
             (eq :uncertain-unresolved
                 (derive-effect-standing store "a-ins"))
             (handler-case
                 (progn (check-retry-safety-from-store
                         store :seat-name "sedes-1"
                         :candidate-attempt-name "a-ins-2")
                        nil)
               (lisp-plus-kernel0:unsafe-retry () t)))))))

(check "NC-11 reconciling where nothing is uncertain refuses ~
        cap2-nothing-uncertain (a settled attempt, and an absent one ~
        alike): the fold decides what is uncertain, not the caller"
  (lambda ()
    (flet ((refused-p (attempt-name)
             (handler-case
                 (progn (reconcile-uncertain-effect *store* *world*
                                                    attempt-name)
                        nil)
               (cap2-nothing-uncertain () t))))
      (and (refused-p "a-001")        ; settled
           (refused-p "a-never")))))  ; absent

;;; ---------------------------------------------------------------------------
(note "~%== the three planted mutants, killed in this suite too ==")

(check "NC-12a mutant :ack-promotes-to-settled KILLED (strict :uncertain ~
        vs mutant :settled over the same scripted ambiguous world)"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :ack-promotes-to-settled *root*)
      (and killed (eq strict :uncertain) (eq mutant :settled)))))

(check "NC-12b mutant :auto-retry-on-uncertain KILLED (strict refuses ~
        unsafe-retry; the mutant dispatches and the ledger's TWO entries ~
        exhibit the double-apply the law exists to prevent)"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :auto-retry-on-uncertain *root*)
      (declare (ignore mutant))
      (and killed (eq strict :unsafe-retry)))))

(check "NC-12c mutant :stored-resolved-flag KILLED (a mutable flag with no ~
        reconciliation event convinces the mutant and not the fold)"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :stored-resolved-flag *root*)
      (and killed (eq strict :unsafe-retry) (eq mutant :authorized)))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "CAP2_CONTROLS_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "CAP2_CONTROLS_DIE") "1")
  (note "dying mid-controls (planted truncation control)")
  (finish-output)
  (sb-ext:exit :code 3 :abort t))

(unless (or (equal (sb-ext:posix-getenv "CAP2_CONTROLS_PLANT_FAULT") "1")
            (equal (sb-ext:posix-getenv "CAP2_CONTROLS_DIE") "1"))
  (check "the planted-fault gate FIRES: a child run with ~
          CAP2_CONTROLS_PLANT_FAULT=1 exits 1 with FAIL PLANTED FAULT in ~
          its transcript"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/capability2/capability2-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP2_CONTROLS_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "NC-13 truncation detected: a child run with CAP2_CONTROLS_DIE=1 ~
          exits 3 with NO RESULT: sentinel — an unfinished run must never ~
          read as a clean one"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/capability2/capability2-controls.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP2_CONTROLS_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text))
             (search "dying mid-controls" text))))))

;;; ---------------------------------------------------------------------------

(when (probe-file *root*)
  (sb-ext:delete-directory *root* :recursive t))

(format t "~%capability2-controls: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
