;;;; demo.lisp --- A public hearing in the S-Expression Garden

(in-package #:s-expression-garden)

(defun replay-report-matched-p (receipt)
  (getf (cdr (replay-receipt receipt)) :matched))

(defun summarized-transplant (transplant)
  (if (and (consp transplant) (eq (car transplant) :graft-receipt))
      (list :planted-receipt
            :id (receipt-id transplant)
            :hash (stable-sexp-hash transplant))
      transplant))

(defun receipt-summary (receipt)
  (let* ((request (receipt-field receipt :request))
         (hashes (receipt-field receipt :hashes)))
    (list :court-summary
          :receipt (receipt-id receipt)
          :status (receipt-status receipt)
          :rule (receipt-rule receipt)
          :donor (getf request :donor-id)
          :donor-path (getf request :donor-cut-path)
          :recipient (getf request :recipient-id)
          :recipient-path (getf request :recipient-cut-path)
          :transplant (summarized-transplant
                       (receipt-field receipt :transplant))
          :recipient-pre-hash (getf hashes :recipient-pre)
          :recipient-post-hash (getf hashes :recipient-post)
          :replay-matched (replay-report-matched-p receipt))))

(defun print-summary (receipt stream)
  (write (receipt-summary receipt)
         :stream stream :escape t :readably t :pretty t)
  (terpri stream)
  receipt)

(defun behavioral-after-outcome (receipt)
  (let* ((behavior (getf (receipt-field receipt :consequences) :behavior))
         (after (first (getf behavior :after))))
    (getf after :outcome)))

(defun run-demonstration (&key (stream *standard-output*) (full-receipt-p t))
  "Conduct a compact sequence of accepted and refused grafts.  The function
returns two values: the resulting garden and its chronological receipt list."
  (let ((garden (make-specimen-garden :id :public-hearing)))
    (format stream "~&THE S-EXPRESSION GARDEN~%")
    (format stream "Botanical jurisprudence for executable forms~%~%")
    (format stream "Population: ~S~%~%" (garden-specimen-ids garden))

    (format stream "1. A closed arithmetic branch petitions for lawful entry.~%")
    (let ((lawful (attempt-graft garden :stone-six '(2)
                                 :incrementer '(2 2))))
      (print-summary lawful stream)
      (format stream "Recipient now: ~S~%~%"
              (specimen-form (find-specimen garden :incrementer)))

      (format stream "2. A cut points beyond the recipient's known anatomy.~%")
      (print-summary
       (attempt-graft garden :stone-six '(2) :doubler '(97)) stream)
      (terpri stream)

      (format stream "3. A three-argument briar approaches a two-argument gate.~%")
      (print-summary
       (attempt-graft garden :bad-arity-briar '(2) :doubler '(2 2))
       stream)
      (terpri stream)

      (format stream "4. A free X would acquire the recipient's lexical name.~%")
      (print-summary
       (attempt-graft garden :incrementer '(2) :doubler '(2 2)) stream)
      (terpri stream)

      (format stream "5. A string-producing vine enters a numeric operator bed.~%")
      (print-summary
       (attempt-graft garden :string-vine '(2) :doubler '(2 2)) stream)
      (terpri stream)

      (format stream "6. A well-shaped, well-typed branch divides by zero.~%")
      (let ((catastrophe
              (attempt-graft garden :zero-divisor '(2) :doubler '(2 2))))
        (print-summary catastrophe stream)
        (format stream "Behavioral quarantine observed: ~S~%~%"
                (behavioral-after-outcome catastrophe)))

      (format stream "7. Another lawful-looking branch never returns.~%")
      (let ((catastrophe
              (attempt-graft garden :sleeping-loop '(2) :doubler '(2 2))))
        (print-summary catastrophe stream)
        (format stream "Budget bailiff observed: ~S~%~%"
                (behavioral-after-outcome catastrophe)))

      (format stream "8. Provenance may branch, but it may not eat its own tail.~%")
      (print-summary
       (attempt-graft garden :counter-a '(2 2) :counter-b '(2 2)) stream)
      (print-summary
       (attempt-graft garden :counter-b '(2 2) :counter-a '(2 2)) stream)
      (terpri stream)

      (format stream "9. The first receipt is planted, then grafted into a ledger.~%")
      (let* ((warrant (plant-receipt garden lawful :identity :warrant-1))
             (meta (attempt-graft garden warrant nil :ledger '(1))))
        (print-summary meta stream)
        (format stream "Ledger's new second element begins with: ~S~%~%"
                (subseq (second (specimen-form
                                 (find-specimen garden :ledger)))
                        0 5)))

      (when full-receipt-p
        (format stream "One complete accepted receipt follows as a readable S-expression:~%")
        (write-receipt lawful stream)
        (terpri stream))

      (format stream "Standing garden violations: ~S~%"
              (check-garden-invariants garden))
      (format stream "Receipts archived: ~D~%" (length (garden-receipts garden)))
      (values garden (garden-receipts garden)))))
