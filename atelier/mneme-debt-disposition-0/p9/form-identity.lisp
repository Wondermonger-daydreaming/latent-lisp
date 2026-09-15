;;;; form-identity.lisp — are two Lisp source files the SAME PROGRAM up to comments
;;;; and whitespace?  Reads every top-level form of each with the lane's packages
;;;; loaded (so `in-package` forms resolve and symbols intern where the compiler
;;;; would intern them), then compares the two form lists structurally.
;;;;
;;;;   cd <venue-root> && sbcl --script <this> <lane-dir> <file-A> <file-B>
;;;;
;;;; Prints `FORMS: <nA> = <nB> · IDENTICAL` and exits 0, or the first differing
;;;; form index with both forms printed and exits 1.  A reader error exits 2.
;;;;
;;;; Why not `equal`: `(in-package #:foo)` reads an UNINTERNED symbol each time, and
;;;; two uninterned symbols with the same name are never `equal`.  Symbols are
;;;; therefore compared by (package-name, symbol-name); everything else by the
;;;; ordinary structural rules.  This is auditor machinery for MNEME DEBT
;;;; DISPOSITION /0, Part A (2026-09-15); it changes nothing it reads.

(defun form-equal (a b)
  (cond ((and (symbolp a) (symbolp b))
         (and (string= (symbol-name a) (symbol-name b))
              (equal (and (symbol-package a) (package-name (symbol-package a)))
                     (and (symbol-package b) (package-name (symbol-package b))))))
        ((and (consp a) (consp b))
         (and (form-equal (car a) (car b)) (form-equal (cdr a) (cdr b))))
        ((and (stringp a) (stringp b)) (string= a b))
        ((and (numberp a) (numberp b)) (= a b))
        ((and (characterp a) (characterp b)) (char= a b))
        ((and (pathnamep a) (pathnamep b)) (equal a b))
        ((and (vectorp a) (vectorp b))
         (and (= (length a) (length b))
              (every #'form-equal a b)))
        (t (equalp a b))))

(defun read-all-forms (path)
  "Every top-level form, honouring `in-package` as the loader would."
  (let ((*package* (find-package "COMMON-LISP-USER"))
        (forms '()))
    (with-open-file (s path :direction :input)
      (loop for form = (read s nil :eof)
            until (eq form :eof)
            do (push form forms)
               (when (and (consp form)
                          (symbolp (car form))
                          (string= (symbol-name (car form)) "IN-PACKAGE"))
                 (let ((p (find-package (string (second form)))))
                   (unless p (error "in-package names an unknown package: ~s" (second form)))
                   (setf *package* p)))))
    (nreverse forms)))

(let* ((argv (rest sb-ext:*posix-argv*))
       (lane (first argv)) (file-a (second argv)) (file-b (third argv)))
  (unless (and lane file-a file-b)
    (format t "usage: sbcl --script form-identity.lisp <lane-dir> <file-A> <file-B>~%")
    (sb-ext:exit :code 2))
  ;; Load the lane so its packages exist (the proof file's symbols must intern
  ;; where a real load would intern them).  `load.lisp` loads the four lane
  ;; sources and their dependencies; it runs no suite.
  (load (merge-pathnames "load.lisp" (pathname (concatenate 'string lane "/"))))
  (let ((forms-a (handler-case (read-all-forms file-a)
                   (error (c) (format t "READ ERROR in ~a: ~a~%" file-a c) (sb-ext:exit :code 2))))
        (forms-b (handler-case (read-all-forms file-b)
                   (error (c) (format t "READ ERROR in ~a: ~a~%" file-b c) (sb-ext:exit :code 2)))))
    (format t "A: ~a (~d forms)~%B: ~a (~d forms)~%" file-a (length forms-a) file-b (length forms-b))
    (loop for i from 0
          for fa in forms-a
          for fb in forms-b
          unless (form-equal fa fb)
            do (format t "FORMS: ~d vs ~d · DIFFER at index ~d~%--- A:~%~s~%--- B:~%~s~%"
                       (length forms-a) (length forms-b) i fa fb)
               (sb-ext:exit :code 1))
    (unless (= (length forms-a) (length forms-b))
      (format t "FORMS: ~d vs ~d · DIFFER in count~%" (length forms-a) (length forms-b))
      (sb-ext:exit :code 1))
    (format t "FORMS: ~d = ~d · IDENTICAL~%" (length forms-a) (length forms-b))
    (sb-ext:exit :code 0)))
