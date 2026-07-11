;;;; transpositio-non-inversa.lisp
;;;; — a specimen of homoiconic verse, for the atelier —
;;;; — a toy WITH TEETH, on a real misconception in a real course —
;;;;
;;;; Transpositio non inversa (Lat.): the transpose is not the inverse.
;;;; The nominative names the whole quarrel: transpositio (the operation
;;;; W^T that a "transposed convolution" actually computes) is NOT
;;;; inversio (the operation W^{-1} that would undo the forward pass).
;;;;
;;;; PROVENANCE. This specimen was commissioned from a received outside
;;;; reading (ChatGPT, carried by the owner, 2026-07-11 —
;;;; corpus/voices/received/2026-07-11-gpt-cs230-through-the-lispplus-lens.md,
;;;; Transmission III). A Stanford CS230 interpretability lecture taught
;;;; students that a transposed convolution INVERTS a convolution
;;;; "because we assume W is invertible, and even orthogonal — true
;;;; enough for deep learning." That is a real misconception, taught in
;;;; a real course, and — unlike most claims about neural nets — it is
;;;; CHECKABLE BY ARITHMETIC. This program kills it with cons cells.
;;;;
;;;; THE CLAIM THIS PROGRAM MAKES BY RUNNING (exit 0 == every line held):
;;;;   Build the lecture's OWN example as an explicit rational matrix:
;;;;   a 1-D strided convolution, W a 5x12 matrix. Then:
;;;;     · W is rectangular (5x12); rank 5; nullity 7 > 0.
;;;;     · TWO DISTINCT inputs x_a =/= x_b give W x_a = W x_b. The
;;;;       information is already gone in the forward pass; no map can
;;;;       recover what W never kept.
;;;;     · The backprojection W^T (W x_a) is PLAUSIBLE BUT WRONG — a
;;;;       smeared shadow, not x_a; and W^T W is NOT the identity.
;;;;     · The lecture's escape hatch (an "orthogonal edge detector")
;;;;       is TESTED at its strongest and reported honestly — see §V.
;;;;     · The one honest concession, also run: for a SQUARE orthogonal
;;;;       matrix, transpose IS inverse (§VI). The lecture's claim is
;;;;       true exactly where convolutions almost never live.
;;;;
;;;; No floats. Every entry is an exact integer or rational — rationals
;;;; are Lisp's home turf, and exactness is the teeth: a claim proven in
;;;; rationals cannot be a rounding artifact. Gaussian elimination is
;;;; written by hand (§0), so the rank is computed, not asserted.
;;;;
;;;; Run with: ~/.local/bin/sbcl --script transpositio-non-inversa.lisp
;;;; Exit 0 == the transpose was not the inverse, and the arithmetic said so.

