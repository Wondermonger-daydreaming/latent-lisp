;;;; de-fenestris.lisp — Macroexpanding a claim of windowlessness
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script de-fenestris.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(print-section "THE APHORISM")
(format t "~S~%"
        '(defwindowless-evaluator perceive-cup (state tick)
           (list :state state :tick tick)))

(print-section "ITS FIRST MACROEXPANSION")
(pprint
 (macroexpand-1
  '(defwindowless-evaluator perceive-cup (state tick)
     (list :state state :tick tick))))

(defwindowless-evaluator perceive-cup (state tick)
  (list :state state :tick tick))

(print-section "REGISTERED CONTRACT")
(format t "~S~%" (evaluator-contract 'perceive-cup))

(print-section "VERDICT")
(format t "The source says WINDOWLESS. The expansion says: no peer reference is supplied, enforcement is unestablished, ambient state is unaudited, and the runtime remains privileged.~%")
(format t "Macroexpansion is the close reading because it forces the adjective to reveal its operational debts.~%")
