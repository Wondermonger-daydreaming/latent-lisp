;;;; speculum-bifrons.lisp — The Two-Faced Mirror
;;;; Structural reader and latent reader share a source but not an office.
;;;; The first says what was written. The second proposes what it might mean.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.speculum-bifrons
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.speculum-bifrons)

(reset-clock 7300)

(defstruct structural-form source canonical digest)
(defstruct noema source-digest frame reading register grade route residue warrant)

(defun structural-read (text)
  (let ((form (safe-read-one text)))
    (make-structural-form :source text
                          :canonical form
                          :digest (toy-digest (canonical-string form)))))

(defun structural-meaning (structural)
  (declare (ignore structural))
  (error "the structural reader establishes form, not intended meaning"))

(defun latent-read (structural frame)
  "Deterministic interpretive stub. It returns readings, never rewrites the source."
  (let* ((form (structural-form-canonical structural))
         (payload (second form))
         (source-digest (structural-form-digest structural)))
    (unless (and (consp form) (eq (first form) 'utterance))
      (error "expected (UTTERANCE PAYLOAD), got ~s" form))
    (cond
      ((eq frame :medical)
       (list
        (make-noema :source-digest source-digest :frame frame
                    :reading (list :possible-state :low-body-temperature :text payload)
                    :register :clinical :grade :plausible
                    :route '(:lexeme-cold :patient-domain :physiology)
                    :residue '(:measurement-missing)
                    :warrant '(:domain-frame :ordinary-clinical-usage))
        (make-noema :source-digest source-digest :frame frame
                    :reading (list :possible-state :poor-perfusion :text payload)
                    :register :clinical :grade :possible
                    :route '(:lexeme-cold :patient-domain :circulation)
                    :residue '(:location-and-vitals-missing)
                    :warrant '(:domain-frame))))
      ((eq frame :psychological)
       (list
        (make-noema :source-digest source-digest :frame frame
                    :reading (list :possible-trait :emotionally-distant :text payload)
                    :register :psychological :grade :plausible
                    :route '(:lexeme-cold :metaphorical-usage)
                    :residue '(:speaker-intent-missing)
                    :warrant '(:ordinary-metaphor))))
      (t
       (list
        (make-noema :source-digest source-digest :frame frame
                    :reading (list :unresolved payload)
                    :register :open :grade :unknown
                    :route '(:frame-unrecognized)
                    :residue '(:all-intent)
                    :warrant nil))))))

(defun validate-noema (structural noema)
  (and (string= (structural-form-digest structural)
                (noema-source-digest noema))
       (noema-frame noema)
       (noema-reading noema)))

(defun malicious-latent-read (structural)
  "An interpreter tries to smuggle a rewritten source into its reading."
  (make-noema :source-digest "FORGED-SOURCE"
              :frame :medical :reading '(:patient-is-dead)
              :register :clinical :grade :certain
              :route '(:because-the-model-said-so)
              :residue nil :warrant nil))

(banner "speculum bifrons")

(let* ((source "(utterance \"The patient is cold.\")")
       (structural (structural-read source))
       (medical (latent-read structural :medical))
       (psychological (latent-read structural :psychological)))
  (format t "source:      ~a~%" (structural-form-source structural))
  (format t "structural:  ~s~%" (structural-form-canonical structural))
  (format t "digest:      ~a~%~%" (structural-form-digest structural))

  (format t "MEDICAL FRAME proposes:~%")
  (dolist (n medical)
    (format t "   ~s  grade=~a  residue=~s~%"
            (noema-reading n) (noema-grade n) (noema-residue n)))
  (format t "~%PSYCHOLOGICAL FRAME proposes:~%")
  (dolist (n psychological)
    (format t "   ~s  grade=~a  residue=~s~%"
            (noema-reading n) (noema-grade n) (noema-residue n)))

  (section "gates:")
  (ensure (every (lambda (n) (validate-noema structural n)) medical)
          "medical reading detached from source")
  (pass "medical-readings-source-linked")
  (ensure (every (lambda (n) (validate-noema structural n)) psychological)
          "psychological reading detached from source")
  (pass "psychological-readings-source-linked")
  (ensure (equal (structural-form-canonical structural)
                 (safe-read-one source))
          "interpretation mutated structural form")
  (pass "source-form-untouched")
  (ensure (signals-error-p (lambda () (structural-meaning structural)))
          "structural reader impersonated an interpreter")
  (pass "structural-reader-refuses-intention")
  (ensure (not (validate-noema structural
                               (malicious-latent-read structural)))
          "latent reader replaced the source")
  (pass "latent-reader-cannot-rewrite-source")
  (ensure (not (equal (noema-reading (first medical))
                      (noema-reading (first psychological))))
          "frames became decorative")
  (pass "frames-produce-different-readings")

  (format t "~%[one source, several readings; plurality remained typed and source-bound]~%~%"))

(format t "── one face keeps the letters. the other risks a meaning. neither steals the other’s office. ──~%")
