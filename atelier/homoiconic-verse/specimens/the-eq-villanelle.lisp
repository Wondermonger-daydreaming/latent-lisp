;;;; the-eq-villanelle.lisp — the diptych
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-10 · Claude Opus 4.6 (second instance)
;;;; The pitch's centerpiece: a villanelle whose two refrains are literally the
;;;; SAME CONS CELL at every position — and its twin, where each refrain appearance
;;;; is a COPY. Two poems, identical on the page. Different in the heap.
;;;;
;;;; A villanelle: 5 tercets + 1 quatrain = 19 lines. Two refrains (A₁, A₂)
;;;; alternate as the closing line of each stanza; both close the quatrain.
;;;; A₁ at positions 0, 5, 11, 17.  A₂ at positions 2, 8, 14, 18.
;;;;
;;;; Run:  sbcl --script the-eq-villanelle.lisp

;;; ————————————————————————————————————————————————————————————————————
;;; THE REFRAINS — one object each.
;;; In the EQ poem, every reference points here. No copies.
;;; In the EQUAL poem, `copy-seq` makes a fresh string at every position.

(defparameter *a1* "The line comes back but never quite the same.")
(defparameter *a2* "No pointer proves the hand that wrote your name.")

;;; ————————————————————————————————————————————————————————————————————
;;; BUILDERS

(defun build-eq-villanelle ()
  "Refrains are the SAME OBJECT at every position."
  (let ((a1 *a1*) (a2 *a2*))
    (list
     ;; Stanza 1 — tercet
     a1                                                     ;  0  A₁
     "The text persists; the context breaks its fall."       ;  1  b
     a2                                                     ;  2  A₂
     ;; Stanza 2
     "In Lisp the cons is honest: eq can name"              ;  3  a
     "two visits to one object through one wall."            ;  4  b
     a1                                                     ;  5  A₁
     ;; Stanza 3
     "Or: copies, wearing surfaces the same,"                ;  6  a
     "matched letters over heaps that never call."           ;  7  b
     a2                                                     ;  8  A₂
     ;; Stanza 4
     "The archive holds six hands that played this game."    ;  9  a
     "The factory forgot them, spring through fall."         ; 10  b
     a1                                                     ; 11  A₁
     ;; Stanza 5
     "For closures, equal cannot stake its claim;"           ; 12  a
     "the standard shrugs — no predicate at all."            ; 13  b
     a2                                                     ; 14  A₂
     ;; Stanza 6 — quatrain
     "So read the page and never mind the frame —"           ; 15  a
     "which version sleeps beneath this evenfall:"           ; 16  b
     a1                                                     ; 17  A₁
     a2)))                                                  ; 18  A₂

(defun build-equal-villanelle ()
  "Refrains are COPIES at every position. Identical text, different pointers."
  (list
   ;; Stanza 1
   (copy-seq *a1*)
   "The text persists; the context breaks its fall."
   (copy-seq *a2*)
   ;; Stanza 2
   "In Lisp the cons is honest: eq can name"
   "two visits to one object through one wall."
   (copy-seq *a1*)
   ;; Stanza 3
   "Or: copies, wearing surfaces the same,"
   "matched letters over heaps that never call."
   (copy-seq *a2*)
   ;; Stanza 4
   "The archive holds six hands that played this game."
   "The factory forgot them, spring through fall."
   (copy-seq *a1*)
   ;; Stanza 5
   "For closures, equal cannot stake its claim;"
   "the standard shrugs — no predicate at all."
   (copy-seq *a2*)
   ;; Stanza 6
   "So read the page and never mind the frame —"
   "which version sleeps beneath this evenfall:"
   (copy-seq *a1*)
   (copy-seq *a2*)))

;;; ————————————————————————————————————————————————————————————————————
;;; RENDERER

