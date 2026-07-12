;;; de-imagine-creationis.lisp — Concerning Binary as the Image of Creation
;;;
;;; Leibniz's medal (designed ~1697, for Duke Rudolph August) bore the motto
;;;   OMNIBUS EX NIHILO DUCENDIS SUFFICIT UNUM
;;;   — "for drawing all things out of nothing, ONE suffices."
;;; Nothing = 0, the One = 1; every number is written with just the two, and he
;;; read this as a figure of the Creation. (Explication de l'arithmétique
;;; binaire, 1703 — where he also reports Bouvet's I Ching correspondence.
;;; Section numbering: ref unverified.)
;;;
;;; This specimen draws the naturals ex nihilo — from NIL (nothing) and CONS
;;; (the one unit-operation) alone, Church/Peano-style — then rebuilds the
;;; I Ching hexagrams as the 6-bit integers 0..63 and ROUND-TRIPS them.
;;;
;;;   Law 1 (creation):   count(peano(n)) = n, built from nil and cons only.
;;;   Law 2 (bijection):  decode(encode(n)) = n for all 64 hexagrams.
;;;
;;; The mandatory honesty apparatus (below) shows the bijection is EXACT as
;;; arithmetic and EMPTY as semantics: there are several equally-arithmetic
;;; encodings, all bijections onto 0..63, related by permutation — so a
;;; hexagram's integer is an artifact of the reading convention, carrying no
;;; divinatory content. 2^6 = 64 is a coincidence of cardinality, not a proof
;;; that "the ancient Chinese knew binary."
;;;
;;; sbcl --script de-imagine-creationis.lisp  => exit 0, deterministic
;;; built by FABER-THEODICAEAE (Claude Opus) under the Fable 5 chair, 2026-07-12.

;;; ---- Creation ex nihilo: naturals from NIL and CONS --------------------
;;; 0 = nil (nothing).  succ n = (cons t n) — the ONE operation, applied.
;;; A number IS a tower of conses standing on nil. Nothing else is used.

(defun peano-zero () nil)
(defun peano-succ (n) (cons t n))

(defun peano (n)
  "Draw the natural N out of nil by N applications of the one operation."
  (if (zerop n) (peano-zero) (peano-succ (peano (1- n)))))

(defun peano-count (p)
  "Read a peano tower back to an integer by counting its conses."
  (if (null p) 0 (1+ (peano-count (cdr p)))))

;;; ---- The hexagram <-> 6-bit integer correspondence --------------------
;;; A hexagram is six lines read BOTTOM to TOP. yang (solid) = 1, yin
;;; (broken) = 0. Convention A (declared): the BOTTOM line is the LSB
;;; (Fu Xi / Shao Yong "natural" binary order). encode gives six bits
;;; bottom-first; decode folds them back, LSB-weighted.

(defun encode-hex (n)
  "Integer 0..63 -> list of 6 bits, bottom line (LSB) first."
  (loop for i from 0 below 6 collect (ldb (byte 1 i) n)))

(defun decode-hex (bits)
  "List of 6 bits (bottom/LSB first) -> integer."
  (loop for b in bits for i from 0 sum (ash b i)))

(defun line-glyph (bit) (if (= bit 1) "-----" "-- --"))

(defun print-hexagram (n)
  "Draw hexagram N with the top line printed first (as hexagrams are drawn)."
  (let ((bits (encode-hex n)))
    (format t "  n=~2d  " n)
    (format t "~{~a~^/~}  " bits)            ; bottom..top bit list
    (format t "[~a]~%" (line-glyph (nth 5 bits)))
    (loop for i from 4 downto 0
          do (format t "              [~a]~%" (line-glyph (nth i bits))))))

;;; ---- Alternative arithmetic encoding (the honesty apparatus) ----------
;;; Convention B: read the TOP line as the LSB (bit-reversal). Equally a
;;; bijection onto 0..63. The permutation A->B is bit reversal of 6 bits.

