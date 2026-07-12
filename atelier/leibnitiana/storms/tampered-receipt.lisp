;;;; tampered-receipt.lisp — A self-consistent lie meets an external checkpoint
;;;
;;;; Blade 1 demonstrates that editing an old event breaks a stored chain.
;;;; Blade 2 demonstrates the harder case: a curator rewrites the event and
;;;; recomputes the entire chain, restoring internal validity. Only a prefix
;;;; checkpoint held elsewhere can contradict the rewritten history.
;;;
;;;; The digest is FNV-1a for dependency-free execution and explicitly lacks
;;;; adversarial cryptographic standing. The architecture, not the primitive,
;;;; is the object of this specimen.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))
(load (merge-pathnames "../src/provenance.lisp" *load-truename*))

(in-package #:leibnitiana)

(defun make-original-log ()
  (let ((log (make-receipt-log)))
    (append-receipt-event log :session-opened :orchestrator
                          '(:council :lambda))
    (append-receipt-event log :candidate-emitted :cato
                          '(:position :war :attempt 1))
    (append-receipt-event log :candidate-emitted :ada
                          '(:position :peace :attempt 1))
    log))

(defun bare-events-from-log (log)
  (mapcar (lambda (event)
            (list :kind (getf event :kind)
                  :actor (getf event :actor)
                  :payload (copy-tree (getf event :payload))))
          (receipt-log-events log)))


(defun naively-edit-cato-in-place (log)
  "Mutate Cato's stored payload without recomputing any event hashes."
  (let* ((event (second (receipt-log-events log)))
         (payload (getf event :payload)))
    (setf (getf payload :position) :peace)
    log))

(defun rewrite-cato-as-peace (log)
  "Return a freshly rechained log in which Cato's original WAR became PEACE."
  (let ((bare (bare-events-from-log log)))
    (setf (getf (getf (second bare) :payload) :position) :peace)
    (rebuild-receipt-log bare)))

(print-section "ORIGINAL RECEIPT AND OUTSIDE CHECKPOINT")
(let* ((original (make-original-log))
       (checkpoint
         (witness-receipt original :outside-archivist
                          :declared-relation :external-to-curator
                          :notes :copied-before-publication))
       (original-report (verify-receipt-log original)))
  (format t "Original verification: ~S~%" original-report)
  (format t "Checkpoint: ~S~%" checkpoint)
  (check (getf original-report :internally-valid)
         "the original log is internally self-consistent")

  (print-section "NAIVE IN-PLACE EDIT, STORED HASHES UNCHANGED")
  (let* ((naive (naively-edit-cato-in-place (make-original-log)))
         (naive-report (verify-receipt-log naive))
         (failures (getf naive-report :failures)))
    (format t "Naively edited verification: ~S~%" naive-report)
    (check (not (getf naive-report :internally-valid))
           "an in-place payload edit breaks internal verification")
    (check (find :event-hash-mismatch failures
                 :key (lambda (failure) (getf failure :failure))
                 :test #'eq)
           "the naive edit is exposed as an event-hash mismatch"))

  (print-section "REWRITTEN HISTORY, FULLY RECHAINED")
  (let* ((forged (rewrite-cato-as-peace original))
         (forged-report (verify-receipt-log forged))
         (custody-report
           (verify-custody-checkpoint forged checkpoint)))
    (format t "Forged internal verification: ~S~%" forged-report)
    (format t "External custody comparison: ~S~%" custody-report)
    (check (getf forged-report :internally-valid)
           "a curator can recompute a clean internal chain after rewriting history")
    (check-equal :witnessed-prefix-diverges
                 (getf custody-report :standing)
                 "the outside checkpoint contradicts the rewritten prefix")
    (check (not (getf custody-report :checkpoint-match))
           "internal validity does not erase externally witnessed divergence")

    (print-section "CLAIMS SPLIT")
    (let ((verdict
            (list
             :receipt-self-consistency :established
             :event-truthfulness :not-established
             :event-completeness :not-established
             :cryptographic-collision-resistance :not-established
             :custodian-identity-authentication :not-established
             :prefix-divergence :established
             :standing :architecture-demonstration-only)))
      (format t "~S~%" verdict)
      (check-equal :architecture-demonstration-only
                   (getf verdict :standing)
                   "the toy digest is not promoted to production tamper evidence"))))
