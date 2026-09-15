;;; witness.lisp <lane-dir> <SYMBOL-NAME>
;;;
;;; PREREG-P10-RG-0 §4: a fresh process on the same (possibly mutated) subject,
;;; cwd = the subject root, that loads the lane through <lane-dir>/
;;; ml0-suite-ground.lisp INSIDE a handler-case -- so a loader REFUSAL is
;;; captured and printed rather than fatal -- and then prints exactly one
;;; WITNESS: line for the named symbol.
;;;
;;; Prints:
;;;   LOADER: ok
;;;   LOADER: refused <condition-type>: <message, first 200 chars>
;;;   WITNESS: symbol=<NAME> status=<:EXTERNAL|:INTERNAL|:INHERITED|ABSENT> \
;;;            fboundp=<T|NIL> lambda-list=<list or ERROR:<msg>>
;;;
;;; Exit 0 iff the WITNESS line printed; 2 on a usage error; 1 if the WITNESS
;;; line could not be produced at all.
;;;
;;; The lambda list is printed with *package* bound to the lane package so the
;;; parameter symbols print bare (EVIDENCE &KEY DEFECT), not
;;; LISP-PLUS-MEMORY-LAYER0::EVIDENCE -- the shape the prereg's expectations
;;; quote.  Newlines inside any printed value are squeezed to spaces so the
;;; WITNESS line is always exactly one line.

(require :sb-introspect)

(defparameter *witness-package-name* "LISP-PLUS-MEMORY-LAYER0")

(defun one-line (string)
  (let ((out (make-string-output-stream)))
    (loop for ch across string
          do (write-char (if (member ch '(#\Newline #\Return #\Tab)) #\Space ch)
                         out))
    (let ((s (get-output-stream-string out)))
      (if (> (length s) 200) (subseq s 0 200) s))))

(let* ((args (rest sb-ext:*posix-argv*))
       (lane-dir (first args))
       (symbol-name-arg (second args))
       (witnessed nil))
  (when (or (null lane-dir) (null symbol-name-arg))
    (format *error-output* "witness.lisp: usage: witness.lisp <lane-dir> <SYMBOL-NAME>~%")
    (finish-output *error-output*)
    (sb-ext:exit :code 2))
  ;; ---- the load, under handler-case (a refusal is DATA, not death)
  (handler-case
      (progn
        (load (merge-pathnames "ml0-suite-ground.lisp"
                               (concatenate 'string lane-dir "/")))
        (format t "~&LOADER: ok~%"))
    (error (c)
      (let ((report (princ-to-string c)))
        (format t "~&LOADER: refused ~a: ~a~%" (type-of c) (one-line report))
        ;; The commissioned LOADER line is capped at 200 chars, which truncates
        ;; the shortfall bullets away; PREREG §3 (M1-C) wants the shortfall
        ;; string witnessed, so it is printed here in full, additively.
        (let ((bullets '()))
          (with-input-from-string (in report)
            (loop for line = (read-line in nil nil)
                  while line
                  do (let ((trimmed (string-trim '(#\Space #\Tab #\Return) line)))
                       (when (and (> (length trimmed) 2)
                                  (string= "- " (subseq trimmed 0 2)))
                         (push (subseq trimmed 2) bullets)))))
          (format t "LOADER-SHORTFALL: ~:[(none parsed)~;~:*~{~a~^ | ~}~]~%"
                  (nreverse bullets))))))
  (finish-output)
  ;; ---- the one WITNESS line
  (let* ((package (find-package *witness-package-name*))
         (status "ABSENT")
         (symbol nil)
         (fbound "NIL")
         (arglist-text "ERROR:not attempted"))
    (if (null package)
        (setf arglist-text
              (format nil "ERROR:package ~a does not exist" *witness-package-name*))
        (multiple-value-bind (sym stat) (find-symbol symbol-name-arg package)
          (setf symbol sym)
          (cond ((null sym)
                 (setf status "ABSENT"
                       arglist-text "ERROR:symbol absent from the package"))
                (t
                 (setf status (format nil "~s" stat))
                 (setf fbound (if (fboundp sym) "T" "NIL"))
                 (setf arglist-text
                       (handler-case
                           (let ((*package* package))
                             (format nil "~s"
                                     (sb-introspect:function-lambda-list sym)))
                         (error (c)
                           (format nil "ERROR:~a" (one-line (princ-to-string c))))))))))
    (format t "WITNESS: symbol=~a status=~a fboundp=~a lambda-list=~a~%"
            symbol-name-arg status fbound (one-line arglist-text))
    (finish-output)
    (setf witnessed t))
  (sb-ext:exit :code (if witnessed 0 1)))
