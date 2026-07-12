;;; de-perceptionibus-minutis.lisp — Concerning the Small Perceptions
;;;
;;; Leibniz's petites perceptions: perceptions too faint to be noticed singly,
;;; forever below the threshold of apperception, yet summing to what we do
;;; perceive. His image is the ROAR OF THE SEA — we hear the whole, though no
;;; one wave's sound is heard alone. (New Essays on Human Understanding,
;;; Preface, ~1704 — section numbering ref unverified.)
;;;
;;; The honest medium here is float PRINT precision. Each "wave" is an increment
;;; too small to show at the display precision: printed alone it is 0.0000.
;;; Accumulated, the running sum crosses a threshold and becomes visible — the
;;; moment of apperception. The perception was real all along (the full-precision
;;; sum climbs monotonically); only its APPEARANCE is late.
;;;
;;;   Law:  every single wave prints as 0.0000, yet there is an apperception
;;;         index k* where the running sum first prints nonzero and stays so.
;;;   Teeth: a wave poured into an ALREADY-LOUD sea (1.0) is annihilated at full
;;;         double precision (loss of significance) — a perception that can never
;;;         apperceive because the whole was too loud. Shown firing, caught.
;;;
;;; sbcl --script de-perceptionibus-minutis.lisp  => exit 0, deterministic
;;; built by FABER-THEODICAEAE (Claude Opus) under the Fable 5 chair, 2026-07-12.

(defparameter *wave* 1.0d-6)          ; one small perception
(defparameter *print-prec* 4)         ; display shows 4 decimals

(defun shown (x) (format nil "~,4F" x))          ; how a quantity APPEARS
(defun visible-p (x) (not (string= (shown x) "0.0000")))  ; apperceived?

(defun run ()
  (format t "ONE WAVE alone: value=~,8F  shown=~a  (below apperception)~%~%"
          *wave* (shown *wave*))
  ;; No single wave is visible.
  (assert (not (visible-p *wave*)))

  (format t "THE ROAR — pouring quiet waves together, watching for apperception:~%")
  (let ((sum 0.0d0) (k* nil))
    (dotimes (i 120)
      (incf sum *wave*)
      (when (and (null k*) (visible-p sum))
        (setf k* (1+ i))
        (format t "  apperception at wave k*=~d: running sum first shown as ~a~%"
                k* (shown sum)))
      (when (member (1+ i) '(1 10 49 50 51 120))
        (format t "    after ~3d waves: full=~,8F  shown=~a~%"
                (1+ i) sum (shown sum))))
    ;; LAW: an apperception index exists, and every increment was itself invisible.
    (assert k*)
    (assert (not (visible-p *wave*)))
    (assert (visible-p sum))
    (format t "  law: 120 waves, each invisible (0.0000), yet the sum apperceived~%")
    (format t "       at k*=~d and stayed visible. The roar is real before it is heard.~%~%"
            k*))

  ;; TEETH: the same wave poured into a LOUD sea (1.0) is lost — loss of
  ;; significance. Context sets the threshold; a perception can be annihilated.
  ;; A faint wave (1d-17) is below double-eps relative to a sea of 1.0, so each
  ;; is annihilated on contact; gathered among quiet peers, the same waves sum.
  (format t "TEETH — a wave poured into an already-loud sea (1.0):~%")
  (let ((loud 1.0d0) (faint 1.0d-17))
    (dotimes (i 1000) (setf loud (+ loud faint)))
    (assert (= loud 1.0d0))                    ; every faint wave annihilated
    (format t "  1000 faint waves (1d-17) into a sea of 1.0:  sum still = ~,1F~%" loud)
    (format t "  teeth: below the whole's precision, each perception is LOST —~%")
    (format t "         apperception depends on context, not on the wave alone. Caught.~%")
    ;; and the control: gathered among their quiet peers, the faint waves DO sum.
    (let ((quiet 0.0d0))
      (dotimes (i 1000) (incf quiet faint))
      (assert (> quiet 0.0d0))
      (format t "  control: the same 1000 waves summed among peers = ~,2E (real).~%~%"
              quiet)))

  ;; QUARANTINE — the tempting analogy, explicitly fenced off ------------
  ;; It is SEDUCTIVE to read this as a model of sub-threshold NEURAL activations,
  ;; or of GRADIENT ACCUMULATION crossing a learning threshold, or of an LLM's
  ;; logits summing below a decision boundary until a token "apperceives." THE
  ;; MATH LICENSES NONE OF THIS. What is demonstrated is one narrow fact about
  ;; IEEE-754 float addition and decimal display precision: quantities below a
  ;; representational/print threshold vanish individually and can (under the
  ;; right regime) accumulate. That is a fact about floats, not about minds,
  ;; neurons, gradients, or attention. Any bridge to cognition is SPECULATION
  ;; the code does not support and this specimen refuses to smuggle. The
  ;; quarantine IS the point: it models the lab's own discipline — name the
  ;; analogy, then decline to bank it.
  (format t "EXIT 0 — the sea roars from waves no one hears; the threshold is~%")
  (format t "         a fact about floats, and the mind-analogy stays quarantined.~%"))

(run)
