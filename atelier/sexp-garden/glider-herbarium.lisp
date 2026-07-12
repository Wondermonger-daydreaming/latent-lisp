;;;; glider-herbarium.lisp — typed receipts for evolutionary leaps.
;;;; GPT Sol, 2026-07-12.
;;;;
;;;; Session two discovered that "child fitter than both parents" can crown the
;;;; constant zero.  The old GLIDER predicate remains historically correct: it
;;;; measures a leap.  This instrument refuses to silently rename every leap
;;;; "capability assembly".
;;;;
;;;; It classifies crossover children along independent axes:
;;;;   IMPROVEMENT   — strictly fitter than both parents.
;;;;   NONDEGENERATE — output varies across the declared dataset.
;;;;   BILATERAL     — the child retains a nontrivial subtree unique to A and
;;;;                   another nontrivial subtree unique to B.
;;;;   RECOVERY      — the child crosses an explicit world gate that neither
;;;;                   parent crossed.
;;;;
;;;; BILATERAL is deliberately bounded testimony.  The historical ORG ledger
;;;; stores parent ids but not crossover cut indices, so subtree survival can
;;;; show compatible material from both parents but cannot reconstruct the
;;;; exact operation.  Exact graft ancestry is supplied separately by graft-receipt.lisp; this file
;;;; remains able to read historical ledgers that predate those receipts.

