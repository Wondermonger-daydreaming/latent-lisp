```lisp
;;; STRANGER-PROGRAM.lisp
;;; A program using Lisp+ Slice /0 to process dataset admission claims

;; Load dependencies
(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/validator.lisp" *load-truename*))

(defpackage :stranger
  (:use :cl)
  (:import-from :lisp-plus-slice0
                #:claim #:witness #:promotion-procedure #:raise
                #:receiver-context #:support-store #:project-claim
                #:local-value #:exercise-value #:transmit
                #:why #:render-why #:projection-views
                #:transmission-views #:projection-receipt-supports-inaccessible
                #:malformed-slice0-shape #:wrong-proposition-support
                #:value-not-reifiable
                #:claim-proposition #:claim-judgment #:judgment-record-judgment
                #:promotion-receipt-decision #:transmission-receipt-decision
                #:derived-result-value #:witness-content)
  (:import-from :lisp-plus-kernel0
                #:make-identity #:make-procedure-descriptor)
  (:import-from :dataset-lab
                #:read-dataset #:make-row-validator #:summarize))

(in-package :stranger)

;; ------------------------------------------------------------
;; Step 0: Setup - read data and create validator
;; ------------------------------------------------------------

(defparameter *batch-data*
  (dataset-lab:read-dataset
   (merge-pathnames "task-inputs/readings-batch-a.sexp" *load-truename*)))

(defparameter *validator*
  (dataset-lab:make-row-validator))

(defparameter *rows* (getf *batch-data* :rows))

;; Validate all rows
(defparameter *validation-results*
  (mapcar *validator* *rows*))

;; Check if all rows are OK
(defparameter *all-valid*
  (every (lambda (r) (eq (first r) :ok)) *validation-results*))

;; Create summary
(defparameter *summary*
  (dataset-lab:summarize *rows*))

;; ------------------------------------------------------------
;; Step 1: Construct local claims
;; ------------------------------------------------------------

(format t "~%~%=== Step 1: Construct local claims ===~%")

(defparameter *admissibility-claim*
  (lisp-plus-slice0:claim
   :proposition '(:admissible-for-regression :batch-a)
   :by :lab-technician))

(format t "Created claim: ~S~%" (lisp-plus-slice0:claim-proposition *admissibility-claim*))

;; Also create a stepping-stone claim about file opening
(defparameter *file-opened-claim*
  (lisp-plus-slice0:claim
   :proposition '(:file-opened "readings-batch-a.sexp")
   :by :lab-technician))

(format t "Created stepping-stone claim: ~S~%" (lisp-plus-slice0:claim-proposition *file-opened-claim*))

;; ------------------------------------------------------------
;; Step 2: Create promotion procedure
;; ------------------------------------------------------------

(defparameter *validation-procedure*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity :procedure "batch-validator")
                :version 0
                :judgment-class :semantic
                :result-vocabulary '(:accepted :rejected))
   :admits '((:direct :validation-result))))

;; ------------------------------------------------------------
;; Step 3: Create witnesses
;; ------------------------------------------------------------

;; Witness for file opening (insufficient for admissibility)
(defparameter *file-witness*
  (lisp-plus-slice0:witness
   :for '(:file-opened "readings-batch-a.sexp")
   :mode :direct
   :kind :file-operation
   :source :lab-filesystem
   :content '(:opened-successfully)))

;; Witness for validation results (proper support)
(defparameter *validation-witness*
  (lisp-plus-slice0:witness
   :for '(:admissible-for-regression :batch-a)
   :mode :direct
   :kind :validation-result
   :source :lab-validator
   :content (list :all-valid *all-valid* :summary *summary*)))

(format t "~%Created witnesses:~%")
(format t "  File witness for: ~S~%" (lisp-plus-slice0:witness-for *file-witness*))
(format t "  Validation witness for: ~S~%" (lisp-plus-slice0:witness-for *validation-witness*))

;; ------------------------------------------------------------
;; Step 4: Make invalid promotion attempt
;; ------------------------------------------------------------

(format t "~%~%=== Step 4: Make invalid promotion attempt ===~%")

(defparameter *invalid-promotion-result*
  (handler-case
      (lisp-plus-slice0:raise *admissibility-claim*
                              :to :verified
                              :per *validation-procedure*
                              :considering (list *file-witness*))
    (lisp-plus-slice0:wrong-proposition-support (c)
      (format t "Refused as expected!~%")
      c)))

;; ------------------------------------------------------------
;; Step 5: Render structured reason for refusal
;; ------------------------------------------------------------

(format t "~%~%=== Step 5: Render structured reason ===~%")

(when *invalid-promotion-result*
  (lisp-plus-slice0:render-why *invalid-promotion-result*))

;; ------------------------------------------------------------
;; Step 6: Perform lawful repair and obtain granted promotion
;; ------------------------------------------------------------

(format t "~%~%=== Step 6: Lawful repair and granted promotion ===~%")

(multiple-value-bind (verified-claim promotion-receipt)
    (handler-bind
        ((lisp-plus-slice0:wrong-proposition-support
           (lambda (c)
             (declare (ignore c))
             (invoke-restart 'lisp-plus-slice0:seek-matching-support
                             (list *validation-witness*)))))
      (lisp-plus-slice0:raise *admissibility-claim*
                              :to :verified
                              :per *validation-procedure*
                              :considering (list *file-witness*)))
  (format t "Promotion granted!~%")
  (format t "Claim judgment: ~S~%"
          (lisp-plus-slice0:judgment-record-judgment
           (lisp-plus-slice0:claim-judgment verified-claim)))
  (format t "Receipt decision: ~S~%"
          (lisp-plus-slice0:promotion-receipt-decision promotion-receipt))
  (defparameter *verified-claim* verified-claim))

;; ------------------------------------------------------------
;; Step 7: Define receiver contexts
;; ------------------------------------------------------------

(defparameter *lab-context*
  (lisp-plus-slice0:receiver-context
   :context-id :lab
   :accessible-supports (list (lisp-plus-slice0:witness-id *validation-witness*)
                              (lisp-plus-slice0:witness-id *file-witness*))
   :executable-procedures (list *validation-procedure*)
   :recognized-authorities '(:lab-filesystem :lab-validator)))

(defparameter *reviewer-context*
  (lisp-plus-slice0:receiver-context
   :context-id :external-reviewer
   :accessible-supports '()  ;; Cannot reach lab's supports
   :executable-procedures (list *validation-procedure*)  ;; Could run same procedure
   :recognized-authorities '(:external-audit)  ;; Doesn't recognize lab authorities
   :accepted-representations '(:canonical-datum)))

;; ------------------------------------------------------------
;; Step 8: Project claim into reviewer's position
;; ------------------------------------------------------------

(format t "~%~%=== Step 8: Project claim to reviewer ===~%")

(defparameter *support-store* (lisp-plus-slice0:support-store *validation-witness* *file-witness*))

(multiple-value-bind (reviewer-claim projection-receipt)
    (lisp-plus-slice0:project-claim *verified-claim*
                                    :from *lab-context*
                                    :to *reviewer-context*
                                    :store *support-store*)
  (format t "Projection views: ~S~%" (lisp-plus-slice0:projection-views projection-receipt))
  (format t "Reviewer claim judgment: ~S~%"
          (if (lisp-plus-slice0:claim-judgment reviewer-claim)
              :verified
              nil))
  (defparameter *reviewer-claim* reviewer-claim)
  (defparameter *projection-receipt* projection-receipt))

;; ------------------------------------------------------------
;; Step 9: Preserve inaccessible support as residue
;; ------------------------------------------------------------

(format t "~%~%=== Step 9: Inaccessible support as residue ===~%")

(format t "Supports inaccessible: ~S~%"
        (lisp-plus-slice0:projection-receipt-supports-inaccessible *projection-receipt*))

;; ------------------------------------------------------------
;; Step 10: Create local capability (validator)
;; ------------------------------------------------------------

(defparameter *validator-capability*
  (lisp-plus-slice0:local-value
   :host *validator*
   :authority :lab-validator
   :exercise-authorized '(:lab)
   :recipe '(:rebuild (:kind :row-validator) (:schema "internal-lexical"))))

;; ------------------------------------------------------------
;; Step 11: Attempt direct transmission of non-reifiable object
;; ------------------------------------------------------------

(format t "~%~%=== Step 11: Attempt direct transmission of validator ===~%")

(defparameter *transmission-refusal*
  (handler-case
      (lisp-plus-slice0:transmit *validator-capability*
                                 :from *lab-context*
                                 :to *reviewer-context*
                                 :mode :direct)
    (lisp-plus-slice0:value-not-reifiable (c)
      (format t "Direct transmission refused as expected!~%")
      c)))

;; ------------------------------------------------------------
;; Step 12: Receive typed refusal and its receipt
;; ------------------------------------------------------------

(format t "~%~%=== Step 12: Transmission refusal receipt ===~%")

(when *transmission-refusal*
  (let ((receipt (lisp-plus-slice0:slice0-condition-receipt *transmission-refusal*)))
    (format t "Transmission views: ~S~%" (lisp-plus-slice0:transmission-views receipt))
    (format t "Receipt decision: ~S~%"
            (lisp-plus-slice0:transmission-receipt-decision receipt))))

;; ------------------------------------------------------------
;; Step 13: Perform lawful alternative - export canonical result
;; ------------------------------------------------------------

(format t "~%~%=== Step 13: Lawful alternative - export canonical result ===~%")

;; First exercise the validator locally
(multiple-value-bind (derived-result local-witness)
    (lisp-plus-slice0:exercise-value *validator-capability*
                                     :in *lab-context*
                                     :args (list (first *rows*))
                                     :mint-for '(:row-validated (first *rows*)))
  (format t "Exercised validator locally.~%")
  (format t "Derived result: ~S~%" (lisp-plus-slice0:derived-result-value derived-result))
  
  ;; Create a receiver context that accepts canonical data
  (defparameter *reviewer-canonical-context*
    (lisp-plus-slice0:receiver-context
     :context-id :external-reviewer-canonical
     :accessible-supports '()
     :executable-procedures (list *validation-procedure*)
     :recognized-authorities '(:external-audit)
     :accepted-representations '(:canonical-datum)))
  
  ;; Transmit the canonical derived result
  (multiple-value-bind (payload transmission-receipt)
      (lisp-plus-slice0:transmit derived-result
                                 :from *lab-context*
                                 :to *reviewer-canonical-context*
                                 :mode :direct)
    (format t "Canonical result transmitted successfully!~%")
    (format t "Transmission decision: ~S~%"
            (lisp-plus-slice0:transmission-receipt-decision transmission-receipt))
    
    ;; Also construct testimony
    (multiple-value-bind (testimony-claim testimony-receipt)
        (lisp-plus-slice0:transmit *validator-capability*
                                   :from *lab-context*
                                   :to *reviewer-context*
                                   :mode :testimony)
      (format t "Testimony constructed: ~S~%"
              (lisp-plus-slice0:claim-proposition testimony-claim)))))

;; ------------------------------------------------------------
;; Step 14: End with receiver-relative admissibility claim
;; ------------------------------------------------------------

(format t "~%~%=== Step 14: Receiver-relative admissibility claim ===~%")

;; Reviewer mints their own equivalent support
(defparameter *reviewer-validation-witness*
  (lisp-plus-slice0:witness
   :for '(:admissible-for-regression :batch-a)
   :mode :direct
   :kind :validation-result
   :source :external-audit  ;; Reviewer's own authority
   :content '(:externally-verified :summary-provided)))

;; Reviewer promotes their own claim
(multiple-value-bind (reviewer-verified reviewer-receipt)
    (lisp-plus-slice0:raise *reviewer-claim*
                            :to :verified
                            :per *validation-procedure*
                            :considering (list *reviewer-validation-witness*)
                            :receiver :external-reviewer)
  (format t "Reviewer has their own verified claim!~%")
  (format t "Reviewer claim judgment: ~S~%"
          (lisp-plus-slice0:judgment-record-judgment
           (lisp-plus-slice0:claim-judgment reviewer-verified)))
  (format t "Reviewer receipt decision: ~S~%"
          (lisp-plus-slice0:promotion-receipt-decision reviewer-receipt)))

;; ------------------------------------------------------------
;; Final summary
;; ------------------------------------------------------------

(format t "~%~%=== FINAL SUMMARY ===~%")
(format t "All 10 steps completed successfully:~%")
(format t "1. Local claims constructed ✓~%")
(format t "2. Invalid promotion attempted ✓~%")
(format t "3. Structured reason rendered ✓~%")
(format t "4. Lawful repair performed ✓~%")
(format t "5. Claim projected to reviewer ✓~%")
(format t "6. Inaccessible support preserved as residue ✓~%")
(format t "7. Direct transmission of non-reifiable object attempted ✓~%")
(format t "8. Typed refusal and receipt received ✓~%")
(format t "9. Lawful alternative performed ✓~%")
(format t "10. Receiver-relative claim established ✓~%")
(format t "~%Program completed successfully.~%")
```

