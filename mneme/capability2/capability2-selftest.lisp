;;;; capability2-selftest.lisp — Capability /2 unit checks.
;;;;
;;;; Run:  sbcl --script mneme/capability2/capability2-selftest.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; every store nonce is fixed (declared PJ-META-1 deviation —
;;;; test fixtures only, never production identities).
;;;;
;;;; Gate teeth: with CAP2_SELFTEST_PLANT_FAULT=1 this suite plants a
;;;; failing check and must exit 1 ("a gate that has never fired is
;;;; untested"); the final check spawns exactly that child and watches the
;;;; gate fire.
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

(defvar *root* #p"mneme/capability2/scratch-selftest/")
(when (probe-file *root*)
  (sb-ext:delete-directory *root* :recursive t))

(note "capability2-selftest — the effect-frontier candidate's unit checks")
(note "governing sentence: a recognized, current capability may justify ~
       attempting one exact protected effect — but neither the capability ~
       nor its presentation receipt proves that the effect occurred.~%")

;;; ---------------------------------------------------------------------------
(note "== the world: a controlled effect adapter under a labeled AP0 ~
       subset ==")

(defvar *world* (make-world (merge-pathnames "world-1/" *root*)
                            '(("cella:septima" . "VACUA")
                              ("cella:octava" . "VACUA"))))

(check "a fresh world renders its declared cells as canonical sorted bytes ~
        and an empty ledger (deterministic digests)"
  (lambda ()
    (and (equal "VACUA" (world-cell-value *world* "cella:septima"))
         (equal "VACUA" (world-cell-value *world* "cella:octava"))
         (= 0 (world-ledger-count *world*))
         (string= (world-cells-sha256 *world*)
                  (world-cells-sha256
                   (make-world (merge-pathnames "world-1b/" *root*)
                               '(("cella:octava" . "VACUA")
                                 ("cella:septima" . "VACUA"))))))))

(check "the adapter's dispatch durably applies ONE exact cell write, ~
        ledgers it, and acknowledges :provider-terminal with evidence that ~
        VERIFIES (ledger-entry digest and cell-store digest re-derived ~
        from the surviving bytes)"
  (lambda ()
    (multiple-value-bind (class ledger-sha cells-sha)
        (%world-apply-request *world* "external-request:cap2:a-u1"
                              "cella:septima" "VII")
      (multiple-value-bind (found-p line line-sha)
          (world-ledger-lookup *world* "external-request:cap2:a-u1")
        (declare (ignore line))
        (and (eq class :provider-terminal)
             (equal "VII" (world-cell-value *world* "cella:septima"))
             (= 1 (world-ledger-count *world*))
             found-p
             (string= line-sha ledger-sha)
             (string= (world-cells-sha256 *world*) cells-sha))))))

(check "the adapter declares NO idempotency (§14.5): a second apply under ~
        the SAME request identity appends a SECOND ledger line — blind ~
        retry genuinely double-applies in this world"
  (lambda ()
    (%world-apply-request *world* "external-request:cap2:a-u1"
                          "cella:septima" "VII")
    (= 2 (world-ledger-count *world* "external-request:cap2:a-u1"))))

(check "the scripted :ambiguous world applies and ledgers the write but ~
        acknowledges :acknowledgment-ambiguous with NO evidence — the ~
        effect happened; the process just cannot know it from the ~
        acknowledgment"
  (lambda ()
    (let ((world (make-world (merge-pathnames "world-2/" *root*)
                             '(("cella:septima" . "VACUA"))
                             :script :ambiguous)))
      (multiple-value-bind (class ledger-sha cells-sha)
          (%world-apply-request world "external-request:cap2:a-u2"
                                "cella:septima" "VII")
        (and (eq class :acknowledgment-ambiguous)
             (null ledger-sha) (null cells-sha)
             (equal "VII" (world-cell-value world "cella:septima"))
             (= 1 (world-ledger-count world)))))))

(check "the ledger lookup answers both directions: an unknown request ~
        identity is NOT found, and the absence is attested by the ledger's ~
        own digest, not by silence"
  (lambda ()
    (multiple-value-bind (found-p line line-sha)
        (world-ledger-lookup *world* "external-request:cap2:a-none")
      (declare (ignore line line-sha))
      (and (not found-p)
           (stringp (world-ledger-sha256 *world*))))))

;;; ---------------------------------------------------------------------------
(note "~%== event shapes: the PJ0 fixture grammar, encoded and decoded ==")

(check "attempt:prepared / attempt:frontier-crossed / effect:uncertain ~
        events carry the full ten-field envelope and encode to canonical ~
        PJ-S/0 bytes that decode back :canonical"
  (lambda ()
    (every
     (lambda (event)
       (multiple-value-bind (decoded status)
           (decode-pjs0 (encode-pjs0 event))
         (and decoded (eq :canonical status)
              (every (lambda (name)
                       (record-field decoded "event" name))
                     '("attempt" "body" "capture-boundary"
                       "capture-mechanism" "event-id" "kind" "origin"
                       "process-id" "recorder-principal"
                       "subject-principal")))))
     (list (make-attempt-prepared-event :attempt-name "a-u3"
                                        :seat-name "sedes-u"
                                        :process-name "selftest")
           (make-frontier-crossed-event :attempt-name "a-u3"
                                        :process-name "selftest")
           (make-effect-uncertain-event
            :attempt-name "a-u3" :process-name "selftest"
            :known-fact-segments '(("cap2-event" "e-a-u3-frontier")))))))

(check "the effect:uncertain body is the §10.8 fixture grammar verbatim: ~
        uncertain-effect-id, attempt-id, external-request-id, known-facts, ~
        possible-effects, reconciliation-procedure, and the UNC-1 default ~
        retry-policy forbidden-without-reconciliation"
  (lambda ()
    (let ((event (make-effect-uncertain-event
                  :attempt-name "a-u3" :process-name "selftest"
                  :known-fact-segments '(("cap2-event" "e-a-u3-frontier")))))
      (flet ((body (name) (%body-field event "effect" name)))
        (and (body "uncertain-effect-id")
             (body "attempt-id")
             (body "external-request-id")
             (body "known-facts")
             (= 2 (length (%sequence-elements (body "possible-effects"))))
             (string= "reconciliation:cap2-world-request-lookup:0"
                      (identifier-segment-string
                       (body "reconciliation-procedure")))
             (string= "retry:forbidden-without-reconciliation"
                      (identifier-segment-string (body "retry-policy"))))))))

(check "NO event shape carries any resolvedness field (PJ0 §16, ~
        AP-CRASH-1): the uncertain and reconciled bodies hold exactly ~
        their declared fields and none is a stored flag"
  (lambda ()
    (let ((uncertain (make-effect-uncertain-event
                      :attempt-name "a-u3" :process-name "selftest"
                      :known-fact-segments '(("cap2-event" "x"))))
          (reconciled (make-attempt-reconciled-event
                       :attempt-name "a-u3" :process-name "selftest"
                       :resolution :applied
                       :evidence-segments '(("world-ledger-entry" "a-u3")))))
      (and (null (%body-field uncertain "effect" "resolved"))
           (null (%body-field reconciled "reconciliation" "resolved"))
           ;; the reconciled body's resulting value is a settlement
           ;; DIRECTION record, not a flag: it names the §10.3 terminal
           ;; and the resolution direction separately.
           (string= "effect-value:settled"
                    (identifier-segment-string
                     (%body-field reconciled "reconciliation"
                                  "resulting-effect-value")))
           (string= "resolution:applied"
                    (identifier-segment-string
                     (%body-field reconciled "reconciliation"
                                  "resolution")))))))

;;; ---------------------------------------------------------------------------
(note "~%== rehydration: stored bytes -> live kernel /0 records (the ~
       novel seam) ==")

(defvar *reh-store*
  (create-journal (merge-pathnames "store-reh/" *root*)
                  :declared-durability "synced"
                  :nonce-octets (map '(simple-array (unsigned-byte 8) (*))
                                     #'char-code "cap2-selftest-01")))

(append-event *reh-store* (make-attempt-prepared-event
                           :attempt-name "a-r1" :seat-name "sedes-r"
                           :process-name "selftest"))
(append-event *reh-store* (make-frontier-crossed-event
                           :attempt-name "a-r1" :process-name "selftest"))
(append-event *reh-store* (make-effect-uncertain-event
                           :attempt-name "a-r1" :process-name "selftest"
                           :known-fact-segments
                           '(("cap2-event" "e-a-r1-frontier"))))

(check "a journaled effect:uncertain event rehydrates through kernel /0's ~
        OWN make-uncertain-effect into a live §10.8 record: correct ~
        attempt and external-request identities, two possible effects, ~
        identified reconciliation procedure, UNC-1 default retry policy"
  (lambda ()
    (multiple-value-bind (standing details)
        (derive-effect-standing *reh-store* "a-r1")
      (declare (ignore standing))
      (let ((record (%rehydrate-uncertain-effect (getf details :uncertain))))
        (and (lisp-plus-kernel0:uncertain-effect-p record)
             (string= "attempt:a-r1"
                      (lisp-plus-kernel0:durable-identity-name
                       (uncertain-effect-attempt record)))
             (equal '(:cell-written :cell-not-written)
                    (uncertain-effect-possible-effects record))
             (eq :forbidden-without-reconciliation
                 (uncertain-effect-retry-policy record)))))))

(check "REHYDRATION FEEDS KERNEL /0'S OWN FOLD: over the rehydrated ~
        events plus a candidate dispatch into the same seat, kernel /0's ~
        check-retry-safety itself signals unsafe-retry — the §10.8 record ~
        journaled by one process reaches, as bytes, the fold that enforces ~
        its retry-policy in another"
  (lambda ()
    (multiple-value-bind (kernel-events extension-count)
        (rehydrate-kernel-events
         (prefix-report-events (validate-journal *reh-store*)))
      (declare (ignore extension-count))
      (handler-case
          (progn
            (lisp-plus-kernel0:check-retry-safety
             (append kernel-events
                     (list (make-kernel0-event
                            :event-type :attempt-begun
                            :attempt-id (make-identity :attempt
                                                       "attempt:a-r2")
                            :seat-id (make-identity :seat "seat:sedes-r"))))
             (make-identity :seat "seat:sedes-r"))
            nil)
        (lisp-plus-kernel0:unsafe-retry () t)))))

(check "the extension-event adjudication is visible in the projection: ~
        effect:uncertain projects as kernel :effect-bounded (the stored ~
        record names finite alternatives — §7.3 BOUNDED), and unrecognized ~
        kinds project as explicit extension events, counted, never dropped"
  (lambda ()
    (let ((grant-store
            (create-journal (merge-pathnames "store-reh2/" *root*)
                            :declared-durability "synced"
                            :nonce-octets
                            (map '(simple-array (unsigned-byte 8) (*))
                                 #'char-code "cap2-selftest-02"))))
      (append-event grant-store
                    (make-grant-event :event-id '("cap0-event" "g-x")
                                      :capability-id '("cap" "x")
                                      :subject '("subj" "x")
                                      :action '("act" "x")
                                      :resource '("res" "x")
                                      :scope '("scope" "x")
                                      :issuer '("iss" "x")))
      (multiple-value-bind (kernel-events extension-count)
          (rehydrate-kernel-events
           (prefix-report-events (validate-journal grant-store)))
        (and (= 1 extension-count)
             (= 1 (length kernel-events))
             (lisp-plus-kernel0:kernel0-event-extension-p
              (first kernel-events))))
      t)))

(check "THE PRE-DECLARATION HALF IS GENUINELY THIS LANE'S ADDITION: for a ~
        crossed-unsettled attempt with NO journaled §10.8 record, kernel ~
        /0's fold alone finds nothing to refuse — while ~
        check-retry-safety-from-store refuses under the W1 adjudication ~
        (§10.3 + AP-CRASH-4); each half is load-bearing where the other is ~
        silent"
  (lambda ()
    (let ((store (create-journal (merge-pathnames "store-reh3/" *root*)
                                 :declared-durability "synced"
                                 :nonce-octets
                                 (map '(simple-array (unsigned-byte 8) (*))
                                      #'char-code "cap2-selftest-03"))))
      (append-event store (make-attempt-prepared-event
                           :attempt-name "a-w1" :seat-name "sedes-w"
                           :process-name "selftest"))
      (append-event store (make-frontier-crossed-event
                           :attempt-name "a-w1" :process-name "selftest"))
      (multiple-value-bind (kernel-events extension-count)
          (rehydrate-kernel-events
           (prefix-report-events (validate-journal store)))
        (declare (ignore extension-count))
        (and
         ;; kernel /0's structured fold: no §10.8 record, nothing counted.
         (lisp-plus-kernel0:check-retry-safety
          (append kernel-events
                  (list (make-kernel0-event
                         :event-type :attempt-begun
                         :attempt-id (make-identity :attempt "attempt:a-w2")
                         :seat-id (make-identity :seat "seat:sedes-w"))))
          (make-identity :seat "seat:sedes-w"))
         ;; this lane's composed gate: refused.
         (handler-case
             (progn (check-retry-safety-from-store
                     store :seat-name "sedes-w"
                     :candidate-attempt-name "a-w2")
                    nil)
           (lisp-plus-kernel0:unsafe-retry () t)))))))

(check "a rehydrated reconciliation receipt satisfies kernel /0's OWN ~
        resolution predicate: after declare + reconcile, the composed gate ~
        AND kernel /0's fold over purely-rehydrated records both pass — ~
        resolvedness is fold-derived from bytes, end to end"
  (lambda ()
    (let ((store (create-journal (merge-pathnames "store-reh4/" *root*)
                                 :declared-durability "synced"
                                 :nonce-octets
                                 (map '(simple-array (unsigned-byte 8) (*))
                                      #'char-code "cap2-selftest-04")))
          (world (make-world (merge-pathnames "world-reh4/" *root*)
                             '(("cella:septima" . "VACUA")))))
      (append-event store (make-attempt-prepared-event
                           :attempt-name "a-r4" :seat-name "sedes-r4"
                           :process-name "selftest"))
      (append-event store (make-frontier-crossed-event
                           :attempt-name "a-r4" :process-name "selftest"))
      (declare-uncertain-effect store "a-r4" :process-name "selftest")
      (reconcile-uncertain-effect store world "a-r4"
                                  :process-name "selftest")
      (and (eq :reconciled (derive-effect-standing store "a-r4"))
           (check-retry-safety-from-store store :seat-name "sedes-r4"
                                          :candidate-attempt-name "a-r5")
           (multiple-value-bind (kernel-events extension-count)
               (rehydrate-kernel-events
                (prefix-report-events (validate-journal store)))
             (declare (ignore extension-count))
             (lisp-plus-kernel0:check-retry-safety
              (append kernel-events
                      (list (make-kernel0-event
                             :event-type :attempt-begun
                             :attempt-id (make-identity :attempt
                                                        "attempt:a-r5")
                             :seat-id (make-identity :seat
                                                     "seat:sedes-r4"))))
              (make-identity :seat "seat:sedes-r4")))))))

;;; ---------------------------------------------------------------------------
(note "~%== authorization and invocation units (laws 1, 2, 6 among them) ==")

(defvar *u-store* nil)
(defvar *u-world* nil)
(defvar *u-bootstrap* nil)
(defvar *u-context* nil)
(defvar *u-key* nil)

(multiple-value-setq (*u-store* *u-world* *u-bootstrap* *u-context* *u-key*)
  (%kill-scenario *root* "units" :script :apply))

(defvar *u-cells-sha* (world-cells-sha256 *u-world*))

(check "LAW 1 (authority is not execution): minting and presenting the ~
        live key produced zero effects — the journal holds exactly the ~
        grant, the world's cell bytes are untouched, the ledger is empty"
  (lambda ()
    (and (= 1 (prefix-report-frame-count (validate-journal *u-store*)))
         (string= *u-cells-sha* (world-cells-sha256 *u-world*))
         (= 0 (world-ledger-count *u-world*))
         (equal "VACUA" (world-cell-value *u-world* "cella:septima")))))

(defvar *u-auth* (%kill-authorize *u-store* *u-bootstrap* *u-context*
                                  *u-key* "a-001"))

(check "LAW 2 (authorization-to-attempt is not acknowledgment): the ~
        receipt exists — kind cap2:authorization-to-attempt, bound to the ~
        current prefix, naming capability, effect (kind, class, cell, ~
        value), attempt, seat, idempotency, procedure — and still no ~
        acknowledgment exists anywhere: no world write, no ledger entry, ~
        no journal advance"
  (lambda ()
    (and (%authorization-receipt-p *u-auth*)
         (string= "effect:external-write"
                  (identifier-segment-string
                   (record-field *u-auth* "receipt" "effect-kind")))
         (string= "effect-class:irreversible"
                  (identifier-segment-string
                   (record-field *u-auth* "receipt" "effect-class")))
         (string= "VII" (%receipt-string *u-auth* "value"))
         (= 1 (%receipt-integer *u-auth* "terminal-ordinal"))
         (= 1 (prefix-report-frame-count (validate-journal *u-store*)))
         (string= *u-cells-sha* (world-cells-sha256 *u-world*))
         (= 0 (world-ledger-count *u-world*)))))

(check "the authorization receipt is DERIVED state and is not journaled ~
        (the /0 L9 adjudication carried forward): its identity derives ~
        from declared charge and the frame count did not move"
  (lambda ()
    (= 1 (prefix-report-frame-count (validate-journal *u-store*)))))

(check "invocation without any authorization refuses ~
        cap2-authorization-missing (nil, and a non-receipt record alike), ~
        journal and world untouched"
  (lambda ()
    (flet ((refused-p (datum)
             (handler-case
                 (progn (attempt-protected-effect *u-store* *u-bootstrap*
                                                  *u-context* *u-key*
                                                  datum *u-world*)
                        nil)
               (cap2-authorization-missing () t))))
      (and (refused-p nil)
           (refused-p (make-grant-event :event-id '("cap0-event" "g-z")
                                        :capability-id '("cap" "z")
                                        :subject '("subj" "z")
                                        :action '("act" "z")
                                        :resource '("res" "z")
                                        :scope '("scope" "z")
                                        :issuer '("iss" "z")))
           (= 1 (prefix-report-frame-count (validate-journal *u-store*)))
           (= 0 (world-ledger-count *u-world*))))))

(check "invocation without a declared world refuses cap2-world-missing ~
        before anything else is examined"
  (lambda ()
    (handler-case
        (progn (attempt-protected-effect *u-store* *u-bootstrap* *u-context*
                                         *u-key* *u-auth* nil)
               nil)
      (cap2-world-missing () t))))

(check "a request for a cell outside the capability's exact terms refuses ~
        cap2-effect-not-authorized naming both cells (capability ~
        authorizes cella:septima; request targets cella:nona)"
  (lambda ()
    (handler-case
        (progn (authorize-effect-attempt *u-store* *u-bootstrap* *u-context*
                                         *u-key*
                                         :capability-id +kill-capability+
                                         :query-name "q-u-nona"
                                         :subject +kill-subject+
                                         :action +kill-action+
                                         :resource +kill-cell+
                                         :scope +kill-scope+
                                         :cell '("cella" "nona")
                                         :value "VII"
                                         :attempt-name "a-nona"
                                         :seat-name "sedes-1")
               nil)
      (cap2-effect-not-authorized (condition)
        (and (string= "cella:nona"
                      (cap2-effect-not-authorized-requested-cell condition))
             (string= "cella:septima"
                      (cap2-effect-not-authorized-authorized-cell
                       condition)))))))

(check "a stale authorization receipt at invocation refuses ~
        cap2-stale-authorization NAMING BOTH PREFIXES (an unrelated event ~
        moved the journal; the receipt truthfully binds ordinal 1, the ~
        present prefix is ordinal 2)"
  (lambda ()
    (append-event *u-store*
                  (make-grant-event :event-id '("cap0-event" "g-002")
                                    :capability-id '("cap" "alia")
                                    :subject '("subj" "alia")
                                    :action '("act" "alia")
                                    :resource '("res" "alia")
                                    :scope '("scope" "alia")
                                    :issuer +kill-issuer+))
    (handler-case
        (progn (attempt-protected-effect *u-store* *u-bootstrap* *u-context*
                                         *u-key* *u-auth* *u-world*)
               nil)
      (cap2-stale-authorization (condition)
        (and (= 1 (cap2-stale-authorization-authorization-terminal-ordinal
                   condition))
             (= 2 (cap2-stale-authorization-present-terminal-ordinal
                   condition))
             (stringp (cap2-stale-authorization-authorization-terminal-digest
                       condition))
             (stringp (cap2-stale-authorization-present-terminal-digest
                       condition)))))))

(check "LAW 6 (failure after authorization does not retroactively ~
        invalidate authorization): after the stale refusal the receipt's ~
        bytes are unchanged, decode :canonical, and still truthfully name ~
        the prefix they were derived at"
  (lambda ()
    (multiple-value-bind (decoded status)
        (decode-pjs0 (encode-pjs0 *u-auth*))
      (and decoded (eq :canonical status)
           (= 1 (lisp-plus-cd0:integer-datum-value
                 (record-field decoded "receipt" "terminal-ordinal")))
           (string= "VII" (lisp-plus-cd0:string-datum-value
                           (record-field decoded "receipt" "value")))))))

(check "an authorization for key A does not license key B minted at the ~
        same prefix: invocation refuses cap2-authorization-mismatch naming ~
        the capability-public-id facet"
  (lambda ()
    (let* ((key-b (%kill-remint *u-store* *u-bootstrap* *u-context*
                                "units-b"))
           (auth-b (%kill-authorize *u-store* *u-bootstrap* *u-context*
                                    key-b "a-b1"))
           (key-c (%kill-remint *u-store* *u-bootstrap* *u-context*
                                "units-c")))
      (handler-case
          (progn (attempt-protected-effect *u-store* *u-bootstrap*
                                           *u-context* key-c auth-b
                                           *u-world*)
                 nil)
        (cap2-authorization-mismatch (condition)
          (equal '("capability-public-id")
                 (cap2-authorization-mismatch-facets condition)))))))

(check "every refusal above journaled nothing and wrote no world byte: ~
        frame count still 2, ledger still empty, cell bytes unchanged"
  (lambda ()
    (and (= 2 (prefix-report-frame-count (validate-journal *u-store*)))
         (= 0 (world-ledger-count *u-world*))
         (string= *u-cells-sha* (world-cells-sha256 *u-world*)))))

;;; ---------------------------------------------------------------------------
(note "~%== standing fold walk ==")

(check "derive-effect-standing walks the whole ladder from bytes: absent ~
        -> crossed-unsettled -> uncertain-unresolved -> reconciled, and a ~
        settled attempt reads :settled — no stored flag consulted at any ~
        rung (there is none to consult)"
  (lambda ()
    (let ((store (create-journal (merge-pathnames "store-walk/" *root*)
                                 :declared-durability "synced"
                                 :nonce-octets
                                 (map '(simple-array (unsigned-byte 8) (*))
                                      #'char-code "cap2-selftest-05")))
          (world (make-world (merge-pathnames "world-walk/" *root*)
                             '(("cella:septima" . "VACUA")))))
      (and (eq :absent (derive-effect-standing store "a-s1"))
           (progn (append-event store (make-attempt-prepared-event
                                       :attempt-name "a-s1"
                                       :seat-name "sedes-s"
                                       :process-name "selftest"))
                  (eq :prepared-only (derive-effect-standing store "a-s1")))
           (progn (append-event store (make-frontier-crossed-event
                                       :attempt-name "a-s1"
                                       :process-name "selftest"))
                  (eq :crossed-unsettled
                      (derive-effect-standing store "a-s1")))
           (progn (declare-uncertain-effect store "a-s1"
                                            :process-name "selftest")
                  (eq :uncertain-unresolved
                      (derive-effect-standing store "a-s1")))
           (progn (reconcile-uncertain-effect store world "a-s1"
                                              :process-name "selftest")
                  (eq :reconciled (derive-effect-standing store "a-s1")))
           (progn (append-event store (make-attempt-prepared-event
                                       :attempt-name "a-s2"
                                       :seat-name "sedes-s2"
                                       :process-name "selftest"))
                  (append-event store (make-frontier-crossed-event
                                       :attempt-name "a-s2"
                                       :process-name "selftest"))
                  (append-event store (make-effect-settled-event
                                       :attempt-name "a-s2"
                                       :process-name "selftest"
                                       :evidence-segments
                                       '(("world-ledger-entry" "a-s2"))))
                  (eq :settled (derive-effect-standing store "a-s2")))))))

(check "declaring uncertainty where the fold shows none refuses ~
        cap2-nothing-uncertain, and a second declaration of a standing ~
        record is a DISPOSITION (:already-declared), never a fresh ~
        transition"
  (lambda ()
    (let ((store (create-journal (merge-pathnames "store-walk2/" *root*)
                                 :declared-durability "synced"
                                 :nonce-octets
                                 (map '(simple-array (unsigned-byte 8) (*))
                                      #'char-code "cap2-selftest-06"))))
      (and (handler-case (progn (declare-uncertain-effect store "a-x1") nil)
             (cap2-nothing-uncertain () t))
           (progn (append-event store (make-attempt-prepared-event
                                       :attempt-name "a-x1"
                                       :seat-name "sedes-x"
                                       :process-name "selftest"))
                  (append-event store (make-frontier-crossed-event
                                       :attempt-name "a-x1"
                                       :process-name "selftest"))
                  (declare-uncertain-effect store "a-x1"
                                            :process-name "selftest")
                  (let ((frames (prefix-report-frame-count
                                 (validate-journal store))))
                    (multiple-value-bind (disposition event)
                        (declare-uncertain-effect store "a-x1")
                      (and (eq :already-declared disposition)
                           event
                           (= frames (prefix-report-frame-count
                                      (validate-journal store)))))))))))

;;; ---------------------------------------------------------------------------
(note "~%== the three planted mutants, killed ==")

(check "MUTANT :ack-promotes-to-settled is KILLED: over the scripted ~
        ambiguous world the strict path leaves the effect :uncertain (the ~
        §10.8 record journaled) while the mutant asserts :settled from the ~
        acknowledgment class alone — AP-ACK-4 is load-bearing"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :ack-promotes-to-settled *root*)
      (and killed (eq strict :uncertain) (eq mutant :settled)))))

(check "MUTANT :auto-retry-on-uncertain is KILLED: strict refuses ~
        unsafe-retry into the poisoned seat (with a FRESH, fully current ~
        key — the seat's history binds regardless of key freshness) while ~
        the mutant authorizes, dispatches, and leaves the ledger holding ~
        TWO applied entries — the double-apply counterfactual in bytes"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :auto-retry-on-uncertain *root*)
      (declare (ignore mutant))
      (and killed (eq strict :unsafe-retry)))))

(check "MUTANT :stored-resolved-flag is KILLED: a planted mutable flag ~
        file claims resolution with no reconciliation event anywhere; ~
        strict still refuses from the bytes, the mutant waves the ~
        authorization through — resolvedness is fold-derived or it is ~
        nothing"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :stored-resolved-flag *root*)
      (and killed (eq strict :unsafe-retry) (eq mutant :authorized)))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "CAP2_SELFTEST_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(unless (equal (sb-ext:posix-getenv "CAP2_SELFTEST_PLANT_FAULT") "1")
  (check "the planted-fault gate FIRES: a child run of this suite with ~
          CAP2_SELFTEST_PLANT_FAULT=1 exits 1 and its transcript carries ~
          FAIL PLANTED FAULT — the gate has been seen to fire"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/capability2/capability2-selftest.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP2_SELFTEST_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text))))))

;;; ---------------------------------------------------------------------------

(when (probe-file *root*)
  (sb-ext:delete-directory *root* :recursive t))

(format t "~%capability2-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