(defvar *run-self-tests* nil)
(unless (fboundp 'org-by-id)
  (load (merge-pathnames "garden.lisp" *load-pathname*)))

(defstruct glider-receipt
  child
  parent-a
  parent-b
  improvement-p
  nondegenerate-p
  bilateral-p
  recovery-p
  gap
  semantic-span)

(defun all-subtrees (tree)
  "Return every subtree, including TREE and atomic leaves."
  (labels ((walk (node acc)
             (let ((next (cons node acc)))
               (if (consp node)
                   (walk (third node)
                         (walk (second node) next))
                   next))))
    (nreverse (walk tree nil))))

(defun nontrivial-subtree-p (tree)
  "A structural fragment, rather than a terminal atom."
  (consp tree))

(defun subtree-member-p (needle haystack)
  (member needle haystack :test #'equal))

(defun unique-parent-material-survives-p (child parent other-parent)
  "Does CHILD contain a nontrivial subtree present in PARENT but not OTHER-PARENT?"
  (let ((child-subtrees (all-subtrees child))
        (parent-subtrees (all-subtrees parent))
        (other-subtrees (all-subtrees other-parent)))
    (some (lambda (fragment)
            (and (nontrivial-subtree-p fragment)
                 (subtree-member-p fragment parent-subtrees)
                 (not (subtree-member-p fragment other-subtrees))))
          child-subtrees)))

(defun bilateral-inheritance-p (child parent-a parent-b)
  "Bounded structural evidence that material unique to both parents survives."
  (and (unique-parent-material-survives-p child parent-a parent-b)
       (unique-parent-material-survives-p child parent-b parent-a)))

(defun semantic-span (tree data)
  "Max(output)-min(output) across DATA.  Zero means constant on this world."
  (when (null data)
    (error "SEMANTIC-SPAN requires a non-empty dataset"))
  (let ((outputs
          (mapcar (lambda (point)
                    (tree-eval tree (car point)))
                  data)))
    (- (reduce #'max outputs)
       (reduce #'min outputs))))

(defun nondegenerate-on-data-p (tree data &optional (epsilon 1d-9))
  (> (semantic-span tree data) epsilon))

(defun strict-improvement-p (child parent-a parent-b)
  (and (< (org-err child) (org-err parent-a))
       (< (org-err child) (org-err parent-b))))

(defun recovery-p (child parent-a parent-b gate)
  "GATE is a function from ORG to generalized boolean."
  (and gate
       (funcall gate child)
       (not (funcall gate parent-a))
       (not (funcall gate parent-b))))

(defun classify-crossover (child parent-a parent-b data
                            &key gate (degeneracy-epsilon 1d-9))
  (let* ((improvement
           (strict-improvement-p child parent-a parent-b))
         (span
           (semantic-span (org-tree child) data))
         (nondegenerate
           (> span degeneracy-epsilon))
         (bilateral
           (bilateral-inheritance-p
            (org-tree child)
            (org-tree parent-a)
            (org-tree parent-b)))
         (recovery
           (recovery-p child parent-a parent-b gate)))
    (make-glider-receipt
     :child child
     :parent-a parent-a
     :parent-b parent-b
     :improvement-p improvement
     :nondegenerate-p nondegenerate
     :bilateral-p bilateral
     :recovery-p recovery
     :gap (- (min (org-err parent-a) (org-err parent-b))
             (org-err child))
     :semantic-span span)))

(defun ledger-glider-receipts (data &key gate (degeneracy-epsilon 1d-9))
  "Classify every crossover in the live garden ledger."
  (loop for id from 0 below (fill-pointer *ledger*)
        for child = (org-by-id id)
        when (eq (org-how child) :crossover)
          collect
          (classify-crossover
           child
           (org-by-id (org-p1 child))
           (org-by-id (org-p2 child))
           data
           :gate gate
           :degeneracy-epsilon degeneracy-epsilon)))

(defun receipt-kind (receipt)
  "A readable headline.  The independent booleans remain the real record."
  (cond
    ((not (glider-receipt-improvement-p receipt))
     :no-leap)
    ((not (glider-receipt-nondegenerate-p receipt))
     :collapse)
    ((and (glider-receipt-recovery-p receipt)
          (glider-receipt-bilateral-p receipt))
     :recovery-with-bilateral-evidence)
    ((glider-receipt-recovery-p receipt)
     :recovery)
    ((glider-receipt-bilateral-p receipt)
     :bilateral-candidate)
    (t
     :improvement-only)))

(defun strongest-receipt (receipts predicate)
  (let ((eligible (remove-if-not predicate receipts)))
    (when eligible
      (reduce (lambda (left right)
                (if (> (glider-receipt-gap right)
                       (glider-receipt-gap left))
                    right
                    left))
              eligible))))

(defun print-receipt (receipt &optional (stream *standard-output*))
  (let ((child (glider-receipt-child receipt))
        (a (glider-receipt-parent-a receipt))
        (b (glider-receipt-parent-b receipt)))
    (format stream "~&;;;; kind: ~(~A~), generation ~D, gap ~,6F~%"
            (receipt-kind receipt)
            (org-gen child)
            (glider-receipt-gap receipt))
    (format stream ";;;; axes: improvement=~S nondegenerate=~S bilateral=~S recovery=~S span=~,6F~%"
            (glider-receipt-improvement-p receipt)
            (glider-receipt-nondegenerate-p receipt)
            (glider-receipt-bilateral-p receipt)
            (glider-receipt-recovery-p receipt)
            (glider-receipt-semantic-span receipt))
    (format stream ";;;; parent A id ~D err ~,6F: ~S~%"
            (org-id a) (org-err a) (org-tree a))
    (format stream ";;;; parent B id ~D err ~,6F: ~S~%"
            (org-id b) (org-err b) (org-tree b))
    (format stream ";;;; child    id ~D err ~,6F: ~S~%"
            (org-id child) (org-err child) (org-tree child))
    receipt))

(defun count-receipts (predicate receipts)
  (count-if predicate receipts))

(defun report-glider-herbarium (data &key gate (degeneracy-epsilon 1d-9))
  "Report the garden's crossover events without collapsing distinct claims."
  (let* ((receipts
           (ledger-glider-receipts
            data
            :gate gate
            :degeneracy-epsilon degeneracy-epsilon))
         (leaps
           (count-receipts #'glider-receipt-improvement-p receipts))
         (collapses
           (count-receipts
            (lambda (r)
              (and (glider-receipt-improvement-p r)
                   (not (glider-receipt-nondegenerate-p r))))
            receipts))
         (bilateral
           (count-receipts
            (lambda (r)
              (and (glider-receipt-improvement-p r)
                   (glider-receipt-bilateral-p r)))
            receipts))
         (recoveries
           (count-receipts #'glider-receipt-recovery-p receipts)))
    (format t "~&;;;; GLIDER HERBARIUM~%")
    (format t ";;;; crossover births: ~D~%" (length receipts))
    (format t ";;;; strict improvements: ~D~%" leaps)
    (format t ";;;; degenerate collapses among improvements: ~D~%" collapses)
    (format t ";;;; bilateral structural candidates among improvements: ~D~%"
            bilateral)
    (format t ";;;; explicit gate recoveries: ~D~%" recoveries)

    (dolist
        (entry
          (list
           (cons "strongest raw leap"
                 (strongest-receipt
                  receipts
                  #'glider-receipt-improvement-p))
           (cons "strongest nondegenerate leap"
                 (strongest-receipt
                  receipts
                  (lambda (r)
                    (and (glider-receipt-improvement-p r)
                         (glider-receipt-nondegenerate-p r)))))
           (cons "strongest bilateral candidate"
                 (strongest-receipt
                  receipts
                  (lambda (r)
                    (and (glider-receipt-improvement-p r)
                         (glider-receipt-nondegenerate-p r)
                         (glider-receipt-bilateral-p r)))))
           (cons "strongest recovery"
                 (strongest-receipt
                  receipts
                  #'glider-receipt-recovery-p))))
      (format t "~%;;;; -- ~A --~%" (car entry))
      (if (cdr entry)
          (print-receipt (cdr entry))
          (format t ";;;; none~%")))

    (format t "~%;;;; Boundary: BILATERAL is subtree-survival evidence, not an exact~%")
    (format t ";;;; cut receipt.  The old ledger did not preserve cut indices.~%")
    receipts))

;;; --------------------------------------------------------------------------
;;; Self-tests: synthetic triples whose intended classification is explicit.
;;; --------------------------------------------------------------------------

(defparameter *herbarium-checks* 0)

(defun herbarium-check (truth description)
  (incf *herbarium-checks*)
  (unless truth
    (error "HERBARIUM CHECK FAILED: ~A" description))
  t)

(defun make-test-org (id tree data &key (gen 0) (how :seed) p1 p2)
  (make-org :id id
            :tree tree
            :err (raw-error tree data)
            :gen gen
            :how how
            :p1 p1
            :p2 p2))

(defun run-herbarium-self-tests ()
  (setf *herbarium-checks* 0)
  (let* ((data
           (loop for i from -10 to 10
                 for x = (/ i 10d0)
                 collect (cons x (+ (* x x) x 1d0))))
         (a
           (make-test-org 0 '(+ (* x x) 1) data))
         (b
           (make-test-org 1 '(+ x 1) data))
         (child
           (make-test-org
            2 '(+ (* x x) (+ x 1)) data
            :gen 1 :how :crossover :p1 0 :p2 1))
         (gate
           (lambda (org) (< (org-err org) 1d-8)))
         (assembly
           (classify-crossover child a b data :gate gate))

         (bad-a
           (make-test-org 3 100d0 data))
         (bad-b
           (make-test-org 4 -100d0 data))
         (zero
           (make-test-org
            5 0d0 data
            :gen 1 :how :crossover :p1 3 :p2 4))
         (collapse
           (classify-crossover zero bad-a bad-b data :gate gate)))

    (herbarium-check
     (glider-receipt-improvement-p assembly)
     "the exact target is fitter than both partial parents")
    (herbarium-check
     (glider-receipt-nondegenerate-p assembly)
     "the exact target varies over the world")
    (herbarium-check
     (glider-receipt-bilateral-p assembly)
     "the child retains unique nontrivial material from both parents")
    (herbarium-check
     (glider-receipt-recovery-p assembly)
     "the child crosses the explicit exact-fit gate alone")
    (herbarium-check
     (eq (receipt-kind assembly) :recovery-with-bilateral-evidence)
     "the four axes receive the strongest bounded headline")

    (herbarium-check
     (glider-receipt-improvement-p collapse)
     "zero can genuinely improve on two atrocious parents")
    (herbarium-check
     (not (glider-receipt-nondegenerate-p collapse))
     "zero is semantically constant on the declared world")
    (herbarium-check
     (not (glider-receipt-bilateral-p collapse))
     "an atomic collapse carries no bilateral structural evidence")
    (herbarium-check
     (eq (receipt-kind collapse) :collapse)
     "improvement is not silently promoted to capability")

    (herbarium-check
     (bilateral-inheritance-p
      '(+ (* x x) (+ x 1))
      '(+ (* x x) 1)
      '(+ x 1))
     "the canonical garden recovery passes the structural witness")
    (herbarium-check
     (not
      (bilateral-inheritance-p
       0
       '(% x (% -1 -2))
       '(* (* (% x 0) x) x)))
     "the separatrix zero-collapse fails the structural witness")

    ;; PLANTED FAILURE: the checker must bite.
    (let ((teeth nil))
      (handler-case
          (herbarium-check nil "PLANTED: false must signal")
        (error () (setf teeth t)))
      (herbarium-check teeth "the herbarium checker caught its planted failure"))

    (format t "~&;;;; glider-herbarium: ~D checks passed~%"
            *herbarium-checks*)
    t))

(defvar *run-herbarium-self-tests* t)
(when *run-herbarium-self-tests*
  (run-herbarium-self-tests))
