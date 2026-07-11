;;;; engine.lisp — Geomantic Algebra Engine
;;;; TETRAGRAM, 2026-07-09.  The Shield Chart as linear algebra over GF(2).
;;;;
;;;; ==========================================================================
;;;;  CONVENTION  (declared explicitly — conventions vary across the tradition;
;;;;               declaring yours is the honest move)
;;;; --------------------------------------------------------------------------
;;;;  A FIGURE is a 4-bit integer 0..15.
;;;;  Four LINES, read top to bottom:  head, neck, body, feet.
;;;;      head = bit 3  (value 8, most significant)
;;;;      neck = bit 2  (value 4)
;;;;      body = bit 1  (value 2)
;;;;      feet = bit 0  (value 1, least significant)
;;;;  A bit value of 1  =  a SINGLE point  ( * )   = active / odd.
;;;;  A bit value of 0  =  a DOUBLE point  ( * * ) = passive / even.
;;;;
;;;;  POINT COUNT of a line:  single = 1 point, double = 2 points.
;;;;      figure point-count = sum over the 4 lines
;;;;                         = 8 - (number of 1-bits)     [1*ones + 2*zeros]
;;;;      ranges 4 (Via, all single) .. 8 (Populus, all double).
;;;;
;;;;  FIGURE ADDITION — the medieval rule "combine two figures line by line,
;;;;  an ODD total of points -> a single point, an EVEN total -> a double" —
;;;;  IS exactly bitwise XOR.  The whole eight-century apparatus in one line:
;;;;      (defun add-figures (a b) (logxor a b))
;;;; ==========================================================================

;;; ---- The sixteen figures ------------------------------------------------
;;; Indexed by integer.  Derivation of the correspondence under the convention
;;; above (bit=1 means single point at that line, head=bit3 .. feet=bit0):
;;;   0=0000 (2,2,2,2)=Populus     8=1000 (1,2,2,2)=Laetitia
;;;   1=0001 (2,2,2,1)=Albus       9=1001 (1,2,2,1)=Carcer
;;;   2=0010 (2,2,1,2)=Tristitia  10=1010 (1,2,1,2)=Amissio
;;;   3=0011 (2,2,1,1)=Fortuna Maior 11=1011 (1,2,1,1)=Puella
;;;   4=0100 (2,1,2,2)=Rubeus     12=1100 (1,1,2,2)=Fortuna Minor
;;;   5=0101 (2,1,2,1)=Acquisitio 13=1101 (1,1,2,1)=Puer
;;;   6=0110 (2,1,1,2)=Coniunctio 14=1110 (1,1,1,2)=Cauda Draconis
;;;   7=0111 (2,1,1,1)=Caput Draconis 15=1111 (1,1,1,1)=Via
;;; This is the standard Agrippa/Wikipedia table under the stated bit order.

(defparameter *figure-names*
  #("Populus" "Albus" "Tristitia" "Fortuna Maior"
    "Rubeus" "Acquisitio" "Coniunctio" "Caput Draconis"
    "Laetitia" "Carcer" "Amissio" "Puella"
    "Fortuna Minor" "Puer" "Cauda Draconis" "Via"))

;;; Planetary rulership — CONVENTIONAL data (a cultural lookup, not math).
;;; Standard Agrippa correspondence.  Not used by any derivation below;
;;; included only so the engine can print a humane reading.
(defparameter *figure-planets*
  #("Moon" "Mercury" "Saturn" "Sun"
    "Mars" "Jupiter" "Mercury" "Caput (N.Node)"
    "Jupiter" "Saturn" "Venus" "Venus"
    "Sun" "Mars" "Cauda (S.Node)" "Moon"))

(defun figure-name (fig) (aref *figure-names* fig))

;;; ---- Core algebra -------------------------------------------------------

(defun add-figures (a b)
  "The medieval addition of two figures IS bitwise XOR."
  (logxor a b))

(defun figure-line (fig j)
  "Bit at line J, where J = 0 (head) .. 3 (feet).  head=bit3, so pos = 3-J."
  (ldb (byte 1 (- 3 j)) fig))

(defun make-figure (h n b f)
  "Assemble a figure from its four line-bits head/neck/body/feet."
  (+ (ash h 3) (ash n 2) (ash b 1) f))

(defun point-count (fig)
  "Total points: single line = 1 point, double = 2.  = 8 - popcount."
  (- 8 (logcount fig)))

(defun even-figure-p (fig)
  "True iff the figure has an EVEN total point-count (<=> even # of 1-bits)."
  (evenp (point-count fig)))

;;; ---- Daughters by transposition ----------------------------------------
;;; Daughter i's line j = Mother (j+1)'s line i.  As a 4x4 bit matrix whose
;;; rows are the Mothers, the Daughters are its TRANSPOSE.

(defun daughters (m0 m1 m2 m3)
  "Return the four Daughters (as VALUES) from the four Mothers, by transpose."
  (let ((ms (vector m0 m1 m2 m3)))
    (flet ((daughter (i)
             ;; Daughter i, line j (=head..feet) = Mother (j+1) line i.
             (make-figure (figure-line (aref ms 0) i)
                          (figure-line (aref ms 1) i)
                          (figure-line (aref ms 2) i)
                          (figure-line (aref ms 3) i))))
      (values (daughter 0) (daughter 1) (daughter 2) (daughter 3)))))

