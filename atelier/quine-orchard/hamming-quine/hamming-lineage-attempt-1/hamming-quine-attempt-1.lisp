(let ((s "(let ((s ~s))
  ;; HAMMING QUINE — the orchard's self-correcting transmission (Shannon 1948 p. 28, the [7,4] code
  ;; left on the doormat above Appendix 1).  No args: print self.  --transmit: print self as
  ;; codewords, one (X1 X2 X3 X4 X5 X6 X7) per line, message symbols X3 X5 X6 X7 (Shannon's
  ;; convention), X4/X2/X1 chosen so that alpha/beta/gamma are even.  --receive FILE: decode,
  ;; correct ONE flipped bit per block by the binary number alpha-beta-gamma, COUNT what was
  ;; corrected, and say whether the received text IS this program.  A [7,4] code miscorrects two
  ;; errors in one block; only the identity check catches that — and it says so.
  ;; Body contains no tilde: s is a FORMAT control string and the file is (format nil s s).
  ;; Fable 5.1, 2026-09-16, carte blanche.
  (setf *print-pretty* nil)
  (defun self () (format nil s s))
  (defun octets () (sb-ext:string-to-octets (self) :external-format :utf-8))
  (defun x (a b) (logxor a b))
  (defun encode-nibble (n)
    (let ((x3 (ldb (byte 1 3) n)) (x5 (ldb (byte 1 2) n)) (x6 (ldb (byte 1 1) n)) (x7 (ldb (byte 1 0) n)))
      (list (x x3 (x x5 x7)) (x x3 (x x6 x7)) x3 (x x5 (x x6 x7)) x5 x6 x7)))
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
  (defun receive (path)
    (let ((blocks (with-open-file (in path) (loop for form = (read in nil :eof) until (eq form :eof) collect form)))
          (nibbles nil) (corrected 0))
      (dolist (cw blocks)
        (multiple-value-bind (nib index) (decode-block cw)
          (when (> index 0) (incf corrected))
          (push nib nibbles)))
      (setf nibbles (nreverse nibbles))
      (let* ((bytes (loop for (hi lo) on nibbles by (function cddr) collect (+ (* 16 hi) lo)))
             (text (sb-ext:octets-to-string (coerce bytes (list 'vector '(unsigned-byte 8))) :external-format :utf-8))
             (mine (self)) (same (string= text mine)))
        (write-string \"SYNDROMES corrected=\") (princ corrected) (write-string \" of \") (princ (length blocks)) (write-string \" blocks\") (terpri)
        (write-string \"RECEIVED SELF: \")
        (if same
            (write-string \"YES\")
            (progn (write-string \"NO (\")
                   (princ (loop for i below (min (length text) (length mine)) count (char/= (char text i) (char mine i))))
                   (write-string \" differing chars; a [7,4] code MIScorrects two errors in one block — only this identity check sees it)\")))
        (terpri)
        (if same 0 1))))
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
  ;; correct ONE flipped bit per block by the binary number alpha-beta-gamma, COUNT what was
  ;; corrected, and say whether the received text IS this program.  A [7,4] code miscorrects two
  ;; errors in one block; only the identity check catches that — and it says so.
  ;; Body contains no tilde: s is a FORMAT control string and the file is (format nil s s).
  ;; Fable 5.1, 2026-09-16, carte blanche.
  (setf *print-pretty* nil)
  (defun self () (format nil s s))
  (defun octets () (sb-ext:string-to-octets (self) :external-format :utf-8))
  (defun x (a b) (logxor a b))
  (defun encode-nibble (n)
    (let ((x3 (ldb (byte 1 3) n)) (x5 (ldb (byte 1 2) n)) (x6 (ldb (byte 1 1) n)) (x7 (ldb (byte 1 0) n)))
      (list (x x3 (x x5 x7)) (x x3 (x x6 x7)) x3 (x x5 (x x6 x7)) x5 x6 x7)))
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
  (defun receive (path)
    (let ((blocks (with-open-file (in path) (loop for form = (read in nil :eof) until (eq form :eof) collect form)))
          (nibbles nil) (corrected 0))
      (dolist (cw blocks)
        (multiple-value-bind (nib index) (decode-block cw)
          (when (> index 0) (incf corrected))
          (push nib nibbles)))
      (setf nibbles (nreverse nibbles))
      (let* ((bytes (loop for (hi lo) on nibbles by (function cddr) collect (+ (* 16 hi) lo)))
             (text (sb-ext:octets-to-string (coerce bytes (list 'vector '(unsigned-byte 8))) :external-format :utf-8))
             (mine (self)) (same (string= text mine)))
        (write-string "SYNDROMES corrected=") (princ corrected) (write-string " of ") (princ (length blocks)) (write-string " blocks") (terpri)
        (write-string "RECEIVED SELF: ")
        (if same
            (write-string "YES")
            (progn (write-string "NO (")
                   (princ (loop for i below (min (length text) (length mine)) count (char/= (char text i) (char mine i))))
                   (write-string " differing chars; a [7,4] code MIScorrects two errors in one block — only this identity check sees it)")))
        (terpri)
        (if same 0 1))))
  (let ((args (rest sb-ext:*posix-argv*)))
    (cond ((null args) (write-string (self)))
          ((string= (first args) "--transmit") (transmit))
          ((and (string= (first args) "--receive") (second args)) (sb-ext:exit :code (receive (second args))))
          (t (write-string "usage: hamming-quine.lisp [--transmit | --receive FILE]") (terpri) (sb-ext:exit :code 2)))))
