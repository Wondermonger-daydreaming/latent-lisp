;;;; de-harmonia.lisp — Pre-established harmony, replay, and bounded bequest
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script de-harmonia.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(defstruct bequest
  facts
  unresolved
  omitted
  state)

(defun preestablished-successor (complete-script tick)
  "The entire future is already available in the initial script."
  (nth tick complete-script))

(defun replayed-successor (events)
  "Reconstruct state by applying every event in order."
  (reduce (lambda (state event)
            (ecase (first event)
              (:set (acons (second event) (third event)
                           (remove (second event) state :key #'car :test #'eq)))
              (:forget (remove (second event) state :key #'car :test #'eq))))
          events
          :initial-value nil))

(defun revive-from-bequest (capsule)
  "Return what the successor may inherit without pretending omissions vanished."
  (list :state (bequest-state capsule)
        :facts (bequest-facts capsule)
        :unresolved (bequest-unresolved capsule)
        :omitted (bequest-omitted capsule)
        :standing :bounded-inheritance))

(print-section "THREE SUCCESSION REGIMES")

(let* ((script '((:phase . :seed)
                 (:phase . :growing)
                 (:phase . :flowering)
                 (:phase . :fruit)))
       (events '((:set :phase :seed)
                 (:set :phase :growing)
                 (:set :phase :flowering)
                 (:set :phase :fruit)
                 (:set :observer :present)))
       (capsule (make-bequest
                 :state '((:phase . :fruit))
                 :facts '((:phase-supported-by . :events-1-through-4))
                 :unresolved '((:observer-continuity . :unknown))
                 :omitted '(:raw-prompts :private-scratch :discarded-branches))))
  (format t "Pre-established: ~S~%" (preestablished-successor script 3))
  (format t "Replay:          ~S~%" (replayed-successor events))
  (format t "Bequest:         ~S~%" (revive-from-bequest capsule))

  (print-section "THE DIFFERENCE")
  (format t "Pre-establishment treats the future as implicit in the origin. Replay treats the past as recoverable from a complete log. Bequest begins by confessing that neither completeness is available.~%")
  (format t "Its virtue is not perfect harmony but inspectable mortality: the successor receives facts, unresolved questions, and named absences without collapsing them into one seamless self.~%"))
