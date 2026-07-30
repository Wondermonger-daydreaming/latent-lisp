;;;; interpretation.lisp — vertical-interpretation-0 (contract §10).
;;;;
;;;; PROJECTION ≠ INTERPRETATION.  The deterministic interpretation stage
;;;; classifies each projection's STRUCTURAL CLASS (present / empty /
;;;; invalid / absent-mapped) by validating the tiny declared grammar of
;;;; its shape row against the identified absence table — never claiming
;;;; factual truth or quality from parseability.  Each run journals a
;;;; transformation receipt: procedure identity + version, input
;;;; projection identity, output identity (contract: "claim copied
;;;; without transformation receipt" is an integration defect).
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun %projection-structural-class (status)
  "The declared grammar: a projection's kernel manifestation status maps
to exactly one structural class; anything else refuses."
  (cond ((equal status "present") "present")
        ((equal status "present-empty") "empty")
        ((equal status "present-invalid") "invalid")
        ((equal status "present-partial") "partial")
        ((equal status "absent") "absent-mapped")
        (t (error "interpretation: projection status ~s is outside the ~
                   declared grammar" status))))

(defun vertical-interpretation-0 (projection-body &key seat-id namespace)
  "Interpret one projection record (its BODY record datum; NAMESPACE is
\"ap0\" for live projections, \"vertical\" for recovery projections).
Returns (values transformation-receipt structural-class)."
  (let* ((receipt-id (body-string projection-body namespace
                                  "projection-receipt-id"))
         (shape (body-string projection-body namespace "shape"))
         (status (body-string projection-body namespace
                              "kernel-manifestation-status"))
         (row (absence-row-for-shape shape)))
    (unless receipt-id
      (error "interpretation: projection for seat ~a has no receipt id"
             seat-id))
    (unless row
      (error "interpretation: shape ~s outside the identified table" shape))
    (unless (equal status (absence-row-status row))
      (error "interpretation: projection status ~s disagrees with the ~
              table's row for shape ~s (~s)" status shape
             (absence-row-status row)))
    (let ((class (%projection-structural-class status)))
      (values
       (v-rec '("vertical" "record-kind")
              (v-id "record" "transformation-receipt")
              '("vertical" "transformation-id")
              (v-str (format nil "interp-~a" seat-id))
              '("vertical" "procedure-id")
              (v-str "vertical-interpretation-0")
              '("vertical" "procedure-version") (v-int 0)
              '("vertical" "input-projection-receipt-id") (v-str receipt-id)
              '("vertical" "output-id")
              (v-str (format nil "interp-~a-out" seat-id))
              '("vertical" "structural-class") (v-str class))
       class))))