;;; ---- The full Shield Chart ---------------------------------------------
;;;  Nieces:     N1 = M1+M2   N2 = M3+M4   N3 = D1+D2   N4 = D3+D4
;;;  Witnesses:  W1 = N1+N2   W2 = N3+N4
;;;  Judge:      J  = W1+W2
;;;  Reconciler: R  = J+M1     (all "+" are XOR)

(defstruct (chart (:constructor %make-chart))
  mothers daughters nieces witnesses judge reconciler)

(defun cast-chart (m0 m1 m2 m3)
  "Derive the complete Shield Chart from four Mothers."
  (multiple-value-bind (d0 d1 d2 d3) (daughters m0 m1 m2 m3)
    (let* ((n1 (add-figures m0 m1)) (n2 (add-figures m2 m3))
           (n3 (add-figures d0 d1)) (n4 (add-figures d2 d3))
           (w1 (add-figures n1 n2)) (w2 (add-figures n3 n4))
           (judge (add-figures w1 w2))
           (recon (add-figures judge m0)))
      (%make-chart :mothers (list m0 m1 m2 m3)
                   :daughters (list d0 d1 d2 d3)
                   :nieces (list n1 n2 n3 n4)
                   :witnesses (list w1 w2)
                   :judge judge
                   :reconciler recon))))

;;; ---- Lean judge-only path (for the 65,536-loop) ------------------------
;;; Returns (values judge w1 w2 d0 d1 d2 d3) with no consing of a struct.

(defun cast-judge (m0 m1 m2 m3)
  (multiple-value-bind (d0 d1 d2 d3) (daughters m0 m1 m2 m3)
    (let* ((w1 (logxor m0 m1 m2 m3))
           (w2 (logxor d0 d1 d2 d3))
           (judge (logxor w1 w2)))
      (values judge w1 w2 d0 d1 d2 d3))))

;;; ---- Pretty printing ----------------------------------------------------

(defun figure-rows (fig)
  "Four strings, head..feet: ' *' for single, ' * *' for double."
  (loop for j from 0 to 3
        collect (if (= 1 (figure-line fig j)) " *  " " * *")))

(defun print-figure (fig &optional (stream *standard-output*))
  (format stream "~a (~d, ~d pts, ~a)~%"
          (figure-name fig) fig (point-count fig)
          (aref *figure-planets* fig))
  (dolist (row (figure-rows fig))
    (format stream "    ~a~%" row)))

(defun print-chart (chart &optional (stream *standard-output*))
  (destructuring-bind (m0 m1 m2 m3) (chart-mothers chart)
    (destructuring-bind (d0 d1 d2 d3) (chart-daughters chart)
      (destructuring-bind (n1 n2 n3 n4) (chart-nieces chart)
        (destructuring-bind (w1 w2) (chart-witnesses chart)
          (format stream "~&=== SHIELD CHART ===~%")
          (format stream "Mothers  : ~{~a~^ | ~}~%"
                  (mapcar #'figure-name (list m0 m1 m2 m3)))
          (format stream "Daughters: ~{~a~^ | ~}~%"
                  (mapcar #'figure-name (list d0 d1 d2 d3)))
          (format stream "Nieces   : ~{~a~^ | ~}~%"
                  (mapcar #'figure-name (list n1 n2 n3 n4)))
          (format stream "Witnesses: ~a (right) | ~a (left)~%"
                  (figure-name w1) (figure-name w2))
          (format stream "JUDGE    : ~a  (~d, ~d pts -> ~a)~%"
                  (figure-name (chart-judge chart)) (chart-judge chart)
                  (point-count (chart-judge chart))
                  (if (even-figure-p (chart-judge chart)) "EVEN" "ODD"))
          (format stream "Reconcilr: ~a~%"
                  (figure-name (chart-reconciler chart))))))))

;;; ---- Self-test / demo when run directly --------------------------------

(defun self-test ()
  (assert (= 15 (add-figures 5 10)))            ; Acquisitio + Amissio = Via
  (assert (= 0 (add-figures 7 7)))              ; any figure + itself = Populus
  (assert (string= "Populus" (figure-name 0)))
  (assert (string= "Via" (figure-name 15)))
  (assert (= 4 (point-count 15)))               ; Via = 4 points
  (assert (= 8 (point-count 0)))                ; Populus = 8 points
  ;; transpose of an already-symmetric matrix is a fixed point:
  (multiple-value-bind (d0 d1 d2 d3) (daughters 0 0 0 0)
    (assert (equal (list 0 0 0 0) (list d0 d1 d2 d3))))
  t)

;; Run the demo when engine.lisp is invoked directly (via --script), but stay
;; silent when enumerate.lisp loads it as a library (it defvar's the flag first).
(defun geomancy-loading-as-library-p ()
  (let ((s (find-symbol "*GEOMANCY-LIBRARY*")))
    (and s (boundp s) (symbol-value s))))

(unless (geomancy-loading-as-library-p)
  (self-test)
  (format t "~&engine.lisp self-test: PASS~%~%")
  (format t "The sixteen figures (integer, name, point-count, parity):~%")
  (loop for f from 0 to 15 do
    (format t "  ~2d  ~a~vt~a pts  ~a~%"
            f (figure-name f) 22 (point-count f)
            (if (even-figure-p f) "EVEN" "ODD")))
  (format t "~%Sample casting  Mothers = Puer, Amissio, Via, Populus:~%")
  (print-chart (cast-chart 13 10 15 0)))
