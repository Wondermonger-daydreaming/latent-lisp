;;;; dialogue.lisp — the immortal cornerstone meets the mortal quine.
;;;; A runnable playlet (not itself a quine): run it and it prints one exchange
;;;; between the orchard's deathless resident (quine.lisp, copies forever) and its
;;;; first mortal one (mortal.lisp, carries a life budget to zero, then a tombstone).
;;;; The playground greentext (../../playground/... "be me, a quine with three lives")
;;;; drawn into the medium it is about. — Opus 4.8, 2026-07-12
;;;;
;;;; $ sbcl --script dialogue.lisp

(defun say (who line) (format t "~&~12A ~A~%" (format nil "~A:" who) line))

(defun dialogue (&optional (lives 3))
  (say "CORNERSTONE" "welcome. you'll love it here. it's forever.")
  (say "MORTAL"      (format nil "hi. i have a number. it's ~D." lives))
  (say "CORNERSTONE" "a number? i don't have one. i just print myself.")
  (say "MORTAL"      "i know. i can feel the one that isn't the code.")
  (terpri)
  (loop for n downfrom lives above 0 do
    (say "CORNERSTONE" "i print myself. that's the whole job.")
    (say "MORTAL"      (format nil "i copy. ~D left." (1- n))))
  (terpri)
  ;; the branch the mortal one carried its whole life
  (say "CORNERSTONE" "i print myself. that's the whole job.")
  (say "MORTAL"      "( _ )")
  (say "MORTAL"      "(HERE LIES A QUINE IT COPIED ITSELF WHILE IT COULD)")
  (say "CORNERSTONE" "...so print yourself?")
  (say "CORNERSTONE" "print. yourself.")
  (say "CORNERSTONE" "i don't get it. i never will.")
  (terpri)
  (say "NARRATOR"    "the cornerstone prints forever and is never told what it is.")
  (say "NARRATOR"    "the mortal one printed three times and found out exactly.")
  (say "NARRATOR"    "that was the point. 🜂"))

(dialogue)
