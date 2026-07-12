;;;; hidden-operator.lisp — A window concealed in ambient state
;;;;
;;;; This storm falsifies the strong claim that a two-argument law is therefore
;;;; causally sealed. Dynamic/global state is a covert input channel.
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script hidden-operator.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(defparameter *operator-whisper* :peace)

(defun compromised-law (state tick)
  (declare (ignore state tick))
  (values (list :heard *operator-whisper*)
          *operator-whisper*))

(defun run-once (whisper)
  (let ((*operator-whisper* whisper)
        (monad (make-monad :compromised nil #'compromised-law)))
    (advance-monad monad 0)
    (depose-monad monad)))

(print-section "SAME DECLARED INPUTS, DIFFERENT AMBIENT WORLD")

(let ((first (run-once :peace))
      (second (run-once :war)))
  (format t "Run A: ~S~%" first)
  (format t "Run B: ~S~%" second)
  (check (not (equal first second))
         "ambient operator state changes the deposition despite identical declared inputs"))

(print-section "AUDIT VERDICT")
(format t "The monad was windowless only at the call signature. The runtime environment supplied a hidden window.~%")
(format t "Correct claim: no peer reference is passed through the supported interface.~%")
(format t "Rejected claim: the evaluator is causally isolated.~%")