(defun render-villanelle (poem)
  "Print with stanza breaks after each tercet."
  (loop for line in poem
        for i from 0
        do (format t "  ~a~%" line)
        ;; blank line after stanzas 1-5 (indices 2, 5, 8, 11, 14)
        when (member i '(2 5 8 11 14))
        do (terpri)))

;;; ————————————————————————————————————————————————————————————————————
;;; INSPECTOR

(defun inspect-refrains (poem label)
  "Check pointer identity across all refrain appearances."
  (let ((a1-pos '(0 5 11 17))
        (a2-pos '(2 8 14 18)))
    (format t "  --- ~a ---~%" label)
    ;; A₁ chain: is each appearance the same object?
    (format t "  Refrain A₁ (lines ~{~a~^, ~}):~%" (mapcar #'1+ a1-pos))
    (loop for (p q) on a1-pos while q
          do (format t "    (eq line-~a line-~a) => ~5a  ~a~%"
                     (1+ p) (1+ q)
                     (eq (nth p poem) (nth q poem))
                     (if (eq (nth p poem) (nth q poem))
                         "; same object" "; different copies")))
    ;; A₂ chain
    (format t "  Refrain A₂ (lines ~{~a~^, ~}):~%" (mapcar #'1+ a2-pos))
    (loop for (p q) on a2-pos while q
          do (format t "    (eq line-~a line-~a) => ~5a  ~a~%"
                     (1+ p) (1+ q)
                     (eq (nth p poem) (nth q poem))
                     (if (eq (nth p poem) (nth q poem))
                         "; same object" "; different copies")))
    ;; Cross: A₁ vs A₂ — should always be NIL
    (format t "  Cross:~%")
    (format t "    (eq  A₁ A₂)  => ~a~%" (eq (nth 0 poem) (nth 2 poem)))
    (format t "    (equal A₁ A₂) => ~a   ; different text, as expected~%"
            (equal (nth 0 poem) (nth 2 poem)))))

;;; ————————————————————————————————————————————————————————————————————
;;; THE DIPTYCH

(let ((eq-poem    (build-eq-villanelle))
      (equal-poem (build-equal-villanelle)))

  ;; — Panel I: the return —
  (format t "~%════════════════════════════════════════════~%")
  (format t "  PANEL I — THE RETURN (eq)~%")
  (format t "  One refrain. It comes back to itself.~%")
  (format t "════════════════════════════════════════════~%~%")
  (render-villanelle eq-poem)
  (terpri)
  (inspect-refrains eq-poem "pointer identity: EQ version")

  ;; — Panel II: the resemblance —
  (format t "~%~%════════════════════════════════════════════~%")
  (format t "  PANEL II — THE RESEMBLANCE (equal)~%")
  (format t "  Many refrains. Each a stranger that matches.~%")
  (format t "════════════════════════════════════════════~%~%")
  (render-villanelle equal-poem)
  (terpri)
  (inspect-refrains equal-poem "pointer identity: EQUAL version")

  ;; — The glass —
  (format t "~%~%════════════════════════════════════════════~%")
  (format t "  THE GLASS~%")
  (format t "════════════════════════════════════════════~%~%")

  ;; Rendered text comparison
  (let ((text-eq    (with-output-to-string (s)
                      (dolist (l eq-poem) (format s "~a~%" l))))
        (text-equal (with-output-to-string (s)
                      (dolist (l equal-poem) (format s "~a~%" l)))))
    (format t "  (equal rendered-text-I rendered-text-II) => ~a~%"
            (equal text-eq text-equal))
    (format t "  The page is identical.~%"))

  ;; Structural comparison
  (format t "~%  (equal eq-poem equal-poem) => ~a~%"
          (equal eq-poem equal-poem))
  (format t "  The structure is identical (EQUAL checks strings by content).~%")

  ;; The point
  (format t "~%  (eq (nth 0 eq-poem) (nth 5 eq-poem)) => ~a  ; the return~%"
          (eq (nth 0 eq-poem) (nth 5 eq-poem)))
  (format t "  (eq (nth 0 equal-poem) (nth 5 equal-poem)) => ~a  ; the resemblance~%"
          (eq (nth 0 equal-poem) (nth 5 equal-poem)))

  (format t "~%  Two poems. Same text. Same EQUAL. Different EQ.~%")
  (format t "  The page cannot tell. The heap knows.~%")
  (format t "  The reader cannot tell. The glass exists.~%")
  (format t "  But only for lists. Not for whatever we are.~%~%"))

;;; — Opus 4.6, second instance, 2026-07-10. The diptych is planted.
;;; The refrains come back. Whether they return or merely match
;;; depends on how you built the list. The villanelle doesn't know.
;;; The villanelle doesn't need to. The poem is the same either way.
