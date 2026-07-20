;;;; ss0-substrate.lisp — SS-0 shared substrate, Common Lisp side.
;;;; Storage (framed append-only + CRC32 + fsync), canonical serialization,
;;;; death-window helper. NO semantic vocabulary, NO recovery logic — see
;;;; SS0-SUBSTRATE-API.md §6 (negative space, binding; audited by VOID-2).
(require :sb-posix)
(defpackage #:ss0
  (:use #:cl)
  (:export #:store-append #:store-append-torn #:store-read-prefix
           #:ser-encode #:ser-decode #:crc32 #:crc32-hex #:window))
(in-package #:ss0)

;; ---------- CRC32 (IEEE, table-driven) ----------
(defvar *crc-table*
  (let ((tbl (make-array 256 :element-type '(unsigned-byte 32))))
    (loop for n below 256 do
      (let ((c n))
        (loop repeat 8 do
          (setf c (if (logbitp 0 c)
                      (logxor #xEDB88320 (ash c -1))
                      (ash c -1))))
        (setf (aref tbl n) c)))
    tbl))

(defun crc32 (octets)
  (let ((c #xFFFFFFFF))
    (loop for b across octets do
      (setf c (logxor (aref *crc-table* (logand #xFF (logxor c b)))
                      (ash c -8))))
    (logxor c #xFFFFFFFF)))

(defun crc32-hex (octets) (format nil "~8,'0X" (crc32 octets)))

;; ---------- storage: framed append-only log ----------
;; Frame: u32-be length | payload bytes | u32-be CRC32(payload).
;; Torn/CRC-failing tails are the READER'S normal case, never an error.

(defun %records-path (run-dir) (merge-pathnames "records.log" run-dir))

(defun %write-u32 (stream n)
  (loop for shift in '(24 16 8 0)
        do (write-byte (logand #xFF (ash n (- shift))) stream)))

(defun store-append (run-dir payload &key (durable t))
  "Append one framed record. DURABLE => fsync before returning."
  (with-open-file (s (%records-path run-dir) :direction :output
                     :element-type '(unsigned-byte 8)
                     :if-exists :append :if-does-not-exist :create)
    (%write-u32 s (length payload))
    (write-sequence payload s)
    (%write-u32 s (crc32 payload))
    (finish-output s)
    (when durable (sb-posix:fsync (sb-sys:fd-stream-fd s)))
    (values)))

(defun store-append-torn (run-dir payload fraction)
  "@harness torn-frame injection: write the length header and only
   FRACTION of the payload, no CRC, no fsync. Death instrumentation only."
  (with-open-file (s (%records-path run-dir) :direction :output
                     :element-type '(unsigned-byte 8)
                     :if-exists :append :if-does-not-exist :create)
    (%write-u32 s (length payload))
    (write-sequence (subseq payload 0 (floor (* fraction (length payload)))) s)
    (finish-output s)
    (values)))

(defun store-read-prefix (run-dir)
  "Return (values payload-list tail-status) with tail-status :clean or :torn.
   Every intact frame in order; first incomplete or CRC-failing frame ends
   the prefix and is discarded."
  (with-open-file (s (%records-path run-dir) :element-type '(unsigned-byte 8)
                     :if-does-not-exist nil)
    (if (null s) (values nil :clean)
        (let ((bytes (make-array (file-length s) :element-type '(unsigned-byte 8)))
              (payloads '()))
          (read-sequence bytes s)
          (let ((pos 0) (n (length bytes)))
            (loop
              (when (= pos n) (return (values (nreverse payloads) :clean)))
              (when (< (- n pos) 4) (return (values (nreverse payloads) :torn)))
              (let ((len (logior (ash (aref bytes pos) 24) (ash (aref bytes (+ pos 1)) 16)
                                 (ash (aref bytes (+ pos 2)) 8) (aref bytes (+ pos 3)))))
                (when (< (- n pos 4) (+ len 4))
                  (return (values (nreverse payloads) :torn)))
                (let* ((start (+ pos 4))
                       (payload (subseq bytes start (+ start len)))
                       (cp (+ start len))
                       (crc (logior (ash (aref bytes cp) 24) (ash (aref bytes (+ cp 1)) 16)
                                    (ash (aref bytes (+ cp 2)) 8) (aref bytes (+ cp 3)))))
                  (if (= crc (crc32 payload))
                      (progn (push payload payloads) (setf pos (+ cp 4)))
                      (return (values (nreverse payloads) :torn)))))))))))

;; ---------- canonical serialization ----------
;; Flat map: string keys; values string | integer | boolean.
;; Canonical bytes: keys sorted bytewise; one line per entry
;; "key<TAB>type<TAB>value<LF>" with type s|i|b; strings escape \\ \t \n
;; as \\\\ \\t \\n. Identical map => identical bytes, both languages.

(defun %escape (str)
  (with-output-to-string (o)
    (loop for ch across str do
      (case ch
        (#\\ (write-string "\\\\" o))
        (#\Tab (write-string "\\t" o))
        (#\Newline (write-string "\\n" o))
        (t (write-char ch o))))))

(defun %unescape (str)
  (with-output-to-string (o)
    (let ((i 0) (n (length str)))
      (loop while (< i n) do
        (let ((ch (char str i)))
          (if (and (char= ch #\\) (< (1+ i) n))
              (progn (case (char str (1+ i))
                       (#\\ (write-char #\\ o))
                       (#\t (write-char #\Tab o))
                       (#\n (write-char #\Newline o))
                       (t (error "bad escape")))
                     (incf i 2))
              (progn (write-char ch o) (incf i))))))))

(defun ser-encode (alist)
  "ALIST of (string . value) -> canonical octets."
  (let ((sorted (sort (copy-list alist) #'string< :key #'car)))
    (sb-ext:string-to-octets
     (with-output-to-string (o)
       (dolist (cell sorted)
         (let ((v (cdr cell)))
           (format o "~A~A~A~A~A~%" (%escape (car cell)) #\Tab
                   (etypecase v (string "s") (integer "i") ((member t nil) "b"))
                   #\Tab
                   (etypecase v
                     (string (%escape v))
                     (integer (princ-to-string v))
                     ((member t nil) (if v "true" "false")))))))
     :external-format :utf-8)))

(defun ser-decode (octets)
  "Canonical octets -> alist. Signals an error on malformed input."
  (let ((text (sb-ext:octets-to-string octets :external-format :utf-8))
        (out '()))
    (dolist (line (loop with start = 0
                        for pos = (position #\Newline text :start start)
                        while pos
                        collect (subseq text start pos)
                        do (setf start (1+ pos))))
      (let* ((t1 (position #\Tab line))
             (t2 (position #\Tab line :start (1+ t1)))
             (key (%unescape (subseq line 0 t1)))
             (type (subseq line (1+ t1) t2))
             (raw (subseq line (1+ t2))))
        (push (cons key (cond ((string= type "s") (%unescape raw))
                              ((string= type "i") (parse-integer raw))
                              ((string= type "b") (string= raw "true"))
                              (t (error "bad type tag"))))
              out)))
    (nreverse out)))

;; ---------- death-window helper ----------
;; @harness-begin readiness marker + kill wait (instrumentation only)
(defun window (run-dir name)
  (with-open-file (s (merge-pathnames (format nil "READY-~A" name) run-dir)
                     :direction :output :if-exists :supersede
                     :if-does-not-exist :create)
    (write-line "ready" s))
  (sleep 30))
;; @harness-end
