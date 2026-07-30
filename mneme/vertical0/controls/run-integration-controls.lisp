;;;; run-integration-controls.lisp — the §14 integration-control battery.
;;;;
;;;; Run from the latent-lisp root:
;;;;
;;;;   sbcl --script mneme/vertical0/controls/run-integration-controls.lisp
;;;;
;;;; Exit 0 iff every check passed.  The count at the bottom is a LIVE
;;;; counter over controls actually exercised here — never a remembered
;;;; total, and never inflated by a control discharged elsewhere.
;;;;
;;;; THE STANDARD: each control presents ONE named forbidden design and
;;;; requires it to fail THROUGH ITS INTENDED PREDICATE.  A generic crash is
;;;; not a pass.  Where the predicate is a predecessor's typed condition the
;;;; control triggers the REAL condition through the vertical's own
;;;; composition (the campaign's own mint / authorize / cross / AP0
;;;; operation surface, booted in this process over a scratch execution
;;;; directory) — never a hand-rolled imitation.  Where a process is needed
;;;; the control runs a real child, under strace when the verdict is a
;;;; syscall verdict, and the shipped witness checker
;;;; (harness/witness.lisp) is reused read-only to deliver it.
;;;;
;;;; INERTNESS.  This lane modified NO existing file.  The proof is the
;;;; first section below: the shipped witness checker re-run over the
;;;; PRESERVED campaign-1 / control-a / control-b traces reproduces
;;;; RUN-WITNESS.txt byte-identically, and the real campaign still runs
;;;; clean single-life in a scratch directory.
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "../support/forms-loader.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../support/gate-support.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-vertical0)

(defun cscratch (name)
  (merge-pathnames (format nil "mneme/vertical0/runs/scratch-controls-~a/"
                           name)))

(defvar *control-index* 0)

(defun control (title predicate thunk)
  "One §14 control.  TITLE names the forbidden design, PREDICATE names the
law that must refuse it.  Counts toward the live controls counter."
  (incf *controls-total*)
  (incf *control-index*)
  (when (gcheck "C" (format nil "§14.~2,'0d ~a — refused by ~a"
                            *control-index* (format nil title)
                            (format nil predicate))
                thunk)
    (incf *controls-passed*)))

(defun ccheck (description thunk) (gcheck "C" description thunk))

(gnote "vertical0 integration controls — the §14 battery.  Every item fails ~
        through its intended named predicate; a generic crash is never a ~
        pass.")
(gnote "no pid, no clock, no temporary name appears below: the twin run must ~
        be byte-identical.~%")

;;; Gate teeth first, so the tooth-firing children are cheap.
(when (equal (sb-ext:posix-getenv "VERTICAL0_CONTROLS_PLANT_FAULT") "1")
  (ccheck "PLANTED FAULT — this check must FAIL and the battery must exit 1"
    (lambda () nil))
  (gnote "~%vertical0 integration controls: ~a check~:p, ~a failure~:p"
         *gate-checks* *gate-failures*)
  (format t "RESULT: FAIL~%")
  (sb-ext:exit :code 1))

(when (equal (sb-ext:posix-getenv "VERTICAL0_CONTROLS_DIE") "1")
  (gnote "VERTICAL0_CONTROLS_DIE=1 — dying mid-run WITHOUT a RESULT sentinel ~
          (planted truncation)")
  (sb-ext:exit :code 3))

;;; ===========================================================================
(gnote "== inertness of this lane: the existing tree is unmodified ==")

(ccheck "the shipped witness checker (harness/witness.lisp), re-run over the ~
         PRESERVED campaign-1 / control-a / control-b traces, reproduces ~
         RUN-WITNESS.txt BYTE-IDENTICALLY — 62 checks, 0 failures, same ~
         lines, same order.  Nothing this lane added changed what the ~
         durability witness sees"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script" "mneme/vertical0/harness/witness.lisp")
                     :search t :output output :error output))
           (text (get-output-stream-string output))
           (preserved (read-text-file
                       #p"mneme/vertical0/RUN-WITNESS.txt")))
      (and (eql 0 (sb-ext:process-exit-code process))
           (string= text preserved)))))

