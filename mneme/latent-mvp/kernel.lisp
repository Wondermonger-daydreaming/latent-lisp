;;;; kernel.lisp — the shared root for the Mneme latent-mvp bricks
;;;;
;;;; GPT Sol asked for this four times: the six/seven standalone bricks each
;;;; re-defined `claim`, `witness`, `freeze`, the clock — the Lisp Curse from
;;;; inside, "small private civilizations consistent until one afternoon they
;;;; aren't." This is the un-improvisable common floor. The bricks stay in the
;;;; museum as the record of discovery; going forward, laws are conformance walks
;;;; over THIS kernel (see conformance-walk.lisp).
;;;;
;;;; Deliberately boring. The toys may be strange; their floor should not be.
;;;; Load: (load "kernel.lisp")   ·   used by: conformance-walk.lisp

(require :sb-md5)

(defpackage #:mneme
  (:use #:cl)
  (:export #:*clock* #:tick #:digest #:signals-error-p #:ensure
           #:claim #:make-claim #:claim-proposition #:claim-grade #:claim-evidence
           #:claim-as-of #:claim-freshness
           #:*grades* #:grade-for
           #:witness #:make-witness #:witness-kind #:witness-target #:witness-verdict
           #:witness-verification-status #:witness-capability-status #:witness-provenance
           #:witness-supports-p
           #:certificate #:make-certificate #:certificate-target #:certificate-verifier
           #:certificate-verdict #:certificate-event-kind
           #:*authority* #:may-issue-p #:verify-proposition #:raise-claim #:authenticate-grade
           #:judgment #:make-judgment #:judgment-claims #:judgment-invocation #:judgment-status
           #:freeze #:revive #:receipt #:make-receipt #:receipt-status #:receipt-path
           #:receipt-content-digest #:prepare #:commit #:receive #:mneme-revive))

(in-package #:mneme)

;;; ── the boring floor ────────────────────────────────────────────────────────
(defparameter *clock* 9000)
(defun tick () (incf *clock*))
(defun digest (s) (format nil "~(~{~2,'0x~}~)"
                          (coerce (sb-md5:md5sum-string (if (stringp s) s (format nil "~s" s))) 'list)))
(defun signals-error-p (th) (handler-case (progn (funcall th) nil) (error () t)))
(defmacro ensure (test fmt &rest args) `(unless ,test (error ,fmt ,@args)))

;;; ── grades: warrant MODES, not a prestige ladder (Sol's correction) ─────────
(defparameter *grades*
  '((:observation . :observed) (:execution . :executed) (:test . :tested)
    (:derivation . :derived) (:contract . :contract) (:classification . :classified)))
(defun grade-for (kind) (or (cdr (assoc kind *grades*)) :asserted))

;;; ── claim: bare until recruited as testimony (M4/bounded-witness) ────────────
(defstruct claim proposition (grade :asserted) evidence as-of (freshness :current))

;;; ── witness: typed, RELATIONAL, with orthogonal status (bricks #4/#5) ────────
(defstruct witness kind target procedure input result verdict
                   (verification-status :unverified) (capability-status :available) provenance)

(defun witness-supports-p (w claim)
  "Support is relational: face the exact proposition, admissible kind, :supports
   verdict, verified status, inspectable provenance. Proximity is nothing."
  (and (equal (witness-target w) (claim-proposition claim))
       (assoc (witness-kind w) *grades*)
       (eq (witness-verdict w) :supports)
       (eq (witness-verification-status w) :verified)
       (witness-provenance w) t))

;;; ── certificate + authority: report ≠ certificate (brick #6) ────────────────
(defstruct certificate target verifier verdict event-kind issued-at procedure-digest)
(defparameter *authority*
  '((:execution-verifier . (:execution :replay)) (:observation-source . (:observation))
    (:model-adapter . (:invocation :asserted)) (:store . (:commit))))
(defun may-issue-p (principal kind) (member kind (cdr (assoc principal *authority*))))

(defun verify-proposition (proposition principal &key (event-kind :execution))
  "Structured proposition (:equals (:call PROC INPUT) EXPECTED). The verifier is
   authorized, RE-RUNS, and reads EXPECTED from the proposition — no drift."
  (ensure (may-issue-p principal event-kind) "AUTHORITY: ~a may not issue ~a" principal event-kind)
  (destructuring-bind (rel (ck proc input) expected) proposition
    (ensure (and (eq rel :equals) (eq ck :call)) "unsupported proposition shape")
    (let ((actual (funcall (fdefinition proc) input)))
      (make-certificate :target proposition :verifier principal
                        :verdict (if (equal actual expected) :supports :refutes)
                        :event-kind event-kind :issued-at (tick)
                        :procedure-digest (digest (format nil "~a@v~a" proc (or (get proc 'version) 1)))))))

(defun raise-claim (claim cert)
  "Raising a grade requires a CERTIFICATE, not a self-described report."
  (ensure (certificate-p cert) "REPORT≠CERTIFICATE: a report cannot raise a grade")
  (ensure (equal (certificate-target cert) (claim-proposition claim)) "certificate targets a different claim")
  (ensure (eq (certificate-verdict cert) :supports) "certificate does not support")
  (ensure (may-issue-p (certificate-verifier cert) (certificate-event-kind cert)) "issuer not authorized")
  (let ((c (copy-claim claim)))
    (setf (claim-grade c) (grade-for (certificate-event-kind cert))
          (claim-evidence c) (cons cert (claim-evidence claim)))
    c))

(defun authenticate-grade (claim accepted-certs)
  "Across the gap: a claim earns a grade only from a certificate the successor
   re-validates. A serialized medal is not authentication."
  (let ((c (find-if (lambda (ct) (and (equal (certificate-target ct) (claim-proposition claim))
                                      (eq (certificate-verdict ct) :supports)
                                      (may-issue-p (certificate-verifier ct) (certificate-event-kind ct))))
                    accepted-certs)))
    (if c (grade-for (certificate-event-kind c)) :asserted)))

;;; ── judgment: the result of an evaluator invocation (brick #3) ──────────────
(defstruct judgment claims invocation (status :completed))

;;; ── mortal handoff: prepared → committed → received → revived (handoff-kernel)
(defstruct receipt content-digest status path)
(defun freeze (claim)
  (let ((text (with-standard-io-syntax
                (prin1-to-string (list :tag :mneme :schema 1
                                       :proposition (claim-proposition claim) :grade (claim-grade claim)
                                       :as-of (claim-as-of claim))))))
    (values text (digest text))))
(defun mneme-revive (text)
  "Acknowledged reconstruction — never identity. Safe read (*read-eval* nil)."
  (let ((d (with-standard-io-syntax (let ((*read-eval* nil)) (read-from-string text)))))
    (ensure (and (eq (getf d :tag) :mneme) (eql (getf d :schema) 1)) "unknown schema")
    (make-claim :proposition (getf d :proposition) :grade (getf d :grade)
                :as-of (getf d :as-of) :freshness :aging)))   ; crossed a gap → not :current
(defun prepare (claim)
  (multiple-value-bind (text dig) (freeze claim)
    (list :text text :receipt (make-receipt :content-digest dig :status :prepared))))
(defun commit (prepared store)
  (let* ((r (getf prepared :receipt))
         (path (format nil "~amneme-~a.sexp" store (receipt-content-digest r))))
    (ensure-directories-exist store)
    (with-open-file (s (concatenate 'string path ".tmp") :direction :output :if-exists :supersede)
      (write-string (getf prepared :text) s) (finish-output s))
    (rename-file (concatenate 'string path ".tmp") path)
    (setf (receipt-status r) :committed (receipt-path r) path) r))
(defun receive (receipt)
  (ensure (eq (receipt-status receipt) :committed) "cannot receive: not committed")
  (let ((text (with-open-file (s (receipt-path receipt))
                (let ((b (make-string (file-length s)))) (read-sequence b s) b))))
    (ensure (string= (digest text) (receipt-content-digest receipt)) "digest mismatch (forged)")
    (setf (receipt-status receipt) :received) (values receipt text)))

(format t "mneme kernel loaded: ~a exported symbols~%"
        (let ((n 0)) (do-external-symbols (s :mneme) (declare (ignore s)) (incf n)) n))
