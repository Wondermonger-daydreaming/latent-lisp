;; determinacy.lp — program 3: ordinary computation combined with an
;; already-supported Lisp+ semantic operation through its EXISTING interface.
;;
;;   bash mneme/language-program-0/lisp-plus-run.sh mneme/language-program-0/programs/determinacy.lp
;;
;; The operation is Kernel /0's §7 determinacy constructor,
;; lisp-plus-kernel0:make-determinacy, reached as `kernel0/determinacy`. The
;; kernel's law (K0E-33, Errata 0.2 §6) is that a determinacy record MUST NOT
;; carry a global confidence scalar — the front-page specimen of the public
;; README shows exactly this refusal from a Common Lisp script. Here the same
;; question is asked from Lisp+, by user-defined functions, over a list of
;; candidate offers; the kernel's refusals come back as VALUES the program
;; can inspect, and its acceptances as opaque host values. Nothing is
;; performed: constructing a record is a derivation, and this lane cannot
;; reach an effect (the effect lanes are not loaded).

;; an offer is (label . keyword-arguments-for-the-kernel)
(define offers
  (list (list "plain determinate"      (list :mode :determinate))
        (list "with a confidence 0.8"  (list :mode :determinate :confidence 0.8))
        (list "plain indeterminate"    (list :mode :indeterminate))
        (list "an unknown mode"        (list :mode :fairly-sure))))

(define (offer-label o) (car o))
(define (offer-args o)  (car (cdr o)))

;; apply the kernel's constructor to an argument list held as data
(define (ask-kernel args)
  (cond ((= (length args) 2) (kernel0/determinacy (nth 0 args) (nth 1 args)))
        ((= (length args) 4) (kernel0/determinacy (nth 0 args) (nth 1 args) (nth 2 args) (nth 3 args)))
        (else (quote unsupported-arity))))

;; classify one offer by what the kernel said, keeping the requirement id
(define (classify o)
  (let ((answer (ask-kernel (offer-args o))))
    (cond ((refused? answer)
           (list (offer-label o) (quote refused) (refusal-requirement answer)))
          ((host-value? answer)
           (list (offer-label o) (quote admitted) (kernel0/determinacy-mode answer)))
          (else (list (offer-label o) (quote unknown))))))

(define verdicts (map classify offers))
(for-each print verdicts)

;; ordinary computation over the kernel's answers
(define (refused-count vs) (count-if (lambda (v) (equal? (nth 1 v) (quote refused))) vs))
(print "admitted:" (count-if (lambda (v) (equal? (nth 1 v) (quote admitted))) verdicts)
       "refused:" (refused-count verdicts))

;; the requirement ids that spoke, deduplicated in-language
(define (dedupe xs)
  (fold-right (lambda (x acc) (if (any? (lambda (y) (equal? x y)) acc) acc (cons x acc))) () xs))

(dedupe (map (lambda (v) (nth 2 v))
             (filter (lambda (v) (equal? (nth 1 v) (quote refused))) verdicts)))