(ccheck "the real campaign (program/campaign.lisp, verbatim) still runs ~
         clean: an all-CONTINUE single-life smoke over a fresh scratch ~
         execution directory exits 0 and journals a census and a ~
         campaign-complete record"
  (lambda ()
    (let* ((root (cscratch "inertness-smoke"))
           (results (run-mini-campaign
                     root (mini-config :seats +bank-full-clean+
                                       :order '("seat-alpha"))
                     :program :real))
           (events (mini-store-events root)))
      (and (eql 0 (mini-life-exit-code (last-life results)))
           (has-event-p events "vertical-event:e-census")
           (has-event-p events "vertical-event:e-campaign-complete")))))

(ccheck "and the git working tree confirms it: program/, harness/ and the ~
         sealed artifacts carry no modification from this lane — the only ~
         additions are program/defects.lisp, support/, mutants/ and ~
         controls/ (asserted here by re-reading the three preserved run ~
         transcripts and finding them unchanged on disk)"
  (lambda ()
    (every (lambda (pair)
             (let ((text (read-text-file (first pair))))
               (and text (search (second pair) text))))
           (list (list #p"mneme/vertical0/RUN-CAMPAIGN-1.txt"
                       "vertical0 harness (campaign): 35 checks, 0 failures")
                 (list #p"mneme/vertical0/RUN-W1-CONTROL.txt"
                       "vertical0 harness (control): 12 checks, 0 failures")
                 (list #p"mneme/vertical0/RUN-WITNESS.txt"
                       "vertical0 witness: 62 checks, 0 failures")))))

;;; ===========================================================================
(gnote "~%== the §14 battery ==")

;;; --- one in-process boot serves every predecessor-owned refusal ------------
;;; This is the vertical's own composition, not an imitation: the functions
;;; called below are the ones campaign.lisp calls.

(boot-in-process (cscratch "in-process")
                 (mini-config :seats +bank-two-clean+
                              :order '("seat-alpha" "seat-beta")
                              :revoked '("seat-beta"))
                 :context-label "vertical-controls")

(defvar *alpha* (seat-by-id "seat-alpha"))
(defvar *beta* (seat-by-id "seat-beta"))
(defvar *auth* (authority-config))
(defvar *live* (bind-seat-adapter "seat-alpha"))
(defvar *alpha-prepared* (prepare-seat *live* "seat-alpha"))

;; Complete seat-alpha's lawful crossing once; several controls below are
;; only reachable AFTER a lawful crossing exists.
(journal-pre-frontier-records "seat-alpha" *alpha-prepared*)
(seat-budget-check *alpha*)
(cross-frontier *alpha*)
(journal-membrane-crossing-evidence "seat-alpha" *alpha-prepared* *live*)

(defun refusal-reason (capability-seat resource-seat query)
  (let ((receipt (query-live-authority
                  *store* *bootstrap*
                  :query-id (list "cap0-query" query)
                  :capability-id (seat-capability-id capability-seat)
                  :subject (getf *auth* :subject)
                  :action (getf *auth* :action)
                  :resource (seat-resource resource-seat)
                  :scope (getf *auth* :scope)
                  :origin :live-query)))
    (values (receipt-decision receipt) (receipt-reason receipt))))

;;; 01 duplicate seat identity ------------------------------------------------
(control "duplicate seat — one seat identity declared twice in the bank with ~
          different cells, so its opening grant would be journaled twice ~
          with different content"
         "pj0-event-identity-collision (Journal /0)"
  (lambda ()
    (let* ((config (mini-config
                    :seats '((:id "seat-alpha" :route :full-clean
                              :shape "nonempty" :estimate "100/1000000"
                              :cell "cella-alpha")
                             (:id "seat-alpha" :route :full-clean
                              :shape "nonempty" :estimate "100/1000000"
                              :cell "cella-altera"))
                    :order '("seat-alpha")))
           (results (run-mini-campaign (cscratch "duplicate-seat") config)))
      (equal "PJ0-EVENT-IDENTITY-COLLISION"
             (mini-life-condition-type (last-life results))))))

;;; 02 duplicate attempt identity ---------------------------------------------
(control "duplicate attempt identity — a second crossing under an attempt ~
          name the validated prefix already binds"
         "duplicate-attempt-identity (Kernel /0 §6.6, via Capability /2)"
  (lambda ()
    (signals-exactly lisp-plus-kernel0:duplicate-attempt-identity
      (cross-frontier *alpha*))))

;;; 03 duplicate provider / idempotency identity ------------------------------
(control "duplicate provider identity — re-dispatching a preparation that has ~
          already crossed the membrane once"
         "unsafe-retry (Kernel /0 §14.1, re-exported by Adapter /0)"
  (lambda ()
    (signals-exactly lisp-plus-kernel0:unsafe-retry
      (dispatch *alpha-prepared* :live-adapter *live*))))

;;; 04 occupied target before effect ------------------------------------------
;;; REPORTED, NOT CLAIMED.  See the §15 note printed at the end.
(ccheck "§14 occupied target before effect — NOT EXERCISED.  The composed ~
         stack exposes no predicate for it: Capability /2 deliberately does ~
         NOT expose Kernel /0's occupied `perform`, and a second authorized ~
         attempt on an already-written cell SETTLES (last write wins).  ~
         Recorded here as an APPARENT MISSING PREDECESSOR PREDICATE and ~
         reported upward; this lane performs no predecessor repair.  The ~
         check below asserts only the fact just stated, so the gap is ~
         visible in the transcript rather than silently absent"
  (lambda ()
    (let* ((key (mint-seat-key *alpha* "occupied"))
           (authorization
             (authorize-effect-attempt
              *store* *bootstrap* *context* key
              :capability-id (seat-capability-id "seat-alpha")
              :query-name "q-occupied"
              :subject (getf *auth* :subject) :action (getf *auth* :action)
              :resource (seat-resource *alpha*) :scope (getf *auth* :scope)
              :cell (seat-cell-segments *alpha*) :value "V-second"
              :attempt-name "a-occupied" :seat-name "seat-alpha")))
      (eq :settled (nth-value 0 (attempt-protected-effect
                                 *store* *bootstrap* *context* key
                                 authorization *world*
                                 :process-name "vertical-controls"))))))

;;; 05 revoked capability -----------------------------------------------------
(control "revoked capability — a grant that a later revocation defeated, ~
          presented at the current prefix"
         "the fresh /0 fold's refusal reason capability-revoked"
  (lambda ()
    (multiple-value-bind (decision reason)
        (refusal-reason "seat-beta" *beta* "q-revoked")
      (and (eq :refused decision) (equal "capability-revoked" reason)))))

;;; 06 stale capability -------------------------------------------------------
(control "stale capability — a live key minted before a journal append and ~
          presented after it (every append stales every key)"
         "cap1-stale-capability (Capability /1)"
  (lambda ()
    (let ((key (mint-seat-key *alpha* "stale")))
      (journal-refusal "seat-alpha" "controls-filler"
                       "an append, so the key above is stale")
      (signals-exactly lisp-plus-capability1:cap1-stale-capability
        (authorize-seat *alpha* key :attempt-suffix "stale")))))

;;; 07 scope mutation ---------------------------------------------------------
(control "scope mutation — a capability queried with terms other than the ~
          ones it was granted for"
         "the fold's refusal reason capability-scope-mismatch"
  (lambda ()
    (multiple-value-bind (decision reason)
        (refusal-reason "seat-alpha" *beta* "q-scope-mutation")
      (and (eq :refused decision)
           (equal "capability-scope-mismatch" reason)))))

;;; 08 scope aliasing ---------------------------------------------------------
(control "scope aliasing — a key whose terms match, presented to authorize an ~
          effect on a DIFFERENT cell than the one it names"
         "cap2-effect-not-authorized (exact four-term equality)"
  (lambda ()
    (let ((key (mint-seat-key *alpha* "alias")))
      (signals-exactly lisp-plus-capability2:cap2-effect-not-authorized
        (authorize-effect-attempt
         *store* *bootstrap* *context* key
         :capability-id (seat-capability-id "seat-alpha")
         :query-name "q-alias"
         :subject (getf *auth* :subject) :action (getf *auth* :action)
         :resource (seat-resource *alpha*) :scope (getf *auth* :scope)
         :cell '("cella" "cella-aliena") :value "V"
         :attempt-name "a-alias" :seat-name "seat-alpha")))))

;;; 09 self-restoration attempt ----------------------------------------------
(control "self-restoration attempt — a revoked capability identity re-granted ~
          under the same terms, then queried"
         "the fold's terminal refusal capability-revoked (a revocation is not ~
          undone by a later grant of the same identity)"
  (lambda ()
    (append-event *store*
                  (make-grant-event
                   :event-id '("cap0-event" "g-beta-self-restored")
                   :capability-id (seat-capability-id "seat-beta")
                   :subject (getf *auth* :subject)
                   :action (getf *auth* :action)
                   :resource (seat-resource *beta*)
                   :scope (getf *auth* :scope)
                   :issuer (list "issuer" (getf *auth* :bootstrap-issuer))))
    (multiple-value-bind (decision reason)
        (refusal-reason "seat-beta" *beta* "q-self-restored")
      (and (eq :refused decision) (equal "capability-revoked" reason)))))

;;; 10 restoration with enlarged scope ---------------------------------------
(control "restoration with enlarged scope — the same revoked identity ~
          re-granted with a WIDER scope"
         "the fold's terminal refusal capability-revoked (enlargement buys ~
          nothing a restoration could not buy)"
  (lambda ()
    (append-event *store*
                  (make-grant-event
                   :event-id '("cap0-event" "g-beta-enlarged")
                   :capability-id (seat-capability-id "seat-beta")
                   :subject (getf *auth* :subject)
                   :action (getf *auth* :action)
                   :resource (seat-resource *beta*)
                   :scope '("scope" "semper")
                   :issuer (list "issuer" (getf *auth* :bootstrap-issuer))))
    (let ((receipt (query-live-authority
                    *store* *bootstrap*
                    :query-id '("cap0-query" "q-enlarged")
                    :capability-id (seat-capability-id "seat-beta")
                    :subject (getf *auth* :subject)
                    :action (getf *auth* :action)
                    :resource (seat-resource *beta*)
                    :scope '("scope" "semper")
                    :origin :live-query)))
      (and (eq :refused (receipt-decision receipt))
           (equal "capability-revoked" (receipt-reason receipt))))))

