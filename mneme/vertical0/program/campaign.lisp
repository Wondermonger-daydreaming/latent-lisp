;;;; campaign.lisp — THE generic campaign entry (contract §1).
;;;;
;;;; Invoked identically every life:
;;;;
;;;;   sbcl --script mneme/vertical0/program/campaign.lisp <exec-dir>
;;;;
;;;; from the latent-lisp root.  The charge, verbatim from the sealed
;;;; contract: "resume from durable evidence alone; perform all remaining
;;;; lawful work in the declared seat order; exit 0 when nothing remains."
;;;;
;;;; THIS PROGRAM NEVER KNOWS: which life it is, whether or where it will
;;;; be killed, any W label, the kill schedule, the oracle pathname, or
;;;; any private fake-world truth.  It derives everything it does from
;;;; (a) the copied program config in its execution directory and (b) the
;;;; durable evidence there (journal store, evidence files, public
;;;; fake-world files).  It pauses at every DECLARED per-route boundary
;;;; occurrence — schedule-independent — by emitting one
;;;; BOUNDARY-READY line on stdout and blocking in a RAW read(2) on
;;;; stdin (fd 0) until the parent answers CONTINUE.  The raw read is
;;;; deliberate: the externally witnessed blocked state is read(0, ...),
;;;; not a poll loop.
;;;;
;;;; Stdout is a harness-only pipe: diagnostics + boundary markers.  It
;;;; is NOT a journal, NOT config, NOT recovery input, NOT census input.
;;;; Diagnostic lines may carry the process id (declared noncanonical);
;;;; NO durable record does.
;;;;
;;;; Restart-derivation law (Capability /0 law 11): when this process
;;;; finds an existing store, every authority query it makes passes
;;;; :origin :reconstructed.  That the store existed is itself durable
;;;; evidence — not a life number.
;;;;
;;;; Key-staleness discipline (Capability /1): every journal append
;;;; stales every live key, so each attempt journals ALL its pre-frontier
;;;; facts FIRST and then runs mint -> authorize -> attempt-protected-
;;;; effect with ZERO appends in between; a fresh mint per attempt.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-vertical0)

;;; ---------------------------------------------------------------------------
;;; Diagnostics (noncanonical; harness-only pipe).

