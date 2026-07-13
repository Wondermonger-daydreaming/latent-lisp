;;;; Run with: sbcl --script run-demo.lisp

(let ((root (make-pathname :name nil :type nil
                           :defaults (or *load-truename*
                                         *default-pathname-defaults*))))
  (dolist (file '("package.lisp" "garden.lisp" "specimens.lisp"
                  "demo.lisp"))
    (load (merge-pathnames file root))))

(s-expression-garden:run-demonstration)
