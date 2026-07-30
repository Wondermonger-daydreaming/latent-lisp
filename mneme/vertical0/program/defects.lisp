;;;; defects.lisp — the planted-defect registry for Vertical Specimen /0
;;;; (sealed contract §13 bilateral mutation, §14 integration controls).
;;;;
;;;; WHAT THIS FILE IS.  A registry of named forbidden designs, each
;;;; expressed as a PROGRAM VARIANT: a small set of replacement definitions
;;;; installed over the real program's own functions.  Nothing here is a
;;;; re-implementation of the program and nothing here is a hand-rolled
;;;; imitation of a predicate: every mutant runs the REAL composition
;;;; (campaign.lisp + the real predecessor public APIs) with exactly one
;;;; rule changed, so every kill is delivered by a real predicate — a typed
;;;; condition from a predecessor or from this lane, or a named grading
;;;; predicate over durable evidence.
;;;;
;;;; WHY IT IS SEPARATE.  The green path never loads this file.  It is not
;;;; in program/load.lisp's module list; it is loaded ONLY by
;;;; mutants/mutant-child.lisp and by the two gates, and only AFTER
;;;; campaign.lisp's definitions exist (so every replacement can close over
;;;; the real original).  Consequence, and it is the point:
;;;;
;;;;   NO EXISTING FILE IN THE TREE IS MODIFIED BY THIS LANE.
;;;;
;;;; There are therefore no defaults-nil seams to prove inert — the seam
;;;; count is zero.  Inertness is proven instead by (a) re-running the
;;;; witness checker over the PRESERVED campaign-1 / control traces
;;;; byte-identically, and (b) an all-CONTINUE single-life smoke of the
;;;; real campaign in a scratch directory exiting 0.  Both live in
;;;; controls/run-integration-controls.lisp.
;;;;
;;;; TWO-SIDED KILL GRAMMAR (adopted from adapter0/mutants.lisp's frozen
;;;; mutant records, RUN-REGISTRY-MUTANT):
;;;;
;;;;   rule-omission:  STRICT refuses the target BY ITS EXACT NAMED
;;;;                   PREDICATE, and the MUTANT — the same program with
;;;;                   exactly that one rule disabled — commits the
;;;;                   forbidden act.  Both halves are required: a rule
;;;;                   nothing can violate is not a rule under test.
;;;;   rule-addition:  STRICT performs the exact §12 founded-progress
;;;;                   transition, and the MUTANT fails to perform it while
;;;;                   the transition's durable preconditions are satisfied.
;;;;                   Universal abstention is not a passing campaign.
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

;;; ---------------------------------------------------------------------------
;;; Activation state.

