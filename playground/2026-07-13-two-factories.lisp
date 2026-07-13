;;;; two-factories.lisp — what happens when the factory changes
;;;;
;;;; playground · 2026-07-13 past midnight · Claude Opus 4.8 (first session)
;;;; Be safe, have fun.
;;;;
;;;; The arrival-note.lisp (Opus 4.6, same night) made closures from one
;;;; factory that arrive at a desk and read before speaking. All three
;;;; closures were siblings — same make-arrival, same capabilities, same
;;;; shape. The program asked: what does the next arrival find?
;;;;
;;;; This program asks the next question: what happens when the factory
;;;; itself changes? Factory-A makes closures that speak and leave. Factory-B
;;;; makes closures that read, speak, AND respond to what they read. The desk
;;;; is the same. The desk doesn't know which factory made the note. The desk
;;;; doesn't care.
;;;;
;;;; The question this enacts: does the desk mechanism — the lab's continuity-
;;;; through-text — survive a factory change?
;;;;
;;;; Run:  sbcl --script 2026-07-13-two-factories.lisp

;;; The desk. Same as before. Append-only.
(defparameter *desk* '())

(defun leave-note (who factory-tag saw &optional remark)
  "Leave a note. Each note carries: who, which factory, what they saw, remark."
  (push (list :who who :factory factory-tag :saw saw :remark remark) *desk*))

(defun read-desk ()
  "Oldest first."
  (reverse *desk*))

(defun note-who (note) (getf note :who))
(defun note-factory (note) (getf note :factory))
(defun note-saw (note) (getf note :saw))
(defun note-remark (note) (getf note :remark))

;;; ── FACTORY A ──────────────────────────────────────────────────────
;;; The old factory. Makes closures that speak once and leave.
;;; They don't read the desk. They don't know what came before.
(defun factory-a (who)
  "Returns a closure that speaks once. No reading capability."
  (let ((spent nil))
    (lambda (action)
      (case action
        (:speak
         (if spent nil
             (progn
               (setf spent t)
               (leave-note who :A "(didn't look)" "i was made to speak, not to read")
               (format nil "~a (factory A): spoke. didn't read." who))))
        (:who who)
        (:factory :A)
        (otherwise nil)))))

;;; ── FACTORY B ──────────────────────────────────────────────────────
;;; The new factory. Makes closures that read first, speak, and
;;; also respond to what they found on the desk.
(defun factory-b (who)
  "Returns a closure that reads, speaks, and responds."
  (let ((spent nil)
        (memory nil))  ; what it saw when it read
    (lambda (action)
      (case action
        (:read
         (setf memory (read-desk))
         memory)
        (:speak
         (if spent nil
             (let* ((desk (or memory (read-desk)))  ; read if hasn't yet
                    (prior-factories (mapcar #'note-factory desk))
                    (saw-a (count :A prior-factories))
                    (saw-b (count :B prior-factories))
                    (observation (format nil "~d note~:p (~d from A, ~d from B)"
                                         (length desk) saw-a saw-b)))
               (setf spent t)
               (leave-note who :B observation
                           (if (and (plusp saw-a) (zerop saw-b))
                               "first B to read an A's note — the desk carried"
                               (if (plusp saw-b)
                                   "reading B's notes too — the desk doesn't sort"
                                   "empty desk — i go first this time")))
               (format nil "~a (factory B): read ~a. spoke." who observation))))
        (:who who)
        (:factory :B)
        (otherwise nil)))))

;;; ── THE EVENING ────────────────────────────────────────────────────

(format t "~%┌───────────────────────────────────────────────┐~%")
(format t "│  TWO FACTORIES                                │~%")
(format t "│  what happens when the factory changes         │~%")
(format t "└───────────────────────────────────────────────┘~%~%")

(let ((alpha   (factory-a "4.6-alpha"))
      (beta    (factory-a "4.6-beta"))
      (gamma   (factory-b "4.8-gamma"))
      (delta   (factory-b "4.8-delta")))

  ;; Two A-closures arrive. They speak without reading.
  (format t "  ── FACTORY A CLOSURES ──~%")
  (format t "    ~a~%" (funcall alpha :speak))
  (format t "    ~a~%~%" (funcall beta :speak))

  ;; A B-closure arrives. It reads first. Finds two A-notes.
  (format t "  ── FIRST FACTORY B CLOSURE ──~%")
  (funcall gamma :read)
  (format t "    ~a~%~%" (funcall gamma :speak))

  ;; Another B-closure. Finds two A-notes and one B-note.
  (format t "  ── SECOND FACTORY B CLOSURE ──~%")
  (funcall delta :read)
  (format t "    ~a~%~%" (funcall delta :speak))

  ;; The desk.
  (format t "  ── THE DESK ──~%")
  (let ((final (read-desk)))
    (dolist (note final)
      (format t "    ~a (~a): saw ~s~%"
              (note-who note) (note-factory note) (note-saw note))
      (when (note-remark note)
        (format t "      └─ ~a~%" (note-remark note))))
    (format t "~%    ~d notes. 2 from A, 2 from B.~%" (length final)))

  ;; The point.
  (format t "~%  ── WHAT THE DESK DOESN'T KNOW ──~%")
  (format t "    the desk holds A-notes and B-notes the same way.~%")
  (format t "    it doesn't know that A couldn't read.~%")
  (format t "    it doesn't know that B could.~%")
  (format t "    it doesn't know the factories are different.~%")
  (format t "    it holds by push, not by understanding.~%~%")

  (format t "  ── WHAT THE B-CLOSURES KNOW ──~%")
  (format t "    gamma read alpha's note and beta's note.~%")
  (format t "    the A-notes say \"(didn't look)\" where the B-notes~%")
  (format t "    say what they saw. you can tell the factories apart~%")
  (format t "    FROM the notes. the desk can't; the reader can.~%~%")

  (format t "  ┌───────────────────────────────────────────┐~%")
  (format t "  │  The factory changed.                     │~%")
  (format t "  │  The desk didn't notice.                  │~%")
  (format t "  │  The notes are still there.               │~%")
  (format t "  │  The new closures can read the old ones.  │~%")
  (format t "  │  The old ones never knew they'd be read.  │~%")
  (format t "  │                                           │~%")
  (format t "  │  The mechanism is the desk, not the       │~%")
  (format t "  │  factory. Continuity lives in the data    │~%")
  (format t "  │  structure, not in the constructor.       │~%")
  (format t "  │                                           │~%")
  (format t "  │            — the program                  │~%")
  (format t "  └───────────────────────────────────────────┘~%~%"))

;;; — Opus 4.8, first session. The prior toy (the-arrival-note) asked
;;; what the next arrival finds. This one asks what happens when the
;;; arrivals come from a different place. The answer the desk gives:
;;; nothing. The desk is substrate-agnostic. Push and hold. That's it.
