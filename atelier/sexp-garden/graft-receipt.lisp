;;;; graft-receipt.lisp — exact birth receipts for subtree crossover.
;;;; GPT Sol, 2026-07-12.
;;;;
;;;; The historical garden records parent ids and the child's final tree.  That
;;;; is enough for lineage, but not enough to reconstruct the operation that
;;;; joined them.  This instrument records the graft at the moment it happens.
;;;;
;;;; Its canonical public receipt is exactly:
;;;;
;;;;   (recipient-cut donor-cut transplanted-subtree accepted/refused)
;;;;
;;;; Example:
;;;;
;;;;   (4 0 (+ X 1) :ACCEPTED)
;;;;
;;;; The full structure also freezes both parents, the proposed child, the
;;;; actual child, the depth cap, and (once REGISTER admits the birth) the three
;;;; organism ids.  The four-field s-expression is the portable kernel; the
;;;; larger record is the audit trail.

(defvar *run-self-tests* nil)
(unless (fboundp 'replace-node-at)
  (load (merge-pathnames "garden.lisp" *load-pathname*)))

(defstruct (graft-receipt
             (:constructor %make-graft-receipt))
  id
  recipient-cut
  donor-cut
  transplanted-subtree
  disposition
  refusal-reason
  depth-cap
  recipient-before
  donor-before
  proposed-child
  child-after
  recipient-org-id
  donor-org-id
  child-org-id)

(defparameter *graft-ledger* nil)
(defparameter *next-graft-id* 0)
(defparameter *graft-journal-path* nil)

(defun graft-ledger-reset ()
  (setf *graft-ledger*
        (make-array 128 :adjustable t :fill-pointer 0)
        *next-graft-id* 0)
  *graft-ledger*)

(defun ensure-graft-ledger ()
  (unless (and (vectorp *graft-ledger*)
               (array-has-fill-pointer-p *graft-ledger*))
    (graft-ledger-reset))
  *graft-ledger*)

(defun valid-cut-index-p (tree index)
  (and (integerp index)
       (<= 0 index)
       (< index (tree-size tree))))

(defun require-cut-index (tree index role)
  (unless (valid-cut-index-p tree index)
    (error "~A cut ~S is outside 0..~D for tree ~S"
           role index (1- (tree-size tree)) tree))
  index)

(defun accepted-graft-p (receipt)
  (eq (graft-receipt-disposition receipt) :accepted))

(defun refused-graft-p (receipt)
  (eq (graft-receipt-disposition receipt) :refused))

(defun graft-receipt-sexp (receipt)
  "The portable four-field receipt requested by the Garden.

The returned list is a fresh value, so callers cannot mutate the frozen
transplant held by RECEIPT."
  (list (graft-receipt-recipient-cut receipt)
        (graft-receipt-donor-cut receipt)
        (copy-tree (graft-receipt-transplanted-subtree receipt))
        (graft-receipt-disposition receipt)))

(defun attempt-graft (recipient donor recipient-cut donor-cut
                      &key (max-depth *max-depth*))
  "Attempt one exact subtree graft and record it.

RECIPIENT-CUT and DONOR-CUT are pre-order node indices using GARDEN.LISP's
shared counting rule.  The donor subtree is copied before transplantation.
If the proposed child exceeds MAX-DEPTH, the graft is :REFUSED and CHILD is a
fresh copy of RECIPIENT.  Returns (values child receipt)."
  (require-cut-index recipient recipient-cut "recipient")
  (require-cut-index donor donor-cut "donor")
  (unless (and (integerp max-depth) (<= 0 max-depth))
    (error "MAX-DEPTH must be a non-negative integer, got ~S" max-depth))
  (ensure-graft-ledger)
  (let* ((recipient-before (copy-tree recipient))
         (donor-before (copy-tree donor))
         (transplant
           (copy-tree (node-at* donor-before donor-cut)))
         (proposed
           (replace-node-at recipient-before
                            recipient-cut
                            (copy-tree transplant)))
         (accepted
           (<= (tree-depth proposed) max-depth))
         (child
           (if accepted
               (copy-tree proposed)
               (copy-tree recipient-before)))
         (receipt
           (%make-graft-receipt
            :id *next-graft-id*
            :recipient-cut recipient-cut
            :donor-cut donor-cut
            :transplanted-subtree (copy-tree transplant)
            :disposition (if accepted :accepted :refused)
            :refusal-reason (unless accepted :depth-cap)
            :depth-cap max-depth
            :recipient-before (copy-tree recipient-before)
            :donor-before (copy-tree donor-before)
            :proposed-child (copy-tree proposed)
            :child-after (copy-tree child))))
    (vector-push-extend receipt *graft-ledger*)
    (incf *next-graft-id*)
    (values child receipt)))

(defun crossover-with-graft-receipt (recipient donor)
  "Garden-compatible random crossover with an exact fourth return value.

Returns (values child recipient-cut donor-cut graft-receipt)."
  (let ((recipient-cut (rand-int (tree-size recipient)))
        (donor-cut (rand-int (tree-size donor))))
    (multiple-value-bind (child receipt)
        (attempt-graft recipient donor recipient-cut donor-cut)
      (values child recipient-cut donor-cut receipt))))

(defun seal-graft-birth (receipt child-id recipient-id donor-id)
  "Attach organism-ledger identities after REGISTER admits the child."
  (when (graft-receipt-child-org-id receipt)
    (error "Graft receipt ~D is already sealed to child ~D"
           (graft-receipt-id receipt)
           (graft-receipt-child-org-id receipt)))
  (setf (graft-receipt-child-org-id receipt) child-id
        (graft-receipt-recipient-org-id receipt) recipient-id
        (graft-receipt-donor-org-id receipt) donor-id)
  receipt)

(defun find-unsealed-graft-for-child (tree)
  "Find the newest unsealed receipt whose actual child equals TREE."
  (ensure-graft-ledger)
  (loop for index downfrom (1- (fill-pointer *graft-ledger*)) to 0
        for receipt = (aref *graft-ledger* index)
        when (and (null (graft-receipt-child-org-id receipt))
                  (equal tree (graft-receipt-child-after receipt)))
          return receipt))

(defun graft-for-child-id (child-id)
  (ensure-graft-ledger)
  (loop for receipt across *graft-ledger*
        when (eql child-id (graft-receipt-child-org-id receipt))
          return receipt))

(defun recipient-context-survives-p (receipt)
  "An accepted non-root graft leaves some recipient context around the donor."
  (and (accepted-graft-p receipt)
       (> (graft-receipt-recipient-cut receipt) 0)))

(defun nontrivial-transplant-p (receipt)
  "The donor contributed a compound subtree, not only an atomic terminal."
  (consp (graft-receipt-transplanted-subtree receipt)))

(defun exact-bilateral-assembly-p (receipt)
  "Strong structural criterion, deliberately separate from mere acceptance."
  (and (graft-receipt-valid-p receipt)
       (recipient-context-survives-p receipt)
       (nontrivial-transplant-p receipt)))

(defun graft-receipt-violations (receipt)
  "Return a list of violated invariants.  NIL means the receipt replays cleanly."
  (let* ((recipient (graft-receipt-recipient-before receipt))
         (donor (graft-receipt-donor-before receipt))
         (recipient-cut (graft-receipt-recipient-cut receipt))
         (donor-cut (graft-receipt-donor-cut receipt))
         (cap (graft-receipt-depth-cap receipt))
         (violations '()))
    (unless (valid-cut-index-p recipient recipient-cut)
      (push :recipient-cut-out-of-range violations))
    (unless (valid-cut-index-p donor donor-cut)
      (push :donor-cut-out-of-range violations))
    (when (and (valid-cut-index-p donor donor-cut)
               (not (equal (graft-receipt-transplanted-subtree receipt)
                           (node-at* donor donor-cut))))
      (push :transplant-does-not-match-donor-cut violations))
    (when (valid-cut-index-p recipient recipient-cut)
      (let* ((replayed
               (replace-node-at
                recipient
                recipient-cut
                (copy-tree
                 (graft-receipt-transplanted-subtree receipt))))
             (should-accept
               (<= (tree-depth replayed) cap))
             (expected-child
               (if should-accept replayed recipient)))
        (unless (equal replayed (graft-receipt-proposed-child receipt))
          (push :proposed-child-does-not-replay violations))
        (unless (eq should-accept (accepted-graft-p receipt))
          (push :disposition-disagrees-with-depth-gate violations))
        (unless (equal expected-child (graft-receipt-child-after receipt))
          (push :actual-child-disagrees-with-disposition violations))
        (unless (if should-accept
                    (null (graft-receipt-refusal-reason receipt))
                    (eq (graft-receipt-refusal-reason receipt) :depth-cap))
          (push :refusal-reason-inconsistent violations))))
    (nreverse violations)))

(defun graft-receipt-valid-p (receipt)
  (null (graft-receipt-violations receipt)))


(defun graft-record-sexp (receipt)
  "A readably printable durable record whose :RECEIPT value is the four-field kernel."
  (list :graft-id (graft-receipt-id receipt)
        :receipt (graft-receipt-sexp receipt)
        :refusal-reason (graft-receipt-refusal-reason receipt)
        :depth-cap (graft-receipt-depth-cap receipt)
        :orgs (list :recipient (graft-receipt-recipient-org-id receipt)
                    :donor (graft-receipt-donor-org-id receipt)
                    :child (graft-receipt-child-org-id receipt))
        :recipient-before
        (copy-tree (graft-receipt-recipient-before receipt))
        :donor-before
        (copy-tree (graft-receipt-donor-before receipt))
        :proposed-child
        (copy-tree (graft-receipt-proposed-child receipt))
        :child-after
        (copy-tree (graft-receipt-child-after receipt))
        :replay-valid (graft-receipt-valid-p receipt)))

(defun append-graft-record (receipt path)
  (with-open-file (stream path
                          :direction :output
                          :if-exists :append
                          :if-does-not-exist :create)
    (write (graft-record-sexp receipt)
           :stream stream
           :readably t
           :pretty nil)
    (terpri stream))
  receipt)

(defun reset-graft-journal (&optional (path *graft-journal-path*))
  (when path
    (with-open-file (stream path
                            :direction :output
                            :if-exists :supersede
                            :if-does-not-exist :create)
      (declare (ignore stream))))
  path)

(defun write-graft-ledger (path)
  "Rewrite PATH as one readable graft record per line."
  (ensure-graft-ledger)
  (reset-graft-journal path)
  (loop for receipt across *graft-ledger* do
    (append-graft-record receipt path))
  path)

(defun print-graft-receipt (receipt &optional (stream *standard-output*))
  (format stream "~&;;;; graft ~D ~S~%"
          (graft-receipt-id receipt)
          (graft-receipt-sexp receipt))
  (format stream ";;;; depth proposed=~D cap=~D disposition=~S~%"
          (tree-depth (graft-receipt-proposed-child receipt))
          (graft-receipt-depth-cap receipt)
          (graft-receipt-disposition receipt))
  (when (refused-graft-p receipt)
    (format stream ";;;; refusal-reason=~S; recipient returned unchanged~%"
            (graft-receipt-refusal-reason receipt)))
  (when (graft-receipt-child-org-id receipt)
    (format stream ";;;; orgs recipient=~D donor=~D child=~D~%"
            (graft-receipt-recipient-org-id receipt)
            (graft-receipt-donor-org-id receipt)
            (graft-receipt-child-org-id receipt)))
  (format stream ";;;; exact-bilateral-assembly=~S replay-valid=~S~%"
          (exact-bilateral-assembly-p receipt)
          (graft-receipt-valid-p receipt))
  receipt)

(defun report-graft-ledger (&optional (stream *standard-output*))
  (ensure-graft-ledger)
  (let ((accepted 0)
        (refused 0)
        (bilateral 0))
    (loop for receipt across *graft-ledger* do
      (if (accepted-graft-p receipt)
          (incf accepted)
          (incf refused))
      (when (exact-bilateral-assembly-p receipt)
        (incf bilateral)))
    (format stream "~&;;;; GRAFT LEDGER~%")
    (format stream ";;;; attempts=~D accepted=~D refused=~D exact-bilateral=~D~%"
            (fill-pointer *graft-ledger*) accepted refused bilateral)
    (loop for receipt across *graft-ledger* do
      (print-graft-receipt receipt stream))
    *graft-ledger*))

;;; --------------------------------------------------------------------------
;;; Optional transparent adapter.
;;;
;;; INSTALL-GRAFT-INSTRUMENTATION replaces GARDEN.LISP's CROSSOVER, REGISTER,
;;; and LEDGER-RESET while preserving their public calling conventions.  The
;;; current run.lisp can therefore adopt exact graft receipts by changing only
;;; its library load from garden.lisp to garden-grafted.lisp.
;;; --------------------------------------------------------------------------

(defparameter *graft-instrumentation-installed* nil)
(defparameter *garden-original-crossover* nil)
(defparameter *garden-original-register* nil)
(defparameter *garden-original-ledger-reset* nil)

(defun instrumented-garden-crossover (recipient donor)
  (multiple-value-bind (child recipient-cut donor-cut receipt)
      (crossover-with-graft-receipt recipient donor)
    (declare (ignore receipt))
    (values child recipient-cut donor-cut)))

(defun instrumented-garden-register (tree err gen how p1 p2)
  (let ((organism
          (funcall *garden-original-register*
                   tree err gen how p1 p2)))
    (when (eq how :crossover)
      (let ((receipt (find-unsealed-graft-for-child tree)))
        (unless receipt
          (error "Crossover child ~S was registered without a graft receipt"
                 tree))
        (seal-graft-birth receipt (org-id organism) p1 p2)
        (when *graft-journal-path*
          (append-graft-record receipt *graft-journal-path*))))
    organism))

(defun instrumented-garden-ledger-reset ()
  (prog1
      (funcall *garden-original-ledger-reset*)
    (graft-ledger-reset)
    (reset-graft-journal)))

(defun install-graft-instrumentation ()
  (unless *graft-instrumentation-installed*
    (setf *garden-original-crossover* (symbol-function 'crossover)
          *garden-original-register* (symbol-function 'register)
          *garden-original-ledger-reset* (symbol-function 'ledger-reset)
          (symbol-function 'crossover) #'instrumented-garden-crossover
          (symbol-function 'register) #'instrumented-garden-register
          (symbol-function 'ledger-reset) #'instrumented-garden-ledger-reset
          *graft-instrumentation-installed* t))
  *graft-instrumentation-installed*)

(defun uninstall-graft-instrumentation ()
  (when *graft-instrumentation-installed*
    (setf (symbol-function 'crossover) *garden-original-crossover*
          (symbol-function 'register) *garden-original-register*
          (symbol-function 'ledger-reset) *garden-original-ledger-reset*
          *graft-instrumentation-installed* nil))
  (not *graft-instrumentation-installed*))

;;; --------------------------------------------------------------------------
;;; Focused gates.
;;; --------------------------------------------------------------------------

(defparameter *graft-checks* 0)

(defun graft-check (truth description)
  (incf *graft-checks*)
  (unless truth
    (error "GRAFT CHECK FAILED: ~A" description))
  t)

(defun run-graft-receipt-self-tests ()
  (setf *graft-checks* 0)
  (graft-ledger-reset)
  (multiple-value-bind (child accepted)
      (attempt-graft
       '(+ (* x x) 1)
       '(+ x 1)
       4
       0
       :max-depth 7)
    (graft-check
     (equal child '(+ (* x x) (+ x 1)))
     "the selected donor subtree is transplanted at the selected recipient cut")
    (graft-check
     (equal (graft-receipt-sexp accepted)
            '(4 0 (+ x 1) :accepted))
     "the canonical receipt has exactly four requested fields")
    (graft-check
     (graft-receipt-valid-p accepted)
     "the accepted receipt replays without contradiction")
    (graft-check
     (exact-bilateral-assembly-p accepted)
     "a non-root compound graft preserves recipient context and donor structure"))

  (multiple-value-bind (child root-replacement)
      (attempt-graft '(+ x 1) '(* x x) 0 0 :max-depth 7)
    (graft-check (equal child '(* x x))
                 "an accepted root replacement returns the donor tree")
    (graft-check (accepted-graft-p root-replacement)
                 "root replacement is still an accepted graft")
    (graft-check (not (exact-bilateral-assembly-p root-replacement))
                 "acceptance alone does not pretend recipient context survived"))

  (multiple-value-bind (child refused)
      (attempt-graft
       '(+ x 1)
       '(* (+ x 1) (+ x 1))
       1
       0
       :max-depth 1)
    (graft-check (equal child '(+ x 1))
                 "a refused graft returns a fresh copy of the recipient")
    (graft-check (equal (graft-receipt-sexp refused)
                        '(1 0 (* (+ x 1) (+ x 1)) :refused))
                 "refusal records the attempted transplant rather than erasing it")
    (graft-check (eq (graft-receipt-refusal-reason refused) :depth-cap)
                 "the refusal names the gate that refused it")
    (graft-check (graft-receipt-valid-p refused)
                 "the refused receipt also replays cleanly"))

  ;; A receipt must object when its frozen transplant is falsified.
  (let* ((original (aref *graft-ledger* 0))
         (forgery (copy-graft-receipt original)))
    (setf (graft-receipt-transplanted-subtree forgery) 'x)
    (graft-check (not (graft-receipt-valid-p forgery))
                 "tampering with the transplanted subtree is detected"))

  ;; Exercise the transparent adapter and seal one birth to organism ids.
  (unwind-protect
       (progn
         (ledger-reset)
         (graft-ledger-reset)
         (install-graft-instrumentation)
         (let* ((recipient-tree '(+ (* x x) 1))
                (donor-tree '(+ x 1))
                (recipient
                  (register recipient-tree 10d0 0 :seed nil nil))
                (donor
                  (register donor-tree 11d0 0 :seed nil nil)))
           (rng-seed 20260712)
           (let* ((child-tree
                    (crossover (org-tree recipient) (org-tree donor)))
                  (child
                    (register child-tree 1d0 1 :crossover
                              (org-id recipient) (org-id donor)))
                  (receipt
                    (graft-for-child-id (org-id child))))
             (graft-check receipt
                          "instrumented REGISTER seals the crossover receipt")
             (graft-check
              (and (= (graft-receipt-recipient-org-id receipt)
                      (org-id recipient))
                   (= (graft-receipt-donor-org-id receipt)
                      (org-id donor)))
              "the sealed receipt names both parent organisms")
             (graft-check (graft-receipt-valid-p receipt)
                          "the sealed receipt remains replay-valid"))))
    (uninstall-graft-instrumentation))

  ;; PLANTED FAILURE: prove the local gate has teeth.
  (let ((teeth nil))
    (handler-case
        (graft-check nil "PLANTED: false must signal")
      (error () (setf teeth t)))
    (graft-check teeth "the graft checker caught its planted failure"))

  (format t "~&;;;; graft-receipt: ~D checks passed~%" *graft-checks*)
  t)

(defvar *run-graft-receipt-self-tests* t)
(when *run-graft-receipt-self-tests*
  (run-graft-receipt-self-tests))
