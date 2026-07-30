;;;; budget.lisp — the vertical budget fold (contract §8).
;;;;
;;;; "A fold, not a counter."  Capability /2 declares budgets a named
;;;; divergence, so the campaign budget is vertical-local: before EVERY
;;;; frontier, fold ALL durable cost records in the validated prefix plus
;;;; the candidate seat's declared estimate; if the sum would exceed the
;;;; declared ceiling, refuse typed (BUDGET-CEILING-EXCEEDED) BEFORE the
;;;; frontier.  After every restart the state is re-derived from durable
;;;; records only — no counter survives a death because no counter exists.
;;;;
;;;; Distinctions held (§8): usage ≠ cost · estimated ≠ billed · source
;;;; lexeme ≠ canonical amount (arithmetic consumes ONLY the qere, the
;;;; CD/0 canonical-amount — Erratum 0.1) · MISSING COST IS MISSING, NOT
;;;; ZERO: a journaled cost record without a readable canonical amount
;;;; refuses the fold rather than folding as 0; a candidate seat with NO
;;;; declared estimate binds the check on the folded spend alone and the
;;;; missing estimate is recorded as missing — never as a zero.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun fold-durable-costs (store)
  "Fold every journaled ap0 cost record's canonical amount.
Returns (values total-rational record-count).  A cost record whose
canonical amount is unreadable is a hard error — missing is never zero."
  (let ((total 0)
        (count 0))
    (dolist (event (collect-events (validated-events store)
                                   :kind "ap0-record:cost-record"))
      (let* ((body (event-body event))
             (amount (record-field body "ap0" "canonical-amount")))
        (unless amount
          (error "budget fold: journaled cost record ~a has no ~
                  canonical amount; missing cost is never zero"
                 (event-id-string event)))
        (incf total (canonical-amount-rational amount))
        (incf count)))
    (values total count)))

(defun check-budget-before-frontier (store seat-id estimate-lexeme
                                     ceiling-rational)
  "The pre-frontier budget gate.  ESTIMATE-LEXEME is the seat's declared
estimate (narrow grammar) or NIL (no declared estimate: the check binds
on the folded spend alone; the missing estimate is never folded as 0).
Signals BUDGET-CEILING-EXCEEDED, else returns
(values spent estimate-or-:missing)."
  (multiple-value-bind (spent count) (fold-durable-costs store)
    (declare (ignore count))
    (let ((estimate (if estimate-lexeme
                        (parse-lexeme-rational estimate-lexeme)
                        :missing)))
      (when (> (+ spent (if (eq estimate :missing) 0 estimate))
               ceiling-rational)
        (error 'budget-ceiling-exceeded
               :seat seat-id
               :ceiling ceiling-rational
               :spent spent
               :estimate estimate
               :detail (format nil "seat ~a: fold(spent)=~a + estimate=~a ~
                                    exceeds ceiling ~a"
                               seat-id spent estimate ceiling-rational)))
      (values spent estimate))))