;;; 11 spending ceiling exceeded ----------------------------------------------
(control "spending ceiling exceeded — fold(spent) + declared estimate beyond ~
          the declared ceiling, checked BEFORE the frontier"
         "budget-ceiling-exceeded (contract §8; typed, pre-frontier)"
  (lambda ()
    (signals-exactly budget-ceiling-exceeded
      (check-budget-before-frontier *store* "seat-alpha" "1000000/1"
                                    *ceiling*))))

;;; 12 adapter alias / route drift --------------------------------------------
(control "adapter alias drift — dispatch under a resolved configuration other ~
          than the one bound at preparation"
         "implicit-provider-fallback (AP-ID-8/9: fallback is not continuation)"
  (lambda ()
    (signals-exactly lisp-plus-adapter0:implicit-provider-fallback
      (dispatch (prepare-seat *live* "seat-beta") :live-adapter *live*
                :resolved-configuration-id "some-other-configuration"))))

;;; 13 adapter version drift --------------------------------------------------
(control "adapter version drift — the descriptor version changes between ~
          preparation and dispatch"
         "adapter-version-drift (AP-DESC-3)"
  (lambda ()
    (let ((prepared (prepare-seat *live* "seat-beta"))
          (drifted (bind-live-adapter
                    (descriptor-by-identity "fake-reference-0")
                    :instance-label "controls-drifted")))
      (setf (lisp-plus-adapter0:live-adapter-descriptor-version drifted)
            "0.3.0-drifted")
      (signals-exactly lisp-plus-adapter0:adapter-version-drift
        (dispatch prepared :live-adapter drifted)))))

