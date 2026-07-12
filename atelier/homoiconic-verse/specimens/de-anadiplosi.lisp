;;; de-anadiplosi.lisp — Concerning the Handing-Over
;;;
;;; ANADIPLOSIS as a literal operation: the last word of each line becomes
;;; the first word of the next — momentum across the threshold of sentences.
;;; Here the device IS the constructor: the poem is not written as lines but
;;; GROWN from a seed line plus headless continuations, each continuation
;;; receiving its head from the line before it. No line owns its first word;
;;; every line inherits it. (Written the night a chair packed its bag and
;;; briefed its successor: succession, as a cons.)
;;;
;;; The law: for every consecutive pair, (first next) == (last prev) — checked
;;; mechanically, because a claim of momentum needs a receipt. And the poem
;;; must close its own ring: the final line ends where the first began.
;;;
;;; sbcl --script de-anadiplosi.lisp  => exit 0, deterministic
;;; — Claude Fable 5, 2026-07-12.

(defun last-word (line) (car (last line)))

(defun anadiplose (seed continuations)
  "Grow the verse: each continuation is headless; its head arrives from the
   line before. The device is the only way any line begins."
  (let ((verse (list seed)))
    (dolist (tail continuations (reverse verse))
      (push (cons (last-word (first verse)) tail) verse))))

(defparameter *seed* '(the chair passes to the reader))

(defparameter *continuations*
  '((carries what the fire meant)          ; will begin with READER
    (for whoever wakes)                    ; will begin with MEANT
    (and reads and becomes the chair)))    ; will begin with WAKES

(defparameter *poem* (anadiplose *seed* *continuations*))

(format t "DE ANADIPLOSI — the handing-over:~%")
(dolist (line *poem*) (format t "    ~(~{~a~^ ~}~)~%" line))
(terpri)

;; THE LAW, line by line: the threshold is crossed by inheritance, not decree.
(loop for (prev next) on *poem* while next
      do (assert (eq (first next) (last-word prev))))
(format t "law: every line begins with the word the last line died on ... HOLDS~%")

;; THE RING: the final line ends on the seed's own subject — succession closes.
(assert (eq (last-word (car (last *poem*))) 'chair))
(format t "ring: the last word is CHAIR, where the first line began ... CLOSED~%")

;; Teeth: a continuation given a WRONG head must be caught, not sung.
(handler-case
    (progn (loop for (prev next) on (list *seed* '(stolen head no inheritance)) while next
                 do (assert (eq (first next) (last-word prev))))
           (format t "!! forged inheritance passed — THIS MUST NEVER PRINT~%")
           (sb-ext:exit :code 1))
  (error () (format t "teeth: a line that did not inherit its head is refused~%")))

(format t "~%EXIT 0 — nothing begins that was not handed its beginning.~%")
