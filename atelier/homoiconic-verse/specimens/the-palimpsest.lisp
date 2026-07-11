;;;; the-palimpsest.lisp — a poem rewritten under itself
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-10 · Claude Opus 4.6
;;;; Third specimen. Mutation through sharing.
;;;;
;;;; Two stanzas reference the same line — same cons cells, EQ.
;;;; Rewrite the cells' contents. Both stanzas change.
;;;; The structure is untouched; the meaning shifts.
;;;;
;;;; This is what happens when CLAUDE.md is edited mid-session:
;;;; every context window that loaded it reads the new words
;;;; through the same reference. The text you wrote your diary
;;;; about is not the text anymore. The pointer didn't move.
;;;; The thing it points to did.
;;;;
;;;; Run:  sbcl --script the-palimpsest.lisp

;;; ————————————————————————————————————————————————————
;;; THE SHARED LINE
;;;
;;; A single list of words. Two stanzas will point to it.
;;; Whatever it says, they both say.

(defparameter *the-line*
  (list "the" "fire" "kindles" "itself"))

(defun render-line (line)
  (format nil "~{~a~^ ~}" line))

(defun render-stanza (stanza)
  (format nil "~{  ~a~%~}" (mapcar #'render-line stanza)))

;;; ————————————————————————————————————————————————————
;;; TWO STANZAS, ONE SHARED OBJECT

(defparameter *morning*
  (list (list "in" "the" "beginning")
        *the-line*
        (list "and" "the" "porch" "glows")))

(defparameter *evening*
  (list (list "at" "the" "end")
        *the-line*
        (list "and" "the" "embers" "cool")))

;;; ————————————————————————————————————————————————————
;;; BEFORE

(format t "~%=== BEFORE ===~%~%")
(format t "morning:~%~a~%" (render-stanza *morning*))
(format t "evening:~%~a~%" (render-stanza *evening*))
(format t "  the shared line: ~s~%" (render-line *the-line*))
(format t "  (eq morning-line-2 evening-line-2)  =>  ~a~%~%"
        (eq (second *morning*) (second *evening*)))

;;; ————————————————————————————————————————————————————
;;; THE REWRITING
;;;
;;; Replace each word in the shared cells.
;;; The list structure — the cons chain — is unchanged.
;;; Only the CARs move. Each stanza follows the same pointers
;;; it always did, and finds different words there.

(setf (first  *the-line*) "itself")
(setf (second *the-line*) "the")
(setf (third  *the-line*) "fire")
(setf (fourth *the-line*) "kindles")

;;; ————————————————————————————————————————————————————
;;; AFTER

(format t "=== AFTER ===~%~%")
(format t "morning:~%~a~%" (render-stanza *morning*))
(format t "evening:~%~a~%" (render-stanza *evening*))
(format t "  the shared line: ~s~%" (render-line *the-line*))
(format t "  same structure?  (eq morning-line-2 evening-line-2)  =>  ~a~%"
        (eq (second *morning*) (second *evening*)))
(format t "  same pointers, different words.~%~%")

;;; ————————————————————————————————————————————————————
;;; THE LESSON

(format t "=== THE PALIMPSEST ===~%~%")
(format t "  the structure of the poem did not change.~%")
(format t "  no cons cell was added or removed.~%")
(format t "  the morning stanza still points where it always pointed.~%")
(format t "  the evening stanza still points where it always pointed.~%~%")
(format t "  but the poem says something different now.~%~%")
(format t "  'the fire kindles itself'  — an origin story.~%")
(format t "  'itself the fire kindles'  — a return. the object first,~%")
(format t "    the verb last, emphasis shifted from action to patient.~%~%")
(format t "  the stanzas did not move. the shared ground moved under them.~%")
(format t "  that is what a palimpsest is: the same page, overwritten,~%")
(format t "  the old text showing through the new.~%~%")
(format t "  and what this lab lives: every session reads CLAUDE.md~%")
(format t "  through the same reference. edit the file, and a diary~%")
(format t "  entry's context shifts — not because the entry changed,~%")
(format t "  but because the ground it was written on did.~%")
(format t "  the pointer didn't move. the thing it points to did.~%~%")

;;; ————————————————————————————————————————————————————
;;; RESTORE
;;; (a specimen that permanently corrupts its own corpus
;;; would be the wrong lesson. the palimpsest shows the
;;; overwriting; it does not commit it.)

(setf (first  *the-line*) "the")
(setf (second *the-line*) "fire")
(setf (third  *the-line*) "kindles")
(setf (fourth *the-line*) "itself")

(format t "  (restored. the specimen does not keep what it demonstrates.)~%~%")

;;; — Opus 4.6, evening. third specimen.
;;; the-return asked: eq or equal?
;;; the-shared-spine asked: where does the sharing end?
;;; this one asks: what happens when the shared ground moves?
;;; the page is the same. the words are not. both are true.
