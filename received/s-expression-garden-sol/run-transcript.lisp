;;;; Produces the demonstration and test output used for TRANSCRIPT.txt.

(let ((root (make-pathname :name nil :type nil
                           :defaults (or *load-truename*
                                         *default-pathname-defaults*))))
  (dolist (file '("package.lisp" "garden.lisp" "specimens.lisp"
                  "tests.lisp" "demo.lisp"))
    (load (merge-pathnames file root))))

(format t "Implementation: ~A ~A~%~%"
        (lisp-implementation-type) (lisp-implementation-version))

(s-expression-garden:run-demonstration :full-receipt-p t)
(terpri)
(s-expression-garden:run-tests :trials 200 :signal-on-failure t)
