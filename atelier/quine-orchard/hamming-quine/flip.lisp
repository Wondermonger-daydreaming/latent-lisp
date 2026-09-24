;;;; flip.lisp IN OUT BLOCK BIT [BLOCK BIT]... — the noisy channel, by hand.
;;;; Copies the transmission IN to OUT with the named bits flipped (BLOCK 0-based over codeword
;;;; forms, BIT 1..7 = X1..X7 as Shannon numbers them).  Comments in IN are dropped by the reader;
;;;; OUT begins with one comment naming every flip, so the record says what the channel did.
(setf *print-pretty* nil)
(let* ((args (rest sb-ext:*posix-argv*)) (in (first args)) (out (second args))
       (flips (loop for (b x) on (cddr args) by #'cddr collect (cons (parse-integer b) (parse-integer x)))))
  (unless (and in out flips) (write-line "usage: flip.lisp IN OUT BLOCK BIT [BLOCK BIT]...") (sb-ext:exit :code 2))
  (let ((blocks (with-open-file (s in) (loop for f = (read s nil :eof) until (eq f :eof) collect (copy-list f)))))
    (dolist (fl flips)
      (let ((cw (nth (car fl) blocks)))
        (unless cw (format t "flip: REFUSED — block ~d does not exist (~d blocks)~%" (car fl) (length blocks)) (sb-ext:exit :code 2))
        (setf (nth (1- (cdr fl)) cw) (logxor 1 (nth (1- (cdr fl)) cw)))))
    (with-open-file (o out :direction :output :if-exists :supersede)
      (format o ";; flipped by flip.lisp: ~{block ~d bit X~d~^, ~} (of ~d blocks)~%"
              (loop for fl in flips append (list (car fl) (cdr fl))) (length blocks))
      (dolist (cw blocks) (write cw :stream o :pretty nil) (terpri o)))
    (format t "flip: ~d flip(s) written to ~a~%" (length flips) out)))