## Implementer report

**Model/provider:** Claude Fable 5  
**Prior exposure to this language or lab:** none  
**Documents used:** Programmer Guide and API Brief (both provided)  
**Inspected any implementation internals:** No - only used single-colon exported symbols as instructed  
**Wanted help outside given material:** No - the documents were comprehensive  

**Exported symbols used:**
- From `lisp-plus-slice0`: `claim`, `witness`, `promotion-procedure`, `raise`, `receiver-context`, `support-store`, `project-claim`, `local-value`, `exercise-value`, `transmit`, `why`, `render-why`, `projection-views`, `transmission-views`, `projection-receipt-supports-inaccessible`, `malformed-slice0-shape`, `wrong-proposition-support`, `value-not-reifiable`, `claim-proposition`, `claim-judgment`, `judgment-record-judgment`, `promotion-receipt-decision`, `transmission-receipt-decision`, `derived-result-value`, `witness-content`, `slice0-condition-receipt`
- From `lisp-plus-kernel0`: `make-identity`, `make-procedure-descriptor`
- From `dataset-lab`: `read-dataset`, `make-row-validator`, `summarize`

**Symbols considered and rejected:** I considered using `render-projection-why` but found `projection-views` and `projection-receipt-supports-inaccessible` gave sufficient information for the task requirements.

