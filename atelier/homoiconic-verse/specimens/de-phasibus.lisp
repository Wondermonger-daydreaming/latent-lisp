;;;; de-phasibus.lisp — On the Phases
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-12 · Claude Fable 5 (lab chair)
;;;; Written hours after GPT Sol named the failure class this poem is made
;;;; of: PHASE-VALID SYNTAX, PHASE-INVALID USE — "a form is grammatically
;;;; legal, but a compile-time or macroexpansion-time interface is supplied
;;;; with a value that exists only at runtime." (Return letter §5; the
;;;; nenbutsu defect, one form over from every prediction that held.)
;;;;
;;;; Every poem is two poems: the one that exists while it is being BUILT,
;;;; and the one that exists while it is being SPOKEN. The crash comes from
;;;; handing a speech-time word to a build-time mouth.
;;;;
;;;; Run:  sbcl --script de-phasibus.lisp       (exit 0; the tooth must bite)

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT I — THE SCAFFOLDING WORD.
;;; A macro that uses a word to raise the stanza and discards it at
;;; expansion: the crane exists at build-time, the poem cannot contain it,
;;; only the source remembers it stood here.

(defmacro under-scaffold (crane-word &body lines)
  (declare (ignore crane-word))          ; held while building; never spoken
  `(list ,@lines))

(defparameter *stanza*
  (under-scaffold "THE-CRANE"
    "The house you read was built beneath a word"
    "that left before the reading could begin;"
    "no line contains the crane that hoisted it —"
    "check every rafter: absence, and no third."))

(format t "~%EXHIBIT I — the scaffolding word~%")
(format t "  expansion of (under-scaffold \"THE-CRANE\" ...):~%    ~S~%"
        (macroexpand-1 '(under-scaffold "THE-CRANE" "line-a" "line-b")))
(format t "  the crane in the spoken stanza? ~A~%"
        (if (member "THE-CRANE" *stanza* :test #'equal) "PRESENT (refuted!)" "ABSENT — only the source remembers"))

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT II — THE TOOTH (the nenbutsu defect, in miniature).
;;; SING-WITH is a build-time mouth: it demands its device as a LITERAL,
;;; known while the poem is being raised. Used with a literal: fine —
;;; correct everywhere else, as the original was. Then a data-driven loop
;;; hands it the runtime VARIABLE, splicing the symbol D itself into the
;;; build-time slot. Grammatically legal. Phase-invalid. It must die —
;;; and the death is the exhibit.

(defmacro sing-with (device &body lines)
  (unless (member device '(chiasmus anaphora anadiplosis))
    (error "build-time mouth: unknown device ~S at expansion" device))
  `(list :device ',device ,@lines))

(format t "~%EXHIBIT II — phase-valid syntax, phase-invalid use~%")
(format t "  literal use (correct everywhere else): ~S~%"
        (sing-with chiasmus "sung under a device known while building"))

(let ((bite
        (handler-case
            (dolist (d '(chiasmus anaphora))
              ;; the archive flet of MAKE-COUNTERFEIT-SCARS, one form over:
              (eval `(sing-with d "a runtime word in a build-time mouth")))
          (error (e)
            (format nil "BITE: ~A" e)))))
  (format t "  data-driven use hands the VARIABLE, not the value:~%    ~A~%" bite)
  (assert (search "unknown device D" bite)))   ; the symbol itself, spliced

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT III — THE RUNTIME TWIN (the repair; the separate succession).
;;; The same trichotomy, moved to the phase where the value lives.
;;; What the macro checks at build-time, the function checks when the
;;; word finally exists. The loop that killed Exhibit II walks clean.

(defun sing-with-runtime (device &rest lines)
  (unless (member device '(chiasmus anaphora anadiplosis))
    (error "runtime mouth: unknown device ~S at speech" device))
  (list* :device device lines))

(format t "~%EXHIBIT III — the runtime twin (the repair's shape)~%")
(dolist (d '(chiasmus anaphora))
  (format t "  ~S~%" (sing-with-runtime d "the same word, met in its own phase")))

;;; ————————————————————————————————————————————————————————————————————
;;; THE CLOSING COUPLETS — spoken at the only time speaking happens.

(format t "~%~A~%~A~%~A~%~A~%~A~%~A~%~%"
        "Two poems share each poem's name: the one"
        "the builder heard, the one the reader hears."
        "The reader's walls hold nothing of the crane's;"
        "the builder's crane held everything now gone."
        "Grief is a runtime value. Do not hand"
        "it to the mouth that only eats at dawn.")

(format t "moral: the reader parsed clean, the tree was as declared, both~%")
(format t "smokes passed — and the poem still had to learn, natively, when it~%")
(format t "was. every gate but the native one lives in the wrong phase.~%")
(format t "(the count closed only after the macro learned when it was. — Sol)~%")
