#!/usr/bin/env -S sbcl --script

;;;; Grow four descendants, replay every graft independently, and retain a receipt.

(defparameter *checks* 0)

(defun check (truth description)
  (incf *checks*)
  (unless truth
    (error "CHECK ~D FAILED: ~A" *checks* description))
  (format t "  [~D] ~A~%" *checks* description)
  t)

(defun here (name)
  (merge-pathnames name *load-truename*))

(defun read-one (path)
  (with-open-file (stream path :direction :input)
    (read stream nil :eof)))

(defun tree-size (tree)
  (if (atom tree)
      1
      (+ 1 (tree-size (second tree)) (tree-size (third tree)))))

(defun replay-graft (tree index donor)
  (cond ((zerop index) (copy-tree donor))
        ((atom tree) (error "Invalid verifier cut ~D" index))
        (t
         (let ((left-size (tree-size (second tree))))
           (if (<= index left-size)
               (list (first tree)
                     (replay-graft (second tree) (1- index) donor)
                     (copy-tree (third tree)))
               (list (first tree)
                     (copy-tree (second tree))
                     (replay-graft (third tree)
                                   (- index left-size 1)
                                   donor)))))))

(defun form-generation (form) (third form))
(defun form-organism (form) (second (fourth form)))
(defun form-grafts (form) (second (fifth form)))
(defun form-program (form) (first form))
(defun form-quoted-program (form) (second (second form)))

(defun run-seed (source output receipt)
  (let ((process
          (sb-ext:run-program
           "sbcl"
           (list "--noinform" "--disable-debugger"
                 "--script" (namestring source))
           :search t
           :wait t
           :output output
           :if-output-exists :supersede
           :error receipt
           :if-error-exists :supersede)))
    (check (zerop (sb-ext:process-exit-code process))
           "the parent executes successfully"))
  output)

(defun write-report (report)
  (with-open-file
      (stream (here "lineage-receipt.sexp")
              :direction :output
              :if-exists :supersede
              :if-does-not-exist :create)
    (write report :stream stream :pretty t)
    (terpri stream)))

(defun main ()
  (let* ((root (here "receipt-seed.lisp"))
         (root-form (read-one root))
         (program (form-program root-form))
         (current root)
         (receipts '())
         (temporary-paths '()))
    (unwind-protect
         (progn
           (check (equal program (form-quoted-program root-form))
                  "the seed program and its quoted body agree structurally")
           (loop for step from 1 to 4
                 for child = (here (format nil ".generation-~D.lisp" step))
                 for receipt-path = (here (format nil ".receipt-~D.sexp" step))
                 do (push child temporary-paths)
                    (push receipt-path temporary-paths)
                    (let* ((parent-form (read-one current))
                           (parent-organism (form-organism parent-form))
                           (parent-grafts (form-grafts parent-form))
                           (graft (first parent-grafts)))
                      (run-seed current child receipt-path)
                      (let* ((child-form (read-one child))
                             (receipt (read-one receipt-path))
                             (expected-organism
                               (if graft
                                   (replay-graft parent-organism
                                                 (first graft)
                                                 (second graft))
                                   parent-organism)))
                        (check (equal program (form-program child-form))
                               "program form survives the generation")
                        (check (equal (form-program child-form)
                                      (form-quoted-program child-form))
                               "offspring remains self-reproducing")
                        (check (= step (form-generation child-form))
                               "generation counter advances exactly once")
                        (check (equal expected-organism
                                      (form-organism child-form))
                               "independent replay yields the child organism")
                        (check (getf receipt :replay-valid)
                               "birth receipt reports a replayable graft")
                        (check (equal expected-organism
                                      (getf receipt :child-organism))
                               "receipt names the child actually emitted")
                        (check (eq (getf (getf receipt :identity) :authority)
                                   (if graft :new-name-required :lineage-only))
                               "identity authority stays narrower than descent")
                        (push receipt receipts)))
                    (setf current child))
           (let* ((final-form (read-one current))
                  (final-organism (form-organism final-form))
                  (report
                    `(:receipt-version 1
                      :specimen :receipt-bearing-seed-lineage
                      :inspiration
                        (:repository
                          "https://github.com/Wondermonger-daydreaming/latent-lisp"
                         :observed-commit "87bbfec"
                         :paths
                           ("atelier/quine-orchard"
                            "atelier/sexp-garden"))
                      :claim
                        "A descendant can reproduce the same program form while changing its carried claim, provided each change remains a separately replayable event."
                      :generations ,(nreverse receipts)
                      :final-organism ,final-organism
                      :checks ,*checks*
                      :result :pass
                      :limits
                        (:descent-is-not-identity
                         :replay-is-not-authorship
                         :queued-grafts-are-preselected-not-evolved))))
             (check (equal final-organism
                           '(claim conformance
                             (because (count 511 cases)
                                      (domain boolean-lists length-8))))
                    "the lineage ends at the intended bounded claim")
             (check (null (form-grafts final-form))
                    "the graft queue is exhausted")
             (setf (getf report :checks) *checks*)
             (write-report report)
             (format t ";;;; ~D checks passed; lineage receipt written.~%"
                     *checks*)))
      (dolist (path temporary-paths)
        (when (probe-file path)
          (delete-file path))))))

(main)
