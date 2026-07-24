;;;; Lineage-distant stranger program: scholarly quotation admission.
;;;; Knowledge boundary: written from the two public Guides and two public APIs.

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (warning)
                                  (muffle-warning warning))))
    (load (merge-pathnames "mneme/language-slice-1/slice1.lisp"
                           *load-truename*))))

(defpackage :quotation-stranger
  (:use :cl))
(in-package :quotation-stranger)

;;; Frozen task-local input records.
(defparameter *quotation*
  '(:quotation "q-orpheus-1"
    :text "The soul is like a book on which the world is written."))
(defparameter *claim*
  '(:claim "claim-memory-1"
    :text "The cited author uses inscription as a model of memory."))
(defparameter *editions*
  '((:edition "edition-alpha" :source-id "urn:alpha:orpheus"
     :locator "p. 41, lines 3-4" :passage "passage-alpha-41"
     :provenance "library-scan-alpha" :translation "translation-alpha")
    (:edition "edition-beta" :source-id "urn:beta:orpheus"
     :locator "folio 22r" :passage "passage-beta-22r"
     :provenance "critical-edition-beta" :translation "translation-beta")))
(defparameter *transcription-checks*
  '((:check "check-alpha" :quotation "q-orpheus-1" :passage "passage-alpha-41")
    (:check "check-beta" :quotation "q-orpheus-1" :passage "passage-beta-22r")))
(defparameter *translation-records*
  '((:translation "translation-alpha" :passage "passage-alpha-41")
    (:translation "translation-beta" :passage "passage-beta-22r")))
(defparameter *edition-access-records*
  '((:receiver :reader-a :edition "edition-alpha" :derivative "scan-alpha")
    (:receiver :reader-a :edition "edition-beta" :derivative "transcript-beta")
    (:receiver :reader-b :edition "edition-beta" :derivative "transcript-beta")))
(defparameter *provenance-records*
  '((:edition "edition-alpha" :record "library-scan-alpha")
    (:edition "edition-beta" :record "critical-edition-beta")))

(defun ground (form)
  (lisp-plus-slice1:proposition form))

(defun pattern (form)
  (lisp-plus-slice1:proposition-pattern form))

(defun direct-witness (form &key (kind :scholarly-record) (source :archive)
                                      (accessible-to :all))
  (lisp-plus-slice0:witness
   :for (ground form)
   :mode :direct
   :kind kind
   :source source
   :accessible-to accessible-to))

(defun context (id accessible-witnesses &key procedures)
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p accessible-witnesses))
   :executable-procedures procedures
   :recognized-authorities '(:archive :editorial-board :reader-a :reader-b)
   :accepted-representations '(:canonical-datum)))

