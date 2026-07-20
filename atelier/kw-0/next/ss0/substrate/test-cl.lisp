;;;; test-cl.lisp — CL-side driver for the SS-0 substrate selftest.
;;;; Subcommands: ser-encode <out> | ser-roundtrip <in> <out> |
;;;;   frames-write <dir> | frames-read <dir> | provider <dir> | crc <string>
(load (merge-pathnames "ss0-substrate.lisp" *load-truename*))
(load (merge-pathnames "ss0-provider.lisp" *load-truename*))
(in-package #:ss0)

(defparameter *fixed-map*
  '(("name" . "SS-0") ("n" . 42) ("ok" . t) ("empty" . "")
    ("note" . "tab	here
line") ("weird\\key" . "v")))

(let* ((args (cdr sb-ext:*posix-argv*))
       (cmd (first args)))
  (cond
    ((string= cmd "ser-encode")
     (with-open-file (s (second args) :direction :output
                        :element-type '(unsigned-byte 8)
                        :if-exists :supersede :if-does-not-exist :create)
       (write-sequence (ser-encode *fixed-map*) s)))
    ((string= cmd "ser-roundtrip")
     (let ((bytes (with-open-file (s (second args) :element-type '(unsigned-byte 8))
                    (let ((b (make-array (file-length s) :element-type '(unsigned-byte 8))))
                      (read-sequence b s) b))))
       (with-open-file (s (third args) :direction :output
                          :element-type '(unsigned-byte 8)
                          :if-exists :supersede :if-does-not-exist :create)
         (write-sequence (ser-encode (ser-decode bytes)) s))))
    ((string= cmd "frames-write")
     (let ((dir (pathname (second args))))
       (store-append dir (sb-ext:string-to-octets "alpha"))
       (store-append dir (sb-ext:string-to-octets "beta") :durable nil)
       (store-append-torn dir (sb-ext:string-to-octets "gamma-payload") 0.5)))
    ((string= cmd "frames-read")
     (multiple-value-bind (payloads status) (store-read-prefix (pathname (second args)))
       (format t "~{~A~^,~}|~A~%"
               (mapcar (lambda (p) (sb-ext:octets-to-string p)) payloads)
               (string-downcase (symbol-name status)))))
    ((string= cmd "provider")
     (let ((dir (pathname (second args))))
       (provider-dispatch dir "effect:mint" "a1")
       (provider-dispatch dir "effect-ne:mint" "a2")
       (provider-dispatch dir "complete:hello" "a3")))
    ((string= cmd "crc")
     (format t "~A~%" (crc32-hex (sb-ext:string-to-octets (second args)))))
    (t (error "unknown subcommand"))))
