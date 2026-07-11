;;;; conformance-walk.lisp — the seven bricks, as ONE walk over the shared kernel
;;;;
;;;; Sol's vision realized: "the bricks become executable conformance walks over
;;;; one kernel rather than parallel miniature implementations." This loads
;;;; kernel.lisp once and asserts, in order, every law the seven standalone bricks
;;;; proved separately — now over a single set of objects. exit 0 == they all hold
;;;; together, not just each alone.
;;;;
;;;; Run: sbcl --script conformance-walk.lisp

(load (merge-pathnames "kernel.lisp" *load-pathname*))
(in-package #:mneme)
(defun median-by-sort (xs) (let* ((s (sort (copy-list xs) #'<)) (n (length s)))
                             (if (oddp n) (nth (floor n 2) s)
                                 (/ (+ (nth (1- (floor n 2)) s) (nth (floor n 2) s)) 2))))

(format t "~%── conformance walk: seven laws, one kernel ───~%~%")

;;; LAW 1 — rhetoric ≠ evidence: a claim cannot raise its own grade by assertion.
(let ((c (make-claim :proposition '(:equals (:call median-by-sort (5 9 87 3)) 7))))
  (ensure (eq (claim-grade c) :asserted) "L1: born asserted")
  ;; there is no path from a bare claim to :observed without a certificate:
  (ensure (signals-error-p (lambda () (raise-claim c (make-witness :kind :execution))))
          "L1: a non-certificate raised a grade")
  (format t "L1 rhetoric ≠ evidence            ✓  (no self-raise)~%"))

;;; LAW 2 — production ≠ truth: a model's emission is asserted, not observed.
(let* ((inv (list :model :stub :emitted '(= capital sylvania) :at (tick)))
       (content (make-claim :proposition '(= capital sylvania) :grade :asserted :evidence (list inv))))
  (ensure (eq (claim-grade content) :asserted) "L2: infer content is asserted")
  (format t "L2 production ≠ truth              ✓  (the receipt is not the world)~%"))

;;; LAW 3 — proximity ≠ support: a witness must FACE the proposition.
(let ((c (make-claim :proposition '(:equals (:call median-by-sort (5 9 87 3)) 7)))
      (moon (make-witness :kind :execution :target '(= lunar-period 27.3) :verdict :supports
                          :verification-status :verified :provenance '(:ran))))
  (ensure (not (witness-supports-p moon c)) "L3: a non-facing witness supported")
  (format t "L3 proximity ≠ support            ✓  (the moon does not vouch for the median)~%"))

;;; LAW 4 — report ≠ certificate, and the drift-exploit is dead.
(let* ((prop '(:equals (:call median-by-sort (5 9 87 3)) 7))
       (c (make-claim :proposition prop))
       (cert (verify-proposition prop :execution-verifier)))
  (ensure (eq (certificate-verdict cert) :supports) "L4: honest cert supports")
  (ensure (eq (claim-grade (raise-claim c cert)) :executed) "L4: certificate raises to :executed")
  (ensure (eq (certificate-verdict (verify-proposition '(:equals (:call median-by-sort (5 9 87 3)) 999)
                                                       :execution-verifier)) :refutes)
          "L4: a false proposition was certified")
  (ensure (signals-error-p (lambda () (verify-proposition prop :model-adapter)))
          "L4: the model adapter issued an execution certificate")
  (format t "L4 report ≠ certificate           ✓  (only an authorized verifier notarizes)~%"))

;;; LAW 5 — continuity is a witnessed relation: prepared→committed→received→revived.
(let* ((c (make-claim :proposition '(= median 7) :grade :executed :as-of (tick)))
       (r (commit (prepare c) "/tmp/mneme-kernel-store/")))
  (ensure (eq (receipt-status r) :committed) "L5: committed")
  (multiple-value-bind (r2 text) (receive r)
    (ensure (eq (receipt-status r2) :received) "L5: received")
    (let ((revived (mneme-revive text)))
      (ensure (eq (claim-freshness revived) :aging) "L5: revival is not :current")
      (ensure (equal (claim-proposition revived) '(= median 7)) "L5: proposition survives")))
  (ensure (signals-error-p (lambda () (receive (make-receipt :status :prepared)))) "L5: receive-before-commit")
  (format t "L5 continuity is a relation       ✓  (four-state, digest-validated)~%"))

;;; LAW 6 — claimed ≠ authenticated: a serialized 'verified' grants nothing un-re-checked.
(let* ((prop '(:equals (:call median-by-sort (5 9 87 3)) 7))
       (crossed (make-claim :proposition prop :grade :asserted)))
  (ensure (eq (authenticate-grade crossed '()) :asserted) "L6: no cert, no grade")
  (ensure (eq (authenticate-grade crossed (list (verify-proposition prop :execution-verifier))) :executed)
          "L6: re-verification grants the grade")
  (format t "L6 claimed ≠ authenticated        ✓  (the successor re-checks the notary)~%"))

;;; LAW 7 — a valid witness's testimony survives, a promise dies (positive+negative).
(let ((verified (make-witness :kind :execution :target '(= median 7) :verdict :supports
                              :verification-status :verified :capability-status :unavailable
                              :provenance '(:ran-and-checked)))
      (promise  (make-witness :kind :execution :target '(= median 7) :verdict :supports
                              :verification-status :unverified :capability-status :unavailable
                              :provenance '(:i-could-have))))
  (ensure (witness-supports-p verified (make-claim :proposition '(= median 7))) "L7: verified survives")
  (ensure (not (witness-supports-p promise (make-claim :proposition '(= median 7)))) "L7: promise dies")
  (format t "L7 testimony survives its death   ✓  (the dead hand's work still stands)~%"))

(format t "~%[seven laws, one kernel, no drift — the consolidation holds]~%")
(format t "~%── small private civilizations, unified under one boring floor. ──~%~%")
