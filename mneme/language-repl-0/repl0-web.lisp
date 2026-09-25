;;;; repl0-web.lisp — REPL /0's local browser workbench server (CANDIDATE).
;;;;
;;;; One SBCL process, one listening socket on 127.0.0.1, one session engine (repl0.lisp)
;;;; — the same engine, reader and evaluator the command line uses. The page (web/) is
;;;; static; everything it shows comes from the three /api/ answers below. The contract
;;;; is WEB-API-0.md; this file is its enforcement. No dependency beyond SBCL's own
;;;; sb-bsd-sockets contrib. Single-threaded: one request at a time, Connection: close.
;;;;
;;;; THE FENCE (each line is code below, and each has a check in test-web.sh):
;;;;   • bound to 127.0.0.1 only;
;;;;   • Host must be 127.0.0.1:<port> or localhost:<port> (DNS-rebinding fence) → else 421;
;;;;   • Origin, if sent, must be this origin → else 403; Sec-Fetch-Site on /api/, if sent,
;;;;     must be same-origin or none → else 403;
;;;;   • every /api/ call carries X-Lisp-Plus-Token, a 64-hex secret made per launch from
;;;;     /dev/urandom and delivered only inside the served page → else 403;
;;;;   • no OPTIONS, no Access-Control-* header, ever (so no other origin completes a call);
;;;;   • a fixed list of paths (404 otherwise), of methods (405), a 64 KiB body bound (413),
;;;;     text/plain only (415), strict UTF-8 (400), no chunked bodies (400), a 16 KiB
;;;;     header bound (431), and a 10 s DEADLINE for the whole request (header and body),
;;;;     checked on every byte, with a 2 s timeout on each read (r1: r0's 10 s timeout
;;;;     was per READ, so a client trickling bytes held the single thread 23.7 s — CALIPER
;;;;     suspected it from the code; the chair measured it) → 408;
;;;;   • every response: a strict Content-Security-Policy, nosniff, no-referrer, no-store.
;;;; What the browser types reaches Lisp+ only as TEXT handed to SUBMIT — the same door
;;;; the terminal uses; nothing here reads or evaluates it.

