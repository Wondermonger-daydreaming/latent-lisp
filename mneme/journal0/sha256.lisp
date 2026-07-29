;;;; sha256.lisp — SHA-256, implemented directly from FIPS 180-4.
;;;;
;;;; Process Journal /0 §8 requires SHA-256 for payload, frame, genesis, and
;;;; store-identity digests.  SBCL ships no SHA-256; borrowing one from prior
;;;; journal machinery is fenced off (ALLOWED-SOURCES Class B), so this engine
;;;; is written fresh from the public standard and proven in the selftest
;;;; against the FIPS vectors (empty string, "abc", two-block "abcdbcde...")
;;;; and against the spec's own genesis digest.

(in-package #:lisp-plus-journal0)

(deftype u32 () '(unsigned-byte 32))

(defconstant +sha256-k+
  (if (boundp '+sha256-k+)
      (symbol-value '+sha256-k+)
      (make-array
       64 :element-type 'u32
       :initial-contents
       '(#x428a2f98 #x71374491 #xb5c0fbcf #xe9b5dba5 #x3956c25b #x59f111f1
         #x923f82a4 #xab1c5ed5 #xd807aa98 #x12835b01 #x243185be #x550c7dc3
         #x72be5d74 #x80deb1fe #x9bdc06a7 #xc19bf174 #xe49b69c1 #xefbe4786
         #x0fc19dc6 #x240ca1cc #x2de92c6f #x4a7484aa #x5cb0a9dc #x76f988da
         #x983e5152 #xa831c66d #xb00327c8 #xbf597fc7 #xc6e00bf3 #xd5a79147
         #x06ca6351 #x14292967 #x27b70a85 #x2e1b2138 #x4d2c6dfc #x53380d13
         #x650a7354 #x766a0abb #x81c2c92e #x92722c85 #xa2bfe8a1 #xa81a664b
         #xc24b8b70 #xc76c51a3 #xd192e819 #xd6990624 #xf40e3585 #x106aa070
         #x19a4c116 #x1e376c08 #x2748774c #x34b0bcb5 #x391c0cb3 #x4ed8aa4a
         #x5b9cca4f #x682e6ff3 #x748f82ee #x78a5636f #x84c87814 #x8cc70208
         #x90befffa #xa4506ceb #xbef9a3f7 #xc67178f2))))

(declaim (inline %u32+ %rotr32 %shr32))

(defun %u32+ (&rest xs)
  (declare (dynamic-extent xs))
  (let ((sum 0))
    (declare (type (unsigned-byte 40) sum))
    (dolist (x xs (logand sum #xffffffff))
      (setf sum (logand (+ sum (the u32 x)) #xffffffffff)))))

(defun %rotr32 (x n)
  (declare (type u32 x) (type (integer 0 31) n))
  (logand #xffffffff
          (logior (ash x (- n)) (ash x (- 32 n)))))

(defun %shr32 (x n)
  (declare (type u32 x) (type (integer 0 31) n))
  (ash x (- n)))

(defun sha256-octets (octets)
  "SHA-256 of the octet vector OCTETS, returned as a fresh 32-octet vector."
  (declare (type (simple-array (unsigned-byte 8) (*)) octets))
  (let* ((length (length octets))
         (bit-length (* 8 length))
         ;; Padded message: message || #x80 || zeros || 64-bit big-endian length.
         (padded-length (* 64 (ceiling (+ length 9) 64)))
         (padded (make-array padded-length :element-type '(unsigned-byte 8)
                                          :initial-element 0))
         (h0 #x6a09e667) (h1 #xbb67ae85) (h2 #x3c6ef372) (h3 #xa54ff53a)
         (h4 #x510e527f) (h5 #x9b05688c) (h6 #x1f83d9ab) (h7 #x5be0cd19)
         (w (make-array 64 :element-type 'u32 :initial-element 0)))
    (declare (type u32 h0 h1 h2 h3 h4 h5 h6 h7))
    (replace padded octets)
    (setf (aref padded length) #x80)
    (loop for shift from 56 downto 0 by 8
          for index from (- padded-length 8)
          do (setf (aref padded index)
                   (ldb (byte 8 shift) bit-length)))
    (loop for block-start from 0 below padded-length by 64 do
      (loop for word-index below 16
            for byte-index = (+ block-start (* 4 word-index))
            do (setf (aref w word-index)
                     (logior (ash (aref padded byte-index) 24)
                             (ash (aref padded (+ byte-index 1)) 16)
                             (ash (aref padded (+ byte-index 2)) 8)
                             (aref padded (+ byte-index 3)))))
      (loop for word-index from 16 below 64
            for w15 of-type u32 = (aref w (- word-index 15))
            for w2 of-type u32 = (aref w (- word-index 2))
            for s0 of-type u32 = (logxor (%rotr32 w15 7) (%rotr32 w15 18)
                                         (%shr32 w15 3))
            for s1 of-type u32 = (logxor (%rotr32 w2 17) (%rotr32 w2 19)
                                         (%shr32 w2 10))
            do (setf (aref w word-index)
                     (%u32+ (aref w (- word-index 16)) s0
                            (aref w (- word-index 7)) s1)))
      (let ((a h0) (b h1) (c h2) (d h3) (e h4) (f h5) (g h6) (h h7))
        (declare (type u32 a b c d e f g h))
        (loop for round below 64
              for big-s1 of-type u32
                = (logxor (%rotr32 e 6) (%rotr32 e 11) (%rotr32 e 25))
              for ch of-type u32
                = (logxor (logand e f) (logand (logxor e #xffffffff) g))
              for temp1 of-type u32
                = (%u32+ h big-s1 ch (aref +sha256-k+ round) (aref w round))
              for big-s0 of-type u32
                = (logxor (%rotr32 a 2) (%rotr32 a 13) (%rotr32 a 22))
              for maj of-type u32
                = (logxor (logand a b) (logand a c) (logand b c))
              for temp2 of-type u32 = (%u32+ big-s0 maj)
              do (setf h g  g f  f e
                       e (%u32+ d temp1)
                       d c  c b  b a
                       a (%u32+ temp1 temp2)))
        (setf h0 (%u32+ h0 a) h1 (%u32+ h1 b) h2 (%u32+ h2 c) h3 (%u32+ h3 d)
              h4 (%u32+ h4 e) h5 (%u32+ h5 f) h6 (%u32+ h6 g) h7 (%u32+ h7 h))))
    (let ((digest (make-array 32 :element-type '(unsigned-byte 8))))
      (loop for word in (list h0 h1 h2 h3 h4 h5 h6 h7)
            for base from 0 by 4
            do (setf (aref digest base) (ldb (byte 8 24) word)
                     (aref digest (+ base 1)) (ldb (byte 8 16) word)
                     (aref digest (+ base 2)) (ldb (byte 8 8) word)
                     (aref digest (+ base 3)) (ldb (byte 8 0) word)))
      digest)))

(defconstant +hex-digits+
  (if (boundp '+hex-digits+) (symbol-value '+hex-digits+) "0123456789abcdef"))

(defun octets->hex (octets)
  "Lowercase hexadecimal rendering of an octet vector."
  (let ((hex (make-string (* 2 (length octets)))))
    (loop for octet across octets
          for index from 0 by 2
          do (setf (char hex index) (char +hex-digits+ (ash octet -4))
                   (char hex (1+ index)) (char +hex-digits+ (logand octet #xf))))
    hex))

(defun hex->octets (hex)
  "Octets of a lowercase-hex string; NIL if HEX is not exact lowercase hex."
  (let ((length (length hex)))
    (when (evenp length)
      (let ((octets (make-array (/ length 2) :element-type '(unsigned-byte 8))))
        (loop for index below length by 2
              for high = (position (char hex index) +hex-digits+)
              for low = (position (char hex (1+ index)) +hex-digits+)
              unless (and high low) do (return-from hex->octets nil)
              do (setf (aref octets (/ index 2)) (logior (ash high 4) low)))
        octets))))

(defun sha256-hex (octets)
  "Lowercase-hex SHA-256 of an octet vector."
  (octets->hex (sha256-octets octets)))
