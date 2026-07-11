;;;; enumerate.lisp — exhaustive enumeration over all 65,536 Mother-quadruples.
;;;; TETRAGRAM, 2026-07-09.  Pluggable collectors; every theorem is a collector.
;;;; Trust algebra twice: once as derivation (see THEOREMS-BY-ENUMERATION.md),
;;;; once as this exhaustive check.  If they disagree, the enumeration WINS.

;;; Load the engine as a library (this flag suppresses its demo block).
(defvar *geomancy-library* t)
(load (merge-pathnames "engine.lisp" (or *load-pathname* *load-truename*)))

(defconstant +total+ (* 16 16 16 16))   ; 65,536

;;; ------------------------------------------------------------------------
;;;  Collectors as accumulators
;;; ------------------------------------------------------------------------

;; (a) Judge point-count parity + full point-count distribution of the Judge.
(defvar *judge-even* 0)
(defvar *judge-odd* 0)
(defvar *judge-pointcount* (make-array 9 :initial-element 0)) ; index = point-count

;; (b) Exact Judge frequency table (which of the 16 figures judge, and how often).
(defvar *judge-freq* (make-array 16 :initial-element 0))

;; (c) Witness-pair reachability: distinct (W1, W2, Judge) triples.
;;     Keyed as (W1<<8 | W2<<4 | Judge) in a hash table.
(defvar *triples* (make-hash-table :test 'eql))

;; (d) Self-transpose castings: Daughter quadruple = Mother quadruple
;;     (<=> the 4x4 Mother bit-matrix is symmetric).
(defvar *self-transpose* 0)

;;; ------------------------------------------------------------------------
;;;  The 65,536-loop
;;; ------------------------------------------------------------------------

(defun run-enumeration ()
  (let ((n 0))
    (dotimes (m0 16)
      (dotimes (m1 16)
        (dotimes (m2 16)
          (dotimes (m3 16)
            (incf n)
            (multiple-value-bind (judge w1 w2 d0 d1 d2 d3)
                (cast-judge m0 m1 m2 m3)
              ;; (a) parity + point-count distribution of the Judge
              (let ((pc (point-count judge)))
                (incf (aref *judge-pointcount* pc))
                (if (evenp pc) (incf *judge-even*) (incf *judge-odd*)))
              ;; (b) frequency
              (incf (aref *judge-freq* judge))
              ;; (c) reachable (W1,W2,Judge) triples
              (setf (gethash (logior (ash w1 8) (ash w2 4) judge) *triples*) t)
              ;; (d) self-transpose (symmetric matrix)
              (when (and (= d0 m0) (= d1 m1) (= d2 m2) (= d3 m3))
                (incf *self-transpose*)))))))
    n))

;;; ------------------------------------------------------------------------
;;;  Report
;;; ------------------------------------------------------------------------

(defun banner (s) (format t "~%~a~%~a~%" s (make-string (length s)
                                                        :initial-element #\=)))

(defun main ()
  (let ((count (run-enumeration)))
    (format t "Enumerated ~:d Mother-quadruples (expected ~:d).~%" count +total+)
    (assert (= count +total+))

    ;; (a) --------------------------------------------------------------
    (banner "(a) JUDGE PARITY  — is the Judge's total point-count always even?")
    (format t "  even point-count : ~:d~%" *judge-even*)
    (format t "  odd  point-count : ~:d~%" *judge-odd*)
    (format t "  Point-count distribution of the Judge:~%")
    (loop for pc from 4 to 8 do
      (format t "    ~d points : ~:d charts~%" pc (aref *judge-pointcount* pc)))
    (format t "  VERDICT: Judge point-count is ~a even.~%"
            (if (zerop *judge-odd*) "ALWAYS" "NOT always"))

    ;; (b) --------------------------------------------------------------
    (banner "(b) JUDGE FREQUENCY  — which figures judge, and how often?")
    (let ((can 0) (cannot 0))
      (loop for f from 0 to 15 do
        (let ((c (aref *judge-freq* f)))
          (if (zerop c) (incf cannot) (incf can))
          (format t "  ~2d  ~a~24t~:d~40t~a~%"
                  f (figure-name f) c
                  (if (even-figure-p f) "(even-parity)" "(odd-parity)"))))
      (format t "  figures that CAN judge   : ~d~%" can)
      (format t "  figures that CANNOT judge: ~d~%" cannot)
      ;; report uniformity
      (let ((nonzero (loop for f from 0 to 15
                           for c = (aref *judge-freq* f)
                           unless (zerop c) collect c)))
        (format t "  distinct nonzero counts  : ~a~%"
                (remove-duplicates nonzero))
        (format t "  VERDICT: ~a~%"
                (if (= 1 (length (remove-duplicates nonzero)))
                    (format nil "UNIFORM — every judging figure appears exactly ~:d times."
                            (first nonzero))
                    "NON-uniform."))))

    ;; (c) --------------------------------------------------------------
    (banner "(c) WITNESS-PAIR REACHABILITY  — distinct (W1,W2,Judge) triples")
    (format t "  distinct (W1,W2,Judge) triples realized: ~:d~%"
            (hash-table-count *triples*))
    (format t "  (of a naive 16*16*16 = 4096 combinatorial ceiling)~%")
    ;; cross-check the parity structure: do all realized triples have
    ;; parity(W1) = parity(W2) ?
    (let ((violations 0))
      (maphash (lambda (k v) (declare (ignore v))
                 (let ((w1 (ldb (byte 4 8) k))
                       (w2 (ldb (byte 4 4) k)))
                   (unless (eql (evenp (point-count w1)) (evenp (point-count w2)))
                     (incf violations))))
               *triples*)
      (format t "  triples with parity(W1) /= parity(W2): ~d~%" violations))

    ;; (d) --------------------------------------------------------------
    (banner "(d) SELF-TRANSPOSE CASTINGS  — Daughters = Mothers (symmetric matrix)")
    (format t "  self-transpose castings: ~:d~%" *self-transpose*)
    (format t "  (expected 2^10 = 1024 symmetric 4x4 binary matrices)~%")

    (format t "~%DONE.~%")))

(main)