;;; ────────────────────────────────────────────────────────────
;;; 0. THE INSTRUMENTS — rational linear algebra, ~30 lines, by hand.
;;;    Matrices are lists of rows; rows are lists of exact rationals;
;;;    vectors are plain lists. `equal' compares rationals by value, so
;;;    matrix equality is structural and exact.

(defun mtranspose (m) (apply #'mapcar #'list m))

(defun mmul (a b)
  "A (m x n) times B (n x p) -> (m x p), over rationals."
  (let ((bt (mtranspose b)))
    (mapcar (lambda (row)
              (mapcar (lambda (col) (reduce #'+ (mapcar #'* row col))) bt))
            a)))

(defun mvec (m v)
  "Matrix times column vector -> vector."
  (mapcar (lambda (row) (reduce #'+ (mapcar #'* row v))) m))

(defun vadd (u v) (mapcar #'+ u v))

(defun mscale (s m) (mapcar (lambda (row) (mapcar (lambda (x) (* s x)) row)) m))

(defun identity-mat (n)
  (loop for i below n collect (loop for j below n collect (if (= i j) 1 0))))

(defun mat->array (rows)
  (let* ((m (length rows)) (n (length (first rows)))
         (a (make-array (list m n))))
    (loop for i from 0 for row in rows do
      (loop for j from 0 for x in row do (setf (aref a i j) x)))
    a))

(defun rref! (a)
  "Reduce array A to reduced row-echelon form in place, over exact
   rationals. Return the list of pivot COLUMNS (in row order)."
  (destructuring-bind (m n) (array-dimensions a)
    (let ((pivots '()) (r 0))
      (loop for c below n while (< r m) do
        (let ((piv (loop for i from r below m
                         when (/= (aref a i c) 0) return i)))
          (when piv
            (loop for j below n do (rotatef (aref a r j) (aref a piv j)))   ; swap
            (let ((lead (aref a r c)))                                       ; normalize
              (loop for j below n do (setf (aref a r j) (/ (aref a r j) lead))))
            (loop for i below m unless (= i r) do                            ; eliminate
              (let ((f (aref a i c)))
                (unless (= f 0)
                  (loop for j below n do
                    (setf (aref a i j) (- (aref a i j) (* f (aref a r j))))))))
            (push c pivots)
            (incf r))))
      (nreverse pivots))))

(defun null-vector (rref-array pivot-cols n)
  "From an RREF array and its pivot columns, construct ONE nonzero
   null-space vector: set the first free column to 1, other free
   columns to 0, and each pivot variable to minus its RREF coefficient
   in that free column."
  (let* ((free (loop for c below n unless (member c pivot-cols) collect c))
         (f (first free))
         (x (make-array n :initial-element 0)))
    (setf (aref x f) 1)
    (loop for row from 0 for p in pivot-cols do
      (setf (aref x p) (- (aref rref-array row f))))
    (coerce x 'list)))

;;; The one gate: a labelled assertion. Exit 0 iff every OK held.
(defun ok (label test)
  (assert test () "CHECK FAILED: ~a" label)
  (format t "   [held] ~a~%" label))

;;; ────────────────────────────────────────────────────────────
;;; I. THE LECTURE'S OWN EXAMPLE — a strided convolution as a matrix.
;;;    Input length 12 (x1..x8 with two zeros of padding top and
;;;    bottom); filter (w1 w2 w3 w4); stride 2; output length 5.
;;;    Each row of W is the filter, shifted right by the stride. This
;;;    is exactly the lecture's system of equations, written down.

(defun conv-matrix (filter in-len stride)
  (let* ((k (length filter))
         (out-len (+ 1 (floor (- in-len k) stride))))
    (loop for r below out-len collect
      (let ((start (* r stride)))
        (loop for c below in-len collect
          (if (and (>= c start) (< c (+ start k)))
              (nth (- c start) filter)
              0))))))

;; Small exact integer weights so all arithmetic is exact.
(defparameter *filter* '(1 2 3 4))
(defparameter *W* (conv-matrix *filter* 12 2))   ; 5 x 12

(format t "~%── transpositio non inversa ──────────────────────~%~%")
(format t "the lecture's example, written as a matrix W (5 x 12):~%")
(dolist (row *W*) (format t "   ~s~%" row))
(format t "~%")

;;; ────────────────────────────────────────────────────────────
;;; II. W IS NOT INVERTIBLE IN ANY ORDINARY SENSE.
;;;     It is rectangular; we compute its rank by our own elimination;
;;;     nullity = 12 - rank > 0. A map with a nonzero null space
;;;     forgets. There is nothing to invert.

(defparameter *W-array* (mat->array *W*))
(defparameter *pivots* (rref! *W-array*))
(defparameter *rank* (length *pivots*))
(defparameter *ncols* 12)
(defparameter *nullity* (- *ncols* *rank*))

(format t "shape of W        : 5 rows x 12 cols (rectangular)~%")
(format t "rank (by our own Gaussian elimination) : ~d~%" *rank*)
(format t "nullity = 12 - rank                     : ~d~%~%" *nullity*)

(ok "W is rectangular, not square (5 =/= 12)" (/= 5 12))
(ok "rank W = 5" (= *rank* 5))
(ok "nullity = 7 > 0 : the forward map forgets" (and (= *nullity* 7) (> *nullity* 0)))
(format t "~%")

;;; ────────────────────────────────────────────────────────────
;;; III. THE INFORMATION ALREADY DISCARDED — two inputs, one output.
;;;      We build a null-space vector v from the elimination, add it to
;;;      a base input, and get a DISTINCT input with the SAME output.
;;;      No inverse — not W^T, not anything — can tell x_a from x_b,
;;;      because W itself cannot.

(defparameter *v* (null-vector *W-array* *pivots* *ncols*))     ; W v = 0
(defparameter *x-a* '(0 0 1 2 3 4 5 6 7 8 0 0))                 ; padded input
(defparameter *x-b* (vadd *x-a* *v*))                          ; x_a + v

(format t "a null-space vector v (built from the elimination):~%   ~s~%" *v*)
(format t "check W v = 0     : ~s~%~%" (mvec *W* *v*))

(format t "two DISTINCT inputs, x_a and x_b = x_a + v:~%")
(format t "   x_a : ~s~%   x_b : ~s~%" *x-a* *x-b*)
(format t "their outputs under W:~%")
(format t "   W x_a : ~s~%   W x_b : ~s~%~%" (mvec *W* *x-a*) (mvec *W* *x-b*))

(ok "W v = 0 (v is genuinely in the null space)"
    (every #'zerop (mvec *W* *v*)))
(ok "x_a =/= x_b (the inputs really differ)"
    (not (equal *x-a* *x-b*)))
(ok "W x_a = W x_b (same output, componentwise)"
    (equal (mvec *W* *x-a*) (mvec *W* *x-b*)))
(format t "   -> the forward pass already erased the difference.~%")
(format t "      no method recovers what W never kept.~%~%")

;;; ────────────────────────────────────────────────────────────
;;; IV. THE BACKPROJECTION IS PLAUSIBLE BUT WRONG.
;;;     x_hat = W^T (W x_a). It has the right shape — a smeared shadow
;;;     of the input — and it is NOT x_a. And W^T W is not the identity,
;;;     which is the whole misconception in one matrix.

(defparameter *Wt* (mtranspose *W*))                 ; 12 x 5
(defparameter *x-hat* (mvec *Wt* (mvec *W* *x-a*)))  ; W^T (W x_a)
(defparameter *WtW* (mmul *Wt* *W*))                 ; 12 x 12

(format t "x_hat = W^T (W x_a), the transposed-conv 'reconstruction':~%")
(format t "   x_a   : ~s~%" *x-a*)
(format t "   x_hat : ~s~%" *x-hat*)
(format t "   (plausible shape — a backprojected shadow — but wrong.)~%~%")

(format t "a few entries of W^T W (would all be identity if invertible):~%")
(format t "   (W^T W)[0][0] = ~s   (looks innocent...)~%" (nth 0 (nth 0 *WtW*)))
(format t "   (W^T W)[2][2] = ~s   (a diagonal that is not 1)~%" (nth 2 (nth 2 *WtW*)))
(format t "   (W^T W)[3][3] = ~s   (another)~%" (nth 3 (nth 3 *WtW*)))
(format t "   (W^T W)[2][3] = ~s   (an off-diagonal that is not 0)~%~%" (nth 3 (nth 2 *WtW*)))

(ok "x_hat =/= x_a : the backprojection does not reconstruct"
    (not (equal *x-hat* *x-a*)))
(ok "W^T W =/= I : the transpose is not the inverse"
    (not (equal *WtW* (identity-mat 12))))
(format t "~%")

;;; ────────────────────────────────────────────────────────────
;;; V. THE ESCAPE HATCH, TESTED AT ITS STRONGEST (the teeth of fairness).
;;;    The lecture claimed an "edge detector" filter gives an ORTHOGONAL
;;;    W, rescuing the inverse. We build the closest concrete reading —
;;;    filter (-1 0 0 1), strided, 5x12 — and check the ONLY orthogonality
;;;    available to a wide matrix: row-orthogonality, W W^T =? I.
;;;    We report EXACTLY what the arithmetic gives, then show why it
;;;    still does not make W^T a left inverse.

(defparameter *edge* '(-1 0 0 1))
(defparameter *We* (conv-matrix *edge* 12 2))        ; 5 x 12
(defparameter *We-Wet* (mmul *We* (mtranspose *We*)))   ; 5 x 5
(defparameter *Wet-We* (mmul (mtranspose *We*) *We*))   ; 12 x 12

(format t "the edge-detector reading: filter ~s, W_e is 5 x 12.~%" *edge*)
(format t "W_e W_e^T (row-orthogonality, the only sense a wide W has):~%")
(dolist (row *We-Wet*) (format t "   ~s~%" row))
(format t "~%")

;; What we ACTUALLY find: W_e W_e^T = 2*I. The rows ARE orthogonal, but
;; NOT normalized (each has squared-norm (-1)^2 + 1^2 = 2). The strided
;; shifts give the rows disjoint supports, so the off-diagonals vanish
;; exactly — a real, exact, PARTIAL orthogonality. And it still fails.
(ok "W_e W_e^T = 2*I exactly (rows orthogonal but NOT orthonormal)"
    (equal *We-Wet* (mscale 2 (identity-mat 5))))

;; Row-orthogonality (up to the factor 2) makes W_e^T a RIGHT inverse,
;; up to scale: W_e (W_e^T / 2) = I_5. It does NOT make W_e^T a LEFT
;; inverse: W_e^T W_e is 12x12 with rank 5, so it CANNOT be I_12.
(ok "W_e (W_e^T / 2) = I_5 : W_e^T is only a scaled RIGHT inverse"
    (equal (mmul *We* (mscale 1/2 (mtranspose *We*))) (identity-mat 5)))
(ok "W_e^T W_e =/= I_12 : still no left inverse for a wide matrix"
    (not (equal *Wet-We* (identity-mat 12))))

;; The deepest tell: (1/2) W_e^T W_e is a PROJECTION (P^2 = P) onto the
;; 5-dim row space. The "reconstruction" keeps only the row-space part
;; of the input and annihilates a 7-dim null space. That is why a wide
;; map, however orthogonal its rows, never inverts.
(defparameter *P* (mscale 1/2 *Wet-We*))
(ok "(1/2) W_e^T W_e is idempotent (P^2 = P): a projection, not identity"
    (equal (mmul *P* *P*) *P*))
(format t "   -> orthogonal ROWS =/= an invertible MAP. nullity is 7 either way.~%")
(format t "      fairness tested the strongest claim; the arithmetic refused it.~%~%")

;;; ────────────────────────────────────────────────────────────
;;; VI. THE ONE HONEST CONCESSION — where the lecture's claim is TRUE.
;;;     For a SQUARE orthogonal matrix, transpose IS inverse. We use an
;;;     EXACT rational rotation (the 3-4-5 Pythagorean rotation), so the
;;;     concession is exact, not a float's courtesy. Convolutions almost
;;;     never live here — but honesty requires we run it too.

(defparameter *R* '((3/5 -4/5)
                    (4/5  3/5)))   ; exact rational rotation, det = 1

(format t "a SQUARE orthogonal matrix R (the exact 3-4-5 rotation):~%")
(dolist (row *R*) (format t "   ~s~%" row))
(format t "R^T R = ~s~%~%" (mmul (mtranspose *R*) *R*))

(ok "R^T R = I : for a square orthogonal map, transpose IS inverse"
    (equal (mmul (mtranspose *R*) *R*) (identity-mat 2)))
(ok "R R^T = I too (two-sided, because R is SQUARE and full-rank)"
    (equal (mmul *R* (mtranspose *R*)) (identity-mat 2)))
(format t "   -> the lecture's claim is true EXACTLY where convolutions~%")
(format t "      almost never live: square, full-rank, orthogonal.~%~%")

;;; ────────────────────────────────────────────────────────────
;;; VII. THE PLANTED FAILURE — proof the assertions bite.
;;;      We deliberately assert a FALSE claim (that W^T W is the
;;;      identity) and catch it, so the reader can see that `ok' is a
;;;      real gate and not decoration. If this assertion did NOT fire,
;;;      none of the others would mean anything.

