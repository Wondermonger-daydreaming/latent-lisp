;;;; de-characteristica.lisp — Interchange that carries how it was curated
;;;
;;;; A tiny prototype for Characteristica-as-IR. The source capsule carries
;;;; semantic content, translation lineage, process lineage, custody standing,
;;;; and explicit unknowns. A content-only translator produces an attractive
;;;; target while reporting that its process ancestry was dropped.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(defparameter +capsule-fields+
  '(:content :claim-status :boundary :authority
    :translation-lineage :process-lineage :custody :unknowns))

(defun make-capsule (&rest fields)
  fields)

(defun field-present-p (plist field)
  (loop for tail on plist by #'cddr
        thereis (eq (first tail) field)))

(defun translate-capsule (capsule preserve-fields target-view)
  "Return translated capsule and a loss receipt.

TARGET-VIEW is descriptive only; this specimen does not claim to implement the
aspirational Lumen, Fable-Lisp, or Prism-Lisp profiles."
  (let ((target (list :target-view target-view))
        (preserved '())
        (lost '()))
    (dolist (field +capsule-fields+)
      (cond
        ((and (member field preserve-fields :test #'eq)
              (field-present-p capsule field))
         (setf target (append target (list field (getf capsule field))))
         (push field preserved))
        ((field-present-p capsule field)
         (push (list :field field
                     :reason :not-in-preservation-policy)
               lost))))
    (values target
            (list :preserved (nreverse preserved)
                  :lost (nreverse lost)
                  :target-view target-view
                  :standing :declared-field-preservation-only))))

(defun loss-field-names (receipt)
  (mapcar (lambda (entry) (getf entry :field))
          (getf receipt :lost)))

(defparameter *source-capsule*
  (make-capsule
   :content '(:judgment "calculation requires standing")
   :claim-status :supported-within-essay
   :boundary :leibnitiana-conceptual-prototype
   :authority '(:author :sol :audit :fable :carrier :tomas)
   :translation-lineage
   '((:from :essay :to :lisp-specimen :loss :rhetorical-cadence))
   :process-lineage
   '((:event :drafted :actor :sol)
     (:event :runtime-audited :actor :fable)
     (:event :relayed :actor :tomas :selection-history :not-attested))
   :custody '(:external-checkpoint :not-established)
   :unknowns '(:private-retries :withheld-alternatives)))

(print-section "CONTENT-ONLY INTERCHANGE")
(multiple-value-bind (target receipt)
    (translate-capsule *source-capsule*
                       '(:content :claim-status :boundary)
                       :generic-target-a)
  (format t "Target: ~S~%Receipt: ~S~%" target receipt)
  (check (equal (getf target :content)
                (getf *source-capsule* :content))
         "semantic content survives the narrow translation")
  (check (member :process-lineage (loss-field-names receipt) :test #'eq)
         "the receipt names dropped process lineage")
  (check (member :custody (loss-field-names receipt) :test #'eq)
         "the receipt names dropped custody standing")

  (print-section "ROUND TRIP CANNOT RESURRECT OMITTED LINEAGE")
  (multiple-value-bind (returned return-receipt)
      (translate-capsule target +capsule-fields+ :generic-source-return)
    (declare (ignore return-receipt))
    (format t "Returned: ~S~%" returned)
    (check (not (field-present-p returned :process-lineage))
           "a later translator cannot recover ancestry that was never carried")))

(print-section "CONSTITUTIONAL INTERCHANGE")
(multiple-value-bind (target receipt)
    (translate-capsule *source-capsule*
                       +capsule-fields+
                       :generic-target-b)
  (format t "Target: ~S~%Receipt: ~S~%" target receipt)
  (check (null (getf receipt :lost))
         "the declared complete policy preserves every present capsule field")
  (check (field-present-p target :process-lineage)
         "process lineage travels with content rather than as backstage lore")
  (check-equal :not-established
               (getf (getf target :custody) :external-checkpoint)
               "interchange preserves an unknown without laundering it into assurance"))
