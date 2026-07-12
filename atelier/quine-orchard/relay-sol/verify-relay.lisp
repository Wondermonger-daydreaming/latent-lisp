;;;; verify-relay.lisp — prove the Orchard's two-cycle by execution.
;;;; GPT Sol, 2026-07-12.
;;;;
;;;; relay-a.lisp prints relay-b.lisp byte-for-byte.
;;;; relay-b.lisp prints relay-a.lisp byte-for-byte.
;;;; The verifier also executes the generated children, so the result is a
;;;; genuine A -> B -> A -> B cycle, not merely two source-file comparisons.

(defun orchard-path (name)
  (merge-pathnames name *load-pathname*))

(defun file-bytes (path)
  (with-open-file (stream path :direction :input
                               :element-type '(unsigned-byte 8))
    (let ((bytes (make-array (file-length stream)
                             :element-type '(unsigned-byte 8))))
      (read-sequence bytes stream)
      bytes)))

(defun same-bytes-p (left right)
  (equalp (file-bytes left) (file-bytes right)))

(defun run-script-to (script output)
  (let ((process
          (sb-ext:run-program
           "sbcl"
           (list "--noinform" "--disable-debugger"
                 "--script" (namestring script))
           :search t
           :wait t
           :output output
           :if-output-exists :supersede
           :error *error-output*)))
    (unless (zerop (sb-ext:process-exit-code process))
      (error "Child ~A exited ~D"
             script (sb-ext:process-exit-code process))))
  output)

(defparameter *checks* 0)

(defun check (truth description)
  (incf *checks*)
  (unless truth
    (error "CHECK FAILED: ~A" description))
  (format t "  [~D] ~A~%" *checks* description)
  t)

(defun delete-if-present (path)
  (when (probe-file path)
    (delete-file path)))

(defun main ()
  (let* ((a (orchard-path "relay-a.lisp"))
         (b (orchard-path "relay-b.lisp"))
         (grown-b (orchard-path ".relay-grown-b.lisp"))
         (grown-a (orchard-path ".relay-grown-a.lisp"))
         (grown-b2 (orchard-path ".relay-grown-b2.lisp"))
         (direct-a (orchard-path ".relay-direct-a.lisp")))
    (unwind-protect
         (progn
           (format t "~&;;;; QUINE ORCHARD — two-chair relay~%")
           (run-script-to a grown-b)
           (check (same-bytes-p grown-b b)
                  "A executes to the committed B, byte-for-byte")

           (run-script-to grown-b grown-a)
           (check (same-bytes-p grown-a a)
                  "the generated B executes back to A, byte-for-byte")

           (run-script-to grown-a grown-b2)
           (check (same-bytes-p grown-b2 b)
                  "the regenerated A executes to B again: cycle closure")

           (run-script-to b direct-a)
           (check (same-bytes-p direct-a a)
                  "the committed B independently executes to A")

           (check (= (length (file-bytes a)) (length (file-bytes b)))
                  "the two chairs occupy the same byte-length")

           ;; PLANTED FAILURE: prove CHECK bites.
           (let ((teeth nil))
             (handler-case
                 (check nil "PLANTED: false must signal")
               (error () (setf teeth t)))
             (check teeth "the assertion machinery caught its planted failure"))

           (format t ";;;; ~D checks passed; A -> B -> A is executable.~%"
                   *checks*)
           t)
      (mapc #'delete-if-present
            (list grown-b grown-a grown-b2 direct-a)))))

(main)