(in-package #:lisp-plus-repl0)

(defparameter +csp+
  "default-src 'none'; script-src 'self'; style-src 'self'; connect-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'")

(defparameter +max-header-bytes+ 16384)
(defparameter +request-deadline-seconds+ 10 "The whole request — header and body — must arrive within this.")
(defparameter +read-timeout-seconds+ 2 "Each single read on the connection.")
(defvar *deadline* nil "internal-real-time by which the current request must have arrived.")

(defun check-deadline ()
  (when (and *deadline* (> (get-internal-real-time) *deadline*))
    (refuse 408 "the request did not arrive within ~d s" +request-deadline-seconds+)))
(defparameter +token-placeholder+ "__LISP_PLUS_TOKEN__")

;;; ---------------------------------------------------------------------------
;;; JSON — a small encoder. Objects are (:obj k1 v1 k2 v2 …) with string keys;
;;; arrays are (:arr …); :null :true :false; strings; integers.
;;; ---------------------------------------------------------------------------

(defun json-string (s out)
  (write-char #\" out)
  (loop for ch across s
        for code = (char-code ch)
        do (cond ((char= ch #\") (write-string "\\\"" out))
                 ((char= ch #\\) (write-string "\\\\" out))
                 ((char= ch #\Newline) (write-string "\\n" out))
                 ((char= ch #\Return) (write-string "\\r" out))
                 ((char= ch #\Tab) (write-string "\\t" out))
                 ((or (< code #x20) (= code #x7f) (= code #x2028) (= code #x2029))
                  (format out "\\u~(~4,'0x~)" code))
                 ((> code #xFFFF)            ; outside the BMP: a UTF-16 surrogate pair
                  (let ((v (- code #x10000)))
                    (format out "\\u~(~4,'0x~)\\u~(~4,'0x~)" (+ #xD800 (ash v -10)) (+ #xDC00 (logand v #x3FF)))))
                 (t (write-char ch out))))
  (write-char #\" out))

(defun json (v out)
  (cond ((eq v :null) (write-string "null" out))
        ((eq v :true) (write-string "true" out))
        ((eq v :false) (write-string "false" out))
        ((stringp v) (json-string v out))
        ((integerp v) (format out "~d" v))
        ((and (consp v) (eq (car v) :obj))
         (write-char #\{ out)
         (loop for (k val) on (cdr v) by #'cddr
               for first = t then nil
               do (unless first (write-char #\, out))
                  (json-string k out) (write-char #\: out) (json val out))
         (write-char #\} out))
        ((and (consp v) (eq (car v) :arr))
         (write-char #\[ out)
         (loop for x in (cdr v) for first = t then nil
               do (unless first (write-char #\, out)) (json x out))
         (write-char #\] out))
        (t (error "json: unencodable ~s" v))))

(defun to-json (v) (with-output-to-string (s) (json v s)))
(defun nullable (x) (if (null x) :null x))

(defun session-json (s)
  (list :obj "id" (session-id s) "started" (session-started s) "generation" (session-generation s)
        "submissions" (session-submissions s) "names" (cons :arr (session-names s))))

(defun runtime-json ()
  (list :obj "language" "Lisp+ PROGRAM /0" "program0_version" +program0-version+
        "repl_version" +repl0-version+ "sbcl" (lisp-implementation-version)
        "step_budget" *step-budget* "depth_limit" *depth-limit*
        "max_source_bytes" *max-submission-bytes*))

(defun error-json (e)
  (let ((loc (getf e :location)))
    (list :obj "code" (getf e :code) "message" (getf e :message)
          "location" (if loc
                         (list :obj "source" (getf loc :source) "line" (getf loc :line) "column" (getf loc :column))
                         :null)
          "in" (nullable (getf e :in))
          "within" (cons :arr (getf e :within))
          "frames" (cons :arr (getf e :frames))
          "explanation" (nullable (getf e :explanation))
          "text" (getf e :text))))

(defun result-json (r)
  (list :obj
        "index" (nullable (result-index r))
        "status" (string-downcase (symbol-name (result-status r)))
        "forms" (nullable (result-forms r))
        "value" (nullable (result-value r))
        "kind" (nullable (result-kind r))
        "output" (or (result-output r) "")
        "elapsed_ms" (nullable (result-elapsed-ms r))
        "error" (if (result-error r) (error-json (result-error r)) :null)
        "fault" (if (result-fault r)
                    (list :obj "type" (getf (result-fault r) :type) "message" (getf (result-fault r) :message))
                    :null)
        "note" (nullable (result-note r))
        "state_note" (nullable (result-state-note r))))

;;; ---------------------------------------------------------------------------
;;; HTTP — just enough, and nothing permissive.
;;; ---------------------------------------------------------------------------

(define-condition http-refusal (error)
  ((status :initarg :status :reader http-refusal-status)
   (text :initarg :text :reader http-refusal-text)
   (extra :initarg :extra :reader http-refusal-extra :initform nil)))   ; more (:obj …) fields

(defun refuse (status fmt &rest args)
  (error 'http-refusal :status status :text (apply #'format nil fmt args)))

;;; r3 (Astra's AMEND, 2026-09-25): an answer that does not arrive is not evidence that
;;; nothing happened. So the server says, on every refusal, whether the state could have
;;; changed — and it knows STRUCTURALLY: *MUTATION-STARTED* is set immediately before the
;;; one call that mutates (SUBMIT, or replacing the session), and is never unset.
(defvar *mutation-started* nil)

(defun expect-session (server headers)
  "The page states which session it is acting on; the server compares BEFORE mutating.
Missing → 428; different → 409 carrying the CURRENT session, so the page can show it."
  (let ((expected (header headers "x-lisp-plus-session"))
        (current (server-session server)))
    (cond ((null expected)
           (refuse 428 "state the session you are acting on in X-Lisp-Plus-Session"))
          ((not (string= expected (session-id current)))
           (error 'http-refusal :status 409
                  :text (format nil "stale page: it acted on session ~a, but the current session is ~a (generation ~d); nothing was evaluated or reset"
                                expected (session-id current) (session-generation current))
                  :extra (list "session" (session-json current)))))))

(defparameter +reasons+
  '((200 . "OK") (204 . "No Content") (400 . "Bad Request") (408 . "Request Timeout") (403 . "Forbidden") (404 . "Not Found")
    (405 . "Method Not Allowed") (413 . "Payload Too Large") (415 . "Unsupported Media Type")
    (409 . "Conflict") (421 . "Misdirected Request") (428 . "Precondition Required")
    (431 . "Request Header Fields Too Large")
    (500 . "Internal Server Error")))

(defun octets (string) (sb-ext:string-to-octets string :external-format :utf-8))

(defun send (stream status content-type body-string &key extra-headers)
  (let* ((body (octets body-string))
         (head (with-output-to-string (h)
                 (format h "HTTP/1.1 ~d ~a~c~c" status (cdr (assoc status +reasons+)) #\Return #\Newline)
                 (dolist (pair (append
                                (list (cons "Content-Type" content-type)
                                      (cons "Content-Length" (princ-to-string (length body)))
                                      (cons "Content-Security-Policy" +csp+)
                                      (cons "X-Content-Type-Options" "nosniff")
                                      (cons "Referrer-Policy" "no-referrer")
                                      (cons "Cache-Control" "no-store")
                                      (cons "X-Frame-Options" "DENY")
                                      (cons "Connection" "close"))
                                extra-headers))
                   (format h "~a: ~a~c~c" (car pair) (cdr pair) #\Return #\Newline))
                 (format h "~c~c" #\Return #\Newline))))
    (write-sequence (octets head) stream)
    (write-sequence body stream)
    (finish-output stream)))

(defun send-json (stream status v)
  (send stream status "application/json; charset=utf-8" (to-json v)))

(defun read-header-block (stream)
  "Read bytes up to and including CRLF CRLF. → the header block as a string (ASCII)."
  (let ((buf (make-array 1024 :element-type '(unsigned-byte 8) :adjustable t :fill-pointer 0)))
    (loop
      (let ((b (read-byte stream nil nil)))
        (unless b (refuse 400 "connection closed inside the request header"))
        (check-deadline)
        (when (>= (fill-pointer buf) +max-header-bytes+)
          (refuse 431 "request header larger than ~d bytes" +max-header-bytes+))
        (vector-push-extend b buf)
        (let ((n (fill-pointer buf)))
          (when (and (>= n 4) (= (aref buf (- n 4)) 13) (= (aref buf (- n 3)) 10)
                     (= (aref buf (- n 2)) 13) (= (aref buf (- n 1)) 10))
            (return)))))
    (when (some (lambda (b) (> b 126)) buf) (refuse 400 "non-ASCII byte in the request header"))
    (map 'string #'code-char buf)))

(defun split-crlf (s)
  (let ((lines '()) (start 0))
    (loop for pos = (search (format nil "~c~c" #\Return #\Newline) s :start2 start)
          while pos do (push (subseq s start pos) lines) (setf start (+ pos 2)))
    (nreverse lines)))

(defun uiop-free-split (s ch)
  (let ((out '()) (start 0))
    (loop for pos = (position ch s :start start)
          do (push (subseq s start pos) out)
             (if pos (setf start (1+ pos)) (return)))
    (nreverse out)))

(defun parse-request (stream)
  "→ (values method path headers-alist). Header names lowercased; a repeated
Host/Origin/Content-Length/token header is refused (ambiguity is never resolved in favour of the caller)."
  (let* ((lines (remove "" (split-crlf (read-header-block stream)) :test #'string=))
         (request-line (first lines))
         (parts (and request-line (uiop-free-split request-line #\Space))))
    (unless (and (= (length parts) 3) (member (third parts) '("HTTP/1.1" "HTTP/1.0") :test #'string=))
      (refuse 400 "malformed request line"))
    (let ((headers '()))
      (dolist (line (rest lines))
        (let ((colon (position #\: line)))
          (unless (and colon (plusp colon)) (refuse 400 "malformed header line"))
          (let ((name (string-downcase (subseq line 0 colon)))
                (value (string-trim '(#\Space #\Tab) (subseq line (1+ colon)))))
            (when (and (member name '("host" "origin" "content-length" "x-lisp-plus-token" "content-type" "sec-fetch-site" "x-lisp-plus-session")
                               :test #'string=)
                       (assoc name headers :test #'string=))
              (refuse 400 "header ~a sent twice" name))
            (push (cons name value) headers))))
      (values (first parts) (second parts) headers))))

(defun header (headers name) (cdr (assoc name headers :test #'string=)))

(defun constant-time-equal (a b)
  (and (stringp a) (stringp b) (= (length a) (length b))
       (zerop (loop for x across a for y across b sum (logxor (char-code x) (char-code y))))))

(defun read-body (stream headers)
  (when (header headers "transfer-encoding") (refuse 400 "Transfer-Encoding is not accepted; send Content-Length"))
  (let ((cl (header headers "content-length")))
    (cond ((null cl) (refuse 400 "Content-Length required"))
          ((not (and (plusp (length cl)) (every #'digit-char-p cl) (<= (length cl) 9)))
           (refuse 400 "malformed Content-Length"))
          (t (let ((n (parse-integer cl)))
               (when (> n *max-submission-bytes*)
                 (refuse 413 "the submission is larger than ~:d bytes" *max-submission-bytes*))
               (let ((buf (make-array n :element-type '(unsigned-byte 8))))
                 (dotimes (i n)
                   (let ((b (read-byte stream nil nil)))
                     (unless b (refuse 400 "the body ended after ~d of ~d bytes" i n))
                     (setf (aref buf i) b)
                     (check-deadline)))
                 (handler-case (sb-ext:octets-to-string buf :external-format :utf-8)
                   (error () (refuse 400 "the body is not valid UTF-8")))))))))

;;; ---------------------------------------------------------------------------
;;; the server
;;; ---------------------------------------------------------------------------

(defstruct (server (:copier nil))
  port token session static)          ; static: alist path → (content-type . string)

(defun web-directory ()
  (merge-pathnames "web/" cl-user::*repl0-here*))

(defun load-static (token)
  (flet ((file (rel type)
           (let ((p (merge-pathnames rel (web-directory))))
             (unless (probe-file p) (error "the workbench file ~a is missing" p))
             (cons type (lisp-plus-program0::read-file-text p)))))
    (let* ((index (file "index.html" "text/html; charset=utf-8"))
           (html (cdr index))
           (at (search +token-placeholder+ html)))
      (unless (and at (null (search +token-placeholder+ html :start2 (1+ at))))
        (error "web/index.html must contain the token placeholder exactly once"))
      (list (cons "/" (cons (car index)
                            (concatenate 'string (subseq html 0 at) token
                                         (subseq html (+ at (length +token-placeholder+))))))
            (cons "/app.js" (file "app.js" "text/javascript; charset=utf-8"))
            (cons "/app.css" (file "app.css" "text/css; charset=utf-8"))
            (cons "/vendor/webtui-css-0.1.10/full.css"
                  (file "vendor/webtui-css-0.1.10/full.css" "text/css; charset=utf-8"))))))

(defun check-fence (server method path headers)
  (declare (ignore method))
  (let* ((port (server-port server))
         (host (header headers "host"))
         (origin (header headers "origin"))
         (site (header headers "sec-fetch-site"))
         (apip (and (>= (length path) 5) (string= "/api/" path :end2 5))))
    (unless (and host (member (string-downcase host)
                              (list (format nil "127.0.0.1:~d" port) (format nil "localhost:~d" port))
                              :test #'string=))
      (refuse 421 "this server answers only to 127.0.0.1:~d or localhost:~d" port port))
    (when (and origin (not (member origin (list (format nil "http://127.0.0.1:~d" port)
                                                (format nil "http://localhost:~d" port))
                                   :test #'string=)))
      (refuse 403 "cross-origin request refused"))
    (when (and apip site (not (member site '("same-origin" "none") :test #'string=)))
      (refuse 403 "cross-site request refused"))
    (when apip
      (unless (constant-time-equal (header headers "x-lisp-plus-token") (server-token server))
        (refuse 403 "missing or wrong X-Lisp-Plus-Token")))))

(defun handle (server stream)
  (multiple-value-bind (method path headers) (parse-request stream)
    (check-fence server method path headers)
    (let ((static (assoc path (server-static server) :test #'string=)))
      (cond
        (static
         (unless (string= method "GET") (refuse 405 "~a is not allowed on ~a" method path))
         (send stream 200 (cadr static) (cddr static)))
        ;; browsers ask for an icon on their own; answer "none" explicitly, so a 404 in
        ;; the console never hides a real error (a data: icon would break img-src 'self')
        ((string= path "/favicon.ico")
         (unless (string= method "GET") (refuse 405 "~a is not allowed on ~a" method path))
         (send stream 204 "text/plain; charset=utf-8" ""))
        ((string= path "/api/session")
         (unless (string= method "GET") (refuse 405 "~a is not allowed on ~a" method path))
         (send-json stream 200 (list :obj "session" (session-json (server-session server)) "runtime" (runtime-json))))
        ((string= path "/api/submit")
         (unless (string= method "POST") (refuse 405 "~a is not allowed on ~a" method path))
         (let ((ct (header headers "content-type")))
           (unless (and ct (let ((c (string-downcase ct)))
                             (or (string= c "text/plain")
                                 (and (> (length c) 11) (string= "text/plain;" c :end2 11)))))
             (refuse 415 "send the source as text/plain")))
         (let* ((text (read-body stream headers))      ; reading the body mutates nothing
                (r (progn (expect-session server headers)
                          (setf *mutation-started* t)
                          (submit (server-session server) text))))
           (send-json stream 200 (list :obj "session" (session-json (server-session server)) "result" (result-json r)))))
        ((string= path "/api/reset")
         (unless (string= method "POST") (refuse 405 "~a is not allowed on ~a" method path))
         (expect-session server headers)
         (let ((old (server-session server)))
           (setf *mutation-started* t
                 (server-session server) (make-session :generation (1+ (session-generation old))))
           (format *error-output* "~&; RESET from the browser: session ~a ended; new session ~a (generation ~d)~%"
                   (session-id old) (session-id (server-session server)) (session-generation (server-session server)))
           (finish-output *error-output*)
           (send-json stream 200 (list :obj "session" (session-json (server-session server)) "runtime" (runtime-json)))))
        (t (refuse 404 "no such path"))))))

(defun serve-one (server client)
  (let* ((stream (sb-bsd-sockets:socket-make-stream client :input t :output t
                                                          :element-type '(unsigned-byte 8)
                                                          :buffering :full :timeout +read-timeout-seconds+))
        (*deadline* (+ (get-internal-real-time)
                       (* +request-deadline-seconds+ internal-time-units-per-second)))
        (*mutation-started* nil))
    (unwind-protect
         (handler-case (handle server stream)
           (http-refusal (r)
             (ignore-errors (send-json stream (http-refusal-status r)
                                       (append (list :obj "error" (http-refusal-text r)
                                                     "before_mutation" (if *mutation-started* :false :true))
                                               (http-refusal-extra r)))))
           (sb-sys:io-timeout () nil)
           (stream-error () nil)
           (error (c)
             (format *error-output* "~&; server defect while handling a request: ~a: ~a~%" (type-of c) c)
             (ignore-errors (send-json stream 500 (list :obj "error" (format nil "server defect: ~a" (type-of c))
                                                        "before_mutation" (if *mutation-started* :false :true))))))
      (ignore-errors (close stream))
      (ignore-errors (sb-bsd-sockets:socket-close client)))))

(defun run-web (&key (port 4917))
  (let* ((token (random-hex 32))
         (server (make-server :port port :token token :session (make-session)
                              :static (load-static token)))
         (socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
    (setf (sb-bsd-sockets:sockopt-reuse-address socket) t)
    (handler-case (sb-bsd-sockets:socket-bind socket #(127 0 0 1) port)
      (error (c)
        (format *error-output* "lisp-plus-repl: cannot listen on 127.0.0.1:~d — ~a~%" port c)
        (finish-output *error-output*)
        (return-from run-web 1)))
    (sb-bsd-sockets:socket-listen socket 16)
    (format t "Lisp+ REPL /0 workbench (candidate) — open http://127.0.0.1:~d/~%~
               session ~a (generation ~d) · listening on 127.0.0.1 only · Ctrl-C stops the server~%"
            port (session-id (server-session server)) (session-generation (server-session server)))
    (finish-output)
    (unwind-protect
         (handler-case
             (loop (let ((client (sb-bsd-sockets:socket-accept socket)))
                     (when client (serve-one server client))))
           (sb-sys:interactive-interrupt ()
             (format t "~&; workbench stopped (session ~a, ~d submission~:p)~%"
                     (session-id (server-session server)) (session-submissions (server-session server)))
             (finish-output)))
      (ignore-errors (sb-bsd-sockets:socket-close socket)))
    0))