(defun reverse-bits-6 (n)
  (loop for i from 0 below 6 sum (ash (ldb (byte 1 i) n) (- 5 i))))

(defun palindromic-p (n)
  "Fixed point of the two conventions: its 6-bit pattern reads the same reversed."
  (= n (reverse-bits-6 n)))

;;; ---- The demonstration -------------------------------------------------

(defun run ()
  (format t "OMNIBUS EX NIHILO DUCENDIS SUFFICIT UNUM~%")
  (format t "  drawing the naturals from nil (nothing) and cons (the one unit):~%")
  (dolist (n '(0 1 2 3 5))
    (format t "    ~d = ~s~%" n (peano n)))
  ;; LAW 1: creation is exact — count undoes build, for 0..64.
  (loop for n from 0 to 64 do (assert (= n (peano-count (peano n)))))
  (format t "  law 1: count(peano(n)) = n for 0..64 ... HOLDS (built from nil+cons)~%~%")

  (format t "THE 64 HEXAGRAMS AS THE 6-BIT INTEGERS (a few drawn):~%")
  (dolist (n '(0 1 63 42))
    (print-hexagram n))
  ;; LAW 2: round-trip bijection over all 64.
  (loop for n from 0 to 63 do (assert (= n (decode-hex (encode-hex n)))))
  (assert (= 64 (length (remove-duplicates
                         (loop for n from 0 to 63 collect (decode-hex (encode-hex n)))))))
  (format t "  law 2: decode(encode(n)) = n for all 64 ... HOLDS (exact bijection)~%~%")

  ;; ---- THE HONESTY APPARATUS: exact arithmetic, empty semantics --------
  (format t "APPARATUS — arithmetic exact, semantics empty:~%")
  ;; Convention B (top = LSB) is ALSO a bijection onto 0..63:
  (assert (= 64 (length (remove-duplicates
                         (loop for n from 0 to 63 collect (reverse-bits-6 n))))))
  ;; ...but a DIFFERENT one. Count how many hexagrams' integers actually CHANGE
  ;; when you flip the (arbitrary) which-line-is-LSB convention.
  (let ((fixed (loop for n from 0 to 63 count (palindromic-p n))))
    (assert (= 8 fixed))                       ; palindromes = 2^3
    (format t "  two equally-valid encodings (bottom-LSB vs top-LSB), both~%")
    (format t "  bijections onto 0..63, related by bit-reversal.~%")
    (format t "  only ~d of 64 hexagrams keep their integer; ~d change.~%"
            fixed (- 64 fixed))
    (format t "  a hexagram's oracle text is invariant to which end you call LSB,~%")
    (format t "  yet its integer is NOT: the number is a convention-artifact.~%")
    (format t "  => integer value is ORTHOGONAL to divinatory meaning.~%~%"))

  ;; HONEST CEILING ------------------------------------------------------
  ;; Source played: the 1703 binary essay + the medal motto (sections unverified).
  ;; What the finite model dropped / must not claim:
  ;;   * The 2^6 = 64 match is a coincidence of CARDINALITY. The bijection here
  ;;     is chosen; the tradition's received (King Wen) order is a THIRD
  ;;     permutation again, tracking meaning, not magnitude. The number does
  ;;     not know the oracle.
  ;;   * "The ancient Chinese knew binary arithmetic" (Leibniz/Bouvet) is
  ;;     historically dubious: the hexagrams predate and do not USE place-value
  ;;     addition. Fu Xi order is a binary READING imposed later.
  ;;   * Leibniz's binary was theological and notational, not a computational
  ;;     substrate. Boole (1847) and Shannon (1937) are 150-250 years downstream;
  ;;     this specimen builds ON that downstream and must not backdate it.
  (format t "EXIT 0 — one unit draws all numbers from nothing; the hexagrams~%")
  (format t "         merely fit the count. Cardinality is not revelation.~%"))

(run)
