;;;; council-process-ledger.lisp — The first non-toy relay ledger
;;;
;;;; This storm consumes an actual process record assembled only from claims
;;;; established in the carried Sol/Fable relays. Unknown backstage events are
;;;; not reconstructed. Silence remains :NOT-ESTABLISHED and is tested against
;;;; laundering into innocence, guilt, or a fictional zero.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))
(load (merge-pathnames "../src/provenance.lisp" *load-truename*))

(in-package #:leibnitiana)

(defun read-council-record ()
  (let ((*read-eval* nil))
    (with-open-file (stream (merge-pathnames
                             "../data/council-process-2026-07-12.sexp"
                             *load-truename*)
                            :direction :input)
      (read stream nil nil))))

(defun record-event (record id)
  (find id (getf record :events)
        :key (lambda (event) (getf event :id))
        :test #'eq))

(defun silence-entry (record field)
  (find field (getf record :explicit-silences)
        :key (lambda (entry) (getf entry :field))
        :test #'eq))

(defun build-council-receipt (record)
  (let ((log (make-receipt-log)))
    (dolist (event (getf record :events) log)
      (append-receipt-event
       log
       (getf event :kind)
       (getf event :actor)
       (list :id (getf event :id)
             :artifact (getf event :artifact)
             :claim (getf event :claim)
             :source (getf event :source))))))

(defun audit-council-record (record)
  (let* ((log (build-council-receipt record))
         (verification (verify-receipt-log log))
         (r3-landing (record-event record :r3-fable-landing))
         (mirror (record-event record :r3-public-mirror-proposal))
         (carrier-silence
           (silence-entry record :carrier-selection-and-omission-history))
         (outsider-silence
           (silence-entry record :outsider-identity-and-selection-process))
         (checkpoint-silence
           (silence-entry record :specific-public-mirror-commit-checkpoint))
         (manufactured-evidence
           (find-if
            (lambda (event)
              (member (getf event :kind)
                      '(:private-retry :semantic-edit :withholding
                        :selective-publication)
                      :test #'eq))
            (getf record :events))))
    (list
     :internal-ledger-valid (getf verification :internally-valid)
     :event-count (length (getf record :events))
     :round-three-repairs (getf (getf r3-landing :claim) :repairs)
     :repair-kinds (getf (getf r3-landing :claim) :repair-kinds)
     :manufactured-unanimity
     (if manufactured-evidence :supported :not-established)
     :carrier-selection-history (getf carrier-silence :status)
     :outsider-selection (getf outsider-silence :status)
     :public-mirror-existence
     (getf (getf mirror :claim) :mirror-exists)
     :specific-mirror-checkpoint (getf checkpoint-silence :status)
     :independent-review :pending
     :standing (getf record :declared-standing)
     :boundary (getf record :evidence-boundary))))

(print-section "ACTUAL COUNCIL PROCESS LEDGER — ESTABLISHED EVENTS ONLY")
(let* ((record (read-council-record))
       (report (audit-council-record record)))
  (format t "Record: ~S~%" record)
  (format t "Audit: ~S~%" report)
  (check-equal 11
               (getf report :event-count)
               "the ledger contains eleven established relay events")
  (check (getf report :internal-ledger-valid)
         "the derived council receipt is internally self-consistent")
  (check-equal 2
               (getf report :round-three-repairs)
               "the ledger preserves the first nonzero repair count")
  (check-equal '(:reload-unsafe-string-constant
                 :advertised-naive-blade-absent)
               (getf report :repair-kinds)
               "both self-applicative round-three repairs remain visible")
  (check-equal :not-established
               (getf report :manufactured-unanimity)
               "the public record does not invent private curation evidence")
  (check-equal :not-established
               (getf report :carrier-selection-history)
               "unattested carrier selection remains unknown")
  (check-equal :not-established
               (getf report :outsider-selection)
               "the cold reader has not yet been selected")
  (check-equal :reported
               (getf report :public-mirror-existence)
               "the public mirror exists within the supplied testimony")
  (check-equal :not-established
               (getf report :specific-mirror-checkpoint)
               "no commit identifier is hallucinated from a generic mirror claim")
  (check-equal :shared-root-process-ledger-with-explicit-silences
               (getf report :standing)
               "the ledger does not promote itself to independent validation"))
