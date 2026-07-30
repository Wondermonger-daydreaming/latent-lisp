;;;; capability0-selftest.lisp — unit teeth for Capability /0.
;;;;
;;;; Run:  sbcl --script mneme/capability0/capability0-selftest.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: fixed store nonces (declared PJ-META-1 deviation, exactly
;;;; as journal0's specimen declared it: the stores are test fixtures, never
;;;; production identities); no timestamps, pids, or absolute paths printed.
;;;; Two runs produce byte-identical transcripts.
;;;;
;;;; GATE TEETH (the journal0 §28 discipline, applied to this runner
;;;; itself): CAP0_SELFTEST_PLANT_FAULT=1 plants one deliberately false
;;;; check; the runner spawns itself once under that variable and asserts
;;;; the planted fault FIRES (exit 1 + the FAIL line).  A selftest that has
;;;; never been seen to fail is untested.
;;;;
;;;; — CLAVIGER (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-capability0)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery — counts derived from verdicts rendered.

(defvar *checks* 0)
(defvar *failures* 0)

(defun tcheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun tnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(defmacro expects (condition-type &body body)
  `(handler-case (progn ,@body nil)
     (,condition-type () t)
     (error () nil)))

(defun t-read-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun t-ascii (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun t-octets-string (octets)
  (map 'string #'code-char octets))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defvar *scratch* #p"mneme/capability0/scratch-selftest/")
(fresh-directory *scratch*)

(tnote "capability0-selftest — unit teeth")
(tnote "governing sentence: history may prove that authority once existed; ~
        only the validated present prefix can say whether it remains live.~%")

;;; ---------------------------------------------------------------------------
;;; 1. Exact canonical equality.

(tcheck "datum= is exact canonical CD/0 equality: same segments equal, ~
         different segments differ, and NIL is never equal to anything"
  (lambda ()
    (and (datum= (identifier-from-segments '("cap" "clavis"))
                 (identifier-from-segments '("cap" "clavis")))
         (not (datum= (identifier-from-segments '("cap" "clavis"))
                      (identifier-from-segments '("cap" "sigillum"))))
         (not (datum= nil (identifier-from-segments '("cap" "clavis"))))
         (not (datum= (identifier-from-segments '("cap" "clavis")) nil)))))

(tcheck "segment aliasing is DISTINCT under datum=: (id \"a:b\") and ~
         (id \"a\" \"b\") are different identities (canonical encodings ~
         differ; the equality is CD/0's, not a joined-string's)"
  (lambda ()
    (not (datum= (identifier-from-segments '("a:b"))
                 (identifier-from-segments '("a" "b"))))))

(tcheck "ensure-identifier accepts an identifier datum unchanged and a ~
         segment list by construction; refuses a bare string with ~
         cap0-malformed-authority-event"
  (lambda ()
    (let ((datum (identifier-from-segments '("cap" "clavis"))))
      (and (eq (ensure-identifier datum) datum)
           (datum= (ensure-identifier '("cap" "clavis")) datum)
           (expects cap0-malformed-authority-event
             (ensure-identifier "cap:clavis"))))))

;;; ---------------------------------------------------------------------------
;;; 2. Bootstrap authority — explicit, checked, never smuggled.

(defvar *issuer-segments* '("cap0-issuer" "radix"))

(tcheck "declare-bootstrap-authority builds an explicit bootstrap value; a ~
         non-string store binding is refused (cap0-bootstrap-missing)"
  (lambda ()
    (let ((bootstrap (declare-bootstrap-authority *issuer-segments*
                                                  "pj0-store:feed")))
      (and (bootstrap-authority-p bootstrap)
           (datum= (bootstrap-authority-issuer bootstrap)
                   (identifier-from-segments *issuer-segments*))
           (string= (bootstrap-authority-store-id bootstrap)
                    "pj0-store:feed")
           (expects cap0-bootstrap-missing
             (declare-bootstrap-authority *issuer-segments* 42))))))

;;; ---------------------------------------------------------------------------
;;; 3. Event constructors.

(defun test-grant (&key (event-id '("cap0-event" "g-001"))
                        (capability-id '("cap" "clavis"))
                        (subject '("subj" "tardigrada"))
                        (action '("act" "aperire"))
                        (resource '("res" "arca-prima"))
                        (scope '("scope" "exact"))
                        (issuer *issuer-segments*))
  (make-grant-event :event-id event-id :capability-id capability-id
                    :subject subject :action action :resource resource
                    :scope scope :issuer issuer))

(defun test-revocation (&key (event-id '("cap0-event" "r-001"))
                             (capability-id '("cap" "clavis"))
                             (issuer *issuer-segments*))
  (make-revocation-event :event-id event-id :capability-id capability-id
                         :issuer issuer))

(tcheck "make-grant-event carries kind capability0:granted, its event ~
         identity, and all six capability terms; construction is ~
         deterministic (two constructions encode byte-identically)"
  (lambda ()
    (let ((grant (test-grant)))
      (and (string= "capability0:granted"
                    (identifier-segment-string
                     (record-field grant "event" "kind")))
           (datum= (record-field grant "event" "event-id")
                   (identifier-from-segments '("cap0-event" "g-001")))
           (datum= (record-field grant "capability" "capability-id")
                   (identifier-from-segments '("cap" "clavis")))
           (datum= (record-field grant "capability" "issuer")
                   (identifier-from-segments *issuer-segments*))
           (equalp (encode-pjs0 grant) (encode-pjs0 (test-grant)))))))

(tcheck "make-revocation-event carries kind capability0:revoked and the ~
         exact target capability identity"
  (lambda ()
    (let ((revocation (test-revocation)))
      (and (string= "capability0:revoked"
                    (identifier-segment-string
                     (record-field revocation "event" "kind")))
           (datum= (record-field revocation "revocation" "capability-id")
                   (identifier-from-segments '("cap" "clavis")))))))

(tcheck "a constructor missing a required term refuses with ~
         cap0-malformed-authority-event (nothing half-built)"
  (lambda ()
    (expects cap0-malformed-authority-event
      (make-grant-event :event-id '("cap0-event" "g-bad")
                        :capability-id '("cap" "clavis")
                        :subject '("subj" "tardigrada")
                        ;; :action omitted
                        :resource '("res" "arca-prima")
                        :scope '("scope" "exact")
                        :issuer *issuer-segments*))))

;;; ---------------------------------------------------------------------------
;;; 4. A small living store for the fold/query/receipt units.

(defvar *store-a-directory* (merge-pathnames "store-a/" *scratch*))
(defvar *store-a*
  (create-journal *store-a-directory*
                  :nonce-octets (t-ascii "cap0-selftest-a!")))
(defvar *bootstrap-a*
  (declare-bootstrap-authority *issuer-segments*
                               (journal-store-store-id *store-a*)))

(tcheck "an empty journal folds to an empty ledger under the explicit ~
         bootstrap (no record invented from nothing)"
  (lambda ()
    (let ((ledger (derive-authority-ledger *store-a* *bootstrap-a*)))
      (and (authority-ledger-p ledger)
           (null (authority-ledger-records ledger))
           (string= (authority-ledger-store-id ledger)
                    (journal-store-store-id *store-a*))))))

(tcheck "the fold REFUSES to derive without an explicit bootstrap: NIL ~
         signals cap0-bootstrap-missing; a bootstrap bound to another store ~
         identity signals cap0-bootstrap-store-mismatch carrying expected ~
         and actual"
  (lambda ()
    (and (expects cap0-bootstrap-missing
           (derive-authority-ledger *store-a* nil))
         (handler-case
             (progn (derive-authority-ledger
                     *store-a*
                     (declare-bootstrap-authority *issuer-segments*
                                                  "pj0-store:0000"))
                    nil)
           (cap0-bootstrap-store-mismatch (condition)
             (and (string= (cap0-bootstrap-store-mismatch-expected condition)
                           "pj0-store:0000")
                  (string= (cap0-bootstrap-store-mismatch-actual condition)
                           (journal-store-store-id *store-a*))))))))

(append-event *store-a* (test-grant))

(tcheck "after one committed grant the fold yields one record with the ~
         grant's exact terms, grant ordinal 1, and NO revocation"
  (lambda ()
    (multiple-value-bind (record ledger)
        (capability-history *store-a* *bootstrap-a* '("cap" "clavis"))
      (and record
           (= 1 (length (authority-ledger-records ledger)))
           (eql 1 (capability-record-grant-ordinal record))
           (datum= (capability-record-grant-event-id record)
                   (identifier-from-segments '("cap0-event" "g-001")))
           (datum= (capability-record-subject record)
                   (identifier-from-segments '("subj" "tardigrada")))
           (null (capability-record-revocation-ordinal record))
           (null (capability-record-dispositions record))))))

(tcheck "a committed capability0-kind event MISSING a required field makes ~
         the fold refuse with cap0-malformed-authority-event naming ordinal ~
         and field — the fold never guesses what an event meant"
  (lambda ()
    (let* ((directory (merge-pathnames "store-malformed/" *scratch*))
           (store (create-journal directory
                                  :nonce-octets (t-ascii "cap0-selftest-b!")))
           (bootstrap (declare-bootstrap-authority
                       *issuer-segments* (journal-store-store-id store)))
           ;; raw record built beside the constructors, on purpose.
           (event (lisp-plus-cd0:make-record-datum
                   (list (lisp-plus-cd0:make-record-entry
                          (identifier-from-segments '("event" "event-id"))
                          (identifier-from-segments '("cap0-event" "g-mal")))
                         (lisp-plus-cd0:make-record-entry
                          (identifier-from-segments '("event" "kind"))
                          (identifier-from-segments
                           '("capability0" "granted")))))))
      (append-event store event)
      (handler-case (progn (derive-authority-ledger store bootstrap) nil)
        (cap0-malformed-authority-event (condition)
          (and (eql 1 (cap0-malformed-authority-event-ordinal condition))
               (string= "capability:capability-id"
                        (cap0-malformed-authority-event-missing-field
                         condition))))))))

(tcheck "a committed grant whose issuer the declared bootstrap does not ~
         ground makes the fold refuse with kernel0's ~
         MINTING-AUTHORITY-INVALID (offending-field \"issuer\")"
  (lambda ()
    (handler-case
        (progn (derive-authority-ledger
                *store-a*
                (declare-bootstrap-authority '("cap0-issuer" "usurpator")
                                             (journal-store-store-id
                                              *store-a*)))
               nil)
      (lisp-plus-kernel0:minting-authority-invalid (condition)
        (and (string= "issuer"
                      (lisp-plus-kernel0:kernel0-condition-offending-field
                       condition))
             (string= "cap0-issuer:radix"
                      (lisp-plus-kernel0:kernel0-condition-offending-value
                       condition)))))))

;;; ---------------------------------------------------------------------------
;;; 5. Receipts.

(defun q (query-name &rest overrides)
  (apply #'query-live-authority *store-a* *bootstrap-a*
         :query-id (list "cap0-query" query-name)
         (append overrides
                 (list :capability-id '("cap" "clavis")
                       :subject '("subj" "tardigrada")
                       :action '("act" "aperire")
                       :resource '("res" "arca-prima")
                       :scope '("scope" "exact")))))

(tcheck "an authorized receipt binds to the EXACT validated prefix: ~
         store-id, terminal ordinal, valid byte count, and terminal digest ~
         all equal the fresh prefix-report's values"
  (lambda ()
    (let ((receipt (q "q-bind"))
          (report (validate-journal *store-a*)))
      (and (eq :authorized (receipt-decision receipt))
           (string= "grant-live-at-validated-prefix"
                    (receipt-reason receipt))
           (receipt-current-p receipt report
                              :store-id (journal-store-store-id
                                         *store-a*))))))

(tcheck "receipt carries procedure identity and version, the query ~
         identity, the capability identity, and the grant event identity"
  (lambda ()
    (let ((receipt (q "q-fields")))
      (and (string= "lisp-plus-capability0:query-live-authority"
                    (identifier-segment-string
                     (record-field receipt "receipt" "procedure-id")))
           (= 0 (lisp-plus-cd0:integer-datum-value
                 (record-field receipt "receipt" "procedure-version")))
           (datum= (record-field receipt "receipt" "query-id")
                   (identifier-from-segments '("cap0-query" "q-fields")))
           (datum= (record-field receipt "receipt" "capability-id")
                   (identifier-from-segments '("cap" "clavis")))
           (datum= (record-field receipt "receipt" "grant-event-id")
                   (identifier-from-segments '("cap0-event" "g-001")))))))

(tcheck "receipt construction is deterministic: two queries at the same ~
         prefix with the same terms encode BYTE-IDENTICALLY"
  (lambda ()
    (equalp (encode-pjs0 (q "q-det")) (encode-pjs0 (q "q-det")))))

(tcheck "a receipt survives the canonical codec: decode-pjs0 of its ~
         encoding reads back the same decision, reason, and binding"
  (lambda ()
    (let* ((receipt (q "q-codec"))
           (decoded (decode-pjs0 (encode-pjs0 receipt))))
      (and decoded
           (eq :authorized (receipt-decision decoded))
           (string= (receipt-reason receipt) (receipt-reason decoded))
           (equalp (encode-pjs0 receipt) (encode-pjs0 decoded))))))

(tcheck "the origin facet is a CLOSED set: :live-query and :reconstructed ~
         render as themselves, :observed is REFUSED IN CODE (the ecase has ~
         no such member — law L10 enforced, not remembered), and no receipt ~
         byte sequence contains \"observed\""
  (lambda ()
    (let ((live (q "q-live"))
          (reconstructed (q "q-reco" :origin :reconstructed)))
      (and (string= "origin:live-query"
                    (identifier-segment-string
                     (record-field live "receipt" "origin")))
           (string= "origin:reconstructed"
                    (identifier-segment-string
                     (record-field reconstructed "receipt" "origin")))
           (null (search "observed" (t-octets-string (encode-pjs0 live))))
           (null (search "observed"
                         (t-octets-string (encode-pjs0 reconstructed))))
           (expects type-error (q "q-obs" :origin :observed))))))

(tcheck "receipt-current-p DETECTS a stale binding and names the facets: ~
         after one further committed event, a receipt from the earlier ~
         prefix mismatches on terminal-ordinal, valid-byte-count, and ~
         terminal-digest (store-id still agrees)"
  (lambda ()
    (let ((old-receipt (q "q-stale")))
      (append-event *store-a*
                    (lisp-plus-cd0:make-record-datum
                     (list (lisp-plus-cd0:make-record-entry
                            (identifier-from-segments '("event" "event-id"))
                            (identifier-from-segments '("cap0-event" "u-001")))
                           (lisp-plus-cd0:make-record-entry
                            (identifier-from-segments '("event" "kind"))
                            (identifier-from-segments
                             '("de-potestate" "noted"))))))
      (multiple-value-bind (currentp mismatches)
          (receipt-current-p old-receipt (validate-journal *store-a*)
                             :store-id (journal-store-store-id *store-a*))
        (and (not currentp)
             (equal mismatches '("terminal-ordinal" "valid-byte-count"
                                 "terminal-digest")))))))

;;; ---------------------------------------------------------------------------
;;; 6. require-live-authority — kernel0's own condition types, fired.

(tcheck "require-live-authority returns the receipt when authority is live"
  (lambda ()
    (eq :authorized
        (receipt-decision
         (require-live-authority *store-a* *bootstrap-a*
                                 :capability-id '("cap" "clavis")
                                 :subject '("subj" "tardigrada")
                                 :action '("act" "aperire")
                                 :resource '("res" "arca-prima")
                                 :scope '("scope" "exact")
                                 :query-id '("cap0-query" "q-req"))))))

(tcheck "an unknown capability identity escalates to kernel0's ~
         CAPABILITY-MISSING (the exact exported type)"
  (lambda ()
    (expects lisp-plus-kernel0:capability-missing
      (require-live-authority *store-a* *bootstrap-a*
                              :capability-id '("cap" "ignotum")
                              :subject '("subj" "tardigrada")
                              :action '("act" "aperire")
                              :resource '("res" "arca-prima")
                              :scope '("scope" "exact")
                              :query-id '("cap0-query" "q-missing")))))

(tcheck "a term mismatch escalates to kernel0's CAPABILITY-SCOPE-MISMATCH ~
         with offending-field naming the mismatched term (\"subject\")"
  (lambda ()
    (handler-case
        (progn (require-live-authority *store-a* *bootstrap-a*
                                       :capability-id '("cap" "clavis")
                                       :subject '("subj" "alienus")
                                       :action '("act" "aperire")
                                       :resource '("res" "arca-prima")
                                       :scope '("scope" "exact")
                                       :query-id '("cap0-query" "q-subj"))
               nil)
      (lisp-plus-kernel0:capability-scope-mismatch (condition)
        (string= "subject"
                 (lisp-plus-kernel0:kernel0-condition-offending-field
                  condition))))))

(append-event *store-a* (test-revocation))

(tcheck "after the matching revocation commits, the escalation is kernel0's ~
         CAPABILITY-REVOKED with BOTH event identities in evidence-ids ~
         (§11.6: historical validity distinguished from current state)"
  (lambda ()
    (handler-case
        (progn (require-live-authority *store-a* *bootstrap-a*
                                       :capability-id '("cap" "clavis")
                                       :subject '("subj" "tardigrada")
                                       :action '("act" "aperire")
                                       :resource '("res" "arca-prima")
                                       :scope '("scope" "exact")
                                       :query-id '("cap0-query" "q-rev"))
               nil)
      (lisp-plus-kernel0:capability-revoked (condition)
        (equal (lisp-plus-kernel0:kernel0-condition-evidence-ids condition)
               '("cap0-event:g-001" "cap0-event:r-001"))))))

;;; ---------------------------------------------------------------------------
;;; 7. Planted mutants — each killed over this same living store.

(tcheck "planted mutant :ignore-revocation is KILLED: the strict fold ~
         refuses (revoked) where the defective fold still authorizes"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :ignore-revocation *store-a* *bootstrap-a*
                         :capability-id '("cap" "clavis")
                         :subject '("subj" "tardigrada")
                         :action '("act" "aperire")
                         :resource '("res" "arca-prima")
                         :scope '("scope" "exact"))
      (and killed
           (eq :refused (getf strict :decision))
           (eq :authorized (getf mutant :decision))))))

(tcheck "planted mutant :receipt-unbound-to-prefix is KILLED: the strict ~
         receipt's binding matches the fresh prefix-report, the mutant's ~
         genesis-bound receipt does not"
  (lambda ()
    (multiple-value-bind (killed strict mutant)
        (run-mutant-kill :receipt-unbound-to-prefix *store-a* *bootstrap-a*
                         :capability-id '("cap" "clavis")
                         :subject '("subj" "tardigrada")
                         :action '("act" "aperire")
                         :resource '("res" "arca-prima")
                         :scope '("scope" "exact"))
      (and killed
           (getf strict :binding-current)
           (not (getf mutant :binding-current))))))

(tcheck "planted mutant :cached-status is KILLED: warmed on a live grant, ~
         then a revocation commits underneath it — the strict fold-per-query ~
         refuses, the cached-status mutant still authorizes from its cache ~
         (the mutable status slot, demonstrated fatal)"
  (lambda ()
    (let* ((directory (merge-pathnames "store-cache/" *scratch*))
           (store (create-journal directory
                                  :nonce-octets (t-ascii "cap0-selftest-c!")))
           (bootstrap (declare-bootstrap-authority
                       *issuer-segments* (journal-store-store-id store))))
      (append-event store (test-grant :event-id '("cap0-event" "g-f01")
                                      :capability-id '("cap" "fenestra")))
      (multiple-value-bind (killed strict mutant)
          (run-mutant-kill :cached-status store bootstrap
                           :capability-id '("cap" "fenestra")
                           :subject '("subj" "tardigrada")
                           :action '("act" "aperire")
                           :resource '("res" "arca-prima")
                           :scope '("scope" "exact")
                           :warm-cache-thunk
                           (lambda ()
                             (append-event store
                                           (test-revocation
                                            :event-id '("cap0-event" "r-f01")
                                            :capability-id
                                            '("cap" "fenestra")))))
        (and killed
             (eq :refused (getf strict :decision))
             (eq :authorized (getf mutant :decision)))))))

(tcheck "the STRICT path never touches the mutant cache: after strict ~
         queries the cache variable is still NIL (no status is stored ~
         anywhere; every strict answer is a fresh fold)"
  (lambda ()
    (setf *mutant-ledger-cache* nil)
    (q "q-nocache")
    (null *mutant-ledger-cache*)))

;;; ---------------------------------------------------------------------------
;;; 8. The query executes nothing (law 12, unit form).

(tcheck "query-live-authority writes NOTHING: EVENTS.pj0 is byte-identical ~
         (by sha256) before and after a query and an escalated refusal"
  (lambda ()
    (let ((before (sha256-hex (t-read-octets
                               (merge-pathnames "EVENTS.pj0"
                                                *store-a-directory*)))))
      (q "q-ro")
      (expects lisp-plus-kernel0:capability-revoked
        (require-live-authority *store-a* *bootstrap-a*
                                :capability-id '("cap" "clavis")
                                :subject '("subj" "tardigrada")
                                :action '("act" "aperire")
                                :resource '("res" "arca-prima")
                                :scope '("scope" "exact")
                                :query-id '("cap0-query" "q-ro2")))
      (string= before
               (sha256-hex (t-read-octets
                            (merge-pathnames "EVENTS.pj0"
                                             *store-a-directory*)))))))

;;; ---------------------------------------------------------------------------
;;; 9. Gate teeth — this runner shown able to fail.

(when (sb-posix:getenv "CAP0_SELFTEST_PLANT_FAULT")
  (tcheck "PLANTED FAULT (CAP0_SELFTEST_PLANT_FAULT): this check is false ~
           by construction"
    (lambda () nil)))

(unless (sb-posix:getenv "CAP0_SELFTEST_PLANT_FAULT")
  (tcheck "gate teeth: this selftest CAN fail — a child run with a planted ~
           fault exits 1 and its transcript carries the FAIL line (a suite ~
           that has never been seen red certifies nothing)"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       '("--script"
                         "mneme/capability0/capability0-selftest.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "CAP0_SELFTEST_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text))))))

;;; ---------------------------------------------------------------------------
;;; Teardown + derived result.

(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%capability0-selftest: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
