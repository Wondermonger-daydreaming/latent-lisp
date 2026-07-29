;;;; frame.lisp — §7 frame grammar and §8 digest procedures.
;;;;
;;;; Frame:  PJ0F 0 ORDINAL PAYLOAD-LENGTH PAYLOAD-SHA256
;;;;         PREVIOUS-FRAME-SHA256 FRAME-SHA256 LF
;;;;         PAYLOAD-OCTETS LF
;;;; All header characters ASCII, single-SP separated, no leading/trailing SP
;;;; (§7).  Header decimals and digests have exactly one canonical spelling
;;;; (PJ-FRM-2).

(in-package #:lisp-plus-journal0)

;; §8.1: lowercase-hex SHA-256 of the ASCII bytes "PJ0-GENESIS-0".
;; Computed, not transcribed: the selftest asserts this equals
;; (sha256-hex "PJ0-GENESIS-0"-octets) and the frozen metadata value.
(defvar +genesis-digest-hex+
  (sha256-hex (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                   "PJ0-GENESIS-0")))

(defun canonical-decimal-p (string)
  "Exactly one canonical unsigned decimal spelling: \"0\" or [1-9][0-9]*."
  (and (plusp (length string))
       (every (lambda (character) (char<= #\0 character #\9)) string)
       (or (string= string "0")
           (char/= (char string 0) #\0))))

(defun lowercase-hex-64-p (string)
  (and (= (length string) 64)
       (every (lambda (character)
                (or (char<= #\0 character #\9)
                    (char<= #\a character #\f)))
              string)))

(defun frame-digest-hex (store-id-string ordinal payload-length
                         payload-sha256-hex previous-sha256-hex)
  "§8.3 frame digest: SHA-256 over
\"PJ0-FRAME-0\" NUL ASCII(STORE-ID) NUL ASCII(ORDINAL) NUL
ASCII(PAYLOAD-LENGTH) NUL RAW(PAYLOAD-SHA256) RAW(PREVIOUS-FRAME-SHA256)."
  (let* ((prefix (format nil "PJ0-FRAME-0~c~a~c~d~c~d~c"
                         #\Nul store-id-string #\Nul ordinal #\Nul
                         payload-length #\Nul))
         (prefix-octets (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                             prefix))
         (payload-raw (hex->octets payload-sha256-hex))
         (previous-raw (hex->octets previous-sha256-hex))
         (preimage (make-array (+ (length prefix-octets) 32 32)
                               :element-type '(unsigned-byte 8))))
    (assert (and payload-raw previous-raw (= 32 (length payload-raw))
                 (= 32 (length previous-raw)))
            () "frame-digest-hex requires two lowercase 64-hex digests")
    (replace preimage prefix-octets)
    (replace preimage payload-raw :start1 (length prefix-octets))
    (replace preimage previous-raw :start1 (+ (length prefix-octets) 32))
    (sha256-hex preimage)))

(defun render-frame-octets (store-id-string ordinal payload-octets
                            previous-sha256-hex)
  "Exact §7 frame bytes for PAYLOAD-OCTETS at ORDINAL after
PREVIOUS-SHA256-HEX.  Returns (values frame-octets frame-digest-hex
payload-digest-hex)."
  (let* ((payload-hex (sha256-hex payload-octets))
         (frame-hex (frame-digest-hex store-id-string ordinal
                                      (length payload-octets)
                                      payload-hex previous-sha256-hex))
         (header (format nil "PJ0F 0 ~d ~d ~a ~a ~a"
                         ordinal (length payload-octets)
                         payload-hex previous-sha256-hex frame-hex))
         (header-octets (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                             header))
         (frame (make-array (+ (length header-octets) 1
                               (length payload-octets) 1)
                            :element-type '(unsigned-byte 8))))
    (replace frame header-octets)
    (setf (aref frame (length header-octets)) #x0a)
    (replace frame payload-octets :start1 (1+ (length header-octets)))
    (setf (aref frame (1- (length frame))) #x0a)
    (values frame frame-hex payload-hex)))
