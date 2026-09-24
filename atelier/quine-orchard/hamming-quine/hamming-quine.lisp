(let ((s "(let ((s ~s))
  ;; HAMMING QUINE — the orchard's self-correcting transmission (Shannon 1948 p. 28, the [7,4] code
  ;; left on the doormat above Appendix 1).  No args: print self.  --transmit: print self as
  ;; codewords, one (X1 X2 X3 X4 X5 X6 X7) per line, message symbols X3 X5 X6 X7 (Shannon's
  ;; convention), X4/X2/X1 chosen so that alpha/beta/gamma are even.  --receive FILE: decode,
  ;; flip ONE bit per block where the binary number alpha-beta-gamma is nonzero, COUNT what was
  ;; observed and done, and say whether the received OCTETS are this program's octets.
  ;; r1 (2026-09-16, after the review of parcel ed346f74): identity is decided on BYTES, before any
  ;; text decoding — a byte at a literal ? position, replaced by an invalid octet, decoded to ? and
  ;; matched the source as TEXT (byte 737; reproduced).  Text is decoded afterwards for display only,
  ;; with replacement, and the replacement characters are counted.  Length differences are reported
  ;; apart from differing octets.  The decoder's counts are named for what they are: nonzero
  ;; syndromes and bit flips applied — never \"corrected\", because under two or three errors the
  ;; flip is wrong or absent.  A malformed transmission is REPORTED (RECEIVED SELF: NO) rather than
  ;; a crash, for the shapes this reader anticipates; a shape it does not anticipate may still end
  ;; the process before the verdict.
  ;; Body contains no tilde: s is a FORMAT control string and the file is (format nil s s).
  ;; Fable 5.1, 2026-09-16, carte blanche.
  (setf *print-pretty* nil)
  (defun self () (format nil s s))
  (defun octets () (sb-ext:string-to-octets (self) :external-format :utf-8))
  (defun x (a b) (logxor a b))
  (defun encode-nibble (n)
    (let ((x3 (ldb (byte 1 3) n)) (x5 (ldb (byte 1 2) n)) (x6 (ldb (byte 1 1) n)) (x7 (ldb (byte 1 0) n)))
      (list (x x3 (x x5 x7)) (x x3 (x x6 x7)) x3 (x x5 (x x6 x7)) x5 x6 x7)))
  (defun bit-p (b) (or (eql b 0) (eql b 1)))
  (defun codeword-p (cw) (and (listp cw) (= (length cw) 7) (every (function bit-p) cw)))
  (defun decode-block (cw)
    (destructuring-bind (x1 x2 x3 x4 x5 x6 x7) (copy-list cw)
      (let* ((a (x x4 (x x5 (x x6 x7)))) (b (x x2 (x x3 (x x6 x7)))) (g (x x1 (x x3 (x x5 x7))))
             (index (+ (* 4 a) (* 2 b) g)) (bits (list x1 x2 x3 x4 x5 x6 x7)))
        (when (> index 0) (setf (nth (- index 1) bits) (x 1 (nth (- index 1) bits))))
        (destructuring-bind (y1 y2 y3 y4 y5 y6 y7) bits
          (declare (ignore y1 y2 y4))
          (values (+ (* 8 y3) (* 4 y5) (* 2 y6) y7) index)))))
  (defun transmit ()
    (let ((o (octets)))
      (write-string \";; hamming-quine transmission: \") (princ (* 2 (length o)))
      (write-string \" codewords for \") (princ (length o)) (write-string \" source octets; (X1 X2 X3 X4 X5 X6 X7), data X3 X5 X6 X7\")
      (terpri)
      (loop for byte across o do
        (write (encode-nibble (ldb (byte 4 4) byte)) :pretty nil) (terpri)
        (write (encode-nibble (ldb (byte 4 0) byte)) :pretty nil) (terpri))))
  (defun say-no (why) (write-string \"RECEIVED SELF: NO (\") (write-string why) (write-string \")\") (terpri) 1)
  (defun receive (path)
    (let ((blocks (handler-case (with-open-file (in path) (loop for form = (read in nil :eof) until (eq form :eof) collect form))
                    (error (c) (write-string \"SYNDROMES nonzero-syndromes=NIL bit-flips-applied=NIL blocks=NIL\") (terpri)
                      (return-from receive (say-no (concatenate 'string \"unreadable transmission: \" (string (type-of c))))))))
          (nibbles nil) (nonzero 0))
      (let ((bad (count-if-not (function codeword-p) blocks)))
        (when (> bad 0)
          (write-string \"SYNDROMES nonzero-syndromes=NIL bit-flips-applied=NIL blocks=\") (princ (length blocks)) (terpri)
          (return-from receive (say-no \"malformed codewords: not every form is a list of seven bits\"))))
      (dolist (cw blocks)
        (multiple-value-bind (nib index) (decode-block cw)
          (when (> index 0) (incf nonzero))
          (push nib nibbles)))
      (setf nibbles (nreverse nibbles))
      (write-string \"SYNDROMES nonzero-syndromes=\") (princ nonzero) (write-string \" bit-flips-applied=\") (princ nonzero)
      (write-string \" blocks=\") (princ (length blocks)) (terpri)
      (when (oddp (length nibbles))
        (return-from receive (say-no \"odd number of codewords: the last nibble has no partner\")))
      (let* ((mine (octets))
             (bytes (coerce (loop for (hi lo) on nibbles by (function cddr) collect (+ (* 16 hi) lo)) (list 'vector '(unsigned-byte 8))))
             (common (min (length bytes) (length mine)))
             (differing (loop for i below common count (/= (aref bytes i) (aref mine i))))
             (length-difference (- (length bytes) (length mine)))
             (same (and (= length-difference 0) (= differing 0)))
             (text (sb-ext:octets-to-string bytes :external-format (list :utf-8 :replacement (code-char 65533))))
             (replacements (count (code-char 65533) text)))
        (write-string \"OCTETS received=\") (princ (length bytes)) (write-string \" self=\") (princ (length mine))
        (write-string \" differing-octets=\") (princ differing) (write-string \" length-difference=\") (princ length-difference)
        (write-string \" replacement-chars-in-display-decode=\") (princ replacements) (terpri)
        (if same
            (progn (write-string \"RECEIVED SELF: YES (octet-equal)\") (terpri) 0)
            (say-no \"octets differ; a [7,4] code flips ONE bit per block, flips WRONG under two errors, and can see NOTHING under three; text decoding is display only and decides nothing\")))))
  (let ((args (rest sb-ext:*posix-argv*)))
    (cond ((null args) (write-string (self)))
          ((string= (first args) \"--transmit\") (transmit))
          ((and (string= (first args) \"--receive\") (second args)) (sb-ext:exit :code (receive (second args))))
          (t (write-string \"usage: hamming-quine.lisp [--transmit | --receive FILE]\") (terpri) (sb-ext:exit :code 2)))))
"))
  ;; HAMMING QUINE — the orchard's self-correcting transmission (Shannon 1948 p. 28, the [7,4] code
  ;; left on the doormat above Appendix 1).  No args: print self.  --transmit: print self as
  ;; codewords, one (X1 X2 X3 X4 X5 X6 X7) per line, message symbols X3 X5 X6 X7 (Shannon's
  ;; convention), X4/X2/X1 chosen so that alpha/beta/gamma are even.  --receive FILE: decode,
  ;; flip ONE bit per block where the binary number alpha-beta-gamma is nonzero, COUNT what was
  ;; observed and done, and say whether the received OCTETS are this program's octets.
  ;; r1 (2026-09-16, after the review of parcel ed346f74): identity is decided on BYTES, before any
  ;; text decoding — a byte at a literal ? position, replaced by an invalid octet, decoded to ? and
  ;; matched the source as TEXT (byte 737; reproduced).  Text is decoded afterwards for display only,
  ;; with replacement, and the replacement characters are counted.  Length differences are reported
  ;; apart from differing octets.  The decoder's counts are named for what they are: nonzero
  ;; syndromes and bit flips applied — never "corrected", because under two or three errors the
  ;; flip is wrong or absent.  A malformed transmission is REPORTED (RECEIVED SELF: NO) rather than
  ;; a crash, for the shapes this reader anticipates; a shape it does not anticipate may still end
  ;; the process before the verdict.
  ;; Body contains no tilde: s is a FORMAT control string and the file is (format nil s s).
  ;; Fable 5.1, 2026-09-16, carte blanche.
  (setf *print-pretty* nil)
  (defun self () (format nil s s))
  (defun octets () (sb-ext:string-to-octets (self) :external-format :utf-8))
  (defun x (a b) (logxor a b))
  (defun encode-nibble (n)
    (let ((x3 (ldb (byte 1 3) n)) (x5 (ldb (byte 1 2) n)) (x6 (ldb (byte 1 1) n)) (x7 (ldb (byte 1 0) n)))
      (list (x x3 (x x5 x7)) (x x3 (x x6 x7)) x3 (x x5 (x x6 x7)) x5 x6 x7)))
  (defun bit-p (b) (or (eql b 0) (eql b 1)))
  (defun codeword-p (cw) (and (listp cw) (= (length cw) 7) (every (function bit-p) cw)))
  (defun decode-block (cw)
    (destructuring-bind (x1 x2 x3 x4 x5 x6 x7) (copy-list cw)
      (let* ((a (x x4 (x x5 (x x6 x7)))) (b (x x2 (x x3 (x x6 x7)))) (g (x x1 (x x3 (x x5 x7))))
             (index (+ (* 4 a) (* 2 b) g)) (bits (list x1 x2 x3 x4 x5 x6 x7)))
        (when (> index 0) (setf (nth (- index 1) bits) (x 1 (nth (- index 1) bits))))
        (destructuring-bind (y1 y2 y3 y4 y5 y6 y7) bits
          (declare (ignore y1 y2 y4))
          (values (+ (* 8 y3) (* 4 y5) (* 2 y6) y7) index)))))
  (defun transmit ()
    (let ((o (octets)))
      (write-string ";; hamming-quine transmission: ") (princ (* 2 (length o)))
      (write-string " codewords for ") (princ (length o)) (write-string " source octets; (X1 X2 X3 X4 X5 X6 X7), data X3 X5 X6 X7")
      (terpri)
      (loop for byte across o do
        (write (encode-nibble (ldb (byte 4 4) byte)) :pretty nil) (terpri)
        (write (encode-nibble (ldb (byte 4 0) byte)) :pretty nil) (terpri))))
  (defun say-no (why) (write-string "RECEIVED SELF: NO (") (write-string why) (write-string ")") (terpri) 1)
  (defun receive (path)
    (let ((blocks (handler-case (with-open-file (in path) (loop for form = (read in nil :eof) until (eq form :eof) collect form))
                    (error (c) (write-string "SYNDROMES nonzero-syndromes=NIL bit-flips-applied=NIL blocks=NIL") (terpri)
                      (return-from receive (say-no (concatenate 'string "unreadable transmission: " (string (type-of c))))))))
          (nibbles nil) (nonzero 0))
      (let ((bad (count-if-not (function codeword-p) blocks)))
        (when (> bad 0)
          (write-string "SYNDROMES nonzero-syndromes=NIL bit-flips-applied=NIL blocks=") (princ (length blocks)) (terpri)
          (return-from receive (say-no "malformed codewords: not every form is a list of seven bits"))))
      (dolist (cw blocks)
        (multiple-value-bind (nib index) (decode-block cw)
          (when (> index 0) (incf nonzero))
          (push nib nibbles)))
      (setf nibbles (nreverse nibbles))
      (write-string "SYNDROMES nonzero-syndromes=") (princ nonzero) (write-string " bit-flips-applied=") (princ nonzero)
      (write-string " blocks=") (princ (length blocks)) (terpri)
      (when (oddp (length nibbles))
        (return-from receive (say-no "odd number of codewords: the last nibble has no partner")))
      (let* ((mine (octets))
             (bytes (coerce (loop for (hi lo) on nibbles by (function cddr) collect (+ (* 16 hi) lo)) (list 'vector '(unsigned-byte 8))))
             (common (min (length bytes) (length mine)))
             (differing (loop for i below common count (/= (aref bytes i) (aref mine i))))
             (length-difference (- (length bytes) (length mine)))
             (same (and (= length-difference 0) (= differing 0)))
             (text (sb-ext:octets-to-string bytes :external-format (list :utf-8 :replacement (code-char 65533))))
             (replacements (count (code-char 65533) text)))
        (write-string "OCTETS received=") (princ (length bytes)) (write-string " self=") (princ (length mine))
        (write-string " differing-octets=") (princ differing) (write-string " length-difference=") (princ length-difference)
        (write-string " replacement-chars-in-display-decode=") (princ replacements) (terpri)
        (if same
            (progn (write-string "RECEIVED SELF: YES (octet-equal)") (terpri) 0)
            (say-no "octets differ; a [7,4] code flips ONE bit per block, flips WRONG under two errors, and can see NOTHING under three; text decoding is display only and decides nothing")))))
  (let ((args (rest sb-ext:*posix-argv*)))
    (cond ((null args) (write-string (self)))
          ((string= (first args) "--transmit") (transmit))
          ((and (string= (first args) "--receive") (second args)) (sb-ext:exit :code (receive (second args))))
          (t (write-string "usage: hamming-quine.lisp [--transmit | --receive FILE]") (terpri) (sb-ext:exit :code 2)))))
