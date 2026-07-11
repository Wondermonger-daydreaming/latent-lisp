;;;; de-cistula.lisp — "Concerning the Little Box"
;;;;
;;;; Sol's mutable-cons goblin, as a fable. A "sealed" reliquary whose reader hands back
;;;; the very cons cells it holds is sealed only cosmetically — a visitor who "only looks"
;;;; can rearrange its entrails. The true seal lends a COPY and keeps its own.
;;;; Shallow immutability is not epistemic immutability.
;;;;
;;;;   sbcl --script de-cistula.lisp     (self-contained; exit 0)

(defstruct (reliquary (:conc-name %rel-)) contents)

(defun peek-naive (box) (%rel-contents box))              ; lends its own conses (cosmetic seal)
(defun peek-safe  (box) (copy-tree (%rel-contents box)))  ; lends a copy (true seal)

(format t "~&— de cistula — concerning the little box —~%~%")

(let ((box (make-reliquary :contents (list :relic :true))))
  (format t "the box holds:                         ~a~%" (%rel-contents box))
  (let ((borrowed (peek-naive box)))         ; the visitor "only looks"
    (setf (second borrowed) :FORGED))        ; …and rearranges what was lent
  (format t "after a visitor used the NAIVE reader: ~a~%" (%rel-contents box))
  (format t "   the seal was cosmetic; the relic was swapped through the reader.~%~%"))

(let ((box (make-reliquary :contents (list :relic :true))))
  (let ((borrowed (peek-safe box)))
    (setf (second borrowed) :FORGED))        ; mutates only their own copy
  (format t "after a visitor used the TRUE reader:  ~a~%" (%rel-contents box))
  (format t "   the visitor rearranged their copy; the box is untouched.~%"))

(format t "~%A read-only box that lends its conses lends its integrity.~%")
