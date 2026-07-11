;;;; de-testimonio-postumo.lisp — Posthumous Testimony
;;;; A certificate survives; the function bound to its old name changes.
;;;; Historical event ≠ replay event. Procedure name ≠ procedure identity.
;;;; Certificate ≠ report. Past verification ≠ present reproducibility.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.de-testimonio-postumo
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.de-testimonio-postumo)

(reset-clock 7100)

(defstruct procedure-record name version digest function environment-digest)
(defstruct execution-certificate
  event-id proposition procedure-name procedure-digest input input-digest result
  environment-digest issuer issued-at verdict signature)
(defstruct replay-certificate
  source-event-id current-procedure-digest expected-procedure-digest input
  expected-result actual-result environment-digest performed-at verdict)

(defparameter *procedure-registry* (make-hash-table :test #'eq))
(defparameter *issuer-secrets* '((:execution-verifier . "cold-iron-key")))

(defun median-v1 (xs)
  (let* ((s (sort (copy-list xs) #'<))
         (n (length s)))
    (if (oddp n)
        (nth (floor n 2) s)
        (/ (+ (nth (1- (floor n 2)) s)
              (nth (floor n 2) s))
           2))))

(defun median-v2 (xs)
  (declare (ignore xs))
  999)

(defun register-procedure (name function version source-id environment)
  (let ((record (make-procedure-record
                 :name name
                 :version version
                 :digest (toy-digest (list name version source-id))
                 :function function
                 :environment-digest (toy-digest environment))))
    (setf (gethash name *procedure-registry*) record
          (symbol-function name) function)
    record))

(defun current-procedure (name)
  (or (gethash name *procedure-registry*)
      (error "unregistered procedure ~a" name)))

(defun certificate-payload (certificate)
  (list :event-id (execution-certificate-event-id certificate)
        :proposition (execution-certificate-proposition certificate)
        :procedure-name (execution-certificate-procedure-name certificate)
        :procedure-digest (execution-certificate-procedure-digest certificate)
        :input (execution-certificate-input certificate)
        :input-digest (execution-certificate-input-digest certificate)
        :result (execution-certificate-result certificate)
        :environment-digest (execution-certificate-environment-digest certificate)
        :issuer (execution-certificate-issuer certificate)
        :issued-at (execution-certificate-issued-at certificate)
        :verdict (execution-certificate-verdict certificate)))

(defun issue-execution-certificate (procedure-name input expected)
  (let* ((record (current-procedure procedure-name))
         (result (funcall (procedure-record-function record) input))
         (issuer :execution-verifier)
         (certificate
           (make-execution-certificate
            :event-id (intern (format nil "EVENT-~A" (tick)) :keyword)
            :proposition (list := (list procedure-name input) expected)
            :procedure-name procedure-name
            :procedure-digest (procedure-record-digest record)
            :input input
            :input-digest (toy-digest input)
            :result result
            :environment-digest (procedure-record-environment-digest record)
            :issuer issuer
            :issued-at (tick)
            :verdict (if (equal result expected) :supports :refutes))))
    (setf (execution-certificate-signature certificate)
          (toy-sign (cdr (assoc issuer *issuer-secrets*))
                    (certificate-payload certificate)))
    certificate))

(defun verify-execution-certificate (certificate)
  (let ((secret (cdr (assoc (execution-certificate-issuer certificate)
                            *issuer-secrets*))))
    (and secret
         (string= (execution-certificate-signature certificate)
                  (toy-sign secret (certificate-payload certificate)))
         (eq (execution-certificate-verdict certificate) :supports))))

(defun replay-certificate (certificate)
  (ensure (verify-execution-certificate certificate)
          "historical certificate failed authentication")
  (let* ((record (current-procedure
                  (execution-certificate-procedure-name certificate)))
         (actual (funcall (procedure-record-function record)
                          (execution-certificate-input certificate)))
         (expected (execution-certificate-result certificate)))
    (make-replay-certificate
     :source-event-id (execution-certificate-event-id certificate)
     :current-procedure-digest (procedure-record-digest record)
     :expected-procedure-digest
     (execution-certificate-procedure-digest certificate)
     :input (execution-certificate-input certificate)
     :expected-result expected
     :actual-result actual
     :environment-digest (procedure-record-environment-digest record)
     :performed-at (tick)
     :verdict (if (equal actual expected) :reproduces :contradicts))))

(banner "de testimonio postumo")

(register-procedure 'median-under-test #'median-v1 :v1
                    '(:sort-copy :middle-pair-average)
                    '(:runtime gen-0 :arithmetic rational))

(let ((historical (issue-execution-certificate
                   'median-under-test '(5 9 87 3) 7)))
  (format t "GEN 0 executes MEDIAN-UNDER-TEST: result ~a; certificate ~a.~%"
          (execution-certificate-result historical)
          (execution-certificate-event-id historical))
  (format t "   procedure digest ~a  authenticated? ~a~%~%"
          (execution-certificate-procedure-digest historical)
          (verify-execution-certificate historical))

  ;; The name survives. Its meaning does not.
  (register-procedure 'median-under-test #'median-v2 :v2
                      '(:return-constant 999)
                      '(:runtime gen-1 :arithmetic rational))

  (let ((replay (replay-certificate historical)))
    (format t "GEN 1 resolves the SAME SYMBOL after rebinding.~%")
    (format t "   historical result: ~a   present replay: ~a~%"
            (replay-certificate-expected-result replay)
            (replay-certificate-actual-result replay))
    (format t "   old digest: ~a~%   new digest: ~a~%"
            (replay-certificate-expected-procedure-digest replay)
            (replay-certificate-current-procedure-digest replay))
    (format t "   replay verdict: ~a~%~%" (replay-certificate-verdict replay))

    (section "gates:")
    (ensure (verify-execution-certificate historical)
            "historical certificate should remain authentic")
    (pass "historical-certificate-valid")
    (ensure (not (string= (replay-certificate-current-procedure-digest replay)
                          (replay-certificate-expected-procedure-digest replay)))
            "procedure identity change went undetected")
    (pass "name-is-not-identity")
    (ensure (eql (execution-certificate-result historical) 7)
            "historical event was rewritten")
    (pass "history-not-rewritten")
    (ensure (eql (replay-certificate-actual-result replay) 999)
            "changed implementation did not execute")
    (pass "new-event-recorded")
    (ensure (eq (replay-certificate-verdict replay) :contradicts)
            "replay disagreement was laundered")
    (pass "reproducibility-broken-honestly")

    (format t "~%[the certificate survived; the old function did not return through its name]~%~%")))

(format t "── the dead computation did not change its answer. the living name changed what it meant. ──~%")
