;;;; surface2-selftest.lisp — Language Surface /2, the POSITIVE direction:
;;;; every pattern class matches and RUNS its body on lawful fixtures.
;;;; Universal refusal is not ergonomic conformance (contract §6).
;;;;
;;;; Run:  sbcl --script mneme/language-surface-2/surface2-selftest.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; Fixtures: the preserved campaign-1 execution directory
;;;; (mneme/vertical0/runs/campaign-1/exec/), READ-ONLY — nothing here
;;;; appends, and the journal file's digest is compared before/after.
;;;;
;;;; DETERMINISM: nothing time-, pid-, or path-dependent is printed.
;;;; Gate teeth: SURFACE2_SELFTEST_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; SURFACE2_SELFTEST_DIE=1 exits 3 mid-run, no RESULT sentinel.
;;;;
;;;; — GLOSSATOR (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "surface2.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:surface2-selftest
  (:use #:cl #:lisp-plus-surface2))
(in-package #:surface2-selftest)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[S~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[S~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "surface2-selftest — outcomes keep their axes, positive direction")

;;; ---------------------------------------------------------------------------
(note "~%== the fixtures: campaign-1, read-only ==")

(defvar *root* (merge-pathnames "../../" (make-pathname
                                          :name nil :type nil
                                          :defaults *load-truename*)))
(defvar *exec* (merge-pathnames "mneme/vertical0/runs/campaign-1/exec/" *root*))

(defun file-sha256 (pathname)
  (with-open-file (s pathname :element-type '(unsigned-byte 8))
    (let ((octets (make-array (file-length s)
                              :element-type '(unsigned-byte 8))))
      (read-sequence octets s)
      (lisp-plus-journal0:sha256-hex octets))))

(defvar *journal-digest-before*
  (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))

(defvar *store* (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" *exec*)))
(defvar *events* (validated-store-events *store*))

(check "1 the validated prefix carries the campaign's events"
  (lambda () (> (length *events*) 100)))

;;; The twelve seats, in declared bank order, with the census truth as
;;; carried by the preserved run artifacts (RUN-RECONSTRUCTION.txt and the
;;; journaled census record) — quoted here as the expected facet table.
(defvar *seat-truth*
  ;; seat-id                 class          execution             manifestation     effect                              provenance         interp
  '(("seat-first-fruit"      :projection    :settled              "present"         "settled"                           :live              "present")
    ("seat-empty-page"       :projection    :settled              "present-empty"   "settled"                           :live              "empty")
    ("seat-locked-purse"     :refusal       :absent               "absent"          nil                                 :none              :not-interpreted)
    ("seat-torn-crossing"    :uncertain     :uncertain-unresolved "absent"          "uncertain-unresolved"              :none              :not-interpreted)
    ("seat-half-song"        :closure       :settled              "present-partial" "crossed-unsettled-partial-closed"  :none              :not-interpreted)
    ("seat-broken-glass"     :projection    :settled              "present-invalid" "settled"                           :live              "invalid")
    ("seat-dead-hand"        :refusal       :absent               "absent"          nil                                 :none              :not-interpreted)
    ("seat-slammed-door"     :reconciled    :reconciled           "absent"          "reconciled-not-applied"            :none              :not-interpreted)
    ("seat-burned-draft"     :projection    :settled              "absent"          "settled"                           :live              "absent-mapped")
    ("seat-sealed-letter"    :projection    :settled              "present"         "settled"                           :derived-recovery  "present")
    ("seat-cold-supper"      :projection    :settled              "present"         "settled"                           :live              "present")
    ("seat-late-riser"       :projection    :settled              "present"         "settled"                           :live              "present")))

(defvar *outcomes*
  (loop for row in *seat-truth*
        collect (derive-seat-outcome *store* *events* (first row))))

(check "2 all twelve seats derive to SEAT-OUTCOME objects"
  (lambda () (and (= 12 (length *outcomes*))
                  (every #'seat-outcome-p *outcomes*))))

;;; ---------------------------------------------------------------------------
(note "~%== every facet reader answers (values VALUE STANDING) on every seat ==")

(defvar *three-states* '(:present :absent-from-evidence :malformed-in-evidence))

(check "3 every facet reader on every seat returns a lawful standing"
  (lambda ()
    (every
     (lambda (o)
       (every (lambda (reader)
                (multiple-value-bind (v s) (funcall reader o)
                  (declare (ignore v))
                  (member s *three-states*)))
              (list #'seat-outcome-seat-id #'seat-outcome-attempt-name
                    #'seat-outcome-execution-standing
                    #'seat-outcome-execution-evidence
                    #'seat-outcome-manifestation
                    #'seat-outcome-no-payload-state
                    #'seat-outcome-provenance #'seat-outcome-effect
                    #'seat-outcome-chunks-preserved #'seat-outcome-refusal
                    #'seat-outcome-interpretation-class
                    #'seat-outcome-evidence-class
                    #'seat-outcome-source-events)))
     *outcomes*)))

(check "4 evidence class, execution standing, manifestation, effect, ~
        provenance and interpretation agree with the campaign-1 truth ~
        on all twelve seats"
  (lambda ()
    (every
     (lambda (row o)
       (destructuring-bind (sid class execution manifestation effect
                            provenance interp) row
         (and (equal sid (seat-outcome-seat-id o))
              (eq class (seat-outcome-evidence-class o))
              (eq execution (seat-outcome-execution-standing o))
              (equal manifestation (nth-value 0 (seat-outcome-manifestation o)))
              (equal effect (nth-value 0 (seat-outcome-effect o)))
              (eq provenance (seat-outcome-provenance o))
              (equal interp (nth-value 0 (seat-outcome-interpretation-class o))))))
     *seat-truth* *outcomes*)))

(check "5 the attempt name is derived once and carried as a value"
  (lambda ()
    (every (lambda (o) (equal (format nil "a-~a" (seat-outcome-seat-id o))
                              (seat-outcome-attempt-name o)))
           *outcomes*)))

(check "6 the cap2 evidence plist is RETAINED: every :settled seat still ~
        holds its settled event; the reconciled seat holds its ~
        reconciliation event"
  (lambda ()
    (every (lambda (o)
             (let ((details (seat-outcome-execution-evidence o)))
               (case (seat-outcome-execution-standing o)
                 (:settled (not (null (getf details :settled))))
                 (:reconciled (not (null (getf details :reconciled))))
                 (:uncertain-unresolved (not (null (getf details :uncertain))))
                 (t (listp details)))))
           *outcomes*)))

(check "7 typed absence, measured against real evidence: ~
        seat-burned-draft's no-payload-state is :PRESENT ~
        \"absent-after-completion\"; seat-first-fruit's field is a CD/0 ~
        UNIT — :PRESENT :DECLARED-NONE, the writer's explicit none; ~
        seat-locked-purse (no projection at all) is ~
        :ABSENT-FROM-EVIDENCE.  BODY-STRING answers NIL to all three; ~
        this surface does not"
  (lambda ()
    (let ((fruit (first *outcomes*))
          (purse (third *outcomes*))
          (draft (ninth *outcomes*)))
      (and (multiple-value-bind (v s) (seat-outcome-no-payload-state draft)
             (and (equal v "absent-after-completion") (eq s :present)))
           (multiple-value-bind (v s) (seat-outcome-no-payload-state fruit)
             (and (eq v :declared-none) (eq s :present)))
           (multiple-value-bind (v s) (seat-outcome-no-payload-state purse)
             (and (null v) (eq s :absent-from-evidence)))))))

(check "8 provenance is a SLOT, never an (or ...): seat-sealed-letter ~
        answers :DERIVED-RECOVERY, seat-cold-supper answers :LIVE"
  (lambda ()
    (and (eq :derived-recovery (seat-outcome-provenance (tenth *outcomes*)))
         (eq :live (seat-outcome-provenance (nth 10 *outcomes*))))))

(check "9 the retained refusal keeps type and explanation DISTINCT on ~
        seat-locked-purse and seat-dead-hand"
  (lambda ()
    (every (lambda (index name)
             (multiple-value-bind (desc s)
                 (seat-outcome-refusal (nth index *outcomes*))
               (and (eq s :present)
                    (refusal-description-p desc)
                    (equal name (refusal-description-condition-name desc))
                    (stringp (refusal-description-explanation desc))
                    (not (equal (refusal-description-condition-name desc)
                                (refusal-description-explanation desc))))))
           '(2 6) '("budget-ceiling-exceeded" "capability-revoked"))))

(check "10 chunk custody: seat-half-song reads 1 :PRESENT; a seat with no ~
        stream reads :NOT-APPLICABLE, typed, never NIL"
  (lambda ()
    (and (multiple-value-bind (v s) (seat-outcome-chunks-preserved
                                     (fifth *outcomes*))
           (and (eql 1 v) (eq s :present)))
         (multiple-value-bind (v s) (seat-outcome-chunks-preserved
                                     (first *outcomes*))
           (and (eq :not-applicable v) (eq s :present))))))

(check "11 the witness is retained: every seat's SOURCE-EVENTS lists the ~
        events its derivation consulted"
  (lambda ()
    (every (lambda (o)
             (let ((consulted (seat-outcome-source-events o)))
               (ecase (seat-outcome-evidence-class o)
                 (:refusal (assoc :refusal consulted))
                 (:closure (assoc :stream-closure consulted))
                 (:projection (or (assoc :live-projection consulted)
                                  (assoc :recovery-projection consulted)))
                 ((:uncertain :reconciled) (listp consulted)))))
           *outcomes*)))

;;; ---------------------------------------------------------------------------
(note "~%== WITH-OUTCOME: the whole object, bound ==")

(check "12 WITH-OUTCOME binds the complete outcome and the body reads any ~
        axis it likes"
  (lambda ()
    (equal '("seat-half-song" :settled "present-partial" 1)
           (with-outcome (o (derive-seat-outcome *store* *events*
                                                 "seat-half-song"))
             (list (seat-outcome-seat-id o)
                   (seat-outcome-execution-standing o)
                   (nth-value 0 (seat-outcome-manifestation o))
                   (nth-value 0 (seat-outcome-chunks-preserved o)))))))

;;; ---------------------------------------------------------------------------
(note "~%== MATCH-OUTCOME: every pattern class matches and RUNS its body ~
       across all twelve campaign seats ==")

(defvar *clause-hits* (make-hash-table :test #'eq))

(defun tally (key result) (incf (gethash key *clause-hits* 0)) result)

(defun dispatch-seat (o)
  "Every pattern class in the closed grammar, exercised: single keyword
axes, string axes, integer axis, refusal-name and refusal-presence,
interpretation, chunk custody, conjunction, facet destructuring, and
OTHERWISE — with the parent outcome consulted in EVERY body."
  (match-outcome o
    ;; refusal by NAME (string-designator pattern class)
    ((:refusal budget-ceiling-exceeded)
     (tally :refusal-budget (list :refused (seat-outcome-seat-id o))))
    ;; refusal by PRESENCE
    ((:refusal :retained) :facets ((desc :refusal))
     (tally :refusal-other (list :refused (seat-outcome-seat-id o)
                                 (refusal-description-condition-name desc))))
    ;; conjunction + integer axis + facet destructuring
    ((:and (:evidence-class :closure) (:chunks-preserved 1))
     :facets ((chunks :chunks-preserved))
     (tally :closure (list :closed (seat-outcome-seat-id o) chunks)))
    ;; conjunction expressing the settled projection, split by provenance
    ((:and (:evidence-class :projection) (:execution :settled)
           (:provenance :derived-recovery))
     (tally :projection-recovery
            (list :settled-recovery (seat-outcome-seat-id o))))
    ;; string-value axis on manifestation + interpretation string axis
    ((:and (:manifestation "present-invalid") (:interpretation "invalid"))
     (tally :invalid (list :invalid-kept (seat-outcome-seat-id o))))
    ;; no-payload-state string axis
    ((:no-payload-state "absent-after-completion")
     (tally :absent-after (list :absent-after (seat-outcome-seat-id o))))
    ;; execution keyword axis
    ((:execution :uncertain-unresolved)
     (tally :uncertain (list :uncertain (seat-outcome-seat-id o))))
    ((:execution :reconciled)
     (tally :reconciled (list :reconciled (seat-outcome-seat-id o)
                              (nth-value 0 (seat-outcome-effect o)))))
    ;; the remaining settled projections
    ((:and (:evidence-class :projection) (:execution :settled))
     (tally :projection (list :settled (seat-outcome-seat-id o))))
    (otherwise
     (tally :otherwise (list :unmatched (seat-outcome-seat-id o))))))

(defvar *dispatches* (mapcar #'dispatch-seat *outcomes*))

(check "13 all twelve seats dispatched and every body consulted the ~
        parent outcome (each result carries the seat id read from it)"
  (lambda ()
    (every (lambda (row result)
             (member (first row) (rest result) :test #'equal))
           *seat-truth* *dispatches*)))

(check "14 every clause of the dispatch was exercised at least once ~
        (nine clause keys)"
  (lambda ()
    (every (lambda (key) (>= (gethash key *clause-hits* 0) 1))
           '(:refusal-budget :refusal-other :closure :projection-recovery
             :invalid :absent-after :uncertain :reconciled :projection))))

(check "15 OTHERWISE runs as a real clause and receives the WHOLE outcome ~
        (a projection seat reaching OTHERWISE can still read its axes)"
  (lambda ()
    (let ((o (first *outcomes*)))
      (equal '(:fell-through "seat-first-fruit" :settled :live)
             (match-outcome o
               ((:evidence-class :refusal) :never)
               (otherwise
                (list :fell-through (seat-outcome-seat-id o)
                      (seat-outcome-execution-standing o)
                      (seat-outcome-provenance o))))))))

(check "16 MATCH-OUTCOME with a bound variable name works over ~
        WITH-OUTCOME (the two forms compose)"
  (lambda ()
    (equal '(:torn "seat-torn-crossing" :uncertain-unresolved)
           (with-outcome (o (derive-seat-outcome *store* *events*
                                                 "seat-torn-crossing"))
             (match-outcome o
               ((:and (:execution :uncertain-unresolved)
                      (:manifestation "absent"))
                (list :torn (seat-outcome-seat-id o)
                      (seat-outcome-execution-standing o)))
               (otherwise :wrong))))))

;;; ---------------------------------------------------------------------------
(note "~%== the discipline: doors, receipts, versions ==")

(defvar *tag* (lisp-plus-journal0:identifier-from-segments
               '("surface2-selftest" "occurrence" "t1")))

(check "17 the construct table has exactly the two declared rows"
  (lambda ()
    (equal '(("LISP-PLUS-SURFACE2" "WITH-OUTCOME")
             ("LISP-PLUS-SURFACE2" "MATCH-OUTCOME"))
           (known-surface2-constructs))))

(check "18 grammar, procedure and policy versions all read 1"
  (lambda ()
    (and (= 1 (surface2-grammar-version))
         (= 1 (surface2-procedure-version))
         (= 1 (surface2-policy-version)))))

(check "19 the refusal catalogue is split — protocol refusals and ~
        integrity alarms, never flattened — and the contract's named ~
        codes are all catalogued"
  (lambda ()
    (let ((protocol (surface2-protocol-refusal-codes))
          (alarms (surface2-integrity-alarm-codes)))
      (and (null (intersection protocol alarms))
           (every (lambda (code) (member code protocol))
                  '(:non-exhaustive-match :duplicate-pattern
                    :unreachable-pattern :source-form-not-a-call
                    :not-a-known-surface2-construct
                    :occurrence-tag-not-identifier))
           (every (lambda (code) (member code alarms))
                  '(:receipt-not-minted
                    :source-identity-projection-mismatch
                    :expanded-identity-projection-mismatch
                    :projection-without-settled-execution
                    :no-evidence-class))))))

(defvar *match-form*
  '(lisp-plus-surface2:match-outcome o
    ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id o))
    (otherwise o)))

(defvar *with-form*
  '(lisp-plus-surface2:with-outcome (o (identity o2)) o))

(defvar *match-request* nil)

(check "20 DOOR 1 mints an immutable request carrying the construct ~
        identity and the three governing versions as VALUES"
  (lambda ()
    (setf *match-request* (request-expansion *match-form* :macroexpand-1 *tag*))
    (and (expansion-request-p *match-request*)
         (expansion-request-construct-identity *match-request*)
         (= 1 (expansion-request-grammar-version *match-request*))
         (= 1 (expansion-request-procedure-version *match-request*))
         (= 1 (expansion-request-policy-version *match-request*)))))

(check "21 the stored source datum decodes back to a tree that re-encodes ~
        to the same canonical octets (the account names the form)"
  (lambda ()
    (let ((datum (expansion-request-source-form-datum *match-request*)))
      (lisp-plus-cd0:equal-datum
       datum (encode-term2 (decode-term2 datum))))))

(defvar *match-receipt* nil)
(defvar *match-expanded* nil)

(check "22 DOOR 2 performs the MATCH-OUTCOME expansion and mints a receipt"
  (lambda ()
    (multiple-value-bind (receipt expanded occurrence)
        (perform-expansion *match-request*)
      (setf *match-receipt* receipt *match-expanded* expanded)
      (and (expansion-receipt-p receipt)
           (expansion-occurrence-p occurrence)
           (consp expanded)))))

(check "23 the receipt's digest identities re-derive from its stored data ~
        (VERIFY-RECEIPT green), and the receipt stores the minting ~
        versions as values"
  (lambda ()
    (and (verify-receipt *match-receipt*)
         (= 1 (expansion-receipt-grammar-version *match-receipt*))
         (= 1 (expansion-receipt-procedure-version *match-receipt*))
         (= 1 (expansion-receipt-policy-version *match-receipt*)))))

(check "24 the accounted expansion IS the expansion this image performs: ~
        ENCODE-TERM2 of a direct MACROEXPAND-1 equals the receipt's ~
        expanded datum, byte for byte"
  (lambda ()
    (lisp-plus-cd0:equal-datum
     (expansion-receipt-expanded-form-datum *match-receipt*)
     (encode-term2 (macroexpand-1 *match-form* nil)))))

(check "25 disposition names the operation's shape: :MACROEXPAND-1 -> ~
        \"expanded-once\""
  (lambda ()
    (equal "expanded-once" (expansion-receipt-disposition *match-receipt*))))

(check "26 WITH-OUTCOME goes through the same doors: request, perform, ~
        receipt, digests re-derive"
  (lambda ()
    (let ((request (request-expansion *with-form* :macroexpand *tag*)))
      (multiple-value-bind (receipt expanded) (perform-expansion request)
        (and (expansion-receipt-p receipt)
             (verify-receipt receipt)
             (equal "expanded-to-fixpoint"
                    (expansion-receipt-disposition receipt))
             (consp expanded))))))

(check "27 the TRY- twins answer (REQUEST NIL) / (RECEIPT EXPANDED NIL) ~
        on the completing path"
  (lambda ()
    (multiple-value-bind (request refusal)
        (try-request-expansion *match-form* :macroexpand-1 *tag*)
      (and request (null refusal)
           (multiple-value-bind (receipt expanded try-refusal)
               (try-perform-expansion request)
             (and receipt (consp expanded) (null try-refusal)))))))

(check "28 receipts and refusals carry identity OCTETS (comparable, ~
        diagnosable, never a content address)"
  (lambda ()
    (and (plusp (identity-octets (expansion-receipt-identity *match-receipt*)))
         (stringp (render-identity-hex
                   (expansion-receipt-identity *match-receipt*))))))

;;; ---------------------------------------------------------------------------
(note "~%== read-only proof ==")

(check "29 the campaign-1 journal's bytes are untouched by everything above"
  (lambda ()
    (equal *journal-digest-before*
           (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "SURFACE2_SELFTEST_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "SURFACE2_SELFTEST_DIE") "1")
  (note "SURFACE2_SELFTEST_DIE=1 — dying mid-run WITHOUT a RESULT ~
         sentinel (planted truncation)")
  (sb-ext:exit :code 3))

;;; ---------------------------------------------------------------------------

(format t "~%surface2-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
