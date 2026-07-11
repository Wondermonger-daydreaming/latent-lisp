;;;; museum-nocturnum.lisp — Night Shift at the Museum
;;;; The dead are preserved. Preservation does not grant a vote in the present.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.museum-nocturnum
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.museum-nocturnum)

(reset-clock 7500)

(defstruct museum-item
  id text proposition preservation-status retrieval-eligibility current-standing
  historical-significance quarantine-reason witness-status salience supersedes)
(defstruct museum-hit item resemblance display-score support-eligible reason)

(defun support-current-p (item)
  (and (eq (museum-item-retrieval-eligibility item) :eligible)
       (eq (museum-item-current-standing item) :active)
       (eq (museum-item-witness-status item) :verified)))

(defun night-recall (pattern items)
  "Return everything relevant enough to inspect; voting eligibility remains explicit."
  (stable-sort
   (mapcar
    (lambda (item)
      (let* ((resemblance (overlap-similarity pattern
                                               (museum-item-proposition item)))
             (score (+ resemblance
                       (museum-item-salience item)
                       (* 0.1 (museum-item-historical-significance item)))))
        (make-museum-hit
         :item item :resemblance resemblance :display-score score
         :support-eligible (support-current-p item)
         :reason
         (cond
           ((eq (museum-item-current-standing item) :retracted) :retracted)
           ((eq (museum-item-retrieval-eligibility item) :quarantined) :quarantined)
           ((eq (museum-item-current-standing item) :superseded) :superseded)
           ((not (eq (museum-item-witness-status item) :verified)) :unverified)
           (t :eligible)))))
    items)
   #'> :key #'museum-hit-display-score))

(banner "museum nocturnum")

(let* ((vivid-falsehood
         (make-museum-item
          :id :beautiful-error
          :text "The moon remembers every password."
          :proposition '(moon remembers every password)
          :preservation-status :preserved
          :retrieval-eligibility :eligible
          :current-standing :retracted
          :historical-significance 1.0
          :witness-status :refuted
          :salience 0.8))
       (dull-current
         (make-museum-item
          :id :median-record
          :text "Execution certificate: median = 7."
          :proposition '(median 5 9 87 3 equals 7)
          :preservation-status :preserved
          :retrieval-eligibility :eligible
          :current-standing :active
          :historical-significance 0.2
          :witness-status :verified
          :salience 0.05))
       (foreign
         (make-museum-item
          :id :foreign-certificate
          :text "Unknown notary claims the median is 999."
          :proposition '(median 5 9 87 3 equals 999)
          :preservation-status :preserved
          :retrieval-eligibility :quarantined
          :current-standing :inactive
          :historical-significance 0.4
          :quarantine-reason :unknown-authority
          :witness-status :unknown
          :salience 0.5))
       (old-taxonomy
         (make-museum-item
          :id :taxonomy-v1
          :text "Old classification: ambiguity is one undifferentiated kind."
          :proposition '(ambiguity has one kind)
          :preservation-status :preserved
          :retrieval-eligibility :eligible
          :current-standing :superseded
          :historical-significance 0.9
          :witness-status :historical
          :salience 0.3
          :supersedes nil))
       (items (list vivid-falsehood dull-current foreign old-taxonomy))
       (hits (night-recall '(moon median password ambiguity) items)))
  (format t "the museum opens its cases at midnight:~%")
  (dolist (hit hits)
    (let ((item (museum-hit-item hit)))
      (format t "   display ~,3f  vote? ~a  standing=~a  ~a~%"
              (museum-hit-display-score hit)
              (museum-hit-support-eligible hit)
              (museum-item-current-standing item)
              (museum-item-text item))
      (unless (museum-hit-support-eligible hit)
        (format t "      withheld because: ~a~%" (museum-hit-reason hit)))))

  (section "gates:")
  (ensure (eq (museum-item-id (museum-hit-item (first hits))) :beautiful-error)
          "vivid historical falsehood did not surface for inspection")
  (pass "retracted-item-still-retrievable")
  (ensure (not (support-current-p vivid-falsehood))
          "retracted falsehood voted in present")
  (pass "retracted-item-cannot-support")
  (ensure (support-current-p dull-current)
          "active verified artifact lost its vote")
  (pass "active-verified-item-can-support")
  (ensure (not (support-current-p foreign))
          "quarantined artifact escaped quarantine")
  (pass "quarantine-blocks-support")
  (ensure (eq (museum-item-preservation-status vivid-falsehood) :preserved)
          "retraction erased history")
  (pass "retraction-does-not-delete")
  (ensure (and (eq (museum-item-current-standing old-taxonomy) :superseded)
               (eq (museum-item-preservation-status old-taxonomy) :preserved))
          "superseded taxonomy was overwritten")
  (pass "superseded-remains-diffable")

  (format t "~%[the museum preserved every corpse and counted only the living witnesses]~%~%"))

(format t "── keep the dead. do not let every corpse vote in the present. ──~%")
