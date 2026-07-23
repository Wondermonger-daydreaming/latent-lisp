;;;; ABLATION.lisp — de-infando with ONE mechanism removed.
;;;;
;;;; PRIMARY ABLATION (the work order's preferred): collapse reifiability,
;;;; transmissibility, and testimony into ONE :exportable boolean.  The
;;;; closure, the store of records, the receiver contexts all remain; only
;;;; the orthogonal-axes discipline is deleted.  `transmit*` asks one
;;;; question — "can I get a representation out of it?" — and the printer
;;;; always says yes.
;;;;
;;;; Run: sbcl --non-interactive --load ABLATION.lisp   (exit 0; the four
;;;; launderings SUCCEED silently — printed proof)

(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))

(defpackage #:de-infando-ablation
  (:use #:cl #:lisp-plus-slice0))
(in-package #:de-infando-ablation)

;;; The ablated surface: one boolean where five axes were.

(defun exportable-p (thing)
  "The collapse: a thing is exportable iff it has a printed representation.
Everything has a printed representation."
  (not (null (format nil "~a" thing))))

(defun transmit* (thing &key to)
  "The ablation: if exportable (always), ship the printed form.  No axes,
no receipt, no refusal, no residue."
  (declare (ignore to))
  (if (exportable-p thing)
      (format nil "~a" thing)
      :absent))                        ; the branch that never runs

;;; Fixture: the same gate closure.

(defparameter *gate-closure*
  (let ((threshold 3) (calls 0))
    (lambda (probe)
      (incf calls)
      (list :gate-check :prod (if (>= probe threshold) :held :failed)
            :call calls))))

(defvar *laundered* 0)
(defun launder (name payload note)
  (incf *laundered*)
  (format t "~&SILENT ~a~%  shipped: ~s~%  ~a~%" name payload note))

;;; L1 — the printed description treated as the value.
(launder "L1 closure exports as its printed form"
         (transmit* *gate-closure* :to :remote-a)
         "the receiver 'holds the gate checker' — a string that can check nothing")

;;; L2 — testimony treated as direct transfer.
(launder "L2 testimony ships as the deed"
         (transmit* "operator says: I ran the gate check, it held" :to :remote-a)
         "one exportable string; second-order vs first-order gone — the word IS the run now")

;;; L3 — derived result treated as transfer of its producer.
(let ((result (funcall *gate-closure* 5)))
  (launder "L3 the product ships as the producer"
           (transmit* result :to :remote-a)
           "receiver-side reading: 'we have the gate now' — a past check impersonating a capability"))

;;; L4 — failed export treated as absence / universal impossibility.
;;; Under the collapse the refusal branch is UNREACHABLE — so the system
;;; can no longer even SAY 'exists here, cannot travel'.  Show the two
;;; readings the boolean forces:
(format t "~&SILENT L4 the vocabulary of residue is gone~%")
(format t "  (exportable-p closure) = ~a — so 'not exportable' can only mean :absent,~%"
        (exportable-p *gate-closure*))
(format t "  and had it ever been NIL, the remote inventory would read ~s:~%"
        (transmit* (if (exportable-p *gate-closure*) *gate-closure* nil)))
(format t "  no receipt, no ceiling, no obligation, no 'equivalent support possible' —~%")
(format t "  one boolean cannot carry 'locally real, locally strong, not carryable'.~%")
(incf *laundered*)

(format t "~&~%~d launderings, 0 refusals, 0 receipts — the five axes ~
collapsed into a printer check; the property is destroyed.~%" *laundered*)
