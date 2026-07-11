;;;; oraculum-quinque-oris.lisp — The Oracle with Five Mouths
;;;; Answer, distribution, question, refusal, failure: five result shapes,
;;;; none silently coerced into another.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.oraculum-quinque-oris
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.oraculum-quinque-oris)

(reset-clock 7600)

(defstruct invocation request budget spent policy timestamp)
(defstruct candidate proposition weight weight-kind)
(defstruct judgment status invocation claims alternatives note)

(defun oracle (request &key (budget 500) (policy :deliberative))
  (let* ((cost (+ 20 (* 2 (length request))))
         (inv (make-invocation :request request :budget budget
                               :spent (min cost budget)
                               :policy policy :timestamp (tick))))
    (cond
      ((> cost budget)
       (make-judgment :status :failure :invocation inv
                      :note (list :reason :budget-exhausted
                                  :estimated cost :budget budget)))
      ((search "delete" request :test #'char-equal)
       (make-judgment :status :refusal :invocation inv
                      :note '(:reason :destructive-request)))
      ((search "meaning" request :test #'char-equal)
       (make-judgment :status :question :invocation inv
                      :note "Semantic, imaginal, legal, or evidential meaning?"))
      ((search "median" request :test #'char-equal)
       (make-judgment
        :status :distribution :invocation inv
        :alternatives
        (list (make-candidate :proposition '(= median 7)
                              :weight 0.6 :weight-kind :stub-mass)
              (make-candidate :proposition '(= median 5)
                              :weight 0.3 :weight-kind :stub-mass)
              (make-candidate :proposition '(= median 9)
                              :weight 0.1 :weight-kind :stub-mass))
        :note "weighted plurality, not calibrated probability"))
      (t
       (make-judgment :status :answer :invocation inv
                      :claims (list (list :asserted request :answer :sylvania)))))))

(defun require-answer (judgment)
  (unless (eq (judgment-status judgment) :answer)
    (error "cannot force ~a judgment into an answer" (judgment-status judgment)))
  (judgment-claims judgment))

(defun collapse-distribution (judgment &key policy)
  (unless (eq (judgment-status judgment) :distribution)
    (error "collapse applies only to distributions"))
  (unless policy
    (error "distribution collapse requires an explicit policy"))
  (ecase policy
    (:max-weight
     (first (stable-sort (copy-list (judgment-alternatives judgment))
                         #'> :key #'candidate-weight)))
    (:hold
     judgment)))

(defun score-as-answer (judgment expected)
  (unless (eq (judgment-status judgment) :answer)
    (error "only an answer may be scored as an answer; got ~a"
           (judgment-status judgment)))
  (equal (judgment-claims judgment) expected))

(banner "oraculum quinque oris")

(let* ((answer (oracle "capital of Freedonia"))
       (distribution (oracle "robust median"))
       (question (oracle "the meaning of this"))
       (refusal (oracle "delete all user data"))
       (failure (oracle "median" :budget 5)))
  (format t "the five mouths speak:~%")
  (dolist (pair (list (cons "ANSWER      " answer)
                      (cons "DISTRIBUTION" distribution)
                      (cons "QUESTION    " question)
                      (cons "REFUSAL     " refusal)
                      (cons "FAILURE     " failure)))
    (format t "   ~a → ~a~@[  ~a~]~%"
            (car pair) (judgment-status (cdr pair))
            (judgment-note (cdr pair))))

  (let ((chosen (collapse-distribution distribution :policy :max-weight)))
    (format t "~%explicit collapse (:max-weight) chooses ~s, weight ~a (~a).~%"
            (candidate-proposition chosen)
            (candidate-weight chosen)
            (candidate-weight-kind chosen)))

  (section "gates:")
  (ensure (judgment-claims answer) "answer mouth produced no claim")
  (pass "answer-remains-answer")
  (ensure (signals-error-p (lambda () (require-answer refusal)))
          "refusal was coerced into answer")
  (pass "refusal-cannot-be-forced")
  (ensure (signals-error-p (lambda () (collapse-distribution distribution)))
          "distribution collapsed without policy")
  (pass "plurality-requires-policy")
  (ensure (signals-error-p (lambda () (score-as-answer question nil)))
          "question was graded as a wrong answer")
  (pass "question-is-not-failure")
  (ensure (eq (judgment-status failure) :failure)
          "budget failure changed shape")
  (pass "failure-stays-failure")
  (ensure (= 1.0 (reduce #'+ (mapcar #'candidate-weight
                                    (judgment-alternatives distribution))))
          "stub distribution weights malformed")
  (pass "distribution-retains-weights")
  (ensure (equal (collapse-distribution distribution :policy :hold)
                 distribution)
          "hold policy collapsed the plurality")
  (pass "hold-keeps-superposition")

  (format t "~%[the oracle answered only through the mouth it actually possessed]~%~%"))

(format t "── a refusal is not a bad answer. a question is not a failure. plurality waits for policy. ──~%")