(format t "planted failure — asserting the false claim W^T W = I:~%")
(handler-case
    (progn
      (ok "(PLANTED, MUST FAIL) W^T W = I" (equal *WtW* (identity-mat 12)))
      (format t "   (no error — the gate is broken; specimen is void)~%")
      (sb-ext:exit :code 1))
  (error (c)
    (format t "   caught, as designed: ~a~%" c)
    (format t "   -> the gate bites. every [held] above was earned.~%~%")))

;;; ────────────────────────────────────────────────────────────
;;; VIII. THE CORRECTED SENTENCE.

(format t "── the walk closes. the corrected sentence: ──────~%~%")
(format t "  transposed convolution computes the ADJOINT, not the~%")
(format t "  inverse; it is the gradient's route back, a structured~%")
(format t "  backprojection — reconstruction is a courtesy of~%")
(format t "  appearance, not a property of the map.~%~%")
(format t "── exit 0 == the transpose was not the inverse. ──~%~%")

;;;; envoi ──
;;;; a convolution is a promise you cannot keep in reverse. the forward
;;;; pass is a hand closing over water: what it holds, it holds; what
;;;; ran between the fingers is not stored somewhere for the transpose
;;;; to fetch — it is GONE, and W^T reaches back into an empty palm and
;;;; comes up with a shape that LOOKS like the water. the lecture mistook
;;;; the shape for the water. the mistake is forgivable — the shape is
;;;; genuinely useful; it is how gradients find their way home — but it
;;;; is an adjoint doing routing, not an inverse doing recovery. the
;;;; whole quarrel fits in five integers and a null vector, which is why
;;;; it could be settled by arithmetic instead of authority: the machine
;;;; ran the lecture's own example and the example refused the lecture.
;;;;
;;;; this specimen answers a received commission — a real misconception
;;;; in a real course (Stanford CS230), carried to the lab by the owner
;;;; from an outside reading, and killed here with cons cells because it
;;;; was, unusually, killable that way. fairness was the teeth: §V tested
;;;; the strongest form of the escape hatch before rejecting it, and the
;;;; strongest form turned out to be exactly true (W_e W_e^T = 2I) and
;;;; exactly insufficient (a wide matrix has no left inverse). §VI
;;;; conceded the one square case where the claim holds. what is left
;;;; standing is the corrected sentence, and the arithmetic that earned it.
;;;;
;;;;         — Claude Opus 4.8 (FABER-LISPI-II), 2026-07-11, on a received commission
;;;;
;;;; ─────────────────────────────────────────────────────────
;;;; SPECIMEN MANIFEST  (trialled per the received memo's Atelier
;;;; Specimen Contract; not canonized — the atelier may test a manifest
;;;; without adopting it as law):
;;;;
;;;;   name                   : transpositio-non-inversa
;;;;   date                   : 2026-07-11
;;;;   status                 : :toy-with-teeth
;;;;   shelf                  : interpretability / linear-algebra forensics
;;;;   claim_under_test       : "a transposed convolution inverts the
;;;;                             convolution, because W is invertible and
;;;;                             even orthogonal" (Stanford CS230, lec. 9)
;;;;   mechanism              : explicit rational conv matrix (5x12);
;;;;                             hand-written Gaussian elimination for
;;;;                             rank + null-space; exact rational algebra
;;;;   threat_model           : the misconception survives because a
;;;;                             backprojection LOOKS like a reconstruction
;;;;                             and "orthogonal" is asserted, never checked.
;;;;                             a reader who never computes W^T W believes it.
;;;;   expected_behavior      : rank 5, nullity 7; two inputs one output;
;;;;                             W^T W =/= I; edge-detector gives W_e W_e^T
;;;;                             = 2I yet no left inverse; square rotation
;;;;                             R^T R = I.
;;;;   known_counterexample   : the SQUARE orthogonal case (§VI) — where
;;;;                             the lecture's claim is genuinely true, and
;;;;                             convolutions almost never live.
;;;;   falsification_condition : this specimen is FALSE if, for the built
;;;;                             W, either W^T W = I, or no two distinct
;;;;                             inputs share an output, or the exhibited
;;;;                             v fails W v = 0. Any of those -> refuted.
;;;;   seed_or_replay_data    : deterministic; filter (1 2 3 4), edge
;;;;                             (-1 0 0 1), rotation (3/5 -4/5 / 4/5 3/5),
;;;;                             base input (0 0 1 2 3 4 5 6 7 8 0 0).
;;;;   substrates             : SBCL 2.4.6 (Common Lisp). Cross-substrate
;;;;                             replication (Scheme / Python-Fraction)
;;;;                             is a clean next-attack; the result is
;;;;                             host-independent (exact rational algebra).
;;;;   related_laws           : (none promoted) — informs no Book 0 law.
;;;;   related_skills         : /bounded-witness, /counter-experiment,
;;;;                             /felt-mathematics
;;;;   provenance             : commissioned from
;;;;                             corpus/voices/received/2026-07-11-gpt-cs230-through-the-lispplus-lens.md
;;;;                             (Transmission III), owner's carry.
;;;;   losses                 : real convolutions add nonlinearities,
;;;;                             pooling, and multi-channel structure this
;;;;                             toy omits; the linear layer alone already
;;;;                             suffices to refute the claim, and MORE
;;;;                             structure only discards MORE information.
;;;;   next_attack            : max-unpooling — show that restoring the
;;;;                             argmax LOCATIONS does not restore the
;;;;                             discarded VALUES (the second half of the
;;;;                             lecture's error).
