;;;; de-cistula.lisp — "Concerning the Little Box"   (hardened after the cold chair)
;;;;
;;;; Sol caught this toy committing its own sin one layer deeper: the "true seal" copied the
;;;; cons skeleton but SHARED its mutable leaves. So the fable grew a third movement.
;;;;   I.   the naive reader lends its conses           → the box is rearranged
;;;;   II.  the cons-safe reader (copy-tree) lends its FRUIT → a shared string is still edited
;;;;   III. the deep reader copies the admitted grammar, leaves and all → the box is whole
;;;; A copied tree may still share its fruit.   sbcl --script de-cistula.lisp   (exit 0)

(defstruct (reliquary (:conc-name %rel-)) contents)

(defun peek-naive     (box) (%rel-contents box))                 ; lends its own conses
(defun peek-cons-safe (box) (copy-tree (%rel-contents box)))     ; copies conses, SHARES mutable leaves
(defun deep-copy (x)                                             ; copies the admitted grammar (cons + string)
  (typecase x
    (cons   (cons (deep-copy (car x)) (deep-copy (cdr x))))
    (string (copy-seq x))
    (t      x)))                                                 ; immutable atoms shared harmlessly
(defun peek-deep (box) (deep-copy (%rel-contents box)))

(format t "~&— de cistula — concerning the little box —~%~%")

(format t "I. the naive reader lends its conses:~%")
(let ((box (make-reliquary :contents (list :relic :true))))
  (let ((borrowed (peek-naive box))) (setf (second borrowed) :FORGED))
  (format t "   after a visitor 'only looked':  ~a   ← the box was rearranged~%~%" (%rel-contents box)))

(format t "II. the cons-safe reader still lends its FRUIT (Sol's catch):~%")
(let ((box (make-reliquary :contents (list :relic (copy-seq "TRUE")))))
  (let ((borrowed (peek-cons-safe box))) (setf (char (second borrowed) 0) #\F))
  (format t "   after editing the shared string: ~s   ← copy-tree copied the branches, not the leaf~%~%"
          (%rel-contents box)))

(format t "III. the deep reader copies the admitted grammar, leaves and all:~%")
(let ((box (make-reliquary :contents (list :relic (copy-seq "TRUE")))))
  (let ((borrowed (peek-deep box))) (setf (char (second borrowed) 0) #\F))
  (format t "   after the same edit:             ~s   ← the box is whole~%~%" (%rel-contents box)))

(format t "A copied tree may still share its fruit.~%")
(format t "Do not promise universal immutability; define the payload domain and copy THAT correctly.~%")
