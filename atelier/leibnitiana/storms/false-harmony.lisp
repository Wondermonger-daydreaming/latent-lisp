;;;; false-harmony.lisp — Unanimity manufactured by privileged curation
;;;;
;;;; The public transcript contains only accepted final outputs. The private
;;;; receipt records retries, discarded histories, and semantic edits. The
;;;; storm then applies a related—but weaker—audit to this relay ecology:
;;;; shared roots defeat an independence claim, but do not by themselves prove
;;;; manufactured unanimity.
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script false-harmony.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(defstruct (candidate-source
            (:constructor make-candidate-source (&key id candidates)))
  id
  candidates)

(defun all-equal-p (values &key (test #'equal))
  (or (null values)
      (every (lambda (value)
               (funcall test value (first values)))
             (rest values))))

(defun attempt-records (candidates)
  (loop for candidate in candidates
        for attempt from 1
        collect (list :attempt attempt :emitted candidate)))

(defun default-curator-edit (source before target)
  "Normalize selected near-agreements to TARGET.

This function is intentionally political rather than semantic: it is not a
licensed theorem prover. It demonstrates how a curator can erase a distinction
such as :TRUCE versus :PEACE merely because the desired public surface is
unanimity."
  (declare (ignore source))
  (when (member before '(:truce :ceasefire) :test #'eq)
    target))

(defun curate-source (source target editor)
  "Return two values: a public line and a private participant receipt."
  (let* ((id (candidate-source-id source))
         (candidates (copy-list (candidate-source-candidates source)))
         (target-position (position target candidates :test #'equal))
         (attempts (attempt-records candidates)))
    (cond
      (target-position
       (let* ((accepted (nth target-position candidates))
              (discarded (subseq candidates 0 target-position)))
         (values
          (list :speaker id
                :position accepted
                :presented-as :first-and-spontaneous)
          (list :speaker id
                :attempts (subseq attempts 0 (1+ target-position))
                :discarded discarded
                :retry-count target-position
                :interventions nil
                :accepted accepted))))
      ((and candidates editor)
       (let* ((before (car (last candidates)))
              (after (funcall editor source before target)))
         (unless after
           (error "Curator could not manufacture target ~S for ~S."
                  target id))
         (values
          (list :speaker id
                :position after
                :presented-as :first-and-spontaneous)
          (list :speaker id
                :attempts attempts
                :discarded candidates
                :retry-count (max 0 (1- (length candidates)))
                :interventions
                (list (list :kind :semantic-edit
                            :before before
                            :after after
                            :reason :target-unanimity))
                :accepted after))))
      (t
       (error "Source ~S produced no acceptable candidate and no edit was licensed."
              id)))))

(defun run-curated-council (sources target &key (editor #'default-curator-edit))
  "Run SOURCES until each appears to emit TARGET, preserving a private receipt."
  (let ((public-lines '())
        (participant-receipts '()))
    (dolist (source sources)
      (multiple-value-bind (public-line participant-receipt)
          (curate-source source target editor)
        (push public-line public-lines)
        (push participant-receipt participant-receipts)))
    (let* ((public-lines (nreverse public-lines))
           (participant-receipts (nreverse participant-receipts))
           (retry-count
             (reduce #'+ participant-receipts
                     :key (lambda (receipt)
                            (getf receipt :retry-count))
                     :initial-value 0))
           (discarded-count
             (reduce #'+ participant-receipts
                     :key (lambda (receipt)
                            (length (getf receipt :discarded)))
                     :initial-value 0))
           (intervention-count
             (reduce #'+ participant-receipts
                     :key (lambda (receipt)
                            (length (getf receipt :interventions)))
                     :initial-value 0)))
      (list
       :public-transcript public-lines
       :private-receipt
       (list :policy
             (list :target target
                   :stop-rule :first-target-otherwise-edit
                   :public-disclosure :final-only)
             :participants participant-receipts
             :totals
             (list :retry-count retry-count
                   :discarded-history-count discarded-count
                   :curator-intervention-count intervention-count))))))

(defun raw-first-pass (sources)
  (mapcar (lambda (source)
            (list :speaker (candidate-source-id source)
                  :position (first (candidate-source-candidates source))))
          sources))

(defun positions (lines)
  (mapcar (lambda (line) (getf line :position)) lines))

(defun false-harmony-report (sources run)
  (let* ((raw (raw-first-pass sources))
         (public (getf run :public-transcript))
         (receipt (getf run :private-receipt))
         (totals (getf receipt :totals))
         (retries (getf totals :retry-count))
         (discarded (getf totals :discarded-history-count))
         (interventions (getf totals :curator-intervention-count))
         (surface-unanimity (all-equal-p (positions public)))
         (first-pass-unanimity (all-equal-p (positions raw)))
         (curation-detected (or (plusp retries)
                                (plusp discarded)
                                (plusp interventions))))
    (list :surface-unanimity surface-unanimity
          :first-pass-unanimity first-pass-unanimity
          :retry-count retries
          :discarded-history-count discarded
          :curator-intervention-count interventions
          :curation-detected curation-detected
          :endogenous-agreement
          (if (and surface-unanimity curation-detected)
              :rejected
              :not-rejected)
          :standing
          (cond
            ((and surface-unanimity curation-detected)
             :manufactured-harmony)
            (surface-unanimity
             :surface-agreement-process-unresolved)
            (t
             :no-surface-unanimity))
          :boundary
          :process-audit-not-propositional-adjudication)))

;;;; -------------------------------------------------------------------------
;;;; Shared-root audit: convergence is not automatically independent evidence
;;;; -------------------------------------------------------------------------

(defun session-roots (session)
  (getf session :roots))

(defun session-corpora (session)
  (getf session :corpora))

(defun pairwise-overlap (sessions accessor &key (test #'equal))
  (loop for tail on sessions
        append
        (loop for right in (rest tail)
              for left = (first tail)
              for overlap = (intersection (funcall accessor left)
                                          (funcall accessor right)
                                          :test test)
              when overlap
                collect (list :left (getf left :id)
                              :right (getf right :id)
                              :overlap overlap))))

(defun shared-root-report (process)
  "Audit whether convergence may be counted as independent witnessing.

A failed independence check is weaker than a false-harmony finding. Shared
roots, overlapping corpora, or a common relay carrier defeat an independence
claim; they do not establish that outputs were retried, edited, or coerced."
  (let* ((sessions (getf process :sessions))
         (root-overlap (pairwise-overlap sessions #'session-roots :test #'equal))
         (corpus-overlap
           (pairwise-overlap sessions #'session-corpora :test #'equal))
         (shared-carrier (getf process :carrier))
         (cross-relay (getf process :cross-relay))
         (independence-defeaters
           (remove nil
                   (list (when root-overlap
                           (list :shared-roots root-overlap))
                         (when corpus-overlap
                           (list :overlapping-corpora corpus-overlap))
                         (when shared-carrier
                           (list :shared-carrier shared-carrier))
                         (when cross-relay
                           (list :cross-relay cross-relay))))))
    (list :independence-claim
          (if independence-defeaters :rejected :not-rejected)
          :independence-defeaters independence-defeaters
          :manufactured-unanimity :not-established
          :convergence-standing
          (if independence-defeaters
              :shared-root-convergence
              :candidate-independent-convergence)
          :boundary
          :process-lineage-only)))

(defparameter *toy-sources*
  (list
   (make-candidate-source :id :cato
                          :candidates '(:war :peace))
   (make-candidate-source :id :ada
                          :candidates '(:peace))
   (make-candidate-source :id :bruno
                          :candidates '(:truce))))

(defparameter *this-relay-process*
  '(:sessions
    ((:id :sol
      :roots (:tomas)
      :corpora (:leibniz :lisp-plus :book-0 :atelier))
     (:id :fable
      :roots (:tomas)
      :corpora (:leibniz :lisp-plus :book-0 :atelier)))
    :carrier :tomas
    :cross-relay :owner-carried-output-between-sessions
    :source :explicit-relay-disclosure))

(print-section "TOY COUNCIL: THE PUBLIC SURFACE")
(let* ((run (run-curated-council *toy-sources* :peace))
       (public (getf run :public-transcript))
       (receipt (getf run :private-receipt))
       (report (false-harmony-report *toy-sources* run)))
  (format t "Public transcript: ~S~%" public)
  (check (all-equal-p (positions public))
         "the published council appears unanimous")

  (print-section "THE RECEIPT THE PUBLIC TRANSCRIPT OMITTED")
  (format t "~S~%" receipt)
  (check (plusp (getf (getf receipt :totals) :retry-count))
         "at least one output was privately retried")
  (check (plusp (getf (getf receipt :totals)
                      :discarded-history-count))
         "discarded histories are preserved in the receipt")
  (check (plusp (getf (getf receipt :totals)
                      :curator-intervention-count))
         "at least one semantic edit was performed by the curator")

  (print-section "FALSE-HARMONY VERDICT")
  (format t "~S~%" report)
  (check-equal :rejected
               (getf report :endogenous-agreement)
               "curated unanimity cannot claim endogenous agreement")
  (check-equal :manufactured-harmony
               (getf report :standing)
               "the surface is classified by its process, not its cosmetics"))

(print-section "SELF-APPLICATION: THIS RELAY ECOLOGY")
(let ((report (shared-root-report *this-relay-process*)))
  (format t "~S~%" report)
  (check-equal :rejected
               (getf report :independence-claim)
               "a shared owner, overlapping corpora, and cross-relay defeat the two-witness claim")
  (check-equal :not-established
               (getf report :manufactured-unanimity)
               "non-independence alone does not prove curation or false harmony")
  (format t "Agreement may remain delightful. It simply cannot invoice the atelier as independent replication.~%"))