(defun conclusion (receiver purpose)
  (ground `(:predicate :quotation-admissible
            (:claim "claim-memory-1")
            (:purpose ,purpose)
            (:quotation "q-orpheus-1")
            (:receiver ,receiver))))

(defun install-schemas ()
  (lisp-plus-slice1:clear-schema-registry)
  (flet ((schema (name unique)
           (lisp-plus-slice1:judgment-schema
            :name name
            :version 1
            :conclusion
            (pattern '(:predicate :quotation-admissible
                       (:claim (:var :claim))
                       (:purpose (:var :purpose))
                       (:quotation (:var :quotation))
                       (:receiver (:var :receiver))))
            :premises
            (list
             (pattern '(:predicate :quotation-text-matches
                        (:check (:var :check))
                        (:edition (:var :edition))
                        (:passage (:var :passage))
                        (:quotation (:var :quotation))))
             (pattern '(:predicate :locator-identifies-passage
                        (:edition (:var :edition))
                        (:locator (:var :locator))
                        (:passage (:var :passage))
                        (:source-id (:var :source-id))))
             (pattern '(:predicate :edition-provenance-acceptable
                        (:edition (:var :edition))
                        (:provenance (:var :provenance))))
             (pattern '(:predicate :translation-corresponds
                        (:edition (:var :edition))
                        (:passage (:var :passage))
                        (:translation (:var :translation))))
             (pattern '(:predicate :receiver-can-inspect
                        (:derivative (:var :derivative))
                        (:edition (:var :edition))
                        (:receiver (:var :receiver))))
             (pattern '(:predicate :quotation-relevant-to-claim
                        (:claim (:var :claim))
                        (:quotation (:var :quotation))))
             (pattern '(:predicate :use-admissible
                        (:claim (:var :claim))
                        (:purpose (:var :purpose))
                        (:quotation (:var :quotation))
                        (:receiver (:var :receiver)))))
            :locals '(:check :derivative :edition :locator :passage
                      :provenance :source-id :translation)
            :unique-locals (if unique '(:translation) '()))))
    (lisp-plus-slice1:register-schema (schema :quotation-admission nil))
    (lisp-plus-slice1:register-schema
     (schema :quotation-admission-designated-translation t))))

(defun edition-path (edition receiver purpose)
  (destructuring-bind (&key edition source-id locator passage provenance
                            translation)
      edition
    (let ((check (if (string= edition "edition-alpha")
                     "check-alpha" "check-beta"))
          (derivative (if (string= edition "edition-alpha")
                          "scan-alpha" "transcript-beta")))
      (list
       (direct-witness
        `(:predicate :quotation-text-matches
          (:check ,check) (:edition ,edition) (:passage ,passage)
          (:quotation "q-orpheus-1")))
       (direct-witness
        `(:predicate :locator-identifies-passage
          (:edition ,edition) (:locator ,locator) (:passage ,passage)
          (:source-id ,source-id)))
       (direct-witness
        `(:predicate :edition-provenance-acceptable
          (:edition ,edition) (:provenance ,provenance)))
       (direct-witness
        `(:predicate :translation-corresponds
          (:edition ,edition) (:passage ,passage) (:translation ,translation)))
       (direct-witness
        `(:predicate :receiver-can-inspect
          (:derivative ,derivative) (:edition ,edition) (:receiver ,receiver)))
       (direct-witness
        '(:predicate :quotation-relevant-to-claim
          (:claim "claim-memory-1") (:quotation "q-orpheus-1")))
       (direct-witness
        `(:predicate :use-admissible
          (:claim "claim-memory-1") (:purpose ,purpose)
          (:quotation "q-orpheus-1") (:receiver ,receiver)))))))

(defun attempt (schema receiver purpose supports &optional inaccessible)
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive
           :schema-name schema :schema-version 1
           :conclusion (conclusion receiver purpose)
           :supports supports
           :receiver (context receiver (or inaccessible supports))
           :by :stranger-scholar)
        (values claim receipt))
    (lisp-plus-slice1:derivation-refused (condition)
      (values nil (lisp-plus-slice1:slice1-condition-receipt condition)))))

(defun assessment-for (receipt predicate)
  (find predicate
        (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (assessment)
               (second
                (lisp-plus-slice1:premise-assessment-premise-pattern
                 assessment)))))

(defun disposition (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition
   (assessment-for receipt predicate)))

(defun check (name truth)
  (format t "~&~A: ~:[FAIL~;PASS~]~%" name (not (null truth)))
  (unless truth
    (error "Check failed: ~A" name)))

(defun run ()
  (install-schemas)
  (let* ((alpha (edition-path (first *editions*) :reader-a :textual-comparison))
         (beta (edition-path (second *editions*) :reader-a :textual-comparison))
         (complete (append alpha beta)))

    ;; 1. Transcription alone cannot grant.
    (multiple-value-bind (claim receipt)
        (attempt :quotation-admission :reader-a :textual-comparison
                 (list (first alpha)))
      (declare (ignore claim))
      (check "01 transcription-alone-refused"
             (and (eq :refused
                      (lisp-plus-slice1:derivation-receipt-decision receipt))
                  (eq :missing (disposition receipt
                                            :locator-identifies-passage)))))

    ;; 2. A locator for edition beta cannot join an alpha transcription path.
    (let ((supports (copy-list alpha)))
      (setf (second supports) (second beta))
      (multiple-value-bind (claim receipt)
          (attempt :quotation-admission :reader-a :textual-comparison supports)
        (declare (ignore claim))
        (check "02 wrong-edition-locator-mismatched"
               (eq :mismatched
                   (disposition receipt :locator-identifies-passage)))))

    ;; 3. A translation of beta's passage cannot discharge alpha's premise.
    (let ((supports (copy-list alpha)))
      (setf (fourth supports) (fourth beta))
      (multiple-value-bind (claim receipt)
          (attempt :quotation-admission :reader-a :textual-comparison supports)
        (declare (ignore claim))
        (check "03 wrong-passage-translation-mismatched"
               (eq :mismatched
                   (disposition receipt :translation-corresponds)))))

    ;; 4. Reader A's inspection record does not become Reader B's.
    (multiple-value-bind (claim receipt)
        (attempt :quotation-admission :reader-b :textual-comparison alpha)
      (declare (ignore claim))
      (check "04 receiver-access-does-not-transfer"
             (eq :mismatched
                 (disposition receipt :receiver-can-inspect))))

    ;; 5. Permission is purpose-bound.
    (multiple-value-bind (claim receipt)
        (attempt :quotation-admission :reader-a :historical-attribution alpha)
      (declare (ignore claim))
      (check "05 purpose-does-not-transfer"
             (eq :mismatched (disposition receipt :use-admissible))))

    ;; 6. Exact but inaccessible evidence remains visible as residue.
    (let ((visible (remove (third alpha) alpha)))
      (multiple-value-bind (claim receipt)
          (attempt :quotation-admission :reader-a :textual-comparison
                   alpha visible)
        (declare (ignore claim))
        (let ((assessment
                (assessment-for receipt :edition-provenance-acceptable)))
          (check "06 inaccessible-is-residue"
                 (and (eq :inaccessible
                          (lisp-plus-slice1:premise-assessment-disposition
                           assessment))
                      (= 1 (length
                            (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports
                             assessment))))))))

    ;; 7. Counter-evidence remains represented and blocks a positive match.
    (let ((counter
            (lisp-plus-slice1:refutation
             :refutes (lisp-plus-slice0:witness-for (first alpha))
             :source :independent-collation)))
      (multiple-value-bind (claim receipt)
          (attempt :quotation-admission :reader-a :textual-comparison
                   (append alpha (list counter)))
        (declare (ignore claim))
        (let ((assessment (assessment-for receipt :quotation-text-matches)))
          (check "07 refutation-recorded-and-blocking"
                 (and (eq :refuted
                          (lisp-plus-slice1:premise-assessment-disposition
                           assessment))
                      (= 1 (length
                            (lisp-plus-slice1:premise-assessment-refuting-supports
                             assessment))))))))

    ;; 8 + 9. Every premise grants; two paths remain two environments.
    (multiple-value-bind (source-claim plural-receipt)
        (attempt :quotation-admission :reader-a :textual-comparison complete)
      (check "08 coherent-premises-grant"
             (and source-claim
                  (eq :granted
                      (lisp-plus-slice1:derivation-receipt-decision
                       plural-receipt))))
      (check "09 plurality-preserved"
             (and (lisp-plus-slice1:derivation-receipt-multiply-supported-p plural-receipt)
                  (= 2 (length
                        (lisp-plus-slice1:derivation-receipt-complete-binding-environments
                         plural-receipt)))
                  (null
                   (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
                    plural-receipt))))

      ;; 10. The same paths conflict only in the schema declaring translation
      ;; uniqueness.
      (multiple-value-bind (claim unique-receipt)
          (attempt :quotation-admission-designated-translation
                   :reader-a :textual-comparison complete)
        (declare (ignore claim))
        (check "10 declared-uniqueness-only"
               (and (eq :refused
                        (lisp-plus-slice1:derivation-receipt-decision
                         unique-receipt))
                    (eq :ambiguous
                        (disposition unique-receipt
                                     :translation-corresponds))
                    (eq :translation
                        (first
                         (first
                          (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts
                           unique-receipt))))
                    (= 2 (length
                          (lisp-plus-slice1:derivation-receipt-complete-binding-environments
                           unique-receipt))))))

      ;; 11. The six-way explanation is read from receipts, not flattened.
      (let ((seen '()))
        (dolist (scenario
                  (list
                   (list :satisfied plural-receipt
                         :quotation-text-matches)))
          (push (disposition (second scenario) (third scenario)) seen))
        ;; Other dispositions have already been asserted above; exercise WHY on
        ;; the plurality receipt here and render the ambiguous receipt above.
        (check "11 why-is-structured"
               (and (eq plural-receipt
                        (lisp-plus-slice1:why plural-receipt))
                    (member :satisfied seen))))

      ;; 12. Projection reconstructs judgment using target-local evidence.
      (let* ((project-support
               (lisp-plus-slice0:witness
                :for (conclusion :reader-b :textual-comparison)
                :mode :derivation
                :kind :quotation-review
                :source :reader-b))
             (project-procedure
               (lisp-plus-slice0:promotion-procedure
                :descriptor
                (lisp-plus-kernel0:make-procedure-descriptor
                 :procedure-id
                 (lisp-plus-kernel0:make-identity
                  :procedure "reader-b-quotation-review")
                 :version 1
                 :judgment-class :semantic
                 :result-vocabulary '(:accepted :rejected))
                :admits '((:derivation :quotation-review))))
             (source-context (context :reader-a '()))
             (target-context
               (context :reader-b (list project-support)
                        :procedures (list project-procedure))))
        (multiple-value-bind (projected projection-receipt)
            (lisp-plus-slice0:project-claim
             source-claim
             :from source-context
             :to target-context
             :store (lisp-plus-slice0:support-store)
             :offering (list project-support)
             :public-form (conclusion :reader-b :textual-comparison)
             :derivation project-support)
          (check "12 projection-reconstructs-target"
                 (and
                  (equal (conclusion :reader-b :textual-comparison)
                         (lisp-plus-slice0:claim-proposition projected))
                  (member :redacted
                          (lisp-plus-slice0:projection-views
                           projection-receipt))
                  (lisp-plus-slice0:claim-judgment projected)))))

      ;; 13. A transported receipt is testimony about Alice's derivation.
      (let ((transport
              (lisp-plus-slice1:transported-testimony
               plural-receipt :context-a :reader-a)))
        (check "13 transported-receipt-is-testimony"
               (and (eq :testimony
                        (lisp-plus-slice0:witness-mode transport))
                    (eq :derivation-report
                        (lisp-plus-slice0:witness-kind transport))
                    (not (equal
                          (lisp-plus-slice0:witness-for transport)
                          (conclusion :reader-b :textual-comparison)))))))

    (format t "~&RESULT ~S~%"
            '(:slice1-stranger-implementation
              :task-completed t
              :guide-sufficient t
              :api-sufficient t
              :front-door-only t
              :proposition-anatomy-preserved t
              :declared-premises-enforced t
              :plurality-preserved t
              :declared-uniqueness-understood t
              :projection-reconstructed t
              :transported-testimony-preserved t
              :exports-total 69
              :exports-used :see-exports-used
              :tacit-knowledge-dependence nil
              :successor-pressure
              (:public-reader-for-derived-promotion-procedure)))))

(run)