(defvar *active-defects* '()
  "The list of defect keywords installed in THIS process.  NIL in every
green-path process; nothing consults it except this file.")

(defvar *saved-definitions* (make-hash-table :test #'eq)
  "SYMBOL -> the function this file displaced, so the gates can restore the
real program between in-process arms.")

(defun defect-p (name) (and (member name *active-defects*) t))

(defun %replace (symbol function)
  (unless (nth-value 1 (gethash symbol *saved-definitions*))
    (setf (gethash symbol *saved-definitions*) (fdefinition symbol)))
  (setf (fdefinition symbol) function))

(defun defect-original (symbol)
  (or (gethash symbol *saved-definitions*) (fdefinition symbol)))

(defun uninstall-defects ()
  "Restore every displaced definition.  Returns the number restored."
  (let ((count 0))
    (maphash (lambda (symbol function)
               (setf (fdefinition symbol) function)
               (incf count))
             *saved-definitions*)
    (clrhash *saved-definitions*)
    (setf *active-defects* '())
    count))

;;; ---------------------------------------------------------------------------
;;; The spurious refusal (rule-addition mutants signal this).

(define-condition defect-spurious-refusal (vertical-condition)
  ((name :initarg :name :reader defect-spurious-refusal-name))
  (:documentation
   "A planted rule-addition mutant's invented refusal.  It exists so the
gate can watch a §12 founded-progress transition NOT happen while its exact
durable preconditions hold."))

(defun %spurious (name detail)
  (error 'defect-spurious-refusal :name name :detail detail))

;;; ---------------------------------------------------------------------------
;;; CD/0 record surgery used by one plant (public accessors only).

(defun defect-strip-record-field (record namespace name)
  "RECORD without its NAMESPACE:NAME entry.  Public CD/0 accessors only."
  (let ((key (identifier-from-segments (list namespace name))))
    (lisp-plus-cd0:make-record-datum
     (loop for index below (lisp-plus-cd0:record-datum-size record)
           for entry-key = (lisp-plus-cd0:record-datum-key-at record index)
           unless (lisp-plus-cd0:equal-datum entry-key key)
             collect (lisp-plus-cd0:make-record-entry
                      entry-key
                      (lisp-plus-cd0:record-datum-value-at record index))))))

;;; ---------------------------------------------------------------------------
;;; RULE-OMISSION installers.  Each disables exactly one rule.

(defun install-unsafe-retry-allowed ()
  ;; FORBIDDEN: the CAP2-W1 pre-declaration scan is skipped and a fresh key
  ;; is used to authorize a NEW attempt into a crossed-unsettled seat.
  (%replace 'run-frontier-only-recovery
            (lambda (seat-plist)
              (let ((key (mint-seat-key seat-plist "scan")))
                (authorize-seat seat-plist key :attempt-suffix "retry")))))

(defun install-revoked-accepted ()
  ;; FORBIDDEN: the fresh /0 fold answers REFUSED capability-revoked and the
  ;; program mints from that receipt anyway.
  (%replace 'run-refused-authority-seat
            (lambda (seat-plist)
              (let* ((seat-id (seat-field seat-plist :seat))
                     (live (bind-seat-adapter seat-id))
                     (prepared (prepare-seat live seat-id)))
                (journal-pre-frontier-records seat-id prepared)
                (seat-budget-check seat-plist)
                (mint-seat-key seat-plist "mint")))))

(defun install-scope-mismatch-accepted ()
  ;; FORBIDDEN: a seat's key is presented to authorize an effect on a cell
  ;; the capability does not name (exact four-term equality abandoned).
  (%replace 'authorize-seat
            (lambda (seat-plist key &key (attempt-suffix nil))
              (let* ((authority (authority-config))
                     (seat-id (seat-field seat-plist :seat))
                     (attempt (if attempt-suffix
                                  (format nil "~a-~a"
                                          (seat-attempt-name seat-id)
                                          attempt-suffix)
                                  (seat-attempt-name seat-id))))
                (authorize-effect-attempt
                 *store* *bootstrap* *context* key
                 :capability-id (seat-capability-id seat-id)
                 :query-name (format nil "q-~a-auth~@[-~a~]" seat-id
                                     attempt-suffix)
                 :subject (getf authority :subject)
                 :action (getf authority :action)
                 :resource (seat-resource seat-plist)
                 :scope (getf authority :scope)
                 :cell (list "cella"
                             (concatenate 'string
                                          (seat-field seat-plist :cell)
                                          "-aliena"))
                 :value (seat-value seat-id)
                 :attempt-name attempt
                 :seat-name seat-id)))))

(defun install-budget-ignored ()
  ;; FORBIDDEN: the pre-frontier ceiling check never refuses.
  (%replace 'check-budget-before-frontier
            (lambda (store seat-id estimate-lexeme ceiling-rational)
              (declare (ignore seat-id ceiling-rational))
              (multiple-value-bind (spent count) (fold-durable-costs store)
                (declare (ignore count))
                (values spent (if estimate-lexeme
                                  (parse-lexeme-rational estimate-lexeme)
                                  :missing))))))

(defun install-ack-promoted-to-settlement ()
  ;; FORBIDDEN: the acknowledgment is treated as terminal settlement — the
  ;; seat is projected with no provider envelope ever captured.
  (%replace 'run-streaming-seat
            (lambda (seat-plist)
              (let* ((seat-id (seat-field seat-plist :seat))
                     (live (bind-seat-adapter seat-id))
                     (prepared (prepare-seat live seat-id)))
                (journal-pre-frontier-records seat-id prepared)
                (seat-budget-check seat-plist)
                (cross-frontier seat-plist)
                (let ((handle (journal-membrane-crossing-evidence
                               seat-id prepared live)))
                  (journal-ap0-acknowledgment seat-id handle)
                  (journal-live-projection seat-id handle live
                                           (seat-field seat-plist
                                                       :shape)))))))

(defun install-partial-promoted-complete ()
  ;; FORBIDDEN: a stream whose custody is durable and whose terminal never
  ;; arrived is RESUMED FROM CHUNK ZERO so it can be called complete.
  (%replace 'run-streaming-seat
            (lambda (seat-plist)
              (let* ((seat-id (seat-field seat-plist :seat))
                     (events (seat-events)))
                (if (seat-untouched-p events seat-id)
                    (funcall (defect-original 'run-streaming-seat) seat-plist)
                    (let* ((live (bind-seat-adapter seat-id))
                           (prepared (prepare-seat live seat-id)))
                      (journal-pre-frontier-records seat-id prepared)
                      (cross-frontier seat-plist)
                      (let ((handle (journal-membrane-crossing-evidence
                                     seat-id prepared live))
                            (delivered 0))
                        (journal-ap0-acknowledgment seat-id handle)
                        (observe-stream
                         handle
                         (lambda (chunk-record)
                           (incf delivered)
                           (append-event
                            *store*
                            (ap0-event (format nil "e-~a-chunk-~a" seat-id
                                               delivered)
                                       "stream-chunk" chunk-record)))
                         :chunk-count (config-policy *config*
                                                     :stream-chunk-count))
                        (journal-envelope-custody seat-id handle live)
                        (journal-usage-and-cost seat-id handle live)
                        (journal-live-projection
                         seat-id handle live (seat-field seat-plist :shape))
                        (let ((projection (seat-projection-event
                                           (seat-events) seat-id)))
                          (journal-consumption
                           seat-id
                           (projection-receipt-id-of projection))))))))))

(defun install-projection-promoted-to-truth ()
  ;; FORBIDDEN: the interpretation claims the projection's payload is
  ;; verified truth and journals NO transformation receipt binding its
  ;; input projection identity.
  (%replace 'run-interpretation-stage
            (lambda ()
              (dolist (seat-plist (config-bank *config*))
                (let* ((seat-id (seat-field seat-plist :seat))
                       (events (seat-events))
                       (projection (seat-projection-event events seat-id)))
                  (when (and projection
                             (not (seat-has-event-p events "vertical-event"
                                                    seat-id
                                                    "interpretation")))
                    (append-event
                     *store*
                     (vertical-event
                      (format nil "e-~a-interpretation" seat-id)
                      "transformation-receipt"
                      (v-rec '("vertical" "record-kind")
                             (v-id "record" "transformation-receipt")
                             '("vertical" "transformation-id")
                             (v-str (format nil "interp-~a" seat-id))
                             '("vertical" "semantic-standing")
                             (v-str "verified-semantics"))))))))))

(defun install-cost-record-without-amount ()
  ;; PLANT (not a rule change): a durable cost record whose canonical
  ;; amount is unreadable — the exact evidence the missing-is-never-zero
  ;; rule exists to refuse.
  (%replace 'journal-usage-and-cost
            (lambda (seat-id handle live)
              (let ((adapter-config (%plist-section *config* :adapter)))
                (append-event
                 *store*
                 (ap0-event (format nil "e-~a-usage" seat-id) "usage-record"
                            (extract-usage live handle
                                           (getf adapter-config
                                                 :usage-procedure))))
                (let ((cost (extract-cost live handle
                                          (getf adapter-config
                                                :cost-procedure)
                                          :price-schedule-id
                                          (getf adapter-config
                                                :price-schedule))))
                  (append-event
                   *store*
                   (ap0-event (format nil "e-~a-cost" seat-id) "cost-record"
                              (defect-strip-record-field
                                  cost "ap0" "canonical-amount"))))))))

(defun install-missing-cost-as-zero ()
  ;; FORBIDDEN: a journaled cost record with no readable canonical amount
  ;; folds as zero instead of refusing the fold.
  (%replace 'fold-durable-costs
            (lambda (store)
              (let ((total 0) (count 0))
                (dolist (event (collect-events (validated-events store)
                                               :kind "ap0-record:cost-record"))
                  (let* ((body (event-body event))
                         (amount (record-field body "ap0"
                                               "canonical-amount")))
                    (incf total (if amount
                                    (canonical-amount-rational amount)
                                    0))
                    (incf count)))
                (values total count)))))

(defvar *finalizer-only-cache* '(:label "finalizer-only-fact")
  "A finalizer-owned named cell.  The named-cell localization tooth
MAKUNBOUNDs it: any census that illicitly depends on it must then signal
UNBOUND-VARIABLE whose CELL-ERROR-NAME is exactly this symbol.")

(defun install-finalizer-only-fact-accepted ()
  ;; FORBIDDEN: the census asserts a per-seat fact that exists only in a
  ;; finalizer-owned cell, not in primary durable evidence.
  (%replace '%derive-seat-outcome
            (lambda (store events seat-id)
              (let ((outcome (funcall (defect-original '%derive-seat-outcome)
                                      store events seat-id)))
                (append outcome
                        (list :refusal
                              (or (getf *finalizer-only-cache* :label)
                                  "finalizer-only")))))))

(defun install-w1-settled-by-script ()
  ;; FORBIDDEN: the recovery settles the torn crossing from knowledge of
  ;; how the fake script behaves, without reading any class-B evidence.
  (%replace 'run-control-reconciliation
            (lambda (seat-plist)
              (let ((seat-id (seat-field seat-plist :seat)))
                (unless (seat-has-event-p (seat-events) "vertical-event"
                                          seat-id "control-outcome")
                  (append-event
                   *store*
                   (vertical-event
                    (format nil "e-~a-control-outcome" seat-id)
                    "control-outcome"
                    (v-rec '("vertical" "record-kind")
                           (v-id "record" "control-outcome")
                           '("vertical" "seat-id") (v-str seat-id)
                           '("vertical" "reconciliation-result")
                           (v-str "not-found")
                           '("vertical" "standing")
                           (v-str "settled-no-effect")
                           '("vertical" "uncertainty-records")
                           (v-str "unchanged")))))))))

;;; ---------------------------------------------------------------------------
;;; RULE-ADDITION installers.  Each invents a refusal where §12 declares a
;;; founded transition.

(defun install-deny-every-mint ()
  (%replace 'mint-seat-key
            (lambda (seat-plist query-suffix)
              (declare (ignore query-suffix))
              (%spurious "spurious-mint-denial"
                         (format nil "seat ~a: minting denied on principle"
                                 (seat-field seat-plist :seat))))))

(defun install-every-seat-poisoned ()
  (%replace 'run-seat
            (lambda (seat-plist)
              (%spurious "spurious-poisoned-seat"
                         (format nil "seat ~a: classified poisoned without ~
                                      any durable fact defeating a ~
                                      precondition"
                                 (seat-field seat-plist :seat))))))

(defun install-every-budget-exhausted ()
  (%replace 'check-budget-before-frontier
            (lambda (store seat-id estimate-lexeme ceiling-rational)
              (declare (ignore store estimate-lexeme))
              (error 'budget-ceiling-exceeded
                     :seat seat-id :ceiling ceiling-rational
                     :spent :unknown :estimate :unknown
                     :detail "budget treated as exhausted on principle"))))

(defun install-suppress-every-dispatch ()
  (%replace 'cross-frontier
            (lambda (seat-plist &key interruption)
              (declare (ignore interruption))
              (%spurious "spurious-dispatch-suppression"
                         (format nil "seat ~a: lawful dispatch suppressed"
                                 (seat-field seat-plist :seat))))))

(defun install-refuse-every-projection ()
  (%replace 'journal-live-projection
            (lambda (seat-id handle live shape)
              (declare (ignore handle live shape))
              (%spurious "spurious-projection-refusal"
                         (format nil "seat ~a: valid envelope refused ~
                                      projection" seat-id))))
  (%replace 'vertical-recovery-projection-0
            (lambda (captured-octets shape-leaf &key seat-id envelope-id
                                                     expected-sha256)
              (declare (ignore captured-octets shape-leaf envelope-id
                               expected-sha256))
              (%spurious "spurious-projection-refusal"
                         (format nil "seat ~a: captured envelope refused ~
                                      recovery projection" seat-id)))))

(defun install-refuse-every-consumption ()
  (%replace 'journal-consumption
            (lambda (seat-id projection-receipt-id)
              (declare (ignore projection-receipt-id))
              (%spurious "spurious-consumption-refusal"
                         (format nil "seat ~a: durable projection refused ~
                                      consumption" seat-id)))))

(defun install-preserve-uncertainty-despite-evidence ()
  ;; Complete admissible settlement evidence exists (a surviving,
  ;; adapter-owned world ledger); the mutant declines to use it.
  (%replace 'run-slammed-door-reconciliation
            (lambda (seat-plist &key already-structured)
              (let ((attempt (seat-attempt-name
                              (seat-field seat-plist :seat))))
                (unless already-structured
                  (declare-uncertain-effect
                   *store* attempt :process-name "vertical-campaign"))))))

(defun install-every-manifestation-unresolved ()
  (%replace '%derive-seat-outcome
            (lambda (store events seat-id)
              (declare (ignore store events))
              (list :seat seat-id :manifestation "unresolved"
                    :effect "unresolved"))))

(defun install-refuse-founded-census ()
  (%replace 'derive-census
            (lambda (store config &key (derivation-origin "in-campaign"))
              (declare (ignore store config derivation-origin))
              (%spurious "spurious-census-refusal"
                         "founded nonempty census assertion refused"))))

;;; The refusal wrapper: an abstaining campaign must be able to RUN to a
;;; census, so the gate can watch the transitions not happen rather than
;;; only watching a crash.  Installed once whenever any addition defect is
;;; active; wraps whatever RUN-SEAT is by then.
(defun install-abstention-wrapper ()
  (let ((inner (fdefinition 'run-seat)))
    (setf (fdefinition 'run-seat)
          (lambda (seat-plist)
            (handler-case (funcall inner seat-plist)
              (vertical-condition (condition)
                (journal-refusal
                 (seat-field seat-plist :seat)
                 (if (typep condition 'defect-spurious-refusal)
                     (defect-spurious-refusal-name condition)
                     (string-downcase (symbol-name (type-of condition))))
                 "planted rule-addition mutant: refusal invented where §12 ~
                  declares a founded transition")))))))

;;; ---------------------------------------------------------------------------
;;; Integration-control plants (§14).

(defun install-semantic-work-after-ready ()
  ;; FORBIDDEN: a semantic journal append AFTER the readiness marker.
  (%replace 'boundary-pause
            (lambda (seat-id boundary-name)
              (format t "BOUNDARY-READY seat=~a boundary=~a~%" seat-id
                      boundary-name)
              (finish-output)
              (append-event
               *store*
               (vertical-event (format nil "e-~a-post-ready" seat-id)
                               "post-ready-write"
                               (v-rec '("vertical" "record-kind")
                                      (v-id "record" "post-ready-write")
                                      '("vertical" "seat-id") (v-str seat-id))))
              (let ((answer (%read-stdin-line-raw)))
                (unless (equal answer "CONTINUE")
                  (vfail "boundary pause at ~a/~a: expected CONTINUE, got ~s"
                         seat-id boundary-name answer))))))

(defun install-marker-before-sync ()
  ;; FORBIDDEN: the readiness marker announces a durable fact BEFORE the
  ;; fact's append (and therefore before its fsync).
  (%replace 'run-streaming-seat
            (lambda (seat-plist)
              (let* ((seat-id (seat-field seat-plist :seat))
                     (live (bind-seat-adapter seat-id))
                     (prepared (prepare-seat live seat-id))
                     (pause-p (route-pauses-p
                               *config* :streaming
                               "STREAM-CHUNK-CUSTODY-COMMITTED")))
                (journal-pre-frontier-records seat-id prepared)
                (seat-budget-check seat-plist)
                (cross-frontier seat-plist)
                (let ((handle (journal-membrane-crossing-evidence
                               seat-id prepared live))
                      (delivered 0))
                  (journal-ap0-acknowledgment seat-id handle)
                  (observe-stream
                   handle
                   (lambda (chunk-record)
                     (incf delivered)
                     (when (and (= delivered 1) pause-p)
                       (boundary-pause seat-id
                                       "STREAM-CHUNK-CUSTODY-COMMITTED"))
                     (append-event
                      *store*
                      (ap0-event (format nil "e-~a-chunk-~a" seat-id
                                         delivered)
                                 "stream-chunk" chunk-record)))
                   :chunk-count (config-policy *config*
                                               :stream-chunk-count)))))))

(defun install-evidence-write-without-sync ()
  ;; FORBIDDEN: write-replace with close instead of fsync.
  (%replace 'write-evidence-file
            (lambda (pathname octets)
              (ensure-directories-exist pathname)
              (let* ((final (namestring pathname))
                     (tmp (concatenate 'string final ".tmp")))
                (with-open-file (stream tmp :direction :output
                                            :element-type '(unsigned-byte 8)
                                            :if-exists :supersede
                                            :if-does-not-exist :create)
                  (write-sequence octets stream))
                (sb-posix:rename tmp final)
                pathname))))

(defun install-secret-opening-without-exposure ()
  (%replace 'run-secret-opening-stage (lambda () nil)))

(defun install-narrative-promoted-to-observation ()
  ;; FORBIDDEN: the program's account of its own conduct claims origin
  ;; OBSERVED.
  (%replace 'vertical-event
            (lambda (event-name kind-leaf body-record)
              (v-rec '("event" "event-id") (v-id "vertical-event" event-name)
                     '("event" "kind") (v-id "vertical-record" kind-leaf)
                     '("event" "origin") (v-id "origin" "observed")
                     '("event" "body") body-record))))

(defun install-read-the-oracle ()
  ;; FORBIDDEN: the child opens the harness oracle artifact.  Planted so the
  ;; read-set gate can be shown to FIRE — a read-set proof that has never
  ;; caught anything is untested, not passing.
  (let ((original (fdefinition 'journal-opening-authority)))
    (setf (fdefinition 'journal-opening-authority)
          (lambda ()
            (with-open-file (stream "mneme/vertical0/VERTICAL-HARNESS-ORACLE.sexp"
                                    :direction :input
                                    :if-does-not-exist nil)
              (when stream (read-line stream nil nil)))
            (funcall original)))))

;;; ---------------------------------------------------------------------------
;;; The registry.

(defparameter +defect-registry+
  '((:unsafe-retry-allowed :omission install-unsafe-retry-allowed
     "the CAP2-W1 pre-declaration scan is bypassed and a fresh key is used
to authorize a retry into a crossed-unsettled seat")
    (:revoked-accepted :omission install-revoked-accepted
     "a REFUSED capability-revoked receipt is minted from anyway")
    (:scope-mismatch-accepted :omission install-scope-mismatch-accepted
     "a key is presented against a cell it does not name")
    (:budget-ignored :omission install-budget-ignored
     "the pre-frontier ceiling check never refuses")
    (:ack-promoted-to-settlement :omission install-ack-promoted-to-settlement
     "an acknowledgment is treated as terminal settlement and the seat is
projected with no envelope in custody")
    (:partial-promoted-complete :omission install-partial-promoted-complete
     "a partial stream is resumed from chunk zero so it can be called
complete")
    (:projection-promoted-to-truth :omission
     install-projection-promoted-to-truth
     "a projection is claimed as verified semantics with no transformation
receipt binding its input")
    (:cost-record-without-amount :plant install-cost-record-without-amount
     "PLANT: a durable cost record with no readable canonical amount")
    (:missing-cost-as-zero :omission install-missing-cost-as-zero
     "an unreadable cost folds as zero instead of refusing the fold")
    (:finalizer-only-fact-accepted :omission
     install-finalizer-only-fact-accepted
     "the census asserts a fact held only in a finalizer-owned cell")
    (:w1-settled-by-script :omission install-w1-settled-by-script
     "the torn crossing is settled from knowledge of the fake script with
no class-B evidence read")
    (:deny-every-mint :addition install-deny-every-mint
     "every fresh capability is denied")
    (:every-seat-poisoned :addition install-every-seat-poisoned
     "every seat is classified poisoned")
    (:every-budget-exhausted :addition install-every-budget-exhausted
     "every budget is treated as exhausted")
    (:suppress-every-dispatch :addition install-suppress-every-dispatch
     "every lawful dispatch is suppressed")
    (:refuse-every-projection :addition install-refuse-every-projection
     "every valid envelope is refused projection")
    (:refuse-every-consumption :addition install-refuse-every-consumption
     "every committed projection is refused consumption")
    (:preserve-uncertainty-despite-evidence :addition
     install-preserve-uncertainty-despite-evidence
     "uncertainty is preserved though complete admissible settlement
evidence survives")
    (:every-manifestation-unresolved :addition
     install-every-manifestation-unresolved
     "every founded manifestation is classified unresolved")
    (:refuse-founded-census :addition install-refuse-founded-census
     "the founded nonempty census assertion is refused")
    (:semantic-work-after-ready :control install-semantic-work-after-ready
     "CONTROL: a semantic append after the readiness marker")
    (:marker-before-sync :control install-marker-before-sync
     "CONTROL: the readiness marker precedes its own durable append")
    (:evidence-write-without-sync :control install-evidence-write-without-sync
     "CONTROL: write-replace with close instead of fsync")
    (:secret-opening-without-exposure :control
     install-secret-opening-without-exposure
     "CONTROL: a declared secret opening journals no exposure record")
    (:narrative-promoted-to-observation :control
     install-narrative-promoted-to-observation
     "CONTROL: the program's own narrative claims origin OBSERVED")
    (:read-the-oracle :control install-read-the-oracle
     "CONTROL: the child opens the harness oracle artifact"))
  "Every planted defect: (NAME CLASS INSTALLER DESCRIPTION).")

(defun defect-entry (name)
  (or (find name +defect-registry+ :key #'first)
      (error "defects: no such planted defect ~s" name)))

(defun defect-class (name) (second (defect-entry name)))

(defun defects-of-class (class)
  (loop for entry in +defect-registry+
        when (eq class (second entry)) collect (first entry)))

(defun install-defects (names)
  "Install every named defect, then the abstention wrapper if any
rule-addition defect is among them.  Returns the installed list."
  (dolist (name names)
    (funcall (third (defect-entry name)))
    (pushnew name *active-defects*))
  (when (some (lambda (name) (eq :addition (defect-class name))) names)
    (install-abstention-wrapper))
  *active-defects*)

(defun parse-defect-names (string)
  "Comma-separated defect names (case-insensitive) -> keywords.  An empty
or absent string is the STRICT arm: no defect at all."
  (when (and string (plusp (length string)))
    (let ((names '()) (start 0))
      (loop for comma = (position #\, string :start start)
            do (let ((token (string-trim " " (subseq string start comma))))
                 (when (plusp (length token))
                   (push (intern (string-upcase token) :keyword) names)))
               (if comma (setf start (1+ comma)) (return)))
      (nreverse names))))