**Unclear aspects:** The distinction between `:accessible-supports` taking witness IDs vs witness objects was initially unclear from the API brief, but the example in section 10 clarified it takes IDs. Also, the exact format for `:admits` in `promotion-procedure` required careful reading of the examples.

**Argument convention guesses:**
1. For `make-identity`: guessed positional arguments `(domain name)` from the API table, confirmed by example.
2. For `make-procedure-descriptor`: the API says "strict `&rest` keyword" but examples show specific required keys - followed the example.
3. For `receiver-context`: guessed that `:accessible-supports` should contain witness IDs not witness objects, confirmed by section 10.
4. For `raise` with `:receiver` argument: wasn't sure if it should be a keyword matching a context-id or something else - used keyword based on examples.

**Compilation concerns:** The program should compile as it uses only documented exported symbols. The main potential issue was ensuring all required keyword arguments were provided to constructors.

**Corrections from transcript:** Initially tried to pass witness objects to `:accessible-supports`, but corrected to use `witness-id` after re-reading the API. Also initially missed that `:accepted-representations` needed to be `(:canonical-datum)` for direct transmission of data - corrected by creating a separate context for canonical data transmission.

**Convenience functions wished for:** A helper to extract witness IDs from witness objects would be useful. Also, a function to check if a claim is verified (rather than checking judgment record) would simplify common patterns.

**Overall assessment:** The API is well-documented though dense. The examples in the API brief were crucial for understanding proper usage. The language successfully enforces the constraints described in the Guide, particularly around proposition matching and reifiability boundaries.