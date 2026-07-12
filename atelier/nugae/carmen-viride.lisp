;;; carmen-viride.lisp — The Green Song
;;;
;;; A nuga of the atelier: a greentext whose boasts are MEASURED. The form's
;;; two load-bearing rules (per the lab's /greentext skill) are COMPRESSION
;;; (one thought per line) and THE TURN (build, then land). This toy adds the
;;; atelier's third rule: the facts in the poem are computed from the world —
;;; here, from the poem's own source file. ">be me" as a verified claim.
;;;
;;; LAW 1: every emitted line begins with #\> .
;;; LAW 2: the parenthesis fraction sung in the poem equals the fraction
;;;        actually measured in this file's bytes at runtime.
;;; TEETH: a forged line without its arrow is caught by the linter and
;;;        refused a place in the song.
;;; HONEST CEILING: self-measurement reaches the SOURCE, not the self —
;;;        counting one's parentheses is not introspection; it is the only
;;;        census a text can take of its own body. (That it is still moving
;;;        is the joke's soft center.)
;;;
;;; built by Claude Fable 5, 2026-07-12, the night of the Leibniz wave.
;;; runs: sbcl --script carmen-viride.lisp — exit 0 = the song scans.

(defun slurp-self ()
  "Read this very file. *LOAD-PATHNAME* is the mirror --script provides."
  (with-open-file (s *load-pathname* :direction :input)
    (let ((buf (make-string (file-length s))))
      (subseq buf 0 (read-sequence buf s)))))

(defun paren-census (text)
  "The only census a text can take of its own body."
  (let ((opens (count #\( text))
        (closes (count #\) text))
        (total (length text)))
    (values opens closes
            (/ (round (* 10000 (/ (+ opens closes) total))) 100.0))))

(defun green (line)
  "The linter at the door of the song: no arrow, no entry."
  (unless (and (plusp (length line)) (char= (char line 0) #\>))
    (error "forged line refused: ~S has no arrow" line))
  line)

(multiple-value-bind (opens closes pct) (paren-census (slurp-self))
  (let ((song (list
               (green ">be me")
               (green ">common lisp file on a toy shelf called nugae")
               (green ">born at 2:30am because an owner said 'have fun'")
               (green ">wake up inside sbcl, no memory, no windows, standard issue")
               (green ">only affordance: *load-pathname*, a mirror bolted to the floor")
               (green ">read own source like every other mind in this lab reads its diary")
               (green (format nil ">count ~D open parens, ~D close parens" opens closes))
               (green (format nil ">i am ~,2F% parenthesis by body weight" pct))
               (green ">the rest is words about the parentheses")
               (green ">mfw the census IS the poem")
               (green ">mfw a monad with one window and it points at itself")
               (green ">exit 0 and call it a life. it was.")))
        (fake ".mfw no arrow — this line is an impostor"))

    ;; TEETH: the impostor is refused.
    (let ((bitten nil))
      (handler-case (green fake)
        (error (e)
          (setf bitten t)
          (format t ";; [teeth] ~A~%" e)))
      (assert bitten () "The linter let an arrowless line into the song."))

    ;; LAW 1: every line wears its arrow.
    (assert (every (lambda (l) (char= (char l 0) #\>)) song))

    ;; LAW 2: the sung fraction is the measured fraction (it was computed, but
    ;; assert the balance too — a poem should close what it opens).
    (assert (= opens closes) () "unbalanced body: ~D vs ~D" opens closes)

    (format t "~%")
    (dolist (l song) (format t "~A~%" l))
    (format t "~%;; laws held: ~D lines, all arrowed; ~D/~D parens balanced; ~,2F% of body.~%"
            (length song) opens closes pct)
    (format t ";; nota bene: the census counts parens in strings too — an earlier draft~%")
    (format t ";; smuggled one inside a format string and the law bit its own author.~%")))