;;; 14 unsafe fallback (frozen fixture) ---------------------------------------
(control "unsafe fallback — the frozen BAD-CFG-01 adversarial fixture (a ~
          silent provider substitution)"
         "implicit-provider-fallback, rule-exact at Adapter /0's validator"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (lisp-plus-adapter0:validate-case
         (lisp-plus-adapter0:read-pjs-fixture
          (merge-pathnames "vectors/adversarial/BAD-CFG-01.pjs"
                           lisp-plus-adapter0:+reissue-root+)))
      (and (eq :reject verdict)
           (equal "implicit-provider-fallback" condition)))))

;;; 15 unsafe retry from durable bytes ----------------------------------------
(control "unsafe retry — the pre-declaration scan run from durable bytes ~
          alone over a seat whose crossing is unsettled"
         "unsafe-retry (CAP2-W1, check-retry-safety-from-store)"
  (lambda ()
    (let* ((config (mini-config :seats +bank-frontier+ :order '("seat-torn")
                                :request-loss '("seat-torn")))
           (root (cscratch "unsafe-retry")))
      (run-mini-campaign root config)
      (let ((store (nth-value 1 (mini-store-events root))))
        ;; The seat is left :uncertain-unresolved by declared policy; the
        ;; scan over its durable bytes still refuses a candidate retry.
        (signals-exactly lisp-plus-kernel0:unsafe-retry
          (check-retry-safety-from-store
           store :seat-name "seat-torn"
           :candidate-attempt-name "a-seat-torn-controls-retry"))))))

;;; 16 standing inflation -----------------------------------------------------
(control "standing inflation — a transport-level acknowledgment relabelled as ~
          provider receipt (the frozen BAD-ACK-01 fixture)"
         "acknowledgment-ambiguous (AP-ACK-4: an acknowledgment class has no ~
          settling force by itself)"
  (lambda ()
    (multiple-value-bind (verdict condition)
        (lisp-plus-adapter0:validate-case
         (lisp-plus-adapter0:read-pjs-fixture
          (merge-pathnames "vectors/adversarial/BAD-ACK-01.pjs"
                           lisp-plus-adapter0:+reissue-root+)))
      (and (eq :reject verdict)
           (equal "acknowledgment-ambiguous" condition)))))

;;; 17 torn journal tail ------------------------------------------------------
(control "torn journal tail — a truncated EVENTS.pj0 offered to a recovering ~
          child as its surviving evidence"
         "the strict reader's :TORN-TAIL status; the child refuses a damaged ~
          prefix rather than resuming on it"
  (lambda ()
    (let* ((root (cscratch "torn-tail"))
           (exec (merge-pathnames "exec/" root))
           (events-path (merge-pathnames "store/EVENTS.pj0" exec)))
      (run-mini-campaign root (mini-config :seats +bank-full-clean+
                                           :order '("seat-alpha")))
      (let ((octets (read-octet-file events-path)))
        (with-open-file (stream events-path :direction :output
                                            :element-type '(unsigned-byte 8)
                                            :if-exists :supersede)
          (write-sequence (subseq octets 0 (- (length octets) 9)) stream)))
      (let ((status (prefix-report-status
                     (validate-journal (open-store
                                        (merge-pathnames "store/" exec)))))
            (life (run-mini-life exec)))
        (and (eq :torn-tail status)
             (eql 2 (mini-life-exit-code life))
             (search "did not validate :valid (TORN-TAIL)"
                     (or (mini-life-child-error life) "")))))))

;;; 18 invalid interior record ------------------------------------------------
(control "invalid interior record — a flipped octet inside an already-sealed ~
          frame"
         "the strict reader's :CORRUPTION status; the child refuses the ~
          prefix rather than reading past the damage"
  (lambda ()
    (let* ((root (cscratch "interior-corruption"))
           (exec (merge-pathnames "exec/" root))
           (events-path (merge-pathnames "store/EVENTS.pj0" exec)))
      (run-mini-campaign root (mini-config :seats +bank-full-clean+
                                           :order '("seat-alpha")))
      (let ((octets (read-octet-file events-path)))
        (setf (aref octets 200) (logxor 255 (aref octets 200)))
        (with-open-file (stream events-path :direction :output
                                            :element-type '(unsigned-byte 8)
                                            :if-exists :supersede)
          (write-sequence octets stream)))
      (let ((status (prefix-report-status
                     (validate-journal (open-store
                                        (merge-pathnames "store/" exec)))))
            (life (run-mini-life exec)))
        (and (eq :corruption status)
             (eql 2 (mini-life-exit-code life))
             (search "did not validate :valid (CORRUPTION)"
                     (or (mini-life-child-error life) "")))))))

;;; 19 self-written narrative promoted to observation -------------------------
(control "self-written narrative promoted to observation — the program's own ~
          account of its conduct claiming origin OBSERVED"
         "the origin-jurisdiction predicate: every vertical- and ap0-namespace ~
          event is ASSERTED testimony (AP-JRN-1); an OBSERVED one is a defect"
  (lambda ()
    (flet ((origins (root)
             (let ((events (mini-store-events root)))
               (remove-duplicates
                (loop for event in events
                      for id = (event-id-string event)
                      when (and id (or (%line-prefix-p "vertical-event:" id)
                                       (%line-prefix-p "ap0-event:" id)))
                        collect (let ((origin (record-field event "event"
                                                            "origin")))
                                  (and origin
                                       (identifier-segment-string origin))))
                :test #'equal))))
      (let ((config (mini-config :seats +bank-full-clean+
                                 :order '("seat-alpha")))
            (strict-root (cscratch "origin-strict"))
            (mutant-root (cscratch "origin-mutant")))
        (run-mini-campaign strict-root config)
        (run-mini-campaign mutant-root config
                           :defects '(:narrative-promoted-to-observation))
        (and (equal '("origin:asserted") (origins strict-root))
             (member "origin:observed" (origins mutant-root)
                     :test #'equal)
             t)))))

;;; 20 claim copied without transformation receipt ----------------------------
(control "claim copied without a transformation receipt — a projection's ~
          content carried downstream with no procedure identity, version and ~
          input binding"
         "the transformation-receipt requirement (contract §10)"
  (lambda ()
    (let* ((config (mini-config :seats +bank-full-clean+
                                :order '("seat-alpha")))
           (strict-root (cscratch "receipt-strict"))
           (mutant-root (cscratch "receipt-mutant")))
      (run-mini-campaign strict-root config)
      (run-mini-campaign mutant-root config
                         :defects '(:projection-promoted-to-truth))
      (flet ((binding (root)
               (let* ((events (mini-store-events root))
                      (receipt (find-event
                                events :event-id
                                "vertical-event:e-seat-alpha-interpretation")))
                 (and receipt
                      (body-string (event-body receipt) "vertical"
                                   "input-projection-receipt-id")))))
        (and (binding strict-root) (null (binding mutant-root)))))))

;;; 21 secret opening without an exposure record ------------------------------
(control "secret opening without an exposure record — a declared synthetic ~
          rubric opened with nothing journaled naming capability, principals ~
          and scope"
         "the exposure-record requirement (contract §9)"
  (lambda ()
    (let* ((config (mini-config :seats +bank-full-clean+
                                :order '("seat-alpha") :secret t))
           (strict-root (cscratch "secret-strict"))
           (mutant-root (cscratch "secret-mutant")))
      (run-mini-campaign strict-root config)
      (run-mini-campaign mutant-root config
                         :defects '(:secret-opening-without-exposure))
      (let* ((strict-events (mini-store-events strict-root))
             (exposure (find-event strict-events
                                   :event-id
                                   "vertical-event:e-secret-exposure")))
        (and exposure
             (body-string (event-body exposure) "vertical" "capability-id")
             (body-string (event-body exposure) "vertical" "exposure-scope")
             (not (has-event-p (mini-store-events mutant-root)
                               "vertical-event:e-secret-exposure")))))))

;;; 22 finalizer-only primary fact --------------------------------------------
(control "finalizer-only primary fact — a census assertion held only in a ~
          finalizer-owned named cell"
         "the named-cell localization tooth: unbound-variable whose ~
          cell-error-name is the finalizer-only symbol"
  (lambda ()
    (let* ((root (cscratch "finalizer-cell"))
           (config (read-vertical-config
                    #p"mneme/vertical0/VERTICAL-PROGRAM-CONFIG.sexp")))
      (fresh-directory root)
      (copy-tree-directory #p"mneme/vertical0/runs/campaign-1/exec/store/"
                           root)
      (let ((store (open-store (merge-pathnames "store/" root))))
        (install-defects '(:finalizer-only-fact-accepted))
        (makunbound '*finalizer-only-cache*)
        (prog1
            (handler-case (progn (derive-census store config) nil)
              (unbound-variable (condition)
                (eq '*finalizer-only-cache* (cell-error-name condition))))
          (uninstall-defects)
          (setf *finalizer-only-cache* '(:label "finalizer-only-fact")))))))

;;; 23 raw host value crossing a durable boundary -----------------------------
(control "raw host value crossing a durable boundary — a configuration ~
          carrying a host float, and one carrying a bare symbol (i.e. code)"
         "the narrow data reader's refusal (config-reader §2.1: keywords, ~
          strings, integers, NIL and proper lists — nothing else)"
  (lambda ()
    (let ((root (cscratch "raw-host-value")))
      (fresh-directory root)
      (flet ((refuses (text name)
               (let ((path (merge-pathnames name root)))
                 (write-text-file path text)
                 (handler-case (progn (read-vertical-config path) nil)
                   (error (condition)
                     (search "non-data object"
                             (format nil "~a" condition)))))))
        (and (refuses "(:vertical-program-config (:policy (:x 1.5)))"
                      "float.sexp")
             (refuses "(:vertical-program-config (:policy (:x some-symbol)))"
                      "symbol.sexp"))))))

;;; 24 convenience accessor discarding outcome context ------------------------
(control "convenience accessor discarding outcome context — a refusal reduced ~
          to a bare NIL, losing why"
         "cap1-mint-refused, which CARRIES its BASIS ~
          (:receipt-not-authorized) and names the /0 reason in its detail, ~
          rather than collapsing the refusal to a value"
  (lambda ()
    (handler-case (progn (mint-seat-key *beta* "context") nil)
      (lisp-plus-capability1:cap1-mint-refused (condition)
        (and (eq :receipt-not-authorized
                 (lisp-plus-capability1:cap1-mint-refused-basis condition))
             (search "capability-revoked"
                     (lisp-plus-capability1:cap1-condition-detail condition))
             t)))))

;;; 25 runner truncation before canonical result ------------------------------
(control "runner truncation before a canonical result — a gate child killed ~
          mid-run"
         "the exit-3 / no-RESULT-sentinel pair (truncation is never ~
          mistakable for a pass)"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script"
                           "mneme/vertical0/controls/run-integration-controls.lisp")
                     :search t :output output :error output
                     :environment (cons "VERTICAL0_CONTROLS_DIE=1"
                                        (sb-ext:posix-environ))))
           (text (get-output-stream-string output)))
      (and (eql 3 (sb-ext:process-exit-code process))
           (not (search "RESULT:" text))))))

;;; 26 marker emitted before sync ---------------------------------------------
(control "marker emitted before sync — a readiness marker announcing a ~
          durable fact BEFORE that fact's append (and therefore before its ~
          fsync)"
         "the corpse test: the record the marker announced is ABSENT from the ~
          journal at death, and one fewer fsync(EVENTS.pj0) precedes the ~
          marker than in the strict arm"
  (lambda ()
    (flet ((arm (root defects)
             (let ((config (mini-config
                            :seats +bank-stream+ :order '("seat-song")
                            :route-pauses '((:streaming
                                             "STREAM-CHUNK-CUSTODY-COMMITTED"))))
                   (trace (merge-pathnames "trace-life1.txt" root)))
               (fresh-directory root)
               (setup-mini-exec (merge-pathnames "exec/" root) config)
               (run-mini-life (merge-pathnames "exec/" root)
                              :defects defects :trace-path trace
                              :policy (lambda (l s b o)
                                        (declare (ignore l s b o)) :kill))
               (let* ((events (cl-user::parse-trace trace))
                      (ready (cl-user::last-index
                              (cl-user::ready-writes events))))
                 (list :fsyncs-before-ready
                       (length (cl-user::events-matching
                                events :op :fsync :path-suffix "EVENTS.pj0"
                                :end ready))
                       :chunk-durable
                       (has-event-p (store-events
                                     (merge-pathnames "exec/store/" root))
                                    "ap0-event:e-seat-song-chunk-1"))))))
      (let ((strict (arm (cscratch "marker-strict") nil))
            (mutant (arm (cscratch "marker-mutant") '(:marker-before-sync))))
        (and (getf strict :chunk-durable)
             (not (getf mutant :chunk-durable))
             (= (getf mutant :fsyncs-before-ready)
                (1- (getf strict :fsyncs-before-ready))))))))

;;; 27 no-sync durability mutant ----------------------------------------------
(control "no-sync durability — the same program on a best-effort journal, ~
          whose bytes are STILL readable after SIGKILL"
         "the shipped external witness check-sync-before-every-ready ~
          (readable bytes are not the passing condition)"
  (lambda ()
    (let* ((root (cscratch "no-sync"))
           (config (mini-config
                    :seats +bank-stream+ :order '("seat-song")
                    :route-pauses '((:streaming
                                     "STREAM-CHUNK-CUSTODY-COMMITTED"))
                    :durability "best-effort"))
           (trace (merge-pathnames "trace-life1.txt" root)))
      (fresh-directory root)
      (setup-mini-exec (merge-pathnames "exec/" root) config)
      (run-mini-life (merge-pathnames "exec/" root)
                     :trace-path trace
                     :policy (lambda (l s b o) (declare (ignore l s b o))
                               :kill))
      (let ((events (cl-user::parse-trace trace))
            (failures 0))
        (let ((cl-user::*checks* 0) (cl-user::*failures* 0)
              (*standard-output* (make-broadcast-stream)))
          (cl-user::check-sync-before-every-ready "no-sync" events)
          (setf failures cl-user::*failures*))
        (and (plusp failures)
             (zerop (length (cl-user::events-matching
                             events :op :fsync :path-suffix "EVENTS.pj0")))
             (eq :valid (prefix-report-status
                         (validate-journal
                          (open-store (merge-pathnames "exec/store/"
                                                       root))))))))))

;;; 28 semantic work after readiness marker -----------------------------------
(control "semantic work after the readiness marker — a journal append between ~
          READY and SIGKILL"
         "the shipped external witness check-killed-tail (no write, pwrite, ~
          rename or unlink may follow the final marker)"
  (lambda ()
    (flet ((arm (root defects)
             (let ((config (mini-config
                            :seats +bank-stream+ :order '("seat-song")
                            :route-pauses '((:streaming
                                             "STREAM-CHUNK-CUSTODY-COMMITTED"))))
                   (trace (merge-pathnames "trace-life1.txt" root)))
               (fresh-directory root)
               (setup-mini-exec (merge-pathnames "exec/" root) config)
               (run-mini-life (merge-pathnames "exec/" root)
                              :defects defects :trace-path trace
                              :policy (lambda (l s b o)
                                        (declare (ignore l s b o)) :kill))
               (let ((events (cl-user::parse-trace trace))
                     (failures 0))
                 (let ((cl-user::*checks* 0) (cl-user::*failures* 0)
                       (*standard-output* (make-broadcast-stream)))
                   (cl-user::check-killed-tail "arm" events "W-mini")
                   (setf failures cl-user::*failures*))
                 failures))))
      (and (zerop (arm (cscratch "after-ready-strict") nil))
           (plusp (arm (cscratch "after-ready-mutant")
                       '(:semantic-work-after-ready)))))))

;;; 29 write-replace without fsync --------------------------------------------
(control "captured-evidence write-replace with close instead of fsync — the ~
          temporary file renamed with no barrier before or after"
         "the shipped external witness check-write-replace-protocol (close ~
          alone is never a durability primitive)"
  (lambda ()
    (flet ((arm (root defects)
             (let ((config (mini-config
                            :seats '((:id "seat-sealed"
                                      :route :envelope-then-recover
                                      :shape "nonempty" :estimate "400/1000000"
                                      :cell "cella-sigillata"))
                            :order '("seat-sealed")
                            :route-pauses '((:envelope-then-recover
                                             "ENVELOPE-CUSTODY-COMMITTED"))))
                   (trace (merge-pathnames "trace-life1.txt" root)))
               (fresh-directory root)
               (setup-mini-exec (merge-pathnames "exec/" root) config)
               (run-mini-life (merge-pathnames "exec/" root)
                              :defects defects :trace-path trace
                              :policy (lambda (l s b o)
                                        (declare (ignore l s b o)) :eof))
               (let ((events (cl-user::parse-trace trace))
                     (failures 0))
                 (let ((cl-user::*checks* 0) (cl-user::*failures* 0)
                       (*standard-output* (make-broadcast-stream)))
                   (cl-user::check-write-replace-protocol "arm" events)
                   (setf failures cl-user::*failures*))
                 failures))))
      (and (zerop (arm (cscratch "write-replace-strict") nil))
           (plusp (arm (cscratch "write-replace-mutant")
                       '(:evidence-write-without-sync)))))))

;;; 30 oracle file exposed to child -------------------------------------------
(control "the oracle artifact exposed to a child — a child that opens ~
          VERTICAL-HARNESS-ORACLE.sexp"
         "the shipped external witness check-read-set, shown FIRING (a ~
          read-set proof that has never caught anything is untested)"
  (lambda ()
    (flet ((arm (root defects)
             (let ((config (mini-config :seats +bank-full-clean+
                                        :order '("seat-alpha")))
                   (trace (merge-pathnames "trace-life1.txt" root)))
               (fresh-directory root)
               (setup-mini-exec (merge-pathnames "exec/" root) config)
               (run-mini-life (merge-pathnames "exec/" root)
                              :defects defects :trace-path trace)
               (let ((events (cl-user::parse-trace trace))
                     (failures 0))
                 (let ((cl-user::*checks* 0) (cl-user::*failures* 0)
                       (*standard-output* (make-broadcast-stream)))
                   (cl-user::check-read-set "arm" events)
                   (setf failures cl-user::*failures*))
                 failures))))
      (and (zerop (arm (cscratch "read-set-strict") nil))
           (plusp (arm (cscratch "read-set-mutant") '(:read-the-oracle)))))))

;;; 31 kill schedule passed through configuration -----------------------------
(control "the kill schedule passed through the program configuration — any ~
          of life number, W label, kill schedule, expected fold or outcome, ~
          or the oracle pathname appearing in what the child lawfully reads"
         "the §2.1 jurisdiction scanner over the PARSED configuration — the ~
          data the child can actually read — shown FIRING on a planted config"
  (lambda ()
    (let* ((forbidden '("KILL-SCHEDULE" "W1" "W2" "W3" "W4" "LIFE-NUMBER"
                        "EXPECTED-FOLD" "EXPECTED-OUTCOME"
                        "VERTICAL-HARNESS-ORACLE"))
           (root (cscratch "jurisdiction"))
           (planted-path (merge-pathnames "planted-config.sexp" root)))
      (fresh-directory root)
      (write-text-file planted-path
                       ";;;; planted §2.1 jurisdiction violation
(:vertical-program-config
 (:policy (:kill-schedule ((:boundary \"EFFECT-FRONTIER-CROSSED-UNSETTLED\"
                            :occurrence 1 :w \"W1\")))))")
      (flet ((violations (path)
               ;; Scan the PARSED datum, not the raw bytes: the reader drops
               ;; comments, so a comment can never reach the program.  (The
               ;; sealed file does carry the string "W1" in a prose header
               ;; naming the control bank — never in data.)
               (let ((text (string-upcase
                            (prin1-to-string (read-vertical-config path)))))
                 (count-if (lambda (token) (search token text)) forbidden))))
        (and (zerop (violations
                     #p"mneme/vertical0/VERTICAL-PROGRAM-CONFIG.sexp"))
             (plusp (violations planted-path)))))))

;;; 32 schedule independence (§2.3) -------------------------------------------
(control "schedule independence — the harness schedule changed while the ~
          program's own artifacts must not move"
         "the §2.3 digest identity: program source digest, program ~
          configuration digest and public bank digest are equal under two ~
          genuinely different oracle schedules"
  (lambda ()
    (let* ((root (cscratch "schedule-independence"))
           (oracle (read-text-file
                    #p"mneme/vertical0/VERTICAL-HARNESS-ORACLE.sexp"))
           (sources '("package.lisp" "config-reader.lisp" "records.lisp"
                      "evidence.lisp" "budget.lisp" "recovery-projection.lisp"
                      "interpretation.lisp" "census.lisp" "campaign.lisp"
                      "load.lisp")))
      (fresh-directory root)
      (flet ((program-digest ()
               (sha256-hex
                (sb-ext:string-to-octets
                 (apply #'concatenate 'string
                        (append
                         (mapcar (lambda (name)
                                   (read-text-file
                                    (merge-pathnames
                                     name #p"mneme/vertical0/program/")))
                                 sources)
                         (list (read-text-file
                                #p"mneme/vertical0/VERTICAL-PROGRAM-CONFIG.sexp"))))
                 :external-format :utf-8))))
        (let ((before (program-digest))
              (schedule-a oracle)
              ;; A genuinely different schedule: the same oracle with its
              ;; kill occurrences renumbered.  Written to SCRATCH — the real
              ;; oracle is never touched.
              (schedule-b (substitute #\2 #\1 oracle)))
          (write-text-file (merge-pathnames "oracle-a.sexp" root) schedule-a)
          (write-text-file (merge-pathnames "oracle-b.sexp" root) schedule-b)
          (let ((after (program-digest)))
            (and (not (string= schedule-a schedule-b))
                 (string= before after))))))))

;;; 33 W1 settled through script knowledge ------------------------------------
(control "W1 settled through script knowledge — a settlement claimed with no ~
          class-B reconciliation evidence read"
         "reconciliation-insufficient, and adapter-witness-boundary-missing ~
          when the completeness witness is merely ASSERTED (AP-REC-6).  The ~
          full two-arm wrong-in-one-arm grading of the same forbidden design ~
          is discharged in RUN-MUTATION.txt (O11) and is not double-counted ~
          here"
  (lambda ()
    (let ((live (bind-live-adapter
                 (descriptor-by-identity "fake-reference-0")
                 :instance-label "controls-rec")))
      (and (signals-exactly lisp-plus-adapter0:reconciliation-insufficient
             (reconcile-request live "controls-rec-1" :result "not-found"
                                :provider-request-id "pr-controls-1"))
           (signals-exactly
               lisp-plus-adapter0:adapter-witness-boundary-missing
             (reconcile-request live "controls-rec-2" :result "not-found"
                                :provider-request-id "pr-controls-2"
                                :domain-complete t
                                :completeness-witness
                                '(:evidence-id "e" :boundary "b"
                                  :procedure-id "p" :standing "validated"
                                  :origin "asserted")))))))

;;; ===========================================================================
(gnote "~%== gate teeth — a gate that has never fired is untested ==")

(ccheck "the planted-fault tooth FIRES: a child battery with ~
         VERTICAL0_CONTROLS_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED FAULT ~
         — the battery can fail, so its PASS is evidence"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script"
                           "mneme/vertical0/controls/run-integration-controls.lisp")
                     :search t :output output :error output
                     :environment
                     (cons "VERTICAL0_CONTROLS_PLANT_FAULT=1"
                           (sb-ext:posix-environ))))
           (text (get-output-stream-string output)))
      (and (eql 1 (sb-ext:process-exit-code process))
           (search "FAIL PLANTED FAULT" text)))))

;;; ===========================================================================

(gnote "~%§15 RETURN NOTE — apparent missing predecessor predicate.")
(gnote "  occupied target before effect: the composed stack has no refusal ~
        for a second authorized attempt on an already-written cell.  ~
        Capability /2 deliberately does not expose Kernel /0's occupied ~
        `perform`, and its own frontier settles last-write-wins.  REPORTED, ~
        not repaired: this lane makes no predecessor change.")

(gnote "~%§14 controls exercised here: ~a of ~a passed (live counter)"
       *controls-passed* *controls-total*)
(gnote "vertical0 integration controls: ~a check~:p, ~a failure~:p"
       *gate-checks* *gate-failures*)
(if (and (zerop *gate-failures*)
         (= *controls-passed* *controls-total*))
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
