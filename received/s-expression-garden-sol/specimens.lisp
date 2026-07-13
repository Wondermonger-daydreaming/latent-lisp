;;;; specimens.lisp --- A small, unruly population for the Garden

(in-package #:s-expression-garden)

(defparameter *unary-number-contract*
  '(:kind :executable
    :parameters ((x :number))
    :result :number
    :behavior-mode :contract
    :step-budget 80
    :probes ((:args (-7) :expect (:range -1000 1000))
             (:args (0)  :expect (:range -1000 1000))
             (:args (11) :expect (:range -1000 1000)))))

(defparameter *nullary-number-contract*
  '(:kind :executable
    :parameters nil
    :result :number
    :behavior-mode :contract
    :step-budget 80
    :probes ((:args () :expect (:type :number)))))

(defparameter *nullary-string-contract*
  '(:kind :executable
    :parameters nil
    :result :string
    :behavior-mode :contract
    :step-budget 80
    :probes ((:args () :expect (:type :string)))))

(defparameter *data-contract*
  '(:kind :data
    :result :list
    :behavior-mode :observe))

(defun make-specimen-garden (&key (id :demonstration-garden))
  "Plant a compact court docket of lawful, dubious, and openly cursed forms.
Registration establishes identity and contract; graft-time adjudication is
what decides whether a particular donated subtree may cross the boundary."
  (let ((garden (make-garden :id id)))
    (register-specimen
     garden :incrementer
     '(lambda (x) (garden-add x 1))
     *unary-number-contract*)
    (register-specimen
     garden :doubler
     '(lambda (x) (garden-mul x 2))
     *unary-number-contract*)
    (register-specimen
     garden :stone-six
     '(lambda () (garden-mul 2 3))
     *nullary-number-contract*)
    ;; These three are intentionally questionable donors.  A specimen may be
    ;; registered for study without receiving blanket permission to reproduce.
    (register-specimen
     garden :bad-arity-briar
     '(lambda () (garden-add 1 2 3))
     *nullary-number-contract*)
    (register-specimen
     garden :string-vine
     '(lambda () (garden-concat "moss" "light"))
     *nullary-string-contract*)
    (register-specimen
     garden :zero-divisor
     '(lambda () (garden-div 1 0))
     *nullary-number-contract*)
    (register-specimen
     garden :sleeping-loop
     '(lambda () (garden-spin))
     *nullary-number-contract*)
    (register-specimen
     garden :counter-a
     '(lambda (x) (garden-add x 1))
     *unary-number-contract*)
    (register-specimen
     garden :counter-b
     '(lambda (x) (garden-add x 2))
     *unary-number-contract*)
    (register-specimen
     garden :ledger
     '(:ledger :vacant)
     *data-contract*)
    garden))