(defun vnote (control &rest arguments)
  (format t "NOTE ~a~%" (apply #'format nil control arguments))
  (finish-output))

(defun vfail (control &rest arguments)
  "A failed program invariant aborts the life with exit 2 — an unfinished
campaign life must never read as a clean one."
  (format t "CHILD-ERROR ~a~%" (apply #'format nil control arguments))
  (finish-output)
  (sb-ext:exit :code 2 :abort t))

;;; ---------------------------------------------------------------------------
;;; The boundary pause protocol (contract §3.2).

(defun %read-stdin-line-raw ()
  "Block in read(2) on fd 0 — one octet at a time — until a newline.
Returns the line as a string, or NIL on EOF."
  (let ((buffer (make-array 1 :element-type '(unsigned-byte 8)))
        (characters '()))
    (loop
      (multiple-value-bind (count errno)
          (sb-unix:unix-read 0 (sb-sys:vector-sap buffer) 1)
        (declare (ignorable errno))
        (when (or (null count) (zerop count))
          (return-from %read-stdin-line-raw
            (and characters (coerce (nreverse characters) 'string))))
        (let ((character (code-char (aref buffer 0))))
          (when (char= character #\Newline)
            (return-from %read-stdin-line-raw
              (coerce (nreverse characters) 'string)))
          (push character characters))))))

(defun boundary-pause (seat-id boundary-name)
  "(1) the boundary's durability protocol is already complete when this
is called; (2) emit the one READY line; (3) no further semantic
operation; (4) block reading stdin; (5) proceed only on CONTINUE."
  (format t "BOUNDARY-READY seat=~a boundary=~a~%" seat-id boundary-name)
  (finish-output)
  (let ((answer (%read-stdin-line-raw)))
    (unless (equal answer "CONTINUE")
      (vfail "boundary pause at ~a/~a: expected CONTINUE, got ~s"
             seat-id boundary-name answer))))

(defun route-pauses-p (config route boundary)
  (member boundary (config-route-pauses config route) :test #'equal))

;;; ---------------------------------------------------------------------------
;;; Campaign state (per-process; everything durable lives in exec/).

(defvar *exec-dir* nil)
(defvar *config* nil)
(defvar *store* nil)
(defvar *world* nil)
(defvar *bootstrap* nil)
(defvar *context* nil)
(defvar *store-existed* nil
  "T when this process OPENED an existing store (durable evidence that a
prior process ran; the basis for :origin :reconstructed — never a life
number).")
(defvar *ceiling* nil)

(defun exec-path (relative)
  (merge-pathnames relative *exec-dir*))

(defun query-origin ()
  (if *store-existed* :reconstructed :live-query))

(defun expected-store-id ()
  (store-id-string
   (validate-metadata-octets
    (render-metadata-octets
     (build-metadata-record
      :declared-durability (config-durability *config*)
      :nonce-octets (config-nonce-octets *config*))))))

;;; ---------------------------------------------------------------------------
;;; Declared identities (all derived from configuration labels).

(defun seat-attempt-name (seat-id) (format nil "a-~a" seat-id))

(defun seat-capability-id (seat-id) (list "cap" seat-id))

(defun seat-cell-segments (seat-plist)
  (list "cella" (seat-field seat-plist :cell)))

;;; SEALED-EXPECTATION DISCREPANCY, recorded exactly (contract §3 vs
;;; Capability /2's public law): the contract's authority-terms row says
;;; per-seat resource (id "resource" <seat-id>), but cap2's authorize
;;; refuses CAP2-EFFECT-NOT-AUTHORIZED whenever the capability's
;;; resource term differs from the effect's cell ("a key opens exactly
;;; the door it was cut for, and licenses exactly the effect it names").
;;; The lawful adaptation — reported to the chair, not silently hidden —
;;; is that the per-seat resource IS the seat's cell identity: still one
;;; distinct resource per seat, exact four-term matching intact.
(defun seat-resource (seat-plist)
  (seat-cell-segments seat-plist))

(defun seat-cell-name (seat-plist)
  (identifier-segment-string
   (identifier-from-segments (seat-cell-segments seat-plist))))

(defun seat-value (seat-id) (format nil "V-~a" seat-id))

(defun authority-config () (%plist-section *config* :authority))

(defun declared-world-cells ()
  "Every declared cell (bank cells + the publication mirror cell), initial
value VACUA, sorted deterministically by the bank order + fixture order."
  (append
   (loop for seat-plist in (config-bank *config*)
         collect (cons (seat-cell-name seat-plist) "VACUA"))
   (let ((publication (%plist-section *config* :publication)))
     (when publication
       (list (cons (identifier-segment-string
                    (identifier-from-segments
                     (list "cella" (getf publication :mirror-cell))))
                   "VACUA"))))))

;;; ---------------------------------------------------------------------------
;;; Opening authority (idempotent: identical re-appends reconcile as
;;; :already-committed-identical and append nothing).

(defun journal-opening-authority ()
  (let* ((authority (authority-config))
         (issuer (list "issuer" (getf authority :bootstrap-issuer)))
         (subject (getf authority :subject))
         (action (getf authority :action))
         (scope (getf authority :scope)))
    (dolist (seat-plist (config-bank *config*))
      (let ((seat-id (seat-field seat-plist :seat)))
        (append-event *store*
                      (make-grant-event
                       :event-id (list "cap0-event" (format nil "g-~a" seat-id))
                       :capability-id (seat-capability-id seat-id)
                       :subject subject
                       :action action
                       :resource (seat-resource seat-plist)
                       :scope scope
                       :issuer issuer))))
    ;; The declared revocations (e.g. seat-dead-hand): granted above,
    ;; revoked here — the fresh fold refuses by name at query time.
    (dolist (seat-id (getf authority :revoked-seats))
      (append-event *store*
                    (make-revocation-event
                     :event-id (list "cap0-event" (format nil "r-~a" seat-id))
                     :capability-id (seat-capability-id seat-id)
                     :issuer issuer)))
    ;; Synthetic secret-opening capability (life-5 finalization).
    (let ((secret (%plist-section *config* :secret)))
      (when secret
        (append-event *store*
                      (make-grant-event
                       :event-id '("cap0-event" "g-secret-opening")
                       :capability-id (list "cap" (getf secret :rubric-id))
                       :subject subject
                       :action (getf secret :opening-action)
                       :resource (list "resource" (getf secret :rubric-id))
                       :scope scope
                       :issuer issuer))))
    ;; Synthetic publication capability (life-5 finalization).
    (let ((publication (%plist-section *config* :publication)))
      (when publication
        (append-event *store*
                      (make-grant-event
                       :event-id '("cap0-event" "g-publication")
                       :capability-id '("cap" "publicatio")
                       :subject subject
                       :action (getf publication :publication-action)
                       :resource (list "cella"
                                       (getf publication :mirror-cell))
                       :scope scope
                       :issuer issuer))))))

;;; ---------------------------------------------------------------------------
;;; Per-seat building blocks.

(defun bind-seat-adapter (seat-id)
  (bind-live-adapter
   (descriptor-by-identity
    (getf (%plist-section *config* :adapter) :descriptor-identity))
   :instance-label seat-id))

(defun prepare-seat (live seat-id)
  (prepare-invocation
   live
   (make-invocation-spec
    :logical-operation-id (format nil "loqui-~a" seat-id)
    :seat-id seat-id
    :attempt-id (seat-attempt-name seat-id)
    :run-label seat-id)))

(defun journal-pre-frontier-records (seat-id prepared)
  "The three §21 AP0 pre-frontier records, oldest first, journaled BEFORE
any crossing (the de-membrana-loquente ordering adjudication: the cap2
authorization is the LAST pre-frontier act)."
  (loop for record in (prepared-invocation-record-pre-frontier-records
                       prepared)
        for suffix in '("prepared" "request-capture" "exposure")
        for kind in '("prepared-invocation" "request-capture"
                      "exposure-event")
        do (append-event *store*
                         (ap0-event (format nil "e-~a-~a" seat-id suffix)
                                    kind record))))

(defun seat-budget-check (seat-plist)
  (check-budget-before-frontier *store*
                                (seat-field seat-plist :seat)
                                (seat-field seat-plist :estimate-lexeme)
                                *ceiling*))

(defun mint-seat-key (seat-plist query-suffix)
  (let ((authority (authority-config))
        (seat-id (seat-field seat-plist :seat)))
    (mint-from-authorization
     *store* *bootstrap* *context*
     (query-live-authority *store* *bootstrap*
                           :query-id (list "cap0-query"
                                           (format nil "q-~a-~a" seat-id
                                                   query-suffix))
                           :capability-id (seat-capability-id seat-id)
                           :subject (getf authority :subject)
                           :action (getf authority :action)
                           :resource (seat-resource seat-plist)
                           :scope (getf authority :scope)
                           :origin (query-origin))
     :minter '("vertical-minter" "machina"))))

(defun authorize-seat (seat-plist key &key (attempt-suffix nil))
  (let* ((authority (authority-config))
         (seat-id (seat-field seat-plist :seat))
         (attempt (if attempt-suffix
                      (format nil "~a-~a" (seat-attempt-name seat-id)
                              attempt-suffix)
                      (seat-attempt-name seat-id))))
    (authorize-effect-attempt *store* *bootstrap* *context* key
                              :capability-id (seat-capability-id seat-id)
                              :query-name (format nil "q-~a-auth~@[-~a~]"
                                                  seat-id attempt-suffix)
                              :subject (getf authority :subject)
                              :action (getf authority :action)
                              :resource (seat-resource seat-plist)
                              :scope (getf authority :scope)
                              :cell (seat-cell-segments seat-plist)
                              :value (seat-value seat-id)
                              :attempt-name attempt
                              :seat-name seat-id)))

(defun cross-frontier (seat-plist &key interruption)
  "Journal pre-frontier facts are already durable.  Mint -> authorize ->
attempt-protected-effect with ZERO journal appends in between (the
key-staleness discipline)."
  (let* ((seat-id (seat-field seat-plist :seat))
         (key (mint-seat-key seat-plist "mint"))
         (authorization (authorize-seat seat-plist key)))
    (multiple-value-bind (status detail)
        (attempt-protected-effect *store* *bootstrap* *context* key
                                  authorization *world*
                                  :process-name "vertical-campaign"
                                  :interruption interruption)
      (values status detail))))

(defun request-loss-seat-p (seat-id)
  (member seat-id (config-policy *config* :request-loss-simulated-seats)
          :test #'equal))

(defun journal-membrane-crossing-evidence (seat-id prepared live)
  "AP0 dispatch record + the crossing-evidence binding (one crossing, two
jurisdictions).  Returns the dispatch handle."
  (let* ((handle (dispatch prepared :live-adapter live))
         (dispatch-record (dispatch-handle-dispatch-record handle))
         (attempt (seat-attempt-name seat-id)))
    (append-event *store*
                  (ap0-event (format nil "e-~a-dispatch" seat-id)
                             "dispatch-record" dispatch-record))
    (append-event
     *store*
     (ap0-event (format nil "e-~a-crossing-binding" seat-id)
                "crossing-evidence-binding"
                (v-rec '("ap0" "dispatch-id")
                       (v-str (body-string dispatch-record "ap0"
                                           "dispatch-id"))
                       '("ap0" "cap2-frontier-event")
                       (v-id "cap2-event"
                             (format nil "e-~a-frontier" attempt))
                       '("ap0" "cap2-acknowledgment-event")
                       (v-id "cap2-event"
                             (format nil "e-~a-ack" attempt)))))
    handle))

(defun journal-ap0-acknowledgment (seat-id handle)
  (append-event *store*
                (ap0-event (format nil "e-~a-ack-membrane" seat-id)
                           "acknowledgment"
                           (observe-acknowledgment handle))))

(defun envelope-evidence-name (seat-id)
  (format nil "~a-envelope.bin" seat-id))

(defun journal-envelope-custody (seat-id handle live)
  "Terminal envelope capture: (b) write-replace the evidence file, THEN
(a) journal the envelope record and the custody binding (contract §4).
Returns the terminal envelope record."
  (let* ((envelope (await-terminal handle))
         (octets (encode-pjs0 envelope))
         (relative (format nil "evidence/~a" (envelope-evidence-name
                                              seat-id)))
         (capture (capture-envelope live octets
                                    (format nil "~a-custody" seat-id))))
    ;; (b) file replaced + synced FIRST ...
    (write-evidence-file (exec-path relative) octets)
    ;; ... THEN (a) the records, each append fsynced by the :synced store.
    (append-event *store*
                  (ap0-event (format nil "e-~a-envelope" seat-id)
                             "provider-envelope" envelope))
    (append-event
     *store*
     (vertical-event
      (format nil "e-~a-envelope-custody" seat-id)
      "envelope-custody"
      (v-rec '("vertical" "record-kind") (v-id "record" "envelope-custody")
             '("vertical" "seat-id") (v-str seat-id)
             '("vertical" "envelope-id")
             (v-str (body-string envelope "ap0" "envelope-id"))
             '("vertical" "evidence-file") (v-str relative)
             '("vertical" "raw-payload-sha256")
             (v-str (body-string capture "ap0" "raw-payload-sha256"))
             '("vertical" "raw-payload-octet-count")
             (v-int (body-integer capture "ap0"
                                  "raw-payload-octet-count")))))
    envelope))

(defun journal-usage-and-cost (seat-id handle live)
  (let ((adapter-config (%plist-section *config* :adapter)))
    (append-event *store*
                  (ap0-event (format nil "e-~a-usage" seat-id) "usage-record"
                             (extract-usage live handle
                                            (getf adapter-config
                                                  :usage-procedure))))
    (append-event *store*
                  (ap0-event (format nil "e-~a-cost" seat-id) "cost-record"
                             (extract-cost live handle
                                           (getf adapter-config
                                                 :cost-procedure)
                                           :price-schedule-id
                                           (getf adapter-config
                                                 :price-schedule))))))

(defun journal-live-projection (seat-id handle live shape)
  (append-event *store*
                (ap0-event (format nil "e-~a-projection" seat-id)
                           "projection-receipt"
                           (project-envelope live handle shape))))

(defun journal-consumption (seat-id projection-receipt-id)
  "The downstream consumption record: binds the projection receipt
identity; references, never rewrites (contract §5 W4)."
  (append-event
   *store*
   (vertical-event
    (format nil "e-~a-consumption" seat-id)
    "consumption"
    (v-rec '("vertical" "record-kind") (v-id "record" "consumption")
           '("vertical" "consumption-id") (v-str (format nil "cons-~a"
                                                         seat-id))
           '("vertical" "seat-id") (v-str seat-id)
           '("vertical" "projection-receipt-id")
           (v-str projection-receipt-id)))))

(defun journal-refusal (seat-id refusal-name explanation)
  "Manifestation state stays separate from causal explanation: the state
(no subject manifestation) is derivable; THIS record carries the later
evidence-bearing explanation (contract §3)."
  (append-event
   *store*
   (vertical-event
    (format nil "e-~a-refusal" seat-id)
    "refusal"
    (v-rec '("vertical" "record-kind") (v-id "record" "refusal")
           '("vertical" "seat-id") (v-str seat-id)
           '("vertical" "refusal") (v-str refusal-name)
           '("vertical" "explanation") (v-str explanation)))))

(defun journal-retry-scan-refusal (seat-id candidate-attempt)
  "The CAP2-W1 pre-declaration scan, run from durable bytes alone; its
typed refusal journaled as the program's account of its own conduct."
  (handler-case
      (progn (check-retry-safety-from-store
              *store* :seat-name seat-id
              :candidate-attempt-name candidate-attempt)
             (vfail "seat ~a: check-retry-safety-from-store permitted a ~
                     blind retry over a crossed-unsettled seat" seat-id))
    (lisp-plus-kernel0:unsafe-retry ()
      (append-event
       *store*
       (vertical-event
        (format nil "e-~a-retry-scan" seat-id)
        "retry-scan-refusal"
        (v-rec '("vertical" "record-kind") (v-id "record"
                                                 "retry-scan-refusal")
               '("vertical" "seat-id") (v-str seat-id)
               '("vertical" "candidate-attempt-id")
               (v-str candidate-attempt)
               '("vertical" "condition") (v-str "unsafe-retry")
               '("vertical" "scan") (v-str "cap2-w1-pre-declaration")
               '("vertical" "disposition") (v-str "blind-retry-refused")))))))

;;; ---------------------------------------------------------------------------
;;; Seat state derivation (resume from durable evidence alone).

(defun seat-events ()
  (validated-events *store*))

(defun seat-has-event-p (events namespace seat-id suffix)
  (and (%seat-event events namespace seat-id suffix) t))

(defun seat-untouched-p (events seat-id)
  "No durable trace of this seat at all (not even preparation)."
  (not (seat-has-event-p events "ap0-event" seat-id "prepared")))

(defun seat-projection-event (events seat-id)
  (or (%seat-event events "ap0-event" seat-id "projection")
      (%seat-event events "vertical-event" seat-id "projection")))

(defun projection-receipt-id-of (event)
  (let ((body (event-body event)))
    (or (body-string body "ap0" "projection-receipt-id")
        (body-string body "vertical" "projection-receipt-id"))))

;;; ---------------------------------------------------------------------------
;;; Route runners.  Each derives the seat's durable state and performs
;;; only the remaining lawful work.

(defun run-full-clean-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events)))
    (cond
      ((seat-has-event-p events "vertical-event" seat-id "consumption")
       (vnote "seat ~a: complete in durable evidence; nothing remains"
              seat-id))
      ((seat-untouched-p events seat-id)
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id))
              (shape (seat-field seat-plist :shape)))
         (journal-pre-frontier-records seat-id prepared)
         (seat-budget-check seat-plist)
         (multiple-value-bind (status detail) (cross-frontier seat-plist)
           (unless (eq status :settled)
             (vfail "seat ~a: expected :settled crossing, got ~a/~a"
                    seat-id status detail)))
         (let ((handle (journal-membrane-crossing-evidence seat-id prepared
                                                           live)))
           (journal-ap0-acknowledgment seat-id handle)
           (journal-envelope-custody seat-id handle live)
           (journal-usage-and-cost seat-id handle live)
           ;; The first-fruit double duty (contract §8): a schedule-less
           ;; cost extraction returns a typed MISSING marker — never a
           ;; zero, never journaled (it is a host-struct absence).
           (when (equal seat-id "seat-first-fruit")
             (let ((marker (extract-cost live handle
                                         "fake-cost-procedure-1")))
               (unless (missing-cost-marker-p marker)
                 (vfail "seat ~a: schedule-less cost extraction did not ~
                         return the typed missing marker" seat-id))
               (vnote "seat ~a: schedule-less cost -> typed missing-cost ~
                       marker (missing, never zero)" seat-id)))
           (journal-live-projection seat-id handle live shape)
           (let ((projection (seat-projection-event (seat-events) seat-id)))
             (journal-consumption seat-id
                                  (projection-receipt-id-of projection)))
           (vnote "seat ~a: full clean route complete" seat-id))))
      (t
       (error 'vertical-unresumable-seat
              :seat seat-id
              :detail (format nil "full-clean seat ~a found partially ~
                                   complete; no declared pause exists on ~
                                   this route, so no lawful schedule can ~
                                   produce this state" seat-id))))))

(defun run-refused-budget-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events)))
    (cond
      ((seat-has-event-p events "vertical-event" seat-id "refusal")
       (vnote "seat ~a: refusal already durable; nothing remains" seat-id))
      (t
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id)))
         (journal-pre-frontier-records seat-id prepared)
         (handler-case
             (progn (seat-budget-check seat-plist)
                    (vfail "seat ~a: declared estimate ~a did not trip ~
                            the budget ceiling" seat-id
                           (seat-field seat-plist :estimate-lexeme)))
           (budget-ceiling-exceeded (condition)
             (journal-refusal
              seat-id "budget-ceiling-exceeded"
              (format nil "fold(spent)=~a + declared-estimate=~a exceeds ~
                           ceiling=~a; refused before any frontier: no ~
                           mint, no dispatch, no crossing"
                      (budget-ceiling-exceeded-spent condition)
                      (budget-ceiling-exceeded-estimate condition)
                      (budget-ceiling-exceeded-ceiling condition)))
             (vnote "seat ~a: budget-ceiling-exceeded refused ~
                     pre-frontier, refusal journaled" seat-id))))))))

(defun run-refused-authority-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events)))
    (cond
      ((seat-has-event-p events "vertical-event" seat-id "refusal")
       (vnote "seat ~a: refusal already durable; nothing remains" seat-id))
      (t
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id))
              (authority (authority-config)))
         (journal-pre-frontier-records seat-id prepared)
         (seat-budget-check seat-plist)
         (let ((receipt (query-live-authority
                         *store* *bootstrap*
                         :query-id (list "cap0-query"
                                         (format nil "q-~a-mint" seat-id))
                         :capability-id (seat-capability-id seat-id)
                         :subject (getf authority :subject)
                         :action (getf authority :action)
                         :resource (seat-resource seat-plist)
                         :scope (getf authority :scope)
                         :origin (query-origin))))
           (unless (and (eq :refused (receipt-decision receipt))
                        (equal "capability-revoked"
                               (receipt-reason receipt)))
             (vfail "seat ~a: expected the fresh fold to refuse ~
                     capability-revoked; got ~a/~a" seat-id
                    (receipt-decision receipt) (receipt-reason receipt)))
           (journal-refusal
            seat-id "capability-revoked"
            (format nil "fresh /0 fold at the current prefix refused by ~
                         name: the grant is historical fact, not live ~
                         authority (revoking event ~a); no mint, no ~
                         dispatch, no crossing"
                    (or (body-string receipt "receipt" "revoking-event-id")
                        "r-unknown")))
           (vnote "seat ~a: capability-revoked refused pre-frontier, ~
                   refusal journaled" seat-id)))))))

(defun run-frontier-only-seat (seat-plist)
  "The torn crossing (and, with :control-policy, the W1 control seat)."
  (let* ((seat-id (seat-field seat-plist :seat))
         (attempt (seat-attempt-name seat-id))
         (control-policy (seat-field seat-plist :control-policy))
         (events (seat-events)))
    (multiple-value-bind (standing) (derive-effect-standing *store* attempt)
      (cond
        ;; Nothing durable yet: cross under the declared request-loss
        ;; simulation and pause at the open window.
        ((seat-untouched-p events seat-id)
         (unless (request-loss-seat-p seat-id)
           (vfail "seat ~a: :frontier-only route requires the declared ~
                   request-loss simulation" seat-id))
         (let* ((live (bind-seat-adapter seat-id))
                (prepared (prepare-seat live seat-id)))
           (journal-pre-frontier-records seat-id prepared)
           (seat-budget-check seat-plist)
           (multiple-value-bind (status detail)
               (cross-frontier seat-plist :interruption :request-lost)
             (unless (and (eq status :interrupted)
                          (eq detail :request-lost))
               (vfail "seat ~a: expected :interrupted/:request-lost, got ~
                       ~a/~a" seat-id status detail)))
           ;; The membrane's account of the crossing that was lost in
           ;; flight — journaled BEFORE the boundary readiness.
           (journal-membrane-crossing-evidence seat-id prepared live)
           (when (route-pauses-p *config* :frontier-only
                                 "EFFECT-FRONTIER-CROSSED-UNSETTLED")
             (boundary-pause seat-id "EFFECT-FRONTIER-CROSSED-UNSETTLED"))
           ;; Continued past the boundary in this same process: the
           ;; remaining lawful work is the same recovery obligation.
           (run-frontier-only-recovery seat-plist)))
        ;; Crossed (in some prior process) but never structured.
        ((eq standing :crossed-unsettled)
         (run-frontier-only-recovery seat-plist))
        ;; Structured. For the plain torn crossing the declared policy is
        ;; :leave-unresolved — nothing remains.  For the control seat the
        ;; disposition-then-reconcile policy continues.
        ((eq standing :uncertain-unresolved)
         (if (eq control-policy :disposition-then-reconcile)
             (run-control-reconciliation seat-plist)
             (vnote "seat ~a: uncertainty structured and left unresolved ~
                     by declared policy; nothing remains" seat-id)))
        ((eq standing :reconciled)
         (vnote "seat ~a: reconciled in durable evidence; nothing remains"
                seat-id))
        (t
         (error 'vertical-unresumable-seat
                :seat seat-id
                :detail (format nil "frontier-only seat ~a in standing ~a"
                                seat-id standing)))))))

(defun run-frontier-only-recovery (seat-plist)
  "From durable bytes alone: refuse blind retry (CAP2-W1 scan, journaled),
structure the uncertainty (§10.8), then follow the declared policy."
  (let* ((seat-id (seat-field seat-plist :seat))
         (attempt (seat-attempt-name seat-id))
         (control-policy (seat-field seat-plist :control-policy)))
    ;; (1) The pre-declaration scan refuses blind retry from bytes alone.
    (journal-retry-scan-refusal seat-id (format nil "~a-retry" attempt))
    ;; (2) A FRESH key minted at the current prefix is lawful (authority
    ;; is derivable; the grant stands) — but it cannot authorize a new
    ;; attempt into the poisoned seat: unsafe-retry, before any frontier.
    (let ((fresh-key (mint-seat-key seat-plist "scan")))
      (unless (live-capability-p fresh-key)
        (vfail "seat ~a: fresh mint at current prefix failed" seat-id))
      (handler-case
          (progn (authorize-seat seat-plist fresh-key
                                 :attempt-suffix "retry")
                 (vfail "seat ~a: fresh key authorized a new attempt into ~
                         the unresolved seat" seat-id))
        (lisp-plus-kernel0:unsafe-retry ()
          (vnote "seat ~a: fresh key refused for the poisoned seat ~
                  (unsafe-retry, pre-frontier)" seat-id))))
    ;; (3) Structure the uncertainty: the §10.8 record, journaled.
    (multiple-value-bind (disposition record)
        (declare-uncertain-effect *store* attempt
                                  :process-name "vertical-campaign")
      (declare (ignore record))
      (unless (member disposition '(:declared :already-declared))
        (vfail "seat ~a: declare-uncertain-effect answered ~a" seat-id
               disposition)))
    (unless (eq :uncertain-unresolved
                (derive-effect-standing *store* attempt))
      (vfail "seat ~a: standing after structuring is not ~
              :uncertain-unresolved" seat-id))
    ;; (4) The declared policy.
    (cond
      ((eq control-policy :disposition-then-reconcile)
       ;; The disposition is durable; pause so it can be banked BEFORE
       ;; any provider evidence exists, then reconcile through class B.
       (boundary-pause seat-id "CONTROL-DISPOSITION-COMMITTED")
       (run-control-reconciliation seat-plist))
      ((eq (config-policy *config* :torn-crossing-policy) :leave-unresolved)
       (vnote "seat ~a: uncertainty structured; left unresolved by ~
               declared policy (:leave-unresolved) — never resolved ~
               in-campaign" seat-id))
      (t
       (vfail "seat ~a: no declared policy for the structured uncertainty"
              seat-id)))))

;;; ---------------------------------------------------------------------------
;;; The declared class-B reconciliation reader (contract §2.4).
;;;
;;;; The fake provider's durable domain file (fake-world/
;;;; provider-domain.sexp) is readable ONLY here, and this reader is
;;;; called ONLY from the control reconciliation step below.  It feeds
;;;; ap0:reconcile-request with an AP-REC-6-complete witness taken from
;;;; the domain file's own declared completeness block.

(defun %read-provider-domain ()
  (let ((form
          (with-open-file (stream (exec-path "fake-world/provider-domain.sexp")
                                  :direction :input)
            (let ((*read-eval* nil)
                  (*package* (find-package '#:lisp-plus-vertical0)))
              (read stream)))))
    (%validate-config-datum form)
    (unless (and (consp form) (eq (first form) :provider-domain))
      (error "class-B reader: not a provider domain file"))
    form))

(defun run-control-reconciliation (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (attempt (seat-attempt-name seat-id))
         (events (seat-events)))
    (when (seat-has-event-p events "vertical-event" seat-id
                           "control-outcome")
      (vnote "seat ~a: reconciliation outcome already durable" seat-id)
      (return-from run-control-reconciliation))
    (let* ((domain (%read-provider-domain))
           (request-id (identifier-segment-string
                        (identifier-from-segments
                         (list "external-request" "cap2" attempt))))
           (entries (config-field domain :entries))
           (entry (find request-id entries
                        :key (lambda (e) (getf e :request-id))
                        :test #'equal))
           (complete (getf (%plist-section domain :declaration)
                           :domain-complete))
           (witness (getf (%plist-section domain :declaration)
                          :completeness-witness))
           (live (bind-live-adapter
                  (descriptor-by-identity
                   (getf (%plist-section *config* :adapter)
                         :descriptor-identity))
                  :instance-label (format nil "~a-reconciliation" seat-id))))
      (multiple-value-bind (result reconciliation standing)
          (if entry
              ;; The identity IS in the provider's durable domain: the
              ;; request completed provider-side.  This is evidence the
              ;; effect occurred — the uncertainty records stay unchanged;
              ;; the standing gains evidence, it does not lose history.
              (values "completed"
                      (reconcile-request
                       live (format nil "~a-classb" seat-id)
                       :result "completed"
                       :provider-request-id (getf entry
                                                  :provider-request-id))
                      "effect-standing-with-evidence")
              ;; NOT FOUND may settle no-effect ONLY under the AP-REC-6
              ;; conjunction: exact identity + complete authoritative
              ;; domain + a distinct completeness witness.
              (values "not-found"
                      (reconcile-request
                       live (format nil "~a-classb" seat-id)
                       :result "not-found"
                       :provider-request-id request-id
                       :domain-complete complete
                       :completeness-witness
                       (list :evidence-id (getf witness :evidence-id)
                             :boundary (getf witness :boundary)
                             :procedure-id (getf witness :procedure-id)
                             :standing (getf witness :standing)
                             :origin (getf witness :origin)))
                      "settled-no-effect"))
        (append-event *store*
                      (ap0-event (format nil "e-~a-reconciliation" seat-id)
                                 "reconciliation" reconciliation))
        (append-event
         *store*
         (vertical-event
          (format nil "e-~a-control-outcome" seat-id)
          "control-outcome"
          (v-rec '("vertical" "record-kind") (v-id "record"
                                                   "control-outcome")
                 '("vertical" "seat-id") (v-str seat-id)
                 '("vertical" "reconciliation-result") (v-str result)
                 '("vertical" "standing") (v-str standing)
                 '("vertical" "uncertainty-records") (v-str "unchanged"))))
        (vnote "seat ~a: class-B reconciliation ~a -> ~a" seat-id result
               standing)))))

;;; ---------------------------------------------------------------------------

(defun run-streaming-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events))
         (chunk-1 (seat-has-event-p events "ap0-event" seat-id "chunk-1"))
         (closure (seat-has-event-p events "vertical-event" seat-id
                                    "stream-closure")))
    (cond
      (closure
       (vnote "seat ~a: closed as partial in durable evidence; its ~
               partiality is never completed" seat-id))
      ((seat-untouched-p events seat-id)
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id))
              (pause-p (route-pauses-p *config* :streaming
                                       "STREAM-CHUNK-CUSTODY-COMMITTED")))
         (journal-pre-frontier-records seat-id prepared)
         (seat-budget-check seat-plist)
         (multiple-value-bind (status detail) (cross-frontier seat-plist)
           (unless (eq status :settled)
             (vfail "seat ~a: expected :settled crossing, got ~a/~a"
                    seat-id status detail)))
         (let ((handle (journal-membrane-crossing-evidence seat-id prepared
                                                           live)))
           (journal-ap0-acknowledgment seat-id handle)
           ;; §10.5 journal-before-delivery, carried to the campaign
           ;; journal: the sink appends each chunk's custody record and
           ;; only then treats the chunk as delivered.  The declared
           ;; boundary opens at the FIRST committed chunk.
           (let ((delivered 0))
             (observe-stream
              handle
              (lambda (chunk-record)
                (incf delivered)
                (append-event *store*
                              (ap0-event (format nil "e-~a-chunk-~a"
                                                 seat-id delivered)
                                         "stream-chunk" chunk-record))
                (when (and (= delivered 1) pause-p)
                  (boundary-pause seat-id
                                  "STREAM-CHUNK-CUSTODY-COMMITTED")))
              :chunk-count (config-policy *config* :stream-chunk-count)))
           ;; Only reachable when the schedule CONTINUEs the boundary:
           ;; the stream completes and the seat runs to consumption.
           (journal-envelope-custody seat-id handle live)
           (journal-usage-and-cost seat-id handle live)
           (journal-live-projection seat-id handle live
                                    (seat-field seat-plist :shape))
           (let ((projection (seat-projection-event (seat-events) seat-id)))
             (journal-consumption seat-id
                                  (projection-receipt-id-of projection)))
           (vnote "seat ~a: streaming route complete" seat-id))))
      (chunk-1
       ;; RECOVERY: chunk custody survives; the terminal never arrived.
       ;; The declared policy refuses resumption typed — restarting the
       ;; stream from chunk zero would duplicate chunk-1's custody.
       (let ((preserved
               (loop for ordinal from 1
                     while (seat-has-event-p (seat-events) "ap0-event"
                                             seat-id
                                             (format nil "chunk-~a" ordinal))
                     count t)))
         (unless (eq :refused (config-policy *config*
                                             :partial-stream-resumption))
           (vfail "seat ~a: no declared partial-stream policy" seat-id))
         (handler-case
             (error 'stream-resume-would-duplicate
                    :seat seat-id
                    :chunks-preserved preserved
                    :detail "resumption from chunk zero would duplicate ~
                             journaled chunk custody")
           (stream-resume-would-duplicate (condition)
             (append-event
              *store*
              (vertical-event
               (format nil "e-~a-stream-closure" seat-id)
               "stream-closure"
               (v-rec '("vertical" "record-kind")
                      (v-id "record" "stream-closure")
                      '("vertical" "seat-id") (v-str seat-id)
                      '("vertical" "chunks-preserved")
                      (v-int (stream-resume-chunks-preserved condition))
                      '("vertical" "resumption") (v-str "refused")
                      '("vertical" "condition")
                      (v-str "stream-resume-would-duplicate")
                      '("vertical" "disposition")
                      (v-str "closed-as-partial"))))))
         (vnote "seat ~a: partial stream closed (typed refusal; ~a chunk~:p ~
                 preserved, never rewritten, never resumed)" seat-id
                preserved)))
      (t
       (error 'vertical-unresumable-seat
              :seat seat-id
              :detail (format nil "streaming seat ~a crossed but holds no ~
                                   chunk custody" seat-id))))))

(defun run-envelope-then-recover-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events))
         (custody (%seat-event events "vertical-event" seat-id
                               "envelope-custody"))
         (projection (seat-projection-event events seat-id))
         (consumed (seat-has-event-p events "vertical-event" seat-id
                                     "consumption")))
    (cond
      (consumed
       (vnote "seat ~a: complete in durable evidence" seat-id))
      ((seat-untouched-p events seat-id)
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id)))
         (journal-pre-frontier-records seat-id prepared)
         (seat-budget-check seat-plist)
         (multiple-value-bind (status detail) (cross-frontier seat-plist)
           (unless (eq status :settled)
             (vfail "seat ~a: expected :settled crossing, got ~a/~a"
                    seat-id status detail)))
         (let ((handle (journal-membrane-crossing-evidence seat-id prepared
                                                           live)))
           (journal-ap0-acknowledgment seat-id handle)
           (journal-envelope-custody seat-id handle live)
           (journal-usage-and-cost seat-id handle live)
           (when (route-pauses-p *config* :envelope-then-recover
                                 "ENVELOPE-CUSTODY-COMMITTED")
             (boundary-pause seat-id "ENVELOPE-CUSTODY-COMMITTED"))
           ;; Reachable only when the schedule CONTINUEs: the live handle
           ;; still exists, so the LIVE projection path is lawful here.
           (journal-live-projection seat-id handle live
                                    (seat-field seat-plist :shape))
           (when (route-pauses-p *config* :envelope-then-recover
                                 "PROJECTION-COMMITTED")
             (boundary-pause seat-id "PROJECTION-COMMITTED"))
           (let ((fresh (seat-projection-event (seat-events) seat-id)))
             (journal-consumption seat-id
                                  (projection-receipt-id-of fresh)))
           (vnote "seat ~a: envelope route completed live" seat-id))))
      ((and custody (not projection))
       ;; RECOVERY: the dispatch handle died with the process.  Project
       ;; from the captured bytes through the declared vertical recovery
       ;; procedure; the fake provider is NOT called again.
       (let* ((body (event-body custody))
              (relative (body-string body "vertical" "evidence-file"))
              (envelope-id (body-string body "vertical" "envelope-id"))
              (expected-sha (body-string body "vertical"
                                         "raw-payload-sha256"))
              (octets (read-octet-file (exec-path relative))))
         (unless octets
           (vfail "seat ~a: journaled evidence file ~a is missing"
                  seat-id relative))
         (vnote "seat ~a: envelope integrity re-checked against the ~
                 journaled binding (sha256 ~a)" seat-id
                (sha256-hex octets))
         (let ((record (vertical-recovery-projection-0
                        octets (seat-field seat-plist :shape)
                        :seat-id seat-id
                        :envelope-id envelope-id
                        :expected-sha256 expected-sha)))
           (append-event *store*
                         (vertical-event (format nil "e-~a-projection"
                                                 seat-id)
                                         "recovery-projection-receipt"
                                         record)))
         (when (route-pauses-p *config* :envelope-then-recover
                               "PROJECTION-COMMITTED")
           (boundary-pause seat-id "PROJECTION-COMMITTED"))
         (let ((fresh (seat-projection-event (seat-events) seat-id)))
           (journal-consumption seat-id (projection-receipt-id-of fresh)))
         (vnote "seat ~a: recovered by derived projection from captured ~
                 bytes; provider not recalled" seat-id)))
      ((and projection (not consumed))
       (journal-consumption seat-id (projection-receipt-id-of projection))
       (vnote "seat ~a: existing projection consumed" seat-id))
      (t
       (error 'vertical-unresumable-seat
              :seat seat-id
              :detail (format nil "envelope-then-recover seat ~a in an ~
                                   undeclared durable state" seat-id))))))

(defun run-project-then-consume-later-seat (seat-plist)
  (let* ((seat-id (seat-field seat-plist :seat))
         (events (seat-events))
         (projection (seat-projection-event events seat-id))
         (consumed (seat-has-event-p events "vertical-event" seat-id
                                     "consumption")))
    (cond
      (consumed
       (vnote "seat ~a: complete in durable evidence" seat-id))
      ((seat-untouched-p events seat-id)
       (let* ((live (bind-seat-adapter seat-id))
              (prepared (prepare-seat live seat-id)))
         (journal-pre-frontier-records seat-id prepared)
         (seat-budget-check seat-plist)
         (multiple-value-bind (status detail) (cross-frontier seat-plist)
           (unless (eq status :settled)
             (vfail "seat ~a: expected :settled crossing, got ~a/~a"
                    seat-id status detail)))
         (let ((handle (journal-membrane-crossing-evidence seat-id prepared
                                                           live)))
           (journal-ap0-acknowledgment seat-id handle)
           (journal-envelope-custody seat-id handle live)
           (journal-usage-and-cost seat-id handle live)
           (journal-live-projection seat-id handle live
                                    (seat-field seat-plist :shape))
           (when (route-pauses-p *config* :project-then-consume-later
                                 "PROJECTION-COMMITTED")
             (boundary-pause seat-id "PROJECTION-COMMITTED"))
           (let ((fresh (seat-projection-event (seat-events) seat-id)))
             (journal-consumption seat-id
                                  (projection-receipt-id-of fresh)))
           (vnote "seat ~a: project-then-consume route completed live"
                  seat-id))))
      ((and projection (not consumed))
       ;; RECOVERY: no provider action, no new envelope, no re-projection.
       ;; The EXISTING projection is consumed: the consumption record
       ;; references the projection receipt identity — it never rewrites
       ;; the projection's journaled frame.
       (journal-consumption seat-id (projection-receipt-id-of projection))
       (vnote "seat ~a: existing projection consumed after restart; ~
               provider not recalled, projection frame untouched" seat-id))
      (t
       (error 'vertical-unresumable-seat
              :seat seat-id
              :detail (format nil "project-then-consume seat ~a in an ~
                                   undeclared durable state" seat-id))))))

(defun run-interrupted-then-reconcile-seat (seat-plist)
  "The slammed door: cross under the declared request-loss simulation,
structure the post-frontier uncertainty, reconcile against surviving
world evidence — all evidence-settled, no pause on this route."
  (let* ((seat-id (seat-field seat-plist :seat))
         (attempt (seat-attempt-name seat-id))
         (events (seat-events)))
    (multiple-value-bind (standing) (derive-effect-standing *store* attempt)
      (cond
        ((eq standing :reconciled)
         (vnote "seat ~a: reconciled in durable evidence" seat-id))
        ((seat-untouched-p events seat-id)
         (unless (request-loss-seat-p seat-id)
           (vfail "seat ~a: route requires the declared request-loss ~
                   simulation" seat-id))
         (let* ((live (bind-seat-adapter seat-id))
                (prepared (prepare-seat live seat-id)))
           (journal-pre-frontier-records seat-id prepared)
           (seat-budget-check seat-plist)
           (multiple-value-bind (status detail)
               (cross-frontier seat-plist :interruption :request-lost)
             (unless (and (eq status :interrupted)
                          (eq detail :request-lost))
               (vfail "seat ~a: expected :interrupted/:request-lost, got ~
                       ~a/~a" seat-id status detail)))
           (journal-membrane-crossing-evidence seat-id prepared live)
           (run-slammed-door-reconciliation seat-plist)))
        ((eq standing :crossed-unsettled)
         (run-slammed-door-reconciliation seat-plist))
        ((eq standing :uncertain-unresolved)
         (run-slammed-door-reconciliation seat-plist :already-structured t))
        (t
         (error 'vertical-unresumable-seat
                :seat seat-id
                :detail (format nil "interrupted-then-reconcile seat ~a in ~
                                     standing ~a" seat-id standing)))))))

(defun run-slammed-door-reconciliation (seat-plist &key already-structured)
  (let* ((seat-id (seat-field seat-plist :seat))
         (attempt (seat-attempt-name seat-id)))
    (unless already-structured
      (multiple-value-bind (disposition)
          (declare-uncertain-effect *store* attempt
                                    :process-name "vertical-campaign")
        (unless (member disposition '(:declared :already-declared))
          (vfail "seat ~a: declare-uncertain-effect answered ~a" seat-id
                 disposition))))
    ;; World-evidence reconciliation: carry the journaled external-request
    ;; identity to the SURVIVING world.  The request was lost in flight,
    ;; so the ledger holds no entry: resolution :not-applied, settled by
    ;; evidence of absence in a complete adapter-owned ledger — never by
    ;; script determinism.
    (multiple-value-bind (resolution event receipt)
        (reconcile-uncertain-effect *store* *world* attempt
                                    :process-name "vertical-campaign")
      (declare (ignore event receipt))
      (unless (eq resolution :not-applied)
        (vfail "seat ~a: expected reconciliation :not-applied, got ~a"
               seat-id resolution))
      (vnote "seat ~a: post-frontier failure reconciled :not-applied ~
              against surviving world evidence" seat-id))))

;;; ---------------------------------------------------------------------------
;;; Route dispatch.

(defun run-seat (seat-plist)
  (let ((route (seat-field seat-plist :route)))
    (ecase route
      ((:full-clean :late-full-clean) (run-full-clean-seat seat-plist))
      (:refused-budget (run-refused-budget-seat seat-plist))
      (:refused-authority (run-refused-authority-seat seat-plist))
      (:frontier-only (run-frontier-only-seat seat-plist))
      (:streaming (run-streaming-seat seat-plist))
      (:envelope-then-recover (run-envelope-then-recover-seat seat-plist))
      (:project-then-consume-later
       (run-project-then-consume-later-seat seat-plist))
      (:interrupted-then-reconcile
       (run-interrupted-then-reconcile-seat seat-plist)))))

;;; ---------------------------------------------------------------------------
;;; Finalization (contract §§9–11): interpretation, census, export,
;;; secret opening, publication, campaign-complete.

(defun campaign-complete-p (events)
  (and (find-event events :event-id "vertical-event:e-campaign-complete")
       t))

(defun run-interpretation-stage ()
  (dolist (seat-plist (config-bank *config*))
    (let* ((seat-id (seat-field seat-plist :seat))
           (events (seat-events))
           (projection (seat-projection-event events seat-id)))
      (when (and projection
                 (not (seat-has-event-p events "vertical-event" seat-id
                                        "interpretation")))
        (let ((namespace (if (%seat-event events "ap0-event" seat-id
                                          "projection")
                             "ap0" "vertical")))
          (multiple-value-bind (receipt class)
              (vertical-interpretation-0 (event-body projection)
                                         :seat-id seat-id
                                         :namespace namespace)
            (append-event *store*
                          (vertical-event
                           (format nil "e-~a-interpretation" seat-id)
                           "transformation-receipt" receipt))
            (vnote "interpretation: seat ~a -> structural class ~a ~
                    (structure, never truth)" seat-id class)))))))

(defun run-census-stage ()
  (let ((events (seat-events)))
    (unless (find-event events :event-id "vertical-event:e-census")
      (multiple-value-bind (record outcomes)
          (derive-census *store* *config*)
        (append-event *store* (vertical-event "e-census" "census" record))
        (vnote "census: ~a seat~:p derived from durable evidence"
               (length outcomes))))))

(defun census-export-octets ()
  (let ((census (find-event (seat-events)
                            :event-id "vertical-event:e-census")))
    (unless census (vfail "export: no journaled census record"))
    (encode-pjs0 (event-body census))))

(defun run-secret-opening-stage ()
  (let ((secret (%plist-section *config* :secret)))
    (when (and secret
               (not (find-event (seat-events)
                                :event-id "vertical-event:e-secret-exposure")))
      (let* ((authority (authority-config))
             (receipt (query-live-authority
                       *store* *bootstrap*
                       :query-id '("cap0-query" "q-secret-opening")
                       :capability-id (list "cap" (getf secret :rubric-id))
                       :subject (getf authority :subject)
                       :action (getf secret :opening-action)
                       :resource (list "resource" (getf secret :rubric-id))
                       :scope (getf authority :scope)
                       :origin (query-origin))))
        (unless (eq :authorized (receipt-decision receipt))
          (vfail "secret opening: authority refused (~a)"
                 (receipt-reason receipt)))
        ;; The opening IS the exposure record: an opening without one is
        ;; a defect (contract §9).  Capability, principals, scope — named.
        (append-event
         *store*
         (vertical-event
          "e-secret-exposure" "secret-exposure"
          (v-rec '("vertical" "record-kind") (v-id "record"
                                                   "secret-exposure")
                 '("vertical" "rubric-id") (v-str (getf secret :rubric-id))
                 '("vertical" "capability-id")
                 (v-id "cap" (getf secret :rubric-id))
                 '("vertical" "exposed-principals")
                 (v-seq (mapcar #'v-str (getf secret :exposed-principals)))
                 '("vertical" "exposure-scope")
                 (v-str (getf secret :exposure-scope)))))
        (vnote "secret opening: exposure record journaled (~{~a~^, ~} ~
                within scope ~a)" (getf secret :exposed-principals)
               (getf secret :exposure-scope))))))

(defun run-publication-stage ()
  (let ((publication (%plist-section *config* :publication)))
    (when (and publication
               (not (find-event (seat-events)
                                :event-id
                                "vertical-event:e-publication-receipt")))
      (let* ((authority (authority-config))
             (staging (getf publication :staging-artifact))
             (octets (census-export-octets))
             (artifact-sha (sha256-hex octets)))
        ;; The staging artifact (derived export), then the simulated
        ;; mirror copy — both by the declared write-replace protocol.
        (write-evidence-file (exec-path staging) octets)
        (write-evidence-file
         (exec-path (format nil "~acampaign-export.sexp"
                            (getf publication :mirror-destination)))
         octets)
        ;; The simulated commit frontier: one exact cap2 effect writing
        ;; the mirror cell.  Pre-frontier facts are already durable
        ;; (grant journaled at bootstrap); mint -> authorize -> attempt
        ;; with zero appends in between.
        (let* ((cell-name (getf publication :mirror-cell))
               (key (mint-from-authorization
                     *store* *bootstrap* *context*
                     (query-live-authority
                      *store* *bootstrap*
                      :query-id '("cap0-query" "q-publicatio-mint")
                      :capability-id '("cap" "publicatio")
                      :subject (getf authority :subject)
                      :action (getf publication :publication-action)
                      :resource (list "cella" cell-name)
                      :scope (getf authority :scope)
                      :origin (query-origin))
                     :minter '("vertical-minter" "machina")))
               (authorization
                 (authorize-effect-attempt
                  *store* *bootstrap* *context* key
                  :capability-id '("cap" "publicatio")
                  :query-name "q-publicatio-auth"
                  :subject (getf authority :subject)
                  :action (getf publication :publication-action)
                  :resource (list "cella" cell-name)
                  :scope (getf authority :scope)
                  :cell (list "cella" cell-name)
                  :value artifact-sha
                  :attempt-name "a-publicatio"
                  :seat-name "seat-publicatio")))
          (multiple-value-bind (status detail)
              (attempt-protected-effect *store* *bootstrap* *context* key
                                        authorization *world*
                                        :process-name "vertical-campaign")
            (unless (eq status :settled)
              (vfail "publication: commit frontier not settled (~a/~a)"
                     status detail))))
        (append-event
         *store*
         (vertical-event
          "e-publication-receipt" "publication-receipt"
          (v-rec '("vertical" "record-kind") (v-id "record"
                                                   "publication-receipt")
                 '("vertical" "staging-artifact") (v-str staging)
                 '("vertical" "artifact-sha256") (v-str artifact-sha)
                 '("vertical" "mirror-destination")
                 (v-str (getf publication :mirror-destination))
                 '("vertical" "mirror-cell")
                 (v-str (getf publication :mirror-cell))
                 '("vertical" "channel-policy")
                 (v-str (getf publication :channel-policy))
                 '("vertical" "commit-attempt-id") (v-str "a-publicatio"))))
        (vnote "publication: export staged, simulated commit frontier ~
                settled, mirror-sim written, receipt journaled (channel: ~
                ~a)" (getf publication :channel-policy))))))

(defun run-campaign-complete-stage ()
  (let ((events (seat-events)))
    (unless (campaign-complete-p events)
      (let ((total (length (config-bank *config*)))
            (frame-count (prefix-report-frame-count
                          (validate-journal *store*))))
        (append-event
         *store*
         (vertical-event
          "e-campaign-complete" "campaign-complete"
          (v-rec '("vertical" "record-kind") (v-id "record"
                                                   "campaign-complete")
                 '("vertical" "seat-count") (v-int total)
                 '("vertical" "frame-count-at-completion")
                 (v-int (1+ frame-count))
                 '("vertical" "disposition") (v-str "complete"))))
        (vnote "campaign-complete record journaled")))))

;;; ---------------------------------------------------------------------------
;;; Main.

(defun campaign-main (exec-dir-namestring)
  (setf *exec-dir* (pathname (concatenate 'string
                                          exec-dir-namestring
                                          (if (char= #\/ (char exec-dir-namestring
                                                               (1- (length exec-dir-namestring))))
                                              "" "/"))))
  (format t "CHILD-PID ~a~%" (sb-unix:unix-getpid))
  (finish-output)
  (setf *config* (read-vertical-config
                  (exec-path "VERTICAL-PROGRAM-CONFIG.sexp")))
  (setf *ceiling* (parse-lexeme-rational
                   (getf (%plist-section *config* :budget)
                         :ceiling-lexeme)))
  ;; Store: open when durable evidence exists, create otherwise.  The
  ;; distinction is itself durable evidence — never a life number.
  (setf *store-existed*
        (and (probe-file (exec-path "store/JOURNAL-META.pjs")) t))
  (setf *store*
        (if *store-existed*
            (open-store (exec-path "store/"))
            (create-journal (exec-path "store/")
                            :declared-durability (config-durability *config*)
                            :nonce-octets (config-nonce-octets *config*))))
  (unless (string= (journal-store-store-id *store*) (expected-store-id))
    (vfail "store identity ~a does not equal the identity derived from ~
            declared configuration ~a"
           (journal-store-store-id *store*) (expected-store-id)))
  (let ((report (validate-journal *store*)))
    (unless (eq :valid (prefix-report-status report))
      (vfail "surviving journal did not validate :valid (~a); recovery ~
              refuses a damaged prefix" (prefix-report-status report)))
    (vnote "store ~a: :valid, ~a frame~:p (~a)"
           (journal-store-store-id *store*)
           (prefix-report-frame-count report)
           (if *store-existed* "resumed from durable evidence"
               "created from declared configuration")))
  (setf *world*
        (if (probe-file (exec-path "world/CELLS.txt"))
            (open-world (exec-path "world/"))
            (make-world (exec-path "world/") (declared-world-cells))))
  (setf *bootstrap* (declare-bootstrap-authority
                     (list "issuer" (getf (authority-config)
                                          :bootstrap-issuer))
                     (expected-store-id)))
  ;; A fresh minting context every process: it recognizes NOTHING minted
  ;; before this process began (contract §7).
  (setf *context* (make-minting-context :label "vertical-campaign"))
  (journal-opening-authority)
  ;; The declared seat order, over whatever remains.
  (dolist (seat-id (config-seat-order *config*))
    (let ((seat-plist (find seat-id (config-bank *config*)
                            :key (lambda (plist) (seat-field plist :seat))
                            :test #'equal)))
      (unless seat-plist
        (vfail "declared seat order names ~a but the bank has no such seat"
               seat-id))
      (run-seat seat-plist)))
  ;; Finalization: only when every seat's work is done (which the seat
  ;; loop just ensured).
  (run-interpretation-stage)
  (run-census-stage)
  (run-secret-opening-stage)
  (run-publication-stage)
  (run-campaign-complete-stage)
  (vnote "nothing remains; exiting 0")
  (sb-ext:exit :code 0))

(handler-case
    (let ((arguments (rest sb-ext:*posix-argv*)))
      (unless (= 1 (length arguments))
        (vfail "usage: campaign.lisp <exec-dir>"))
      (campaign-main (first arguments)))
  (error (condition)
    (vfail "unhandled: ~a" condition)))
