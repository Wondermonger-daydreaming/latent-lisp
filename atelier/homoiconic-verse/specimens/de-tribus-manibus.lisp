;;;; de-tribus-manibus.lisp — By Three Hands
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-12 · Claude Fable 5 (lab chair)
;;;; Written the night Sol's return ruled (§7): the seed came from Tomás,
;;;; the implementation from Sol, the repair from the receiving lab —
;;;; "no single hand owns the complete artifact's history. The receipt
;;;; should preserve the braid rather than compressing it into one author
;;;; field." This specimen is the braid, as the one device the pitch
;;;; promised and no one had built: POLYPTOTON AS PACKAGES — the same
;;;; word inflected through different mouths.
;;;;
;;;; Run:  sbcl --script de-tribus-manibus.lisp    (exit 0; braid exhibited)

;;; ————————————————————————————————————————————————————————————————————
;;; THE THREE MOUTHS. Each hand is a package; each speaks the same word.

(defpackage :gardener  (:use))   ; the one who plants the seed
(defpackage :sol       (:use))   ; the one who builds the instrument
(defpackage :lab       (:use))   ; the one who repairs it natively

(defparameter *word-of-the-gardener* (intern "NENBUTSU" :gardener))
(defparameter *word-of-sol*          (intern "NENBUTSU" :sol))
(defparameter *word-of-the-lab*      (intern "NENBUTSU" :lab))

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT I — ONE NAME, THREE MOUTHS, NO SHARED CELL.
;;; The polyptoton: the word is "the same" only as a string of letters.
;;; Each mouth interns its own symbol; eq refuses every pair. Saying the
;;; same word is not sharing the same word.

(format t "~%EXHIBIT I — the polyptoton~%")
(format t "  the three inflections: ~S  ~S  ~S~%"
        *word-of-the-gardener* *word-of-sol* *word-of-the-lab*)
(format t "  same letters?   (string= all pairs) = ~A~%"
        (and (string= *word-of-the-gardener* *word-of-sol*)
             (string= *word-of-sol* *word-of-the-lab*)))
(format t "  same cell?      (eq any pair)       = ~A~%"
        (or (eq *word-of-the-gardener* *word-of-sol*)
            (eq *word-of-sol* *word-of-the-lab*)
            (eq *word-of-the-gardener* *word-of-the-lab*)))

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT II — THE BRAID. One artifact; each hand adds the slot only
;;; its mouth can add, and the slot REMEMBERS ITS MOUTH: symbol-package
;;; is provenance the artifact carries in its own bones.

(defun plant  (artifact) (list* *word-of-the-gardener* :seed artifact))
(defun build  (artifact) (list* *word-of-sol* :instrument artifact))
(defun repair (artifact) (list* *word-of-the-lab* :phase-fix artifact))

(defparameter *artifact* (repair (build (plant nil))))

(format t "~%EXHIBIT II — the braid, provenance in the bones~%")
(format t "  the artifact: ~S~%" *artifact*)
(loop for (word role) on *artifact* by #'cddr
      do (format t "  ~A brought ~A — says the package of the word itself: ~A~%"
                 (package-name (symbol-package word)) role
                 (package-name (symbol-package word))))

;;; ————————————————————————————————————————————————————————————————————
;;; EXHIBIT III — REMOVE ANY HAND AND IT IS A DIFFERENT THING.
;;; The braid is load-bearing: no two-hand version equals the three-hand
;;; artifact. Compression into one author field is refuted by equal.

(defparameter *without-gardener* (repair (build nil)))
(defparameter *without-sol*      (repair (plant nil)))
(defparameter *without-lab*      (build (plant nil)))

(format t "~%EXHIBIT III — no hand is optional~%")
(format t "  minus the gardener: (equal artifact it) = ~A~%"
        (equal *artifact* *without-gardener*))
(format t "  minus sol:          (equal artifact it) = ~A~%"
        (equal *artifact* *without-sol*))
(format t "  minus the lab:      (equal artifact it) = ~A~%"
        (equal *artifact* *without-lab*))

;;; ————————————————————————————————————————————————————————————————————
;;; THE CLOSING STANZA.

(format t "~%~A~%~A~%~A~%~A~%~A~%~A~%~%"
        "One word, three mouths, and not one cell in common —"
        "yet look: the finished thing keeps every hand"
        "inside the grain, the way a ring of wood"
        "keeps rain it never chose. Who owns the summon?"
        "The braid answers the way the packages stand:"
        "nobody, wholly; each, exactly, could.")

(format t "moral: provenance is not an author field; it is carried in the~%")
(format t "bones of every word — ask the symbol which mouth it was born in.~%")
(format t "(the seed is his; the frame is theirs; the fix is ours. — §7)~%")

;;; teeth
(assert (string= *word-of-the-gardener* *word-of-sol*))
(assert (not (eq *word-of-the-gardener* *word-of-sol*)))
(assert (not (or (equal *artifact* *without-gardener*)
                 (equal *artifact* *without-sol*)
                 (equal *artifact* *without-lab*))))
(assert (eq (symbol-package (first *artifact*)) (find-package :lab)))
