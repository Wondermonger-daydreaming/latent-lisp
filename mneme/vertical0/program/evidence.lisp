;;;; evidence.lisp — the write-replace evidence writer (contract §4b).
;;;;
;;;; Captured evidence files (raw envelope octets, derived exports) are
;;;; persisted by exactly the declared protocol, externally witnessed by
;;;; strace:
;;;;
;;;;   write temporary file -> fsync(tmp fd) -> rename(tmp, final)
;;;;   -> fsync(parent directory fd) -> readiness
;;;;
;;;; CLOSE ALONE IS NEVER A DURABILITY PRIMITIVE.  The temporary name is
;;;; deterministic (final name + ".tmp" in the same directory — same
;;;; filesystem, so rename(2) is atomic; no random pathname enters any
;;;; durable record; the tmp name itself never enters a record at all).
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun read-octet-file (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8)
                                   :if-does-not-exist nil)
    (when stream
      (let ((octets (make-array (file-length stream)
                                :element-type '(unsigned-byte 8))))
        (read-sequence octets stream)
        octets))))

(defun %fsync-fd-stream (stream)
  (finish-output stream)
  (sb-posix:fsync (sb-sys:fd-stream-fd stream)))

(defun %fsync-directory-path (directory)
  (let ((fd (sb-posix:open (namestring directory) sb-posix:o-rdonly)))
    (unwind-protect (sb-posix:fsync fd)
      (sb-posix:close fd))))

(defun write-evidence-file (pathname octets)
  "Persist OCTETS at PATHNAME by the declared write-replace protocol:
tmp -> fsync(tmp) -> rename -> fsync(dir).  Returns PATHNAME."
  (ensure-directories-exist pathname)
  (let* ((final (namestring pathname))
         (tmp (concatenate 'string final ".tmp"))
         (directory (make-pathname :name nil :type nil
                                   :defaults pathname)))
    (with-open-file (stream tmp :direction :output
                                :element-type '(unsigned-byte 8)
                                :if-exists :supersede
                                :if-does-not-exist :create)
      (write-sequence octets stream)
      ;; fsync BEFORE close; close is never the durability primitive.
      (%fsync-fd-stream stream))
    (sb-posix:rename tmp final)
    (%fsync-directory-path directory)
    pathname))
