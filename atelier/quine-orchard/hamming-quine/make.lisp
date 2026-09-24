;;;; make.lisp — find the fixed point.  Reads template.lisp (whose only tilde is the one ~s where the
;;;; string literal goes), takes the whole text as the control string S, writes hamming-quine.lisp =
;;;; (format nil S S), then reloads that file in a fresh process and checks its output is itself.
;;;;   sbcl --script make.lisp     (cwd: this directory)
(setf *print-pretty* nil)
(defun slurp (p) (with-open-file (in p :external-format :utf-8)
                   (let ((s (make-string (file-length in)))) (subseq s 0 (read-sequence s in)))))
(let* ((s (slurp "template.lisp"))
       (tildes (count #\~ s)))
  (unless (= tildes 1) (format t "make: REFUSED — template has ~d tildes, need exactly 1 (the ~~s)~%" tildes) (sb-ext:exit :code 2))
  (let ((f (format nil s s)))
    (with-open-file (out "hamming-quine.lisp" :direction :output :if-exists :supersede :external-format :utf-8)
      (write-string f out))
    (format t "make: wrote hamming-quine.lisp (~d chars); verifying the fixed point in a fresh process...~%" (length f))
    (let* ((p (sb-ext:run-program "sbcl" '("--script" "hamming-quine.lisp") :search t :output :stream :wait nil))
           (out (with-output-to-string (o) (loop for c = (read-char (sb-ext:process-output p) nil nil) while c do (write-char c o)))))
      (sb-ext:process-wait p)
      (if (string= out f)
          (progn (format t "make: FIXED POINT — the program's output equals its source, ~d chars, byte for byte~%" (length f)) (sb-ext:exit :code 0))
          (progn (format t "make: NOT a fixed point — output ~d chars vs source ~d chars; first difference at ~a~%"
                         (length out) (length f) (or (mismatch out f) "(length)"))
                 (sb-ext:exit :code 1))))))
