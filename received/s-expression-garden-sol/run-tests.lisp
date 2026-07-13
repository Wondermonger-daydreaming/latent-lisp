;;;; Run with: sbcl --script run-tests.lisp

(let ((root (make-pathname :name nil :type nil
                           :defaults (or *load-truename*
                                         *default-pathname-defaults*))))
  (dolist (file '("package.lisp" "garden.lisp" "specimens.lisp"
                  "tests.lisp"))
    (load (merge-pathnames file root))))

(s-expression-garden:run-tests :trials 200 :signal-on-failure t)
