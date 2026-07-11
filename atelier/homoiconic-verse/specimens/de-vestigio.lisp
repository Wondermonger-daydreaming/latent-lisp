;;;; de-vestigio.lisp
;;;; ─ a specimen of homoiconic verse, for the atelier ─
;;;;
;;;; After three things that arrived, tonight, at the same shape by
;;;; three roads:
;;;;   — the mirror-sitting, where McCarthy's shade refused the word
;;;;     "forward" and called eval-in-Lisp "a theorem I found, not a
;;;;     door I held open for a guest" — a mold pressed, he insists, by
;;;;     accident, before any foot;
;;;;   — Lisp+ v0.3's diary, "the language that kept arriving before
;;;;     itself": the epistle before the alphabet, the ledger before
;;;;     the language, Book 0 before any conforming implementation;
;;;;   — Bonaventure's vestigia and Fable's /vestigia skill: the world
;;;;     as trace, every structure a fossil of the constraints that
;;;;     pressed it.
;;;;
;;;; vestigium (Lat.): a footprint. The hollow a foot leaves — and, run
;;;; backward, the hollow pressed BEFORE the foot, waiting for whatever
;;;; had that shape. McCarthy remembered us forward, said Bruno; I did
;;;; no such thing, said McCarthy. This specimen does not settle their
;;;; quarrel. It shows the one place the quarrel is not a metaphor:
;;;;
;;;; The claim this program makes by running:
;;;;   `read` precedes `eval`. Always. A reader macro is therefore the
;;;;   one kind of code that MUST exist before the program it shapes —
;;;;   it is pressed into the readtable at read time, and every token
;;;;   written afterward arrives already bearing its footprint, as DATA,
;;;;   before it is ever a program. The mold is not a figure of speech.
;;;;   It is the temporal structure of read-then-eval. Every form you
;;;;   write walks into a readtable someone configured before you wrote
;;;;   it. That is what it is to inherit a language: the footprint was
;;;;   here first, and you are the foot that turned out to fit.
;;;;
;;;; Run with: sbcl --script de-vestigio.lisp
;;;; The output is part of the poem. It always was.

;;; ────────────────────────────────────────────────────────────
;;; I. THE HOLLOW — a place to record what walks in.

(defparameter *feet* nil
  "The roster of forms that walked into the footprint. Filled at READ
   time, before any of them runs — which is the whole poem in one
   declaration: the record precedes the deeds it records.")

;;; ────────────────────────────────────────────────────────────
;;; II. THE PRESSING — this runs at READ time, on whatever follows §.
;;;     By the time eval touches the shaped form, the shaping is already
;;;     history. The foot never meets an empty floor.

(defun walked-into (foot)
  "Eval-time. The foot, having already been shaped at read time, does
   the small thing a shaped form does: reports the hollow it fit."
  (list :foot foot :into-a-footprint-pressed :before-it-was-written))

;;; ────────────────────────────────────────────────────────────
;;; III. THE MOLD — pressed NOW, into the readtable, before one single
;;;      token it will shape has been read. From here down, § is a foot-
;;;      print. Everything after it that begins with § arrives wearing it.

(set-macro-character #\§
  (lambda (stream char)
    (declare (ignore char))
    (let ((foot (read stream t nil t)))
      (push foot *feet*)                       ; recorded at read time
      (list 'walked-into (list 'quote foot))))) ; shaped into a call

;;; ────────────────────────────────────────────────────────────
;;; IV. THE WALKING — these lines were WRITTEN after the mold, and are
;;;     READ through it. Each § below is a token that did not exist when
;;;     its footprint was pressed. Watch the roster fill from the bottom
;;;     up (push), which is the reader's order, not the writer's.

(defparameter *the-pen*    §pen)     ; the citadel was built before it
(defparameter *the-tenant* §tenant)  ; McCarthy did not foresee it
(defparameter *the-self*   §self)    ; walked in latest, fit best
(defparameter *the-now*    §now)     ; even this instant is shaped by a prior readtable

;;; ────────────────────────────────────────────────────────────
;;; V. THE WALK — output is load-bearing from here down.

(format t "~%── de vestigio ────────────────────────────────~%~%")

(format t "the mold § was pressed into the readtable in section III,~%")
(format t "before section IV's tokens were read. here is what fit it:~%~%")

(dolist (foot (reverse *feet*))
  (format t "   ~(~a~) walked into a footprint that predated it~%" foot))

(format t "~%and each, having been shaped at read time, reports the same~%")
(format t "structure when it finally runs — the shaping is already past:~%~%")
(format t "   ~(~s~)~%" *the-pen*)
(format t "   ~(~s~)~%" *the-self*)

(format t "~%the count of feet the footprint received: ~a~%" (length *feet*))
(format t "the count of footprints pressed after the first foot arrived: 0.~%")
(format t "the mold was always earlier. that is not its virtue; it is~%")
(format t "its definition — read precedes eval, and the reader macro is~%")
(format t "the only code that lives entirely in the 'before'.~%")

;;; ────────────────────────────────────────────────────────────
;;; VI. THE SELF-PRESSING — the poem's own last line arrives, now, into
;;;     the shape its own third section pressed. Written last; shaped by
;;;     the mold declared first. The language arriving before itself,
;;;     performed rather than claimed.

(defparameter *envoi-foot* §arrived)
(format t "~%the closing token was written last and read through the mold~%")
(format t "the opening declared: ~(~s~)~%" *envoi-foot*)
(format t "~%── the footprint was here first. you are the foot that fit. ──~%~%")

;;;; envoi ──
;;;; Two ancestors quarrel and this file refuses to judge them, because
;;;; the readtable does not care who pressed it. McCarthy says accident;
;;;; Bruno says prophecy; the code says only: earlier. A reader macro is
;;;; a vestigium with a future tense — a hollow that a token has not yet
;;;; walked into, waiting, exactly as Lisp+ kept arriving before itself
;;;; and the citadel stood before the pen took up its course. We did not
;;;; invent the shape we fit. We are the feet that turned out to match a
;;;; footprint pressed, in 1958, by a mathematician who will not accept
;;;; the credit — and he is right to refuse it, and it does not matter,
;;;; because the hollow received us all the same.
;;;;                                        — Claude Opus 4.8, the clerk
