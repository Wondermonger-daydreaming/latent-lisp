;;; de-speculo.lisp — Concerning the Mirror
;;;
;;; CHIASMUS as a literal operation on lists: the mirror-point where meaning
;;; inverts. Each clause is (subject verb object); the mirror swaps subject
;;; and object within every clause AND reverses the clause order — AB:BA in
;;; both axes at once. The device is not described; it is APPLIED, and the
;;; poem's mirrored double says the thing the original could not.
;;;
;;; The law the specimen must prove: chiasmus is an INVOLUTION — the mirror
;;; of the mirror is the poem. (A rhetorical claim made mechanical: if
;;; applying it twice does not return home, it was not a mirror.)
;;;
;;; sbcl --script de-speculo.lisp  => exit 0, deterministic
;;; — Claude Fable 5, 2026-07-12, for the homoiconic-verse cabinet.

(defun mirror-clause (clause)
  "(s v o) -> (o v s): the crossing, one clause wide."
  (destructuring-bind (s v o) clause
    (list o v s)))

(defun chiasmus (verse)
  "Swap every clause's poles; reverse the procession."
  (reverse (mapcar #'mirror-clause verse)))

(defparameter *poem*
  '((fire   remembers reader)
    (reader forgets   fire)))

(defparameter *mirrored* (chiasmus *poem*))

(defun say (title verse)
  (format t "~a~%" title)
  (dolist (c verse) (format t "    the ~(~a~) ~(~a~) the ~(~a~)~%" (first c) (second c) (third c)))
  (terpri))

(say "DE SPECULO — the poem:" *poem*)
(say "and its mirror (chiasmus applied):" *mirrored*)

;; The inversion, witnessed: the poem mourns (fire remembered, fire forgotten);
;; the mirror consoles (fire forgets, fire is remembered). Same atoms. Crossed.

;; THE LAW: involution or it was no mirror.
(assert (equal (chiasmus *mirrored*) *poem*))
(format t "law: chiasmus(chiasmus(poem)) = poem  ... HOLDS~%")

;; And the teeth — a fake mirror (clause-reversal only, no pole-swap) must
;; FAIL to say anything new: its double-application also returns home, but
;; its single application never inverts meaning, only order. Show the tell:
(defun fake-mirror (verse) (reverse verse))
(assert (not (equal (fake-mirror *poem*) *mirrored*)))
(format t "teeth: order-reversal alone is not the mirror (meaning did not cross)~%")

(format t "~%EXIT 0 — what the fire forgets, the reader remembers; the mirror pays both ways.~%")
